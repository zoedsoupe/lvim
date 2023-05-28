{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  nix = cfg.enable && cfg.nix.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in
{
  options.lvim.lsp.nix.enable = mkEnableOption "Enables Nix support plugins";

  config.lvim = mkIf nix {
    rawConfig = ''
      -- NIX LSP CONFIG
      require('lspconfig').nil_ls.setup({
        ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        ''}
        cmd = {"${pkgs.nil}/bin/nil"}
      })
      -- END NIX LSP CONFIG
    '';
  };
}
