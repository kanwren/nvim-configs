vim.diagnostic.config({
  virtual_text = { spacing = 5, prefix = '~' },
  signs = true,
  underline = true,
})

local disable_autoformatting_in = {
  'sh'
}

local group = vim.api.nvim_create_augroup('my.lsp', {})
vim.api.nvim_create_autocmd('LspAttach', {
  group = group,
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })

    vim.keymap.set(
      { 'n' },
      'gd',
      '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>',
      { desc = 'Goto definition', noremap = true, silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      { 'n' },
      'grt',
      '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>',
      { desc = 'List type definitions', noremap = true, silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      { 'n' },
      'gO',
      '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>',
      { desc = 'Document symbols', noremap = true, silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      { 'n' },
      'grci',
      '<cmd>lua require("telescope.builtin").lsp_incoming_calls()<CR>',
      { desc = 'Incoming calls', noremap = true, silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      { 'n' },
      'grco',
      '<cmd>lua require("telescope.builtin").lsp_outgoing_calls()<CR>',
      { desc = 'Outgoing calls', noremap = true, silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      { 'n' },
      '<Leader><CR>',
      '<cmd>lua vim.lsp.buf.format()<CR>',
      { desc = 'Format buffer', noremap = true, silent = true, buffer = bufnr }
    )

    -- Format on save
    if vim.b.autoformat == nil then
      -- should this buffer autoformat by default?
      local autoformat = true
      for _, ft in ipairs(disable_autoformatting_in) do
        if vim.bo.filetype == ft then
          autoformat = false
          break
        end
      end
      vim.b.autoformat = autoformat
    end
    vim.keymap.set(
      { 'n' },
      '<Leader>ta',
      function()
        vim.b.autoformat = not vim.b.autoformat
        if vim.b.autoformat then
          vim.notify('Autoformatting enabled')
        else
          vim.notify('Autoformatting disabled')
        end
      end,
      { desc = 'Toggle autoformatting', noremap = true, silent = true, buffer = bufnr }
    )
    if not client:supports_method('textDocument/willSaveWaitUntil') and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = group,
        buffer = args.buf,
        callback = function()
          if not vim.b.autoformat then return end
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = group,
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/formatting') then
      vim.api.nvim_clear_autocmds({
        group = group,
        event = 'BufWritePre',
        buffer = args.buf,
      })
    end
  end,
})

local function server_configs()
  return {
    bashls = {},
    cssls = {},
    emmet_ls = {},
    gopls = {
      settings = {
        gopls = {
          usePlaceholders = true,
          experimentalPostfixCompletions = true,
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
          },
        },
      },
    },
    html = {},
    java_language_server = {
      cmd = { 'java-language-server' },
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
    nixd = {
      settings = {
        nixd = {
          formatting = {
            command = { 'alejandra' },
          },
        },
      },
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
    solargraph = {},
    terraformls = {},
    texlab = {},
    ts_ls = {},
  }
end

local function none_ls_sources(none_ls)
  return {
    -- Diagnostics
    none_ls.builtins.diagnostics.fish,
    -- none_ls.builtins.diagnostics.staticcheck,
    none_ls.builtins.diagnostics.statix,

    -- Formatting
    none_ls.builtins.formatting.fish_indent,
    none_ls.builtins.formatting.goimports,
    none_ls.builtins.formatting.just,
    none_ls.builtins.formatting.shellharden,

    -- LSP actions
    none_ls.builtins.code_actions.gomodifytags,
    none_ls.builtins.code_actions.impl,
  }
end

return {
  'neovim/nvim-lspconfig',

  dependencies = {
    'nvimtools/none-ls.nvim',
  },

  config = function()
    local lspconfig = require('lspconfig')
    local none_ls = require('null-ls')

    local default_capabilities = vim.lsp.protocol.make_client_capabilities()

    local configs = server_configs()
    for server, server_config in pairs(configs) do
      server_config.capabilities = vim.tbl_deep_extend(
        'force',
        default_capabilities,
        server_config.capabilities or {}
      )
      lspconfig[server].setup(server_config)
    end

    none_ls.setup({ sources = none_ls_sources(none_ls) })
  end,
}
