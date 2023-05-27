{ lib, config, pkgs, ... }:

let
  inherit (lib) types mkOption writeIf boolStr;
  inherit (types) bool str int enum listOf;

  cfg = config.lvim;
in
{
  options.lvim = {
    colourTerm = mkOption {
      default = true;
      description = "Set terminal up for 256 colours";
      type = bool;
    };

    concealLevel = mkOption {
      default = 0;
      description = "Show up `` on markdown and ** in org";
      type = int;
    };

    colorColumn = mkOption {
      default = "";
      description = "Comma separated list of screen columns that are highlighted with ColorColumn";
      type = str;
    };

    completeOpt = mkOption {
      default = [ ];
      description = "Completions options";
      type = listOf str;
    };

    foldMethod = mkOption {
      default = "syntax";
      description = "How to fold text blocks";
      type = str;
    };

    hlSearch = mkOption {
      default = false;
      description = "Highlight all matches of a previous search pattern";
      type = bool;
    };

    background = mkOption {
      default = "light";
      description = "Sets background color";
      type = str;
    };

    mapLeaderSpace = mkOption {
      default = true;
      description = "Map the space key to leader key";
      type = bool;
    };

    lineNumberMode = mkOption {
      default = "relNumber";
      description = "How line numbers are displayed. none relative number relNumber";
      type = enum [ "relative" "number" "relNumber" "none" ];
    };

    tabWidth = mkOption {
      default = 2;
      description = "Set the width of tabs to 2";
      type = int;
    };

    autoIndent = mkOption {
      default = true;
      description = "Enable auto indent";
      type = bool;
    };

    cmdHeight = mkOption {
      default = 2;
      description = "Hight of the command pane";
      type = int;
    };

    showSignColumn = mkOption {
      default = true;
      description = "Show the sign column";
      type = bool;
    };

    mapTimeout = mkOption {
      default = 300;
      description = "Timeout microseconds that neovim will wait for mapped action to complete";
      type = int;
    };

    splitBelow = mkOption {
      default = true;
      description = "New splits will open below instead of on top";
      type = bool;
    };

    splitRight = mkOption {
      default = true;
      description = "New splits will open to the right";
      type = bool;
    };

    mouseSupport = mkOption {
      default = "a";
      description = "Set modes for mouse support. a - all n - normal v - visual i - insert c - command";
      type = types.str;
    };

    syntaxHighlighting = mkOption {
      default = true;
      description = "Enable syntax highlighting";
      type = bool;
    };
  };

  config.lvim = {
    startPlugins = with pkgs.neovimPlugins; [ lazy-nvim plenary-nvim ];
    rawConfig = ''
      -- BASIC CONFIG

      -- visual
      vim.o.conceallevel = ${toString cfg.concealLevel}
      vim.o.cmdheight = ${toString cfg.cmdHeight}
      vim.o.termguicolors = ${toString cfg.colourTerm}
      ${writeIf (cfg.lineNumberMode == "number") ''
      vim.wo.number = true
      ''}
      ${writeIf (cfg.lineNumberMode == "relative") ''
      vim.wo.relativenumber = true
      ''}
      ${writeIf (cfg.lineNumberMode == "relNumber") ''
      vim.wo.number = true
      vim.wo.relativenumber = true
      ''}
      vim.wo.signcolumn = "${if cfg.showSignColumn then "yes" else "no"}"

      -- behaviour
      vim.o.hlsearch = ${boolStr cfg.hlSearch}
      vim.o.smartindent = ${boolStr cfg.autoIndent}
      vim.o.tabstop = ${toString cfg.tabWidth}
      vim.o.softtabstop = ${toString cfg.tabWidth}
      vim.o.shiftwidth = ${toString cfg.tabWidth}
      vim.o.splitbelow = ${boolStr cfg.splitBelow}
      vim.o.splitright = ${boolStr cfg.splitRight}
      vim.o.mouse = "${toString cfg.mouseSupport}"
      ${writeIf cfg.mapLeaderSpace ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = ","
      ''}

      -- vim specific
      vim.o.hidden = true
      vim.o.fileencoding = "utf-8"
      vim.o.completeopt = "menuone,noinsert,noselect"
      vim.o.wildmode = "longest,full"
      vim.o.updatetime = ${toString cfg.mapTimeout}
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.g.so = 999

      -- END BASIC CONFIG
    '';
  };
}
