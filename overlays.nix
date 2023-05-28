{ lib }:

let
  libOverlay = f: p: {
    lib = p.lib.extend (_: _: {
      inherit (lib) withPlugins writeIf boolStr withAttrSet;
    });
  };
in
{
  overlays = [ lib.buildPluginOverlay libOverlay ];
}
