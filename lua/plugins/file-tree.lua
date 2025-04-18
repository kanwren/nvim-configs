-- file browser
return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    respect_buf_cwd = true,
    select_prompts = true,
    view = {
      side = 'left',
      preserve_window_proportions = false,
      number = true,
      relativenumber = true,
      signcolumn = 'yes',
    },
    actions = {
      change_dir = {
        enable = true,
        global = true,
      },
    },
  },
  keys = {
    {
      '<Leader>d',
      '<cmd>NvimTreeFindFileToggle<CR>',
      mode = 'n',
      noremap = true,
      desc = 'Toggle file tree',
    },
  },
}
