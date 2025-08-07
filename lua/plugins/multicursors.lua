return {
  'mg979/vim-visual-multi',
  lazy = false,
  init = function()
    vim.g.VM_leader = '\\'
    vim.keymap.set({ 'n' }, '<C-j>', '<Plug>(VM-Add-Cursor-Down)', { desc = "Add cursor down", noremap = true })
    vim.keymap.set({ 'n' }, '<C-k>', '<Plug>(VM-Add-Cursor-Up)', { desc = "Add cursor up", noremap = true })
  end,
}
