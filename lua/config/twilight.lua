local twilight = require('twilight')

twilight.setup {}

vim.keymap.set('n', '<Leader>td', '<cmd>Twilight<CR>', {
  desc = 'toggle dim',
  noremap = true,
})
