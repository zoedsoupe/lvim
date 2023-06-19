{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  css = cfg.enable && cfg.elixir.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.css.enable = mkEnableOption "Enables CSS support plugins";

  config.lvim = mkIf css {
    rawConfig = ''
      -- CSS LSP CONFIG
      require('lspconfig').cssls.setup({
        ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      ''}
        cmd = {"${pkgs.nodePackages.vscode-langservers-extracted}/bin/cssls"},
      })
      -- END CSS LSP CONFIG
    '';
  };
}
