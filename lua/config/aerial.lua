local aerial = require('aerial')

aerial.setup {
  backends = { 'lsp', 'treesitter', 'markdown' },
  default_direction = 'prefer_right',
}

vim.keymap.set('n', '<Leader>as', '<cmd>AerialToggle!<CR>', {
  desc = 'toggle symbol tree',
  noremap = true,
})
