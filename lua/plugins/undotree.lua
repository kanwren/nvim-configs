return {
  'sanfusu/neovim-undotree',
  config = function() 
    vim.keymap.set('n', '<Leader>au', '<cmd>UndotreeToggle<CR>', { desc = 'toggle undo tree', noremap = true })
 end,
}
