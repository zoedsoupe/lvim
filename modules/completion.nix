{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  cfg = config.lvim.completion;
in
{
  options.lvim.completion = {
    enable = mkEnableOption "Enables auto completion";
    path.enable = mkEnableOption "Enables paths auto completion";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins cfg.path.enable [ nvim-cmp-path ]) ++
      [ nvim-cmp ]
    );
    rawConfig = ''
    -- NVIM CMP

    local cmp = require('cmp')

    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
      }),
      sources = cmp.config.sources({
        ${writeIf cfg.path.enable "{ name = 'path' },"}
      }),
    })

    -- END NVIM CMP
    '';
  };
}
