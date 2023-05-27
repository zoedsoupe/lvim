{ lib, config, ... }:

let
  inherit (lib) mkOption types boolStr;
  cfg = config.lvim;
  mkMappingOption = it: mkOption ({
    default = { };
    type = types.attrsOf (types.nullOr types.str);
  } // it);
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

    globals = mkOption {
      default = { };
      description = "Set containing global variable values";
      type = types.attrs;
    };

    # Mappings
    nnoremap = mkMappingOption {
      description = "Defines 'Normal mode' mappings";
    };

    inoremap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vnoremap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    snoremap = mkMappingOption {
      description = "Defines 'Select mode' mappings";
    };

    nmap = mkMappingOption {
      description = "Defines 'Normal mode' mappings";
    };

    imap = mkMappingOption {
      description = "Defines 'Insert and Replace mode' mappings";
    };

    vmap = mkMappingOption {
      description = "Defines 'Visual and Select mode' mappings";
    };

    smap = mkMappingOption {
      description = "Defines 'Select mode' mappings";
    };
  };

  config =
    let
      inherit (lib) mapAttrsFlatten;
      inherit (lib.strings) concatStrings;
      inherit (lib.lists) flatten;
      inherit (builtins) concatStringsSep toJSON;
      mapOpts = o: concatStrings (flatten [ "{" (mapAttrsFlatten (k: v: "${k} = ${boolStr v},") o) "}" ]);
      concatKeybinding = m: k: v: o: concatStrings [ "map(" "\"${m}\"," "\"${k}\"," "\"${v}\"," (mapOpts o) ")" ];
      mapLuabinding = mode: maps: o: mapAttrsFlatten (k: v: concatKeybinding mode k v o) maps;
      nmap = mapLuabinding "n" cfg.nmap { };
      imap = mapLuabinding "i" cfg.imap { };
      vmap = mapLuabinding "v" cfg.vmap { };
      smap = mapLuabinding "s" cfg.smap { };
      nnoremap = mapLuabinding "n" cfg.nnoremap { noremap = true; };
      inoremap = mapLuabinding "i" cfg.inoremap { noremap = true; };
      vnoremap = mapLuabinding "v" cfg.vnoremap { noremap = true; };
      snoremap = mapLuabinding "s" cfg.snoremap { noremap = true; };
      globals = mapAttrsFlatten (n: v: "vim.g.${n} = ${toJSON v}") cfg.globals;
    in
    {
      lvim.configRC = ''
        lua << EOF
        ${cfg.rawConfig}

        -- KEYBIDINGS
        local map = vim.api.nvim_set_keymap
        ${concatStringsSep "\n" nmap}
        ${concatStringsSep "\n" imap}
        ${concatStringsSep "\n" vmap}
        ${concatStringsSep "\n" smap}
        ${concatStringsSep "\n" nnoremap}
        ${concatStringsSep "\n" inoremap}
        ${concatStringsSep "\n" vnoremap}
        ${concatStringsSep "\n" snoremap}
        -- END KEYBIDINGS

        -- GLOBALS
        ${concatStringsSep "\n" globals}
        -- END GLOBALS
        EOF
      '';
    };
}
