{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf withAttrSet withPlugins;
  cfg = config.lvim.zen-mode;
in {
  options.lvim.zen-mode = {
    enable = mkEnableOption "Enable Zen Mode";
    goyo.enable = mkEnableOption "Enables Goyo";
    limelight.enable = mkEnableOption "Enables Limelight";
    true-zen.enable = mkEnableOption "Enables True Zen";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; ((withPlugins (cfg.true-zen.enable) [true-zen-nvim])
      ++ (withPlugins (cfg.goyo.enable) [goyo-vim])
      ++ (withPlugins (cfg.limelight.enable) [limelight-vim]));
    nnoremap =
      (withAttrSet (cfg.true-zen.enable) {
        "<leader>za" = ":TZAtaraxis<CR>";
        "<leader>zm" = ":TZMinimalist<CR>";
        "<leader>zf" = ":TZFocus<CR>";
        "<leader>zn" = ":TZNarrow<CR>";
      })
      // (withAttrSet (cfg.goyo.enable && (!cfg.true-zen.enable)) {
        "<leader>za" = ":Goyo<CR>";
      })
      // (withAttrSet (cfg.limelight.enable) {
        "<leader>zl" = ":Limelight0.6<CR>";
        "<leader>zl!" = ":Limelight!<CR>";
      });
    vnoremap = mkIf (cfg.true-zen.enable) {
      "<leader>zn" = ":'<,'>TZNarrow<CR>";
    };
  };
}
