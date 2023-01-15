-- file browser
return {
  'kyazdani42/nvim-tree.lua',

  dependencies = { 'kyazdani42/nvim-web-devicons' },

  config = function()
    local nvim_tree = require('nvim-tree')

    vim.keymap.set('n', '<Leader>ad', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'toggle file tree', noremap = true })

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
}
