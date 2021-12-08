local utils = require('utils')

local ok1, lspconfig          = pcall(require, 'lspconfig')
local ok2, completion         = pcall(require, 'completion')
local ok3, lsp_status         = pcall(require, 'lsp-status')
local ok4, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not (ok1 and ok2 and ok3 and ok4) then
    error("missing plugin dependencies, lsp configs not loaded")
    return
end

-- diagnostics {{{
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      spacing = 5,
      prefix = '~',
    }
    -- underline = true,
    -- update_in_insert = false,
    -- signs = true,
  }
)
-- }}}

-- lsp_status {{{
lsp_status.register_progress()
lsp_status.config({
  status_symbol = '',
  indicator_errors = 'e',
  indicator_warnings = 'w',
  indicator_info = 'i',
  indicator_hint = 'h',
  indicator_ok = '✔️',
  spinner_frames = { '⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷' },
})
-- }}}

-- utilities {{{

-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
function preview_location(location, context, before_context)
  -- location may be LocationLink or Location (more useful for the former)
  context = context or 10
  before_context = before_context or 5
  local uri = location.targetUri or location.uri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange or location.range
  local contents = vim.api.nvim_buf_get_lines(bufnr, range.start.line - before_context, range['end'].line + 1 + context, false)
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  return vim.lsp.util.open_floating_preview(contents, filetype)
end

function preview_location_callback(_, method, result)
  local context = 10
  if result == nil or vim.tbl_isempty(result) then
    print('No location found: ' .. method)
    return nil
  end
  if vim.tbl_islist(result) then
    floating_buf, floating_win = preview_location(result[1], context)
  else
    floating_buf, floating_win = preview_location(result, context)
  end
end

function peek_definition()
  if vim.tbl_contains(vim.api.nvim_list_wins(), floating_win) then
    vim.api.nvim_set_current_win(floating_win)
  else
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
  end
end

-- }}}

-- lsp mappings{{{
function setup_lsp_mappings(client, bufnr)
  -- Mappings.
  local opts = { noremap=true, silent=true }
  local make_map = function(k, v) vim.api.nvim_buf_set_keymap(bufnr, 'n', k, v, opts) end
  make_map('<Leader>ld', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
  make_map('gd', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  make_map('<C-]>', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  make_map('gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  make_map('1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  make_map('K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  make_map('gK', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  make_map('gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  make_map('<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>')
  make_map('<Leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  make_map('<C-w>}', '<cmd>lua peek_definition()<CR>')
  make_map('g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  make_map('gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')
  make_map('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  make_map(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  -- management
  make_map('<Leader>lx', '<cmd>LspStop<CR>')
  make_map('<Leader>lX', '<cmd>LspRestart<CR>')
end
-- }}}

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  completion.on_attach()
  lsp_status.on_attach(client, bufnr)
  setup_lsp_mappings(client, bufnr)
end

-- lsp servers {{{

lspconfig.hls.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
  root_dir = function(fname)
    return lspconfig.util.root_pattern('hie.yaml', '*.cabal', 'cabal.project', 'package.yaml', 'stack.yaml', '.git')(fname) or '.'
  end,
  settings = {},
}

lspconfig.pylsp.setup {
  on_attach = on_attach,
  capabilities = lsp_status.capabilities,
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
  on_attach=on_attach,
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

local other_servers = { 'rnix', 'tsserver', 'clangd', 'texlab' }
for _, lsp in ipairs(other_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = lsp_status.capabilities,
  }
end

-- }}}

-- treesitter {{{

treesitter_configs.setup {
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",
  -- List of parsers to ignore installing
  ignore_install = {},
  highlight = {
    -- false will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = { },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
  -- gnn for initial selection, grn/grm to expand/contract
  incremental_selection = {
    enable = true,
  },
}

-- }}}

-- completion {{{

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_enable_fuzzy_match = 1
vim.g.completion_confirm_key = ''

if utils.plugins.has('ultisnips') then
  vim.g.completion_enable_snippet = 'UltiSnips'
  vim.g.UltiSnipsExpandTrigger = '<Tab>'
  vim.g.UltiSnipsJumpForwardTrigger = '<C-l>'
  vim.g.UltiSnipsJumpBackwardTrigger = '<C-b>'
end

-- }}}

-- vim: set foldmethod=marker:
