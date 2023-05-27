{ pkgs, config, lib, ... }:

let
  inherit (lib) mkEnableOption mkOption mkIf types writeIf withPlugins;
  inherit (builtins) boolToString;
  cfg = config.lvim.visuals;
in
{
  options.lvim.visuals = {
    enable = mkEnableOption "visual enhancements";
    icons.enable = mkEnableOption "enable dev icons. required for certain plugins";
    cursorWordline = {
      enable = mkEnableOption "enable word and delayed line highlight [nvim-cursorline]";
      lineTimeout = mkOption {
        type = types.int;
        description = "time in milliseconds for cursorline to appear";
      };
    };
    indentBlankline = {
      enable = mkEnableOption "enable indentation guides [indent-blankline]";
      listChar = mkOption {
        type = types.str;
        description = "Character for indentation line";
      };
      fillChar = mkOption {
        type = types.str;
        description = "Character to fill indents";
      };
      eolChar = mkOption {
        type = types.str;
        description = "Character at end of line";
      };
      showCurrContext = mkOption {
        type = types.bool;
        description = "Highlight current context from treesitter";
        default = true;
      };
    };
  };

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; (
      (withPlugins cfg.icons.enable [ nvim-web-devicons ]) ++
      (withPlugins cfg.cursorWordline.enable [ nvim-cursorline ]) ++
      (withPlugins cfg.indentBlankline.enable [ indent-blankline ])
    );
    globals = mkIf cfg.cursorWordline.enable {
      cursorline_timeout = toString cfg.cursorWordline.lineTimeout;
    };
    rawConfig = ''
      ${writeIf cfg.indentBlankline.enable ''
        vim.wo.colorcolumn = "99999"
        vim.opt.list = true
        ${writeIf (cfg.indentBlankline.eolChar != "") ''
        vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
        ''}

        ${writeIf (cfg.indentBlankline.fillChar != "") ''
        vim.opt.listchars:append({ space = "${cfg.indentBlankline.fillChar}"})
        ''}

        require('indent_blankline').setup {
          list = true,
          char = "${cfg.indentBlankline.listChar}",
          show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
          show_end_of_line = true,
        }
      ''}
    '';
  };
}
