for i = 0, 9 do
  vim.keymap.set('v', '<Leader>h' .. i, ':<c-u>HSHighlight ' .. i .. '<CR>', { desc = 'highlight ' .. i, noremap = true, silent = true })
end
vim.keymap.set({ 'n', 'v' }, '<Leader>hr', ':<c-u>HSRmHighlight<CR>', { desc = 'remove highlight', noremap = true, silent = true })
vim.keymap.set('n', '<Leader>hc', ':<c-u>HSRmHighlight rm_all<CR>', { desc = 'clear all highlights', noremap = true, silent = true })
