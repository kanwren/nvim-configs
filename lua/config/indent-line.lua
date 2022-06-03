require('indent_blankline').setup {
  enabled = 0,
  char = '│',
  defaultGroup = 'IndentLine',
}

vim.keymap.set('n', '<Leader>ui', ':IndentBlanklineToggle<CR>', { desc = 'toggle indent guides', noremap = true })
