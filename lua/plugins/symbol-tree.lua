-- symbol tree

return {
  'stevearc/aerial.nvim',
  opts = {
    backends = { 'lsp', 'treesitter', 'markdown' },
    layout = {
      default_direction = 'prefer_right',
    },
  },
  keys = {
    {
      '<Leader>ts',
      '<cmd>AerialToggle!<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle symbol tree',
    },
  },
}
