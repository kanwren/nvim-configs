-- statusline

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    local lualine = require('lualine')

    lualine.setup {
      options = {
        theme = 'catppuccin',
      },
      extensions = {
        'nvim-tree',
      },
    }

    -- TODO: global statusline
  end,
}
