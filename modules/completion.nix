{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption withPlugins writeIf types;
  cfg = config.lvim.completion;
  isluasnip = cfg.snippets.enable && cfg.snippets.source == "luasnip";
in
{
  options.lvim.completion = {
    enable = mkEnableOption "Enables auto completion";
    buffer.enable = mkEnableOption "Enables buffer auto completion";
    cmdline.enable = mkEnableOption "Enables cmdline auto completion";
    path.enable = mkEnableOption "Enables paths auto completion";
    snippets = {
      enable = mkEnableOption "Enables snippets completion";
      source = mkOption {
        type = types.enum [ "luasnip" ];
        description = "Define the snippet plugin source";
        default = "luasnip";
      };
    };
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins cfg.path.enable [ nvim-cmp-path ]) ++
      (withPlugins cfg.buffer.enable [ nvim-cmp-buffer ]) ++
      (withPlugins cfg.cmdline.enable [ nvim-cmp-cmdline ]) ++
      (withPlugins isluasnip [ luasnip friendly-snippets ]) ++
      [ nvim-cmp ]
    );
    rawConfig = ''
      -- NVIM CMP

      ${writeIf isluasnip ''
      require('luasnip.loaders.from_vscode').lazy_load()

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      ''}
      local cmp = require('cmp')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ${writeIf isluasnip ''
          -- super tab editing
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
            -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ''}
        }),
        sources = cmp.config.sources({
          ${writeIf cfg.path.enable "{ name = 'path' },"}
          ${writeIf cfg.buffer.enable "{ name = 'buffer' },"}
          ${writeIf cfg.cmdline.enable "{ name = 'cmdline' },"}
          ${writeIf isluasnip "{ name = 'luasnip' },"}
        }),
      })

      -- END NVIM CMP
    '';
  };
}
