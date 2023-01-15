-- symbol tree

return {
  'stevearc/aerial.nvim',

  config = function()
    local aerial = require('aerial')

    aerial.setup {
      backends = { 'lsp', 'treesitter', 'markdown' },
      layout = {
        default_direction = 'prefer_right',
      },
    }
  end,

  keys = {
    {
      '<Leader>as',
      '<cmd>AerialToggle!<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle symbol tree',
    },
  },
}
