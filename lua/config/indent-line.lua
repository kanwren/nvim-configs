require('indent_blankline').setup {
  enabled = 0,
  char = '│',
  defaultGroup = 'IndentLine',
}

vim.keymap.set('n', '<Leader>ui', ':IndentBlanklineToggle<CR>', { noremap = true })
