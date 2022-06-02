for i = 0, 9 do
  vim.keymap.set('v', '<Leader>h' .. i, ':<c-u>HSHighlight ' .. i .. '<CR>', { noremap = true, silent = true })
end
vim.keymap.set('v', '<Leader>h1', ':<c-u>HSHighlight 1<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>hr', ':<c-u>HSRmHighlight<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>hc', ':<c-u>HSRmHighlight rm_all<CR>', { noremap = true, silent = true })
