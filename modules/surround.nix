{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.surround;
in
{
  options.lvim.surround.enable = mkEnableOption "Enable nvim-surround plugin";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [ nvim-surround ];
    rawConfig = ''
      require('nvim-surround').setup()
    '';
  };
}
