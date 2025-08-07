local colorizer_filetypes = {
  'css',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'html',
  'vim',
  'lua',
}

return {
  -- nicer vim.ui.input (e.g. renaming) and vim.ui.select (e.g. code actions)
  {
    'stevearc/dressing.nvim',
    opts = {
      select = {
        enabled = false, -- use telescope-ui-select instead
      },
    },
  },

  -- sets vim.ui.select to telescope
  'nvim-telescope/telescope-ui-select.nvim',

  -- LSP status indicator
  {
    'j-hui/fidget.nvim',
    tag = 'v1.2.0',
    config = true,
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local ibl = require('ibl')
      ibl.setup({
        enabled = true,
        scope = {
          enabled = true,
        },
        indent = {
          char = '│',
        },
      })

      vim.keymap.set('n', '<Leader>t<Tab>', '<cmd>IBLToggle<CR>', {
        noremap = true,
        desc = 'Toggle indent guides',
      })
    end,
  },

  -- show hex codes as colors: #b4befe, #94e2d5
  {
    'norcalli/nvim-colorizer.lua',
    ft = colorizer_filetypes,
    config = function()
      require('colorizer').setup(colorizer_filetypes)
    end,
  },
}
