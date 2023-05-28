{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  dart = cfg.enable && cfg.dart.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in
{
  options.lvim.lsp.dart.enable = mkEnableOption "Enables Dart support plugins";

  config.lvim = mkIf dart {
    rawConfig = ''
      -- DART LSP CONFIG
      require('lspconfig').dartls.setup({
        ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        ''}
        cmd = {"${pkgs.dart}/bin/dart", "language-server", "--protocol=lsp"}
      })
      -- END DART LSP CONFIG
    '';
  };
}
