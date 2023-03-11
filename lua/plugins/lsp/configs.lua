return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
  },
  config = function()
    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local lsp_format = require('lsp-format')

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = {
        spacing = 5,
        prefix = '~',
      },
      signs = true,
      -- update_in_insert = false,
      underline = true,
    })

    local function setup_lsp_mappings(client, bufnr)
      local function map(mode, k, v, desc)
        local map_opts = { noremap = true, silent = true, desc = desc, buffer = bufnr }
        vim.keymap.set(mode, k, v, map_opts)
      end

      -- TODO: https://github.com/CosmicNvim/CosmicNvim/blob/main/lua/cosmic/lsp/mappings.lua
      -- TODO: https://github.com/crivotz/nv-ide/blob/master/lua/settings/keymap.lua

      -- NOTE: several of the lsp queries open results in the quickfix list by
      -- default. where possible, these are replaced with a telescope picker.
      -- however, the telescope picker can be dumped to the quickfix list with
      -- <C-q>, or the <Leader>lq prefix is used for the normal quickfix queries.

      -- actions at a cursor position
      map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover')
      map('n', '<Leader>lf', '<cmd>lua vim.diagnostic.open_float()<CR>', 'open float diagnostic')
      map({ 'n', 'x' }, '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', 'code action')
      map('n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'signature help')
      map('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename')
      -- queries on a symbol
      map('n', '<Leader>lqgr', '<cmd>lua vim.lsp.buf.references()<CR>', 'references')
      map('n', '<Leader>lqgd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'goto definition')
      map('n', '<Leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'goto declaration')
      map('n', '<Leader>lqgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'goto type definition')
      map('n', '<Leader>lqgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'goto implementation')
      map('n', '<Leader>lgr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'list references')
      map('n', '<Leader>lgd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', 'list definitions')
      map('n', '<Leader>lgt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>',
        'list type definitions')
      map('n', '<Leader>lgi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', 'list implementations')
      -- document
      map('n', '<Leader>lqds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', 'query document symbols')
      map('n', '<Leader>lds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>',
        'query document symbols')
      -- formatting
      if client.server_capabilities.documentFormattingProvider then
        map('n', '<Leader>ldf', '<cmd>lua vim.lsp.buf.format()<CR>', 'format buffer')
      end
      if client.server_capabilities.documentRangeFormattingProvider then
        map('x', '<Leader>ldf', ':lua vim.lsp.buf.range_formatting()<CR>', 'format range')
      end
      map('n', '<Leader>ltf', function() lsp_format.toggle({ args = "" }) end, 'toggle format on save')
      -- workspace
      map('n', '<Leader>lqws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'query workspace symbols')
      map('n', '<Leader>lws', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>',
        'query workspace symbols')
      map('n', '<Leader>lwfl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
        'list workspace folders')
      map('n', '<Leader>lwfa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'add workspace folder')
      map('n', '<Leader>lwfr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove workspace folder')
      -- call hierarchy
      map('n', '<Leader>lqci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'incoming calls')
      map('n', '<Leader>lqco', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'outgoing calls')
      map('n', '<Leader>lci', '<cmd>lua require("telescope.builtin").lsp_incoming_calls()<CR>', 'incoming calls')
      map('n', '<Leader>lco', '<cmd>lua require("telescope.builtin").lsp_outgoing_calls()<CR>', 'outgoing calls')
      -- navigation
      map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'previous LSP diagnostic')
      map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'next LSP diagnostic')
      map('n', '<Leader>lxs', '<cmd>LspStop<CR>', 'stop LSP')
      map('n', '<Leader>lxr', '<cmd>LspRestart<CR>', 'restart LSP')
      -- diagnostics (TODO: add variants for severity levels, see `:h telescope.builtins.diagnostics()`)
      map('n', '<Leader>lDl', '<cmd>lua vim.diagnostic.setloclist()<CR>', 'dump to loclist')
      map('n', '<Leader>lDq', '<cmd>lua vim.diagnostic.setqflist()<CR>', 'dump to quickfix')
      map('n', '<Leader>ldd', '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<CR>',
        'document diagnostics')
      map('n', '<Leader>lwd', '<cmd>lua require("telescope.builtin").diagnostics({})<CR>', 'workspace diagnostics')
    end

    local default_server_configs = {
      on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        lsp_format.on_attach(client)
        setup_lsp_mappings(client, bufnr)
      end,
      capabilities = cmp_nvim_lsp.default_capabilities(),
    }

    local function configure_servers(server_config_overrides)
      for server, server_config in pairs(server_config_overrides) do
        for k, v in pairs(default_server_configs) do
          server_config[k] = v
        end
        lspconfig[server].setup(server_config)
      end
    end

    configure_servers({
      hls = {
        root_dir = function(fname)
          local patterns = {
            'hie.yaml',
            '*.cabal',
            'cabal.project',
            'package.yaml',
            'stack.yaml',
            '.git',
          }
          return lspconfig.util.root_pattern(unpack(patterns))(fname) or '.'
        end,
        settings = {},
      },
      pylsp = {
        settings = {
          pyls = {
            plugins = {
              pydocstyle = {
                enabled = false,
              },
              pycodestyle = {
                enable = true,
                ignore = { "E111", "E501", "E302", "W391" },
              }
            }
          }
        }
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importMergeBehavior = "last",
              importPrefix = "by_self",
            },
            cargo = {
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          }
        }
      },
      lua_ls = {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        }
      },
      gopls = {
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = {
              unusedparams = true,
              shadow = true,
              nilness = true,
            },
          },
        },
      },
      terraformls = {},
      rnix = {},
      clangd = {},
      texlab = {},
      html = {},
      cssls = {},
      emmet_ls = {},
    })
  end,
}
