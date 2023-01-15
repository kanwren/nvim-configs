-- file browser
return {
  'nvim-tree/nvim-tree.lua',

  dependencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    local nvim_tree = require('nvim-tree')

    nvim_tree.setup {
      disable_netrw = true,
      hijack_netrw = true,
      update_cwd = true,

      view = {
        hide_root_folder = false,
        side = 'left',
        preserve_window_proportions = false,
        number = true,
        relativenumber = true,
        signcolumn = 'yes',
      },
    }
  end,

  keys = {
    {
      '<Leader>ad',
      '<cmd>NvimTreeFindFileToggle<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle file tree',
    },
  },
}
