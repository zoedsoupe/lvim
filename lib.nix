{
  pkgs,
  inputs,
}: let
  inherit (pkgs.lib) evalModules;
in {
  withPlugins = cond: plugins:
    if cond
    then plugins
    else [];
  writeIf = cond: msg:
    if cond
    then msg
    else "";
  boolStr = cond:
    if cond
    then "true"
    else "false";
  withAttrSet = cond: attrSet:
    if cond
    then attrSet
    else {};

  mkNeovim = {config}: let
    lvim = opts.config.lvim;
    opts = evalModules {
      modules = [
        {imports = [./modules];}
        config
      ];
      specialArgs = {inherit pkgs;};
    };
  in
    pkgs.wrapNeovim pkgs.neovim-unwrapped {
      withNodeJs = true;
      withPython3 = true;
      configure = {
        customRC = lvim.configRC;
        packages.myVimPackage = {
          start = lvim.startPlugins;
          opt = lvim.optPlugins;
        };
      };
    };

  buildPluginOverlay = super: self: let
    inherit (pkgs.lib.lists) last;
    inherit (pkgs.lib.strings) splitString;
    inherit (pkgs.lib.attrsets) attrByPath;
    inherit (builtins) attrNames getAttr listToAttrs filter;
    inherit (self.vimUtils) buildVimPluginFrom2Nix;
    isPlugin = n: n != "nixpkgs" && n != "flake-utils";
    plugins = filter isPlugin (attrNames inputs);
    buildPlug = name:
      buildVimPluginFrom2Nix {
        pname = name;
        version = last (splitString "/" (attrByPath [name "url"] "HEAD" inputs));
        src = getAttr name inputs;
      };
  in {
    neovimPlugins = listToAttrs (map
      (name: {
        inherit name;
        value = buildPlug name;
      })
      plugins);
  };
}
