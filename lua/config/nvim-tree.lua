vim.keymap.set('n', '<Leader>d', '<cmd>NvimTreeToggle<CR>', { noremap = true })

require('nvim-tree').setup {
  disable_netrw = true,
  hijack_netrw = true,
  -- update_cwd = true, -- TODO: decide if I like this or not
  -- respect_buf_cwd = false,

  view = {
    adaptive_size = false,
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    preserve_window_proportions = false,
    number = true,
    relativenumber = true,
    signcolumn = 'yes',
  },
}
