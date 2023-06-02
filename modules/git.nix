{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types withPlugins;
  cfg = config.lvim.git;
in {
  options.lvim.git = {
    enable = mkEnableOption "Enable git managent and visuals";
    gitsigns.enable = mkOption {
      type = types.bool;
      description = "Enable git options";
    };
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; withPlugins cfg.gitsigns.enable [gitsigns-nvim];
    nnoremap = {
      "<leader>gs" = "<cmd>Gitsigns stage_hunk<CR>";
      "<leader>gu" = "<cmd>Gitsigns undo_stage_hunk<CR>";
      "<leader>gr" = "<cmd>Gitsigns reset_hunk<CR>";
      "<leader>gR" = "<cmd>Gitsigns reset_buffer<CR>";
      "<leader>gp" = "<cmd>Gitsigns preview_hunk<CR>";
      "<leader>gb" = "<cmd>lua require'gitsigns'.blame_line{full=true}<CR>";
      "<leader>gS" = "<cmd>Gitsigns stage_buffer<CR>";
      "<leader>gU" = "<cmd>Gitsigns reset_buffer_index<CR>";
      "<leader>gts" = ":Gitsigns toggle_signs<CR>";
      "<leader>gtn" = ":Gitsigns toggle_numhl<CR>";
      "<leader>gtl" = ":Gitsigns toggle_linehl<CR>";
      "<leader>gtw" = ":Gitsigns toggle_word_diff<CR>";
    };
    vnoremap = {
      "<leader>gr" = ":Gitsigns reset_hunk<CR>";
      "<leader>gs" = ":Gitsigns stage_hunk<CR>";
    };
    rawConfig = mkIf cfg.gitsigns.enable ''
      -- GITSIGNS
      require('gitsigns').setup {
        keymaps = { noremap = true },
      }
      -- END GITSIGNS
    '';
  };
}
