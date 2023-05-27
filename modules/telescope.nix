{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf withAttrSet;
  cfg = config.lvim.telescope;
in
{
  options.lvim.telescope.enable = mkEnableOption "Enables Telescope GUI";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [ telescope-nvim ];
    nnoremap = {
      "<leader>ff" = "<cmd> Telescope find_files<CR>";
      "<leader>fg" = "<cmd> Telescope live_grep<CR>";
      "<leader>fb" = "<cmd> Telescope buffers<CR>";
      "<leader>fh" = "<cmd> Telescope help_tags<CR>";
      "<leader>ft" = "<cmd> Telescope<CR>";

      "<leader>fvcw" = "<cmd> Telescope git_commits<CR>";
      "<leader>fvcb" = "<cmd> Telescope git_bcommits<CR>";
      "<leader>fvb" = "<cmd> Telescope git_branches<CR>";
      "<leader>fvs" = "<cmd> Telescope git_status<CR>";
      "<leader>fvx" = "<cmd> Telescope git_stash<CR>";
    };
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
    -- END TELESCOPE CONFIG
    '';
  };
}
