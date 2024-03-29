{
  description = "Define and config a Neovim using Nix with Lua output!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    conjure = {
      url = "github:Olical/conjure";
      flake = false;
    };

    copilot = {
      url = "github:github/copilot.vim";
      flake = false;
    };

    earthly-vim = {
      url = "github:earthly/earthly.vim";
      flake = false;
    };

    elixir-tools = {
      url = "github:elixir-tools/elixir-tools.nvim";
      flake = false;
    };

    goyo-vim = {
      url = "github:junegunn/goyo.vim";
      flake = false;
    };

    limelight-vim = {
      url = "github:junegunn/limelight.vim";
      flake = false;
    };

    hlargs = {
      url = "github:m-demare/hlargs.nvim";
      flake = false;
    };

    inc-rename = {
      url = "github:smjonas/inc-rename.nvim";
      flake = false;
    };

    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };

    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };

    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };

    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    material-icons = {
      url = "github:DaikyXendo/nvim-material-icon";
      flake = false;
    };

    next-ls = {
      url = "github:elixir-tools/next-ls";
      flake = true;
    };

    nixd = {
      url = "github:nix-community/nixd";
      flake = true;
    };

    null-ls = {
      url = "github:nvimtools/none-ls.nvim";
      flake = false;
    };

    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    nvim-cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    nvim-cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };

    nvim-cmp-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    nvim-cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    nvim-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    nvim-colorizer = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };

    nvim-elixir = {
      url = "github:elixir-editors/vim-elixir";
      flake = false;
    };

    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    nvim-ts-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    nvim-ts-rainbow = {
      url = "github:HiPhish/nvim-ts-rainbow2";
      flake = false;
    };

    nvim-surround = {
      url = "github:kylechui/nvim-surround/v2.0.5";
      flake = false;
    };

    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim/v0.1.3";
      flake = false;
    };

    gitsigns-nvim = {
      url = "github:/lewis6991/gitsigns.nvim";
      flake = false;
    };

    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    telescope-file-browser = {
      url = "github:nvim-telescope/telescope-file-browser.nvim";
      flake = false;
    };

    telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    theme-catppuccin = {
      url = "github:catppuccin/nvim/v1.2.0";
      flake = false;
    };

    theme-doom-one = {
      url = "github:NTBBloodbath/doom-one.nvim";
      flake = false;
    };

    theme-dracula-pro = {
      url = "git+ssh://git@github.com/zoedsoupe/dracula-pro-vim";
      flake = false;
    };

    theme-enfocado = {
      url = "github:wuelnerdotexe/vim-enfocado";
      flake = false;
    };

    theme-gruvbox = {
      url = "github:sainnhe/gruvbox-material";
      flake = false;
    };

    theme-melange = {
      url = "github:savq/melange-nvim";
      flake = false;
    };

    theme-mellifluous = {
      url = "github:ramojus/mellifluous.nvim";
      flake = false;
    };

    theme-rose-pine = {
      url = "github:rose-pine/neovim/v1.2.0";
      flake = false;
    };

    trouble-nvim = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    true-zen-nvim = {
      url = "github:pocco81/true-zen.nvim";
      flake = false;
    };

    typescript-nvim = {
      url = "github:jose-elias-alvarez/typescript.nvim";
      flake = false;
    };

    vim-illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };

    vim-sexp = {
      url = "github:guns/vim-sexp";
      flake = false;
    };

    vim-sexp-mappings = {
      url = "github:tpope/vim-sexp-mappings-for-regular-people";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      lib = import ./lib.nix {inherit pkgs inputs;};

      inherit
        (import ./overlays.nix {
          inherit lib;
        })
        overlays
        ;

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      config = {
        lvim = {
          zen-mode = {
            enable = true;
            goyo.enable = true;
            limelight.enable = true;
            true-zen.enable = false;
          };
          autopair.enable = true;
          comments.enable = true;
          completion = {
            enable = true;
            buffer.enable = true;
            cmdline.enable = false;
            lsp = {
              enable = true;
              lspkind.enable = true;
            };
            path.enable = true;
            snippets = {
              enable = true;
              source = "luasnip";
            };
          };
          filetree = {
            enable = false;
            vinegar-style.enable = true;
          };
          git = {
            enable = true;
            gitsigns.enable = true;
          };
          lsp = {
            enable = true;
            clojure.enable = true;
            css.enable = true;
            dart.enable = true;
            elixir.enable = true;
            nix = {
              enable = true;
              nil.enable = true;
              nixd.enable = false;
            };
            rust.enable = false;
            typescript.enable = false;
            null-ls.enable = true;
            trouble.enable = true;
            rename.enable = true;
          };
          statusline = {
            enable = true;
            theme = "auto";
          };
          surround.enable = true;
          telescope = {
            enable = true;
            file_browser.enable = false;
          };
          theme = {
            enable = true;
            name = "enfocado";
          };
          treesitter = {
            enable = true;
            autotag.enable = true;
            context.enable = false;
            rainbow.enable = true;
            grammars = [
              "clojure"
              "css"
              "dart"
              "dockerfile"
              "eex"
              "elixir"
              "fish"
              "graphql"
              "heex"
              "html"
              "json"
              "lua"
              "markdown"
              "nix"
              "rust"
              "scss"
              "toml"
              "typescript"
              "vim"
              "yaml"
            ];
          };
          ui = {
            enable = true;
            word_highlight.enable = true;
            semantic_highlightment.enable = true;
            which_key.enable = true;
          };
          visuals = {
            icons.enable = true;
            cursorWordline.enable = true;
            indentBlankline = {
              enable = true;
            };
          };
        };
      };
    in rec {
      apps = rec {
        lvim = {
          type = "app";
          program = "${packages.default}/bin/nvim";
        };
        default = lvim;
      };

      overlays.default = _super: _self: {
        inherit (lib) mkNeovim;
        inherit (pkgs) neovimPlugins;
        lvim = packages.lvim;
      };

      packages = rec {
        default = lvim;
        lvim = lib.mkNeovim {inherit config;};
      };

      devShells.default = pkgs.mkShell {
        packages = [packages.lvim];
      };
    });
}
