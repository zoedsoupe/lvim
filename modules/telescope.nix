{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf withAttrSet writeIf withPlugins;
  cfg = config.lvim.telescope;
in {
  options.lvim.telescope = {
    enable = mkEnableOption "Enables Telescope GUI";
    file_browser.enable = mkEnableOption "Enables Telescope file browser";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins cfg.file_browser.enable [telescope-file-browser])
      ++ [telescope-nvim]
    );
    nnoremap =
      {
        "<leader>ff" = "<cmd> Telescope find_files<CR>";
        "<leader>fg" = "<cmd> Telescope live_grep<CR>";
        "<leader>fb" = "<cmd> Telescope buffers<CR>";
        "<leader>fh" = "<cmd> Telescope help_tags<CR>";

        "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
        "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
        "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
        "<leader>fvs" = "<cmd> Telescope git_status<CR>";
        "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
      }
      // (
        withAttrSet config.lvim.lsp.enable {
          "<leader>flsb" = "<cmd> Telescope lsp_document_symbols<CR>";
          "<leader>flsw" = "<cmd> Telescope lsp_workspace_symbols<CR>";
          "<leader>flr" = "<cmd> Telescope lsp_references<CR>";
          "<leader>fli" = "<cmd> Telescope lsp_implementations<CR>";
          "<leader>flD" = "<cmd> Telescope lsp_definitions<CR>";
          "<leader>flt" = "<cmd> Telescope lsp_type_definitions<CR>";
          "<leader>fld" = "<cmd> Telescope diagnostics<CR>";
        }
      )
      // (
        withAttrSet config.lvim.treesitter.enable {
          "<leader>fs" = "<cmd> Telescope treesitter<CR>";
        }
      )
      // (
        withAttrSet cfg.file_browser.enable {
          "<leader>ft" = "<cmd> Telescope file_browser<CR>";
          "<leader>ftc" = "<cmd> Telescope file_browser path=%:p:h select_buffer=true <CR>";
        }
      );
    rawConfig = ''
         -- TELESCOPE CONFIG
         require('telescope').setup({
           defaults = {
             vimgrep_arguments = {
               "${pkgs.silver-searcher}/bin/ag",
               "--smart-case",
               "--nocolor",
               "--noheading",
               "--column",
             },
             pickers = {
               find_command = { "${pkgs.fd}/bin/fd" }
             }
           }
         })
      ${writeIf cfg.file_browser.enable ''
        require("telescope").load_extension("file_browser")
      ''}
         -- END TELESCOPE CONFIG
    '';
  };
}
