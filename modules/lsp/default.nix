{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.lvim.lsp;
in {
  imports = [./clojure.nix ./css.nix ./dart.nix ./elixir.nix ./nix.nix ./nullls.nix ./rename.nix ./rust.nix ./trouble.nix ./typescript.nix];

  options.lvim.lsp.enable = mkEnableOption "Enables programming languages support";

  config.lvim = mkIf cfg.enable {
    startPlugins = with pkgs.neovimPlugins; [nvim-lspconfig];
    nnoremap = mkIf cfg.enable {
      # need remapping optitons...
      # and also accept csutom options [ev].buf
      /*
         "<leader>gD" = "<cmd>lua  vim.lsp.buf.declaration";
      "<leader>gd" = "<cmd>lua vim.lsp.buf.definition";
      "<leader>K" = "<cmd>lua vim.lsp.buf.hover";
      "<leader>gi" = "<cmd>lua vim.lsp.buf.implementation";
      "<leader><C-k>" = "<cmd>lua vim.lsp.buf.signature_help";
      "<leader>wa" = "<cmd>lua vim.lsp.buf.add_workspace_folder";
      "<leader>wr" = "<cmd>lua vim.lsp.buf.remove_workspace_folder";
      "<leader>wl" = "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))";
      "<leader>D" = "<cmd>lua vim.lsp.buf.type_definition";
      "<leader>rn" = "<cmd>lua vim.lsp.buf.rename";
      "<leader>v" = "<cmd>lua vim.lsp.buf.code_action";
      "<leader>gr" = "<cmd>lua vim.lsp.buf.references";
      "<leader>f" = "<cmd>lua vim.lsp.buf.format { async = true }";
      */

      "<leader>e" = "<cmd>lua vim.diagnostic.open_float<cr>";
      "<leader>[d" = "<cmd>lua vim.diagnostic.goto_prev<cr>";
      "<leader>]d" = "<cmd>lua vim.diagnostic.goto_next<cr>";
      "<leader>q" = "<cmd>lua vim.diagnostic.setloclist<cr>";
    };
    rawConfig = ''
      -- LSP CONFIG
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })
      -- END LSP CONFIG
    '';
  };
}
