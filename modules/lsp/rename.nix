{ lib, pkgs, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.lsp;
  rename = cfg.enable && cfg.rename.enable;
in
{
  options.lvim.lsp.rename.enable = mkEnableOption "Enables LSP rename plugins";

  config.lvim = mkIf rename {
    startPlugins = with pkgs.neovimPlugins; [ inc-rename ];
    nnoremap = {
      "<leader>rn" = ":IncRename";
    };
    rawConfig = ''
      -- INC RENAME CONFIG
      require('inc_rename').setup()
      -- INC RENAME CONFIG
    '';
  };
}
