{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  elixir = cfg.enable && cfg.elixir.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.elixir.enable = mkEnableOption "Enables Elixir support plugins";

  config.lvim = mkIf elixir {
    startPlugins = with pkgs.neovimPlugins; [nvim-elixir];
    rawConfig = ''
      -- ELXIR LSP CONFIG
      require('lspconfig').elixirls.setup({
        ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      ''}
        cmd = {"${pkgs.elixir-ls}/bin/elixir-ls"},
      })
      -- END ELIXIR LSP CONFIG
    '';
  };
}
