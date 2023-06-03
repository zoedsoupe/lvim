{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  nix = cfg.enable && cfg.nix.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.nix.enable = mkEnableOption "Enables Nix support plugins";

  config.lvim = mkIf nix {
    rawConfig = ''
        -- NIX LSP CONFIG
      local nix_caps = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
        require('lspconfig').nil_ls.setup({
          ${writeIf completion ''
        capabilities = nix_caps,
      ''}
          cmd = {"${pkgs.nil}/bin/nil"}
        })
        -- END NIX LSP CONFIG
    '';
  };
}
