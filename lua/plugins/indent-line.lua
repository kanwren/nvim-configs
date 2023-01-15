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

    vim.keymap.set('n', '<Leader>t<Tab>', ':IndentBlanklineToggle<CR>', { desc = 'toggle indent guides', noremap = true })
 end,
}
