-- statusline
return {
  'nvim-lualine/lualine.nvim',

  dependencies = { 'kyazdani42/nvim-web-devicons' },

  config = function()
    local lualine = require('lualine')

    lualine.setup {
      options = {
        theme = 'catppuccin',
        globalstatus = true,
      },
      extensions = {
        'nvim-tree',
      },
    }

    vim.o.winbar = '[%n] %f'
  end,
}
