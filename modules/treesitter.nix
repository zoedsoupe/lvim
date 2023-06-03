{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (pkgs) neovimPlugins;
  inherit (lib) mkEnableOption mkIf withPlugins writeIf mkOption types;
  cfg = config.lvim.treesitter;
in {
  options.lvim.treesitter = {
    grammars = mkOption {
      description = "Grammars packages";
      type = types.listOf types.str;
      default = [];
    };
    enable = mkEnableOption "Enables tree-sitter [nvim-treesitter]";
    autotag.enable = mkEnableOption "Enables auto tagging";
    context.enable = mkEnableOption "Enables block context";
    rainbow.enable = mkEnableOption "Enables rainbow colored pairs";
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with neovimPlugins; (
      (withPlugins cfg.autotag.enable [nvim-ts-autotag])
      ++ (withPlugins cfg.context.enable [nvim-ts-context])
      ++ (withPlugins cfg.rainbow.enable [nvim-ts-rainbow])
      ++ [(pkgs.vimPlugins.nvim-treesitter.withPlugins (p: map (g: p.${g}) cfg.grammars))]
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
