{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types writeIf withPlugins mkIf;
  cfg = config.lvim.theme;
  git = config.lvim.git;
  telescope = config.lvim.telescope;
  treesitter = config.lvim.treesitter;
  completion = config.lvim.completion;
  trouble = config.lvim.lsp.trouble;
  which-key = config.lvim.ui.which_key;
  illuminate = config.lvim.ui.word_highlight;
  indent = config.lvim.visuals.indentBlankline;
  lsp = config.lvim.lsp;
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
    flavour = {
      dark = mkOption {
        description = "Dark variant of theme style required";
        type = let
          rp = enum' "rose-pine" ["main" "dawn"];
          cp = types.enum ["frappe" "macchiato" "mocha"];
        in
          rp cp;
        default = "macchiato";
      };
      light = mkOption {
        description = "Light variant theme style";
        type = let
          rp = enum' "rose-pine" ["moon"];
          cp = types.enum ["latte"];
        in
          types.nullOr (rp cp);
        default = null;
      };
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
      doom_one_plugin_telescope = true;
      doom_one_plugin_vim_illuminate = true;
    };
    rawConfig = ''
          		${writeIf (cfg.name == "catppuccin") ''
        			-- CATPPUCCIN THEME
        			require('catppuccin').setup({
        				flavour = "${cfg.flavour.dark}",
        	${writeIf (cfg.flavour.light != null) ''
                  background = {
          	light = "${cfg.flavour.light}",
          	dark = "${cfg.flavour.dark}",
          },
        ''}
        	integrations = {
        		${writeIf completion.enable ''
          cmp = true,
        ''}
        		${writeIf git.enable ''
          gitsigns = true,
        ''}
        		${writeIf telescope.enable ''
          telescope = true,
        ''}
        		${writeIf treesitter.enable ''
          treesitter = true,
        ''}
        		${writeIf treesitter.rainbow.enable ''
          ts_rainbow2 = true,
        ''}
        		${writeIf trouble.enable ''
          lsp_trouble = true,
        ''}
        		${writeIf which-key.enable ''
          which_key = true,
        ''}
        		${writeIf illuminate.enable ''
          illuminate = true,
        ''}
        		${writeIf indent.enable ''
          indent_blankline = {
          	enabled = true,
          	colored_indent_levels = false,
          },
        ''}
        		${writeIf lsp.enable ''
          native_lsp = {
          	enabled = true,
          	virtual_text = {
          		errors = { "italic" },
          		hints = { "italic" },
          		warnings = { "italic" },
          		information = { "italic" },
          	},
          	underlines = {
          		errors = { "underline" },
          		hints = { "underline" },
          		warnings = { "underline" },
          		information = { "underline" },
          	},
          },
        ''}
        	},
        })
        vim.cmd('colo catppuccin')
        	-- END CATPPUCCIN THEME
      ''}

      ${writeIf (cfg.name == "doom-one") "vim.cmd('colo doom-one')"}

      ${writeIf (cfg.name == "rose-pine") ''
        -- ROSE PINE THEME
        	require('rose-pine').setup({
        			variant = 'auto',
        			darkvariant = "${cfg.flavour.dark}",
        			${writeIf (cfg.flavour.light != null) ''
          lightvariant = "${cfg.flavour.light}"
        ''}
        			})
        vim.cmd('colo rose-pine')
        	-- END ROSE PINE THEME
      ''}
    '';
  };
}
