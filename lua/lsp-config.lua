local function load(name, results)
  local ok, x = pcall(require, name)
  results[#results + 1] = ok
  return x
end

local results = {}
local lspconfig = load('lspconfig', results)
local cmp_nvim_lsp = load('cmp_nvim_lsp', results)
local aerial = load('aerial', results)

for _, ok in pairs(results) do
  if not ok then
    vim.notify('LSP plugins not loaded, skipping...', vim.log.levels.WARN)
    return
  end
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    spacing = 5,
    prefix = '~',
  },
  signs = true,
  -- update_in_insert = false,
  underline = true,
})

local format_group = vim.api.nvim_create_augroup("LspFormatting", {})

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
  map('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'code action')
  map('v', '<Leader>la', ':lua vim.lsp.buf.range_code_action()<CR>', 'range code action')
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
  map('n', '<Leader>lgt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', 'list type definitions')
  map('n', '<Leader>lgi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', 'list implementations')
  -- document
  map('n', '<Leader>lqds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', 'query document symbols')
  map('n', '<Leader>lds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', 'query document symbols')
  if client.resolved_capabilities.document_formatting then
    map('n', '<Leader>ldf', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', 'format buffer')

    -- toggle format on save for the current buffer
    local autocmd_id = nil
    local function toggle_format_on_save()
      if autocmd_id then
        vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
        autocmd_id = nil
      else
        autocmd_id = vim.api.nvim_create_autocmd('BufWritePre', {
          group = format_group,
          buffer = bufnr,
          callback = function() vim.lsp.buf.formatting_sync() end,
        })
      end
    end

    map('n', '<Leader>ltf', toggle_format_on_save, 'toggle format on save')
  end
  if client.resolved_capabilities.document_range_formatting then
    map('v', '<Leader>ldf', ':lua vim.lsp.buf.range_formatting()<CR>', 'format range')
  end
  -- workspace
  map('n', '<Leader>lqws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'query workspace symbols')
  map('n', '<Leader>lws', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>',
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
  map('n', '<Leader>ldd', '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<CR>', 'document diagnostics')
  map('n', '<Leader>lwd', '<cmd>lua require("telescope.builtin").diagnostics({})<CR>', 'workspace diagnostics')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local global_server_config = {
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    aerial.on_attach(client, bufnr)
    setup_lsp_mappings(client, bufnr)
  end,
  capabilities = capabilities,
}

local server_configs = {
  hls = {
    root_dir = function(fname)
      return lspconfig.util.root_pattern('hie.yaml', '*.cabal', 'cabal.project', 'package.yaml', 'stack.yaml', '.git')(fname)
          or '.'
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
  sumneko_lua = {
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
  rnix = {},
  clangd = {},
  texlab = {},
  html = {},
  cssls = {},
}

for server, server_config in pairs(server_configs) do
  for k, v in pairs(global_server_config) do
    server_config[k] = v
  end
  lspconfig[server].setup(server_config)
end
