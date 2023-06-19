{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf writeIf;
  cfg = config.lvim.lsp;
  nullls = cfg.enable && cfg.null-ls.enable;
  ts = cfg.enable && cfg.typescript.enable;
  nix = cfg.enable && cfg.nix.enable;
  clojure = cfg.enable && cfg.clojure.enable;
  elixir = cfg.enable && cfg.elixir.enable;
  dart = cfg.enable && cfg.dart.enable;
  rust = cfg.enable && cfg.rust.enable;
in {
  options.lvim.lsp.null-ls.enable = mkEnableOption "Extends Neovim LSP support plugins";

  config.lvim = mkIf nullls {
    startPlugins = with pkgs.neovimPlugins; [null-ls];
    rawConfig = ''
        	 -- NULL LS CONFIG
        	 local null_ls = require('null-ls')
        	 local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        	 local sources = {
        		 ${writeIf ts ''
        null_ls.builtins.formatting.prettier.with({
        	command = "${pkgs.nodePackages.prettier}/bin/prettier",
        }),
        null_ls.builtins.code_actions.eslint_d.with({
        	command = "${pkgs.nodePackages.eslint_d}/bin/eslint_d",
        }),
        null_ls.builtins.diagnostics.tsc.with({
        	command = "${pkgs.nodePackages.tsc}/bin/tsc",
        }),
      ''}
        		 ${writeIf clojure ''
        null_ls.builtins.diagnostics.clj_kondo.with({
        	command = "${pkgs.clj-kondo}/bin/clj-kondo",
        }),
        null_ls.builtins.formatting.joker.with({
        	command = "${pkgs.joker}/bin/joker"
        }),
      ''}
        		 ${writeIf nix ''
        null_ls.builtins.code_actions.statix.with({
        	command = "${pkgs.statix}/bin/statix",
        }),
        null_ls.builtins.diagnostics.deadnix.with({
        	command = "${pkgs.deadnix}/bin/deadnix",
        }),
        null_ls.builtins.formatting.alejandra.with({
        	command = "${pkgs.alejandra}/bin/alejandra"
        }),
      ''}
        		 ${writeIf elixir ''
        null_ls.builtins.diagnostics.credo.with({
        	command = "${pkgs.elixir}/bin/mix"
        }),
        null_ls.builtins.formatting.mix.with({
        	command = "${pkgs.elixir}/bin/mix"
        }),
      ''}
        		 ${writeIf dart ''
        null_ls.builtins.formatting.dart_format.with({
        	command = "${pkgs.dart}/bin/dart"
        }),
      ''}
        		 ${writeIf rust ''
        null_ls.builtins.formatting.rustfmt.with({
        	command = "${pkgs.rustfmt}/bin/rustfmt"
        }),
      ''}
      null_ls.builtins.formatting.trim_whitespace.with({
       command = "${pkgs.gawk}/bin/gawk"
      }),
      null_ls.builtins.diagnostics.alex.with({
      command = "${pkgs.nodePackages.alex}/bin/alex"
      }),
      null_ls.builtins.diagnostics.hadolint.with({
      	command = "${pkgs.hadolint}/bin/hadolint"
      }),
      null_ls.builtins.diagnostics.stylelint.with({
      	command = "${pkgs.nodePackages.stylelint}/bin/stylelint"
      }),
      null_ls.builtins.formatting.stylelint.with({
      	command = "${pkgs.nodePackages.stylelint}/bin/stylelint"
      }),
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.completion.luasnip,

        }
        null_ls.setup({
        	sources = sources,
        	on_attach = function(client, bufnr)
        					if client.supports_method("textDocument/formatting") then
        							vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        							vim.api.nvim_create_autocmd("BufWritePre", {
        									group = augroup,
        									buffer = bufnr,
        									callback = function()
        											vim.lsp.buf.format({ bufnr = bufnr })
        											-- vim.lsp.buf.formatting_sync()
        									end,
        							})
        					end
        			end
        })
        	 -- END NULL LS CONFIG
    '';
  };
}
