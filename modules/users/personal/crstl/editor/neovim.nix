{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # withNodeJs = lib.mkIf config.services.xserver.enable true;
    # withPython3 = lib.mkIf config.services.xserver.enable true;
    withRuby = false;

    extraPackages = [
      pkgs.git
      pkgs.nil
      # ]
      # ++ lib.optionals config.services.xserver.enable
      # [
      # tree-sitter
      pkgs.bat
      pkgs.clang
      pkgs.delta
      pkgs.elmPackages.elm-language-server
      pkgs.fzf
      pkgs.haskell-language-server
      pkgs.luaPackages.lua-lsp
      # pkgs.nodePackages.pyright
      pkgs.nodePackages.typescript
      pkgs.nodePackages.typescript-language-server
      pkgs.ripgrep
      pkgs.silver-searcher
      # sumneko-lua-language-server
    ];

    # config = lib.mkIf cfg.enable {
    #   # Clear the /tmp directory when the system is rebooted
    #   boot.cleanTmpDir = lib.mkDefault true;

    #   profiles.preferences.customizedVimPlugins =
    #     pkgs.vimPlugins
    #     // (with pkgs.vimPlugins; {
    #       # Code editing: Comment and uncomment
    #       vim-commentary = {
    #         plugin = vim-commentary;
    #       };

    #       # Programming language integrations: Language servers
    #       nvim-lspconfig = {
    #         plugin = nvim-lspconfig;
    #         type = "lua";
    #         # plugin = nvim-lspconfig.overrideAttrs (oldAttrs: {
    #         #   dependencies = (old.dependencies or [ ]) ++ [
    #         #     # lsp_extensions-nvim
    #         #     # lsp_signature-nvim
    #         #     # lua-dev-nvim
    #         #     # SchemaStore-nvim
    #         #   ];
    #         # });
    #         config = ''
    #           loadfile('${./neovim/plugins/lspconfig.lua}')()
    #         '';
    #       };

    #       # Code editing: Auto-completion
    #       nvim-cmp = {
    #         plugin = nvim-cmp;
    #         type = "lua";
    #         config =
    #           # Note caveats in the readme regarding native menu
    #           ''
    #             local cmp = require('cmp')
    #             cmp.setup({
    #               snippet = {
    #                 -- I don't use snippets but it appears to be required
    #                 expand = function(args)
    #                   require('luasnip').lsp_expand(args.body)
    #                 end,
    #               },
    #               mapping = cmp.mapping.preset.insert({
    #                 -- Accept the currently selected item
    #                 ['<CR>'] = cmp.mapping.confirm({ select = true }),
    #                 -- Force auto-completion in insert mode without first typing something
    #                 ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    #               }),
    #               sources = cmp.config.sources({
    #                 -- Listed in order of preference
    #                 { name = 'nvim_lua' },
    #                 { name = 'nvim_lsp' },
    #                 { name = 'luasnip' },
    #                 { name = 'buffer' },
    #               })
    #             })
    #             vim.opt.completeopt = {
    #               -- Show the completion menu for a single match so that documentation will always appear
    #               "menuone",
    #               -- Don't pop open documentation unless you explicitly navigate the completion menu
    #               "noselect",
    #             }
    #             -- Suppress command-line noise related to completions
    #             vim.opt.shortmess:append "c"
    #           '';
    #       };

    #       # Code editing: Auto-completion with current buffer contents
    #       cmp-buffer = {
    #         plugin = cmp-buffer;
    #         type = "lua";
    #         config = ''
    #           -- Use buffer as a completion source for search via /
    #           require('cmp').setup.cmdline('/', {
    #             sources = {
    #               { name = 'buffer' }
    #             }
    #           })
    #         '';
    #       };

    #       # Code editing: Auto-completion with language servers
    #       cmp-nvim-lsp = {
    #         plugin = cmp-nvim-lsp;
    #       };

    #       # Code editing: Auto-completion with nvim's lua api
    #       cmp-nvim-lua = {
    #         plugin = cmp-nvim-lua;
    #       };

    #       # Git support
    #       vim-fugitive = {
    #         plugin = vim-fugitive;
    #       };

    #       # Git support: Show changed lines in gutter (replaces gitgutter)
    #       gitsigns-nvim = {
    #         plugin = gitsigns-nvim;
    #         type = "lua";
    #         config = ''
    #           loadfile('${./neovim/plugins/gitsigns.lua}')()
    #         '';
    #       };

    #       # Nix support
    #       vim-nix = {
    #         plugin = vim-nix;
    #       };

    #       # Navigation: Fuzzy finder
    #       telescope-nvim = {
    #         plugin = telescope-nvim;
    #         type = "lua";
    #         config = ''
    #           -- Search file names that are tracked by git
    #           vim.keymap.set('n', '<leader>o', function() return require('telescope.builtin').git_files() end, { desc = "Search tracked files" })
    #           -- Search file names modified relative to HEAD
    #           vim.keymap.set('n', '<leader>m', function() return require('telescope.builtin').git_status() end, { desc = "Search modified files" })
    #           -- Search file names
    #           vim.keymap.set('n', '<leader>O', function() return require('telescope.builtin').find_files() end, { desc = "Search files" })
    #           -- Search file contents
    #           vim.keymap.set('n', '<leader>/', function() return require('telescope.builtin').live_grep() end, { desc = "Search files contents" })
    #           -- Search buffer names
    #           vim.keymap.set('n', '<leader>b', function() return require('telescope.builtin').buffers() end, { desc = "Search open buffers" })
    #           -- Search diagnostics in all open buffers
    #           vim.keymap.set('n', '<leader>D', function() return require('telescope.builtin').diagnostics() end, { desc = "Search workspace diagnostics" })
    #           -- Search diagnostics
    #           vim.keymap.set('n', '<leader>d', function() return require('telescope.builtin').diagnostics({ bufnr = 0 }) end, { desc = "Search diagnostics" })
    #           -- Search vim help
    #           vim.keymap.set('n', '<leader>hh', function() return require('telescope.builtin').help_tags() end, { desc = "Search vim help" })
    #           -- Pressing esc twice to cancel is annoying, so map <esc> to directly close the popup in insert mode
    #           local actions = require('telescope.actions')
    #           require('telescope').setup({
    #             defaults = {
    #               mappings = {
    #                 i = {
    #                   ["<esc>"] = actions.close,
    #                 },
    #               },
    #             },
    #           })
    #         '';
    #       };
    #       telescope-fzf-native-nvim = {
    #         # native fzf ostensibly improves performance
    #         plugin = telescope-fzf-native-nvim;
    #         type = "lua";
    #         config = ''
    #           require('telescope').load_extension('fzf')
    #         '';
    #       };

    #       # Navigation: File tree
    #       nvim-tree-lua = {
    #         plugin = nvim-tree-lua;
    #         type = "lua";
    #         config = ''
    #           require('nvim-tree').setup({
    #           })
    #         '';
    #       };

    #       # Navigation: Tabline
    #       bufferline-nvim = {
    #         plugin = bufferline-nvim;
    #         type = "lua";
    #         config = ''
    #           require('bufferline').setup({
    #             options = {
    #               -- Needed because vim buffers are different from vim tab pages.
    #               -- This is the same as setting vim.opt.showtabline = 2.
    #               always_show_bufferline = true,
    #             },
    #           })
    #         '';
    #       };

    #       # Aesthetics: Color scheme
    #       gruvbox-nvim = {
    #         # faster than gruvbox and gruvbox-community
    #         plugin = gruvbox-nvim;
    #         type = "lua";
    #         config = ''
    #           vim.cmd [[colorscheme gruvbox]]
    #           -- TODO: move to playground
    #           -- "Hide" the cursor line highlight past column 80 and 120 to hint at potential text wrap.
    #           vim.o.colorcolumn=vim.fn.join(vim.fn.range(81,121), ',') .. vim.fn.join(vim.fn.range(121,999), ',')
    #           vim.api.nvim_set_hl(0, 'ColorColumn', { link = 'Normal' })
    #         '';
    #       };

    #       # Aesthetics: icons
    #       nvim-web-devicons = {
    #         plugin = nvim-web-devicons;
    #       };

    #       # Aesthetics: status/tabline
    #       lualine-nvim = {
    #         plugin = lualine-nvim.overrideAttrs (oldAttrs: {
    #           dependencies =
    #             (oldAttrs.dependencies or [])
    #             ++ [
    #               lualine-lsp-progress
    #             ];
    #         });
    #         type = "lua";
    #         config = ''
    #           require('lualine').setup({
    #            sections = {
    #              lualine_a = { { 'mode', upper = true } },
    #              lualine_b = { { 'branch', icon = '' } },
    #              lualine_c = {
    #                 { 'filename', file_status = true, path = 1 },
    #                 { 'diagnostics', sources = { 'nvim_lsp' } },
    #                 { 'lsp_progress' },
    #              },
    #              lualine_x = { 'encoding', 'filetype' },
    #              lualine_y = { 'progress' },
    #              lualine_z = { 'location' },
    #            },
    #           })
    #           -- Suppress mode prefixes like "-- INSERT --" in the command-line
    #           vim.opt.showmode = false
    #         '';
    #       };

    #       # Vim: key binding feedback
    #       which-key-nvim = {
    #         plugin = which-key-nvim;
    #         type = "lua";
    #         config = ''
    #           require('which-key').setup({
    #           })
    #         '';
    #       };

    #       # Vim: benchmarking
    #       vim-startuptime = {
    #         # Run with vim --startuptime
    #         plugin = vim-startuptime;
    #       };
    #     });

    # plugins = with config.profiles.preferences.customizedVimPlugins; [
    #   # Programming language integrations: Language servers
    #   nvim-lspconfig

    #   # Code editing: Comment and uncomment
    #   vim-commentary

    #   # Code editing: Auto-completion
    #   nvim-cmp

    #   # Code editing: Auto-completion with language servers
    #   cmp-nvim-lsp

    #   # Code editing: Auto-completion with current buffer contents
    #   cmp-buffer

    #   # Code editing: Auto-completion with nvim's lua api
    #   cmp-nvim-lua

    #   # Code editing: Auto-completion with current buffer contents
    #   cmp-buffer

    #   # Git support
    #   vim-fugitive

    #   # Git support: Show changed lines in gutter
    #   gitsigns-nvim

    #   # Nix support
    #   vim-nix

    #   # Navigation: Fuzzy finder
    #   telescope-nvim
    #   telescope-fzf-native-nvim

    #   # Navigation: File tree
    #   nvim-tree-lua

    #   # Navigation: Buffers
    #   bufferline-nvim

    #   # Aesthetics: Color scheme
    #   gruvbox-nvim

    #   # Aesthetics: icons
    #   nvim-web-devicons

    #   # Aesthetics: Status/tabline
    #   lualine-lsp-progress
    #   lualine-nvim

    #   # Vim: key binding feedback
    #   which-key-nvim

    #   # Vim: benchmarking
    #   vim-startuptime
    # ];

    # extraConfig = ''
    #   let g:loaded_perl_provider = 0
    #   :set relativenumber
    #   :set rnu
    # '';

    plugins = with pkgs; [
      vimPlugins.vim-nix
      # ]
      # ++ lib.optionals config.services.xserver.enable
      # [
      vimPlugins.vim-clap
      vimPlugins.fzf-vim
      # vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-snippy
      vimPlugins.cmp-path
      vimPlugins.cmp-cmdline
      vimPlugins.cmp-buffer
      vimPlugins.cmp-digraphs
      vimPlugins.cmp-cmdline-history
      vimPlugins.cmp-nvim-lsp-document-symbol
      vimPlugins.cmp-nvim-lsp-signature-help
      vimPlugins.cmp-git
      vimPlugins.vim-airline-themes
      {
        plugin = vimPlugins.nvim-cmp;
        config = ''
          set completeopt=menu,menuone,noselect

          lua <<EOF
          local cmp = require'cmp'
          cmp.setup({
            snippet = {
              expand = function(args)
                require('snippy').expand_snippet(args.body)
              end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<C-e>'] = cmp.mapping.abort(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_document_symbol' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'cmdline_history' },
              { name = 'digraphs' },
              { name = 'path' },
              { name = 'buffer-lines' },
              { name = 'snippy' },
              { name = "git" },
            }, {
              { name = 'buffer' },
            })
          })

          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'cmp_git' },
            }, {
              { name = 'buffer' },
            })
          })

          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })

          local capabilities = require('cmp_nvim_lsp').default_capabilities()

          require'lspconfig'.pyright.setup {
            capabilities = capabilities,
          }
          require'lspconfig'.rnix.setup {
            capabilities = capabilities,
          }
          require'lspconfig'.tsserver.setup {
            capabilities = capabilities,
          }
          require'lspconfig'.clangd.setup {
            capabilities = capabilities,
          }
          EOF
        '';
      }
      {
        plugin = vimPlugins.nvim-snippy;
        config = ''
          lua << EOF
          require('snippy').setup({
              mappings = {
                  is = {
                      ['<Tab>'] = 'expand_or_advance',
                      ['<S-Tab>'] = 'previous',
                  },
                  nx = {
                      ['<leader>x'] = 'cut_text',
                  },
              },
          })
          EOF
        '';
      }
      {
        plugin = vimPlugins.nvim-tree-lua;
        config = ''
          lua << EOF
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          vim.opt.termguicolors = true
          require("nvim-tree").setup()
          EOF
        '';
      }
      {
        plugin = vimPlugins.vim-airline;
        config = ''
          let g:airline_powerline_fonts = 1
          let g:airline_theme='base16'
          let g:airline#extensions#nvimlsp#enabled = 1
        '';
      }
      {
        plugin = vimPlugins.vim-which-key;
        config = ''
          lua << EOF
          require("which-key").setup()
          EOF
        '';
      }
      {
        plugin = vimPlugins.nvim-autopairs;
        config = ''
          lua << EOF
          require("nvim-autopairs").setup()
          EOF
        '';
      }
      {
        plugin = vimPlugins.nvim-lspconfig;
        config = ''
          lua << EOF
          local opts = { noremap=true, silent=true }
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

          local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          end

          local lsp_flags = {
            debounce_text_changes = 150,
          }
          require('lspconfig')['pyright'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
          }
          require('lspconfig')['rnix'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
          }
          require('lspconfig')['tsserver'].setup{
              on_attach = on_attach,
              flags = lsp_flags,
          }
          EOF
        '';
      }
    ];
  };
}
