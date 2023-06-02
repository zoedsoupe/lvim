{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  ts = cfg.enable && cfg.typescript.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.typescript.enable = mkEnableOption "Enables Typescript support plugins";

  config.lvim = mkIf ts {
    startPlugins = with pkgs.neovimPlugins; [typescript-nvim];
    rawConfig = ''
      -- NIX LSP CONFIG
      require("typescript").setup({
        server = {
          ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),,
      ''}
          cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
        }
      })
      -- END NIX LSP CONFIG
    '';
  };
}
