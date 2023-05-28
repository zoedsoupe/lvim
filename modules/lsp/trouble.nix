{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.lsp;
  trouble = cfg.enable && cfg.trouble.enable;
in
{
  options.lvim.lsp.trouble.enable = mkEnableOption "Enables Neovim LSP diagnostic support plugins";

  config.lvim = mkIf trouble {
    startPlugins = with pkgs.neovimPlugins; [ trouble-nvim ];
    nnoremap = {
      "<leader>xx" = "<cmd>TroubleToggle<cr>";
      "<leader>xw" = "<cmd>TroubleToggle workspace_diagnostics<cr>";
      "<leader>xd" = "<cmd>TroubleToggle document_diagnostics<cr>";
      "<leader>xq" = "<cmd>TroubleToggle quickfix<cr>";
      "<leader>xl" = "<cmd>TroubleToggle loclist<cr>";
      "gR" = "<cmd>TroubleToggle lsp_references<cr>";
    };
    rawConfig = ''
      -- TROUBLE CONFIG
      require('trouble').setup({
        auto_preview = false,
      })
      -- END TROUBLE CONFIG
    '';
  };
}
