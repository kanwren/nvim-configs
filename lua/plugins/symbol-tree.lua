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
      '[a',
      '<cmd>AerialPrev<CR>',
      mode = 'n',
      noremap = true,
      desc = 'Previous aerial symbol',
    },
    {
      ']a',
      '<cmd>AerialNext<CR>',
      mode = 'n',
      noremap = true,
      desc = 'Next aerial symbol',
    },
    {
      '<Leader>ts',
      '<cmd>AerialToggle!<CR>',
      mode = 'n',
      noremap = true,
      desc = 'Toggle symbol tree',
    },
  },
}
