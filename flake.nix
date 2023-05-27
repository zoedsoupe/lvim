{
  description = "Define and config a Neovim using Nix with Lua output!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    lazy-nvim = {
      url = "github:folke/lazy.nvim/v9.20.0";
      flake = false;
    };

    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };

    nvim-surround = {
      url = "github:kylechui/nvim-surround/v2.0.5";
      flake = false;
    };

    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim/v0.1.3";
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

    theme-rose-pine = {
      url = "github:rose-pine/neovim/v1.2.0";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        lib = import ./lib.nix { inherit pkgs inputs; };

        inherit (import ./overlays.nix {
          inherit lib;
        }) overlays;

        pkgs = import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };

        config = {
          lvim = {
            autopair.enable = true;
            surround.enable = true;
            theme = {
              enable = true;
              name = "catppuccin";
              flavour = "macchiato";
            };
          };
        };
      in
      rec {
        apps = rec {
          lvim = {
            type = "app";
            program = "${packages.default}/bin/nvim";
          };
          default = lvim;
        };

        overlays.default = super: self: {
          inherit (lib) mkNeovim;
          inherit (pkgs) neovimPlugins;
          lvim = packages.lvim;
        };

        packages = rec {
          default = lvim;
          lvim = lib.mkNeovim { inherit config; };
        };

        devShells.default = pkgs.mkShell {
          packages = [ packages.lvim ];
        };
      });
}
