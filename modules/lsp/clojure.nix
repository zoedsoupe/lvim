{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  clojure = cfg.enable && cfg.clojure.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in
{
  options.lvim.lsp.clojure.enable = mkEnableOption "Enables Clojure support plugins";

  config.lvim = mkIf clojure {
    startPlugins = with pkgs.neovimPlugins; [ conjure vim-sexp vim-sexp-mappings ];
    rawConfig = ''
      -- CLOJURE LSP CONFIG
      require('lspconfig').clojure_lsp.setup({
        ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        ''}
        cmd = {"${pkgs.clojure-lsp}/bin/clojure-lsp"},
      })
      -- END CLOJURE LSP CONFIG
    '';
  };
}
