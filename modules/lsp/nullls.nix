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
        	cmd = {"${pkgs.nodePackages.prettier}/bin/prettier"},
        }),
        null_ls.builtins.code_actions.eslint_d.with({
        	cmd = {"${pkgs.nodePackages.eslint_d}/bin/eslint_d"},
        }),
        null_ls.builtins.diagnostics.tsc.with({
        	cmd = {"${pkgs.nodePackages.tsc}/bin/tsc"},
        }),
      ''}
      		 ${writeIf clojure ''
        null_ls.builtins.diagnostics.clj_kondo.with({
        	cmd = {"${pkgs.clj-kondo}/bin/clj-kondo"},
        }),
        null_ls.builtins.formatting.joker.with({
        	cmd = {"${pkgs.joker}/bin/joker"}
        }),
      ''}
      		 ${writeIf nix ''
        null_ls.builtins.code_actions.statix.with({
        	cmd = {"${pkgs.statix}/bin/statix"},
        }),
        null_ls.builtins.diagnostics.deadnix.with({
        	cmd = {"${pkgs.deadnix}/bin/deadnix"},
        }),
        null_ls.builtins.formatting.nixpkgs_fmt.with({
        	cmd = {"${pkgs.alejandra}/bin/alejandra"}
        }),
      ''}
      		 ${writeIf elixir ''
        null_ls.builtins.diagnostics.credo.with({
        	cmd = {"${pkgs.elixir}/bin/mix"}
        }),
        null_ls.builtins.formatting.mix.with({
        	cmd = {"${pkgs.elixir}/bin/mix"}
        }),
      ''}
      		 ${writeIf dart ''
        null_ls.builtins.formatting.dart_format.with({
        	cmd = {"${pkgs.dart}/bin/dart"}
        }),
      ''}
      		 ${writeIf rust ''
        null_ls.builtins.formatting.rustfmt.with({
        	cmd = {"${pkgs.rustfmt}/bin/rustfmt"}
        }),
      ''}
      		 null_ls.builtins.formatting.trim_whitespace.with({
      			 cmd = {"${pkgs.gawk}/bin/gawk"}
      		 }),
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
