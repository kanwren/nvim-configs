require('indent_blankline').setup {
  enabled = 0,
  char = '│',
  defaultGroup = 'IndentLine',
}

vim.keymap.set('n', '<Leader>t<Tab>', ':IndentBlanklineToggle<CR>', { desc = 'toggle indent guides', noremap = true })