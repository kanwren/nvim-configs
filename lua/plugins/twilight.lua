return {
  'folke/twilight.nvim',

  config = function()
    require('twilight').setup()
  end,

  keys = {
    {
      '<Leader>td',
      '<cmd>Twilight<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle dim',
    },
  },
}
