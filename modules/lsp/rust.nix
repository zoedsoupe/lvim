{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  rust = cfg.enable && cfg.rust.enable;
  completion = config.lvim.completion.enable && cfg.enable;
in {
  options.lvim.lsp.rust.enable = mkEnableOption "Enables Rust support plugins";

  config.lvim = mkIf rust {
    startPlugins = with pkgs.neovimPlugins; [rust-tools];
    nnoremap = {
      "<silent><leader>ri" = "<cmd>lua require('rust-tools.inlay_hints').toggle_inlay_hints()<CR>";
      "<silent><leader>rr" = "<cmd>lua require('rust-tools.runnables').runnables()<CR>";
      "<silent><leader>re" = "<cmd>lua require('rust-tools.expand_macro').expand_macro()<CR>";
      "<silent><leader>rc" = "<cmd>lua require('rust-tools.open_cargo_toml').open_cargo_toml()<CR>";
      "<silent><leader>rg" = "<cmd>lua require('rust-tools.crate_graph').view_crate_graph('x11', nil)<CR>";
    };
    rawConfig = ''
      -- NIX LSP CONFIG
      local rustopts = {
        tools = {
          autoSetHints = true,
          hover_with_actions = false,
          inlay_hints = {
            only_current_line = false,
          }
        },
        server = {
          ${writeIf completion ''
        capabilities = require("cmp_nvim_lsp").default_capabilities(),,
      ''}
          cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
        }
      }

      require('rust-tools').setup(rustopts)
      -- END RUST LSP CONFIG
    '';
  };
}
