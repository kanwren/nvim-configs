return {
  'mg979/vim-visual-multi',
  config = function() 
    vim.g.VM_leader = '\\'

    vim.keymap.set('n', '<C-j>', '<Plug>(VM-Add-Cursor-Down)', { desc = 'add vm cursor down', })
    vim.keymap.set('n', '<C-k>', '<Plug>(VM-Add-Cursor-Up)', { desc = 'add vm cursor up' })
 end,
}
