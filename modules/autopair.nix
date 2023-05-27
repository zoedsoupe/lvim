{ pkgs, lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.autopair;
in
{
  options.lvim.autopair.enable = mkEnableOption "Enable autopairing";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [
      nvim-autopairs
    ];

    rawConfig = ''
      require('nvim-autopairs').setup()
    '';
  };
}
