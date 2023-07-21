{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption withPlugins writeIf types;
  cfg = config.lvim.completion;
  isluasnip = cfg.snippets.enable && cfg.snippets.source == "luasnip";
in {
  options.lvim.completion = {
    enable = mkEnableOption "Enables auto completion";
    buffer.enable = mkEnableOption "Enables buffer auto completion";
    cmdline.enable = mkEnableOption "Enables cmdline auto completion";
    path.enable = mkEnableOption "Enables paths auto completion";
    lsp = {
      enable = mkEnableOption "Enables LSP auto completion";
      lspkind.enable = mkEnableOption "Enables VScode like pictograms";
    };
    snippets = {
      enable = mkEnableOption "Enables snippets completion";
      source = mkOption {
        type = types.enum ["luasnip"];
        description = "Define the snippet plugin source";
        default = "luasnip";
      };
    };
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins cfg.path.enable [nvim-cmp-path])
      ++ (withPlugins cfg.buffer.enable [nvim-cmp-buffer])
      ++ (withPlugins cfg.cmdline.enable [nvim-cmp-cmdline])
      ++ (withPlugins cfg.lsp.enable [nvim-cmp-lsp])
      ++ (withPlugins (cfg.lsp.enable && cfg.lsp.lspkind.enable) [lspkind])
      ++ (withPlugins isluasnip [nvim-cmp-lsp luasnip])
      ++ [nvim-cmp]
    );
    rawConfig = ''
      -- NVIM CMP

      ${writeIf isluasnip ''
        local luasnip = require("luasnip")
        require('luasnip.loaders.from_vscode').lazy_load()
      ''}
      local cmp = require('cmp')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        ${writeIf (cfg.lsp.enable && cfg.lsp.lspkind.enable) ''
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol',
            maxwidth = 35,
            ellipsis_char = '...',
          }),
        },
      ''}
        ${writeIf (isluasnip && cfg.lsp.enable) ''
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
      ''}
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
          ${writeIf cfg.lsp.enable ''
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        ''}
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          ${writeIf cfg.lsp.enable ''
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        ''}
          else
            fallback()
          end
        end, { "i", "s" }),
      ''}
        }),
        sources = cmp.config.sources({
          ${writeIf cfg.lsp.enable "{ name = 'nvim_lsp' },"}
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
