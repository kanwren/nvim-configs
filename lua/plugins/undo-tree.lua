return {
  'sanfusu/neovim-undotree',

  keys = {
    {
      '<Leader>au',
      '<cmd>UndotreeToggle<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle undo tree',
    },
  },
}
