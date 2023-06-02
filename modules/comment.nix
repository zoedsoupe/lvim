{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.comments;
in {
  options.lvim.comments.enable = mkEnableOption "Enable comment plugin";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [kommentary];
    rawConfig = ''
      -- KOMMENTARY
      require('kommentary.config').setup();
      require('kommentary.config').configure_language("nix", {
          single_line_comment_string = "#",
      })
      -- END KOMMENTARY
    '';
  };
}
