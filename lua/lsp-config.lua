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
  local opts = { noremap=true, silent=true }
  local make_map = function(k, v) vim.api.nvim_buf_set_keymap(bufnr, 'n', k, v, opts) end
  -- TODO: https://raygervais.dev/articles/2021/3/neovim-lsp/
  -- TODO: https://github.com/CosmicNvim/CosmicNvim/blob/main/lua/cosmic/lsp/mappings.lua
  -- TODO: https://github.com/crivotz/nv-ide/blob/master/lua/settings/keymap.lua
  make_map('<Leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>')
  make_map('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  make_map('<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
  make_map('<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  make_map('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  make_map(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  make_map('<Leader>lx', '<cmd>LspStop<CR>')
  make_map('<Leader>lX', '<cmd>LspRestart<CR>')
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

