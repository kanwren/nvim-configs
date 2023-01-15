return {
  'folke/twilight.nvim',

  config = function()
    require('twilight').setup()

    vim.keymap.set('n', '<Leader>td', '<cmd>Twilight<CR>', {
      desc = 'toggle dim',
      noremap = true,
    })
  end,
}
