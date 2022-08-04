vim.g.vimwiki_global_ext = 0

vim.keymap.set('n', '<Leader>whc', '<Plug>Vimwiki2HTML', { desc = 'compile current page', })
vim.keymap.set('n', '<Leader>whb', '<Plug>Vimwiki2HTMLBrowse', { desc = 'compile and open current page', })
vim.keymap.set('n', '<Leader>wha', '<cmd>VimwikiAll2HTML<CR>', { desc = 'compile all wiki pages', })
