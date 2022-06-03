local function load(name, results)
  local ok, x = pcall(require, name)
  results[#results + 1] = ok
  return x
end

local results = {}
local lspconfig = load('lspconfig', results)
local cmp_nvim_lsp = load('cmp_nvim_lsp', results)
local lspkind = load('lspkind', results)

for _, ok in pairs(results) do
  if not ok then
    vim.notify('LSP plugins not loaded, skipping...', vim.log.levels.WARN)
    return
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 5,
      prefix = '~',
    },
    signs = true,
    -- update_in_insert = false,
    underline = true,
  }
)

function setup_lsp_mappings(client, bufnr)
  local make_map = function(mode, k, v, desc)
    local map_opts = { noremap = true, silent = true, desc = desc }
    vim.api.nvim_buf_set_keymap(bufnr, mode, k, v, map_opts)
  end
  -- TODO: https://github.com/CosmicNvim/CosmicNvim/blob/main/lua/cosmic/lsp/mappings.lua
  -- TODO: https://github.com/crivotz/nv-ide/blob/master/lua/settings/keymap.lua
  -- actions at a cursor position
  make_map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover')
  make_map('n', '<Leader>lf', '<cmd>lua vim.diagnostic.open_float()<CR>', 'open float diagnostic')
  make_map('n', '<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', 'code action')
  make_map('v', '<Leader>la', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', 'range code action')
  make_map('n', '<Leader>ls', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'signature help')
  make_map('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename')
  -- queries on a symbol
  make_map('n', '<Leader>lgr', '<cmd>lua vim.lsp.buf.references()<CR>', 'references')
  make_map('n', '<Leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', 'goto definition')
  make_map('n', '<Leader>lgD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'goto declaration')
  make_map('n', '<Leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'goto type definition')
  make_map('n', '<Leader>lgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', 'goto implementation')
  make_map('n', '<Leader>ltgr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'list references')
  make_map('n', '<Leader>ltgd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', 'list definitions')
  make_map('n', '<Leader>ltgt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', 'list type definitions')
  make_map('n', '<Leader>ltgi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', 'list implementations')
  -- document
  make_map('n', '<Leader>lds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', 'query document symbols')
  make_map('n', '<Leader>ltds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', 'query document symbols')
  if client.resolved_capabilities.document_formatting then
    make_map('n', '<Leader>ldf', '<cmd>lua vim.lsp.buf.formatting_sync()<CR>', 'format buffer')
  end
  if client.resolved_capabilities.document_range_formatting then
    make_map('v', '<Leader>ldf', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', 'format range')
  end
  -- workspace
  make_map('n', '<Leader>lws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', 'query workspace symbols')
  make_map('n', '<Leader>ltws', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>', 'query workspace symbols')
  make_map('n', '<Leader>lwfl', '<cmd>lua print(vim.lsp.buf.list_workspace_folders())<CR>', 'list workspace folders')
  make_map('n', '<Leader>lwfa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'add workspace folder')
  make_map('n', '<Leader>lwfr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', 'remove workspace folder')
  -- call hierarchy
  make_map('n', '<Leader>lci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', 'incoming calls')
  make_map('n', '<Leader>lco', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', 'outgoing calls')
  -- convert diagnostics
  make_map('n', '<Leader>lql', '<cmd>lua vim.diagnostic.setloclist()<CR>', 'set loclist')
  make_map('n', '<Leader>lqq', '<cmd>lua vim.diagnostic.setqflist()<CR>', 'set quickfix')
  -- navigation
  make_map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', 'previous LSP diagnostic')
  make_map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', 'next LSP diagnostic')
  make_map('n', '<Leader>lls', '<cmd>LspStop<CR>', 'stop LSP')
  make_map('n', '<Leader>llr', '<cmd>LspRestart<CR>', 'restart LSP')
  -- TODO: check correctness
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- lsp_status.on_attach(client, bufnr)
  setup_lsp_mappings(client, bufnr)
end

lspconfig.hls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function(fname)
    return lspconfig.util.root_pattern('hie.yaml', '*.cabal', 'cabal.project', 'package.yaml', 'stack.yaml', '.git')(fname) or '.'
  end,
  settings = {},
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
})

lspconfig.rnix.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

