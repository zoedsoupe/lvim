{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) neovimPlugins;
  inherit (lib) mkEnableOption mkIf withPlugins writeIf;
  cfg = config.lvim.treesitter;
in {
  options.lvim.treesitter = {
    enable = mkEnableOption "Enables tree-sitter [nvim-treesitter]";
    autotag.enable = mkEnableOption "Enables auto tagging";
    context.enable = mkEnableOption "Enables block context";
    rainbow.enable = mkEnableOption "Enables rainbow colored pairs";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with neovimPlugins; (
      (withPlugins cfg.autotag.enable [nvim-ts-autotag])
      ++ (withPlugins cfg.autotag.enable [nvim-ts-context])
      ++ (withPlugins cfg.autotag.enable [nvim-ts-rainbow])
      ++ [nvim-ts]
    );
    globals = {
      "foldmethod" = "expr";
      "foldexpr" = "nvim_treesitter#foldexpr()";
      "nofoldenable" = 1;
    };
    rawConfig = ''
      -- TRESSITTER
      require('nvim-treesitter.configs').setup({
        highlight = {
          enable = true,
          use_languagetree = true,
        },
        ${writeIf cfg.rainbow.enable ''
        rainbow = {
          enable = true,
          query = 'rainbow-parens',
          strategy = require('ts-rainbow').strategy.global,
        },
      ''}
        ${writeIf cfg.autotag.enable ''
        autotag = {
          enable = true,
        },
      ''}
      })
      ${writeIf cfg.context.enable ''
        require'treesitter-context'.setup {
          enable = true,
          throttle = true,
          max_lines = 0
        }
      ''}
      -- END TRESSITTER
    '';
  };
}
