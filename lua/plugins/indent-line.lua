-- show indent levels

return {
  'lukas-reineke/indent-blankline.nvim',

  config = function()
    local indent_blankline = require('indent_blankline')

    indent_blankline.setup {
      enabled = 0,
      char = '│',
      defaultGroup = 'IndentLine',
    }
  end,

  keys = {
    {
      '<Leader>t<Tab>',
      ':IndentBlanklineToggle<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle indent guides',
    },
  },
}
