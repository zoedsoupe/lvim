{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types writeIf withPlugins mkIf;
  cfg = config.lvim.theme;
  enum' = name: flavours: other:
    if (cfg.name == name)
    then types.enum flavours
    else other;
in {
  options.lvim.theme = {
    enable = mkEnableOption "Enable theme customization";
    name = mkOption {
      description = "Name of the theme to use";
      type = types.enum ["doom-one" "rose-pine" "catppuccin"];
      default = "catppuccin";
    };
    flavour = mkOption {
      description = "Theme style";
      type = let
        rp = enum' "rose-pine" ["main" "moon" "dawn"];
        cp = types.enum ["frappe" "latte" "macchiato" "mocha"];
      in
        rp cp;
      default = "macchiato";
    };
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins (cfg.name == "doom-one") [theme-doom-one])
      ++ (withPlugins (cfg.name == "rose-pine") [theme-rose-pine])
      ++ (withPlugins (cfg.name == "catppuccin") [theme-catppuccin])
    );
    globals = mkIf (cfg.name == "doom-one") {
      doom_one_terminal_colors = true;
      doom_one_plugin_whichkey = true;
      doom_one_plugin_indent_blankline = true;
      doom_one_plugin_nvim_tree = true;
      doom_one_plugin_dashboard = true;
      doom_one_plugin_telescope = true;
    };
    rawConfig = ''
      ${writeIf (cfg.name == "catppuccin") ''
        -- CATPPUCCIN THEME
        require('catppuccin').setup({
          flavour = "${cfg.flavour}"
        })
        vim.cmd('colo catppuccin')
        -- END CATPPUCCIN THEME
      ''}

      ${writeIf (cfg.name == "doom-one") "vim.cmd('colo doom-one')"}

      ${writeIf (cfg.name == "rose-pine") ''
        -- ROSE PINE THEME
        require('rose-pine').setup({
          darkvariant = "${cfg.flavour}"
        })
        vim.cmd('colo rose-pine')
        -- END ROSE PINE THEME
      ''}
    '';
  };
}
