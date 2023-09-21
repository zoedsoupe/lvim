{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.zen-mode;
in {
  options.lvim.zen-mode.enable = mkEnableOption "Enable Zen Mode";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [true-zen-nvim];
    nnoremap = {
      "<leader>za" = ":TZAtaraxis<CR>";
      "<leader>zm" = ":TZMinimalist<CR>";
      "<leader>zf" = ":TZFocus<CR>";
      "<leader>zn" = ":TZNarrow<CR>";
    };
    vnoremap = {
      "<leader>zn" = ":'<,'>TZNarrow<CR>";
    };
  };
}
