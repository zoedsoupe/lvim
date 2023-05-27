{ lib, config, ... }:

let
  inherit (lib) mkOption types;
  cfg = config.lvim;
in
{
  options.lvim = {
    startPlugins = mkOption {
      description = "Plugins that are runned on neovim start";
      type = types.listOf types.package;
      default = [ ];
    };

    optPlugins = mkOption {
      description = "Plugins that are runned on-demand";
      type = types.listOf types.package;
      default = [ ];
    };

    rawConfig = mkOption {
      description = "Raw Lua config, if necessary";
      type = types.lines;
      default = "";
    };

    configRC = mkOption {
      description = "Raw vimscript config, used internally";
      type = types.lines;
      default = "";
    };
  };

  config = {
    lvim.configRC = ''
      lua << EOF
      ${cfg.rawConfig}
      EOF
    '';
  };
}
