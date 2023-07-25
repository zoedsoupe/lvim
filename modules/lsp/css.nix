{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  css = cfg.enable && cfg.css.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.css.enable = mkEnableOption "Enables CSS support plugins";

  config.lvim = mkIf css {
    startPlugins = with pkgs.neovimPlugins; [nvim-colorizer];
    rawConfig = ''
          -- CSS LSP CONFIG
      vim.o.termguicolors = true
       require('colorizer').setup()
          require('lspconfig').cssls.setup({
            ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      ''}
            cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/vscode-css-language-server", "--stdio"},
          })
          -- END CSS LSP CONFIG
    '';
  };
}
