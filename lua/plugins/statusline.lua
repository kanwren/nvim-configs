-- statusline
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'catppuccin',
      globalstatus = true,
    },
    extensions = {
      'nvim-tree',
    },
    sections = {
      lualine_a = {
        'mode',
      },
      lualine_b = {
        'branch',
        'diff',
        'diagnostics',
      },
      lualine_c = {
        { 'filename', path = 1 }
      },
      lualine_x = {
        'encoding',
        'fileformat',
        'filetype',
      },
      lualine_y = {
        'progress',
      },
      lualine_z = {
        'location',
      },
    },
    winbar = { lualine_c = { 'filename' } },
    inactive_winbar = { lualine_c = { 'filename' } },
  },
}
