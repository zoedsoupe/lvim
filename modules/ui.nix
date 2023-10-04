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
    which_key.enable = mkEnableOption "Enables keybinding preview";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins (cfg.enable && cfg.word_highlight.enable) [vim-illuminate])
      ++ (withPlugins (cfg.enable && cfg.semantic_highlightment.enable) [hlargs])
      ++ (withPlugins (cfg.enable && cfg.which_key.enable) [which-key])
      ++ []
    );
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
      -- END UI ENHANCEMENTS
    '';
  };
}
