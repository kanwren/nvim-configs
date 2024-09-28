local function setup_lsp_mappings(client, bufnr)
  local lspconfig = require('lspconfig')
  local lsp_format = require('lsp-format')

  local function map(mode, k, v, desc)
    local map_opts = { noremap = true, silent = true, desc = desc, buffer = bufnr }
    vim.keymap.set(mode, k, v, map_opts)
  end

  -- TODO: https://github.com/CosmicNvim/CosmicNvim/blob/main/lua/cosmic/lsp/mappings.lua
  -- TODO: https://github.com/crivotz/nv-ide/blob/master/lua/settings/keymap.lua

  -- actions at a cursor position
  map({ 'n', 'x' }, '<Leader>la', ':lua vim.lsp.buf.code_action()<CR>', 'code action')
  map({ 'n', 'i' }, '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', 'signature help')
  map('n', '<Leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', 'rename')
  -- queries on a symbol
  map('n', 'gd', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', 'list definitions')
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', 'goto declaration')
  map('n', '<Leader>lgt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', 'list type definitions')
  map('n', '<Leader>lgr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', 'list references')
  map('n', '<Leader>lgi', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', 'list implementations')
  -- document
  map('n', '<Leader>lds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>',
    'query document symbols')
  -- formatting
  map('n', '<Leader>ldf', '<cmd>lua vim.lsp.buf.format()<CR>', 'format buffer')
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
  map('n', '<Leader>lci', '<cmd>lua require("telescope.builtin").lsp_incoming_calls()<CR>', 'incoming calls')
  map('n', '<Leader>lco', '<cmd>lua require("telescope.builtin").lsp_outgoing_calls()<CR>', 'outgoing calls')
  -- navigation
  map('n', '<Leader>lxx', '<cmd>LspStop<CR>', 'stop LSP')
  map('n', '<Leader>lxs', function()
    vim.ui.select(lspconfig.util.available_servers(), { prompt = 'LSP server' }, function(choice)
      if choice then vim.api.nvim_command('LspStart ' .. choice) end
    end)
  end, 'start LSP')
  map('n', '<Leader>lxr', '<cmd>LspRestart<CR>', 'restart LSP')
  -- diagnostics (TODO: add variants for severity levels, see `:h telescope.builtins.diagnostics()`)
  map('n', '<Leader>lDl', '<cmd>lua vim.diagnostic.setloclist()<CR>', 'dump to loclist')
  map('n', '<Leader>lDq', '<cmd>lua vim.diagnostic.setqflist()<CR>', 'dump to quickfix')
  map('n', '<Leader>ldd', '<cmd>lua require("telescope.builtin").diagnostics({ bufnr = 0 })<CR>',
    'document diagnostics')
  map('n', '<Leader>lwd', '<cmd>lua require("telescope.builtin").diagnostics({})<CR>', 'workspace diagnostics')

  map('n', '<Leader>lpd', function()
    return vim.lsp.buf_request(
      0,
      'textDocument/definition',
      vim.lsp.util.make_position_params(),
      function(_, result, meta)
        if result == nil or vim.tbl_isempty(result) then
          vim.notify('No location found', vim.log.levels.DEBUG, { title = meta.method })
          return
        end
        result = result[1] or result
        vim.lsp.util.preview_location(result, {})
      end
    )
  end, 'preview definition')
end

return {
  'neovim/nvim-lspconfig',

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'lukas-reineke/lsp-format.nvim',
    'jose-elias-alvarez/null-ls.nvim',
  },

  config = function()
    local lspconfig = require('lspconfig')
    local cmp_nvim_lsp = require('cmp_nvim_lsp')
    local lsp_format = require('lsp-format')
    local null_ls = require('null-ls')

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = { spacing = 5, prefix = '~' },
      signs = true,
      underline = true,
    })

    local server_configs = {
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
      nixd = {},
      texlab = {},
      html = {
        format_on_save = false,
      },
      cssls = {
        format_on_save = false,
      },
      emmet_ls = {
        format_on_save = false,
      },
      bashls = {},
      ts_ls = {},
      solargraph = {},
      java_language_server = {
        cmd = { 'java-language-server' },
      },
    }

    local default_capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities()
    )
    local default_on_attach_no_format = function(client, bufnr)
      vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })
      setup_lsp_mappings(client, bufnr)
    end
    local default_on_attach = function(client, bufnr)
      lsp_format.on_attach(client)
      default_on_attach_no_format(client, bufnr)
    end

    null_ls.setup({
      on_attach = default_on_attach,
      sources = {
        -- NOTE: can disable diagnostics on change with
        -- .with({ method = null_ls.methods.DIAGNOSTICS_ON_SAVE })
        null_ls.builtins.formatting.prettier.with({
          filetypes = { 'html', 'css' },
        }),
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.diagnostics.shellcheck,
      },
    })

    for server, server_config in pairs(server_configs) do
      if not server_config.on_attach then
        if server_config.format_on_save == false then
          server_config.on_attach = default_on_attach_no_format
        else
          server_config.on_attach = default_on_attach
        end
        server_config.format_on_save = nil
      end
      server_config.on_attach = server_config.on_attach or default_on_attach
      server_config.capabilities = vim.tbl_deep_extend(
        'force',
        default_capabilities,
        server_config.capabilities or {}
      )
      lspconfig[server].setup(server_config)
    end
  end,
}
