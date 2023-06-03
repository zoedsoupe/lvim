{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  cfg = config.lvim.ui;
  treesitter = config.lvim.treesitter;
in {
  options.lvim.ui = {
    enable = mkEnableOption "Enables general ui enhancement";
    word_highlight.enable = mkEnableOption "Enables word highlghitment via LSP/Treesitter";
    semantic_highlightment.enable = mkEnableOption "";
    matchup.enable = mkEnableOption "Enables pair matches highlghitment";
    which_key.enable = mkEnableOption "Enables keybinding preview";
    legendary.enable = mkEnableOption "Enables command palette";
    noice.enable = mkEnableOption "Enables noice UI modifiers";
    tabout.enable = mkEnableOption "Enables tabout plugin";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins (cfg.enable && cfg.word_highlight.enable) [vim-illuminate])
      ++ (withPlugins (cfg.enable && cfg.semantic_highlightment.enable) [hlargs])
      ++ (withPlugins (cfg.enable && cfg.matchup.enable) [matchup])
      ++ (withPlugins (cfg.enable && cfg.which_key.enable) [which-key])
      ++ (withPlugins (cfg.enable && cfg.legendary.enable) [legendary])
      ++ (withPlugins (cfg.enable && cfg.noice.enable) [noice nui-nvim nvim-notify])
      ++ (withPlugins (cfg.enable && cfg.tabout.enable) [tabout])
      ++ []
    );
    globals = mkIf cfg.matchup.enable {
      "matchup_matchparen_offscreen" = "{ method = \"popup\" }";
    };
    rawConfig = ''
      -- UI ENHANCEMENTS
      ${writeIf cfg.word_highlight.enable ''
        require('illuminate').configure({delay = 200})
      ''}
      ${writeIf (treesitter.enable && cfg.semantic_highlightment.enable) ''
        require('hlargs').setup()
      ''}
      ${writeIf cfg.which_key.enable ''
        require('which-key').setup()
      ''}
      ${writeIf (cfg.which_key.enable && cfg.legendary.enable) ''
        require('legendary').setup({ which_key = { auto_register = true } })
      ''}
      ${writeIf cfg.noice.enable ''
        require('noice').setup({
        	lsp = {
        		override = {
        			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        			["vim.lsp.util.stylize_markdown"] = true,
        			["cmp.entry.get_documentation"] = true,
        		},
        	},
        	presets = {
        		bottom_search = true, -- use a classic bottom cmdline for search
        		command_palette = true, -- position the cmdline and popupmenu together
        		long_message_to_split = true, -- long messages will be sent to a split
        		inc_rename = false, -- enables an input dialog for inc-rename.nvim
        		lsp_doc_border = false, -- add a border to hover docs and signature help
        	},
        })
      ''}
      ${writeIf cfg.tabout.enable ''
        require('tabout').setup()
      ''}
      -- END UI ENHANCEMENTS
    '';
  };
}
