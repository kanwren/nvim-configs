return {
  -- repeat more things with .
  'kana/vim-repeat',

  -- inserting/changing/deleting delimiters
  { 'kylechui/nvim-surround', config = true },

  -- exchanging two regions
  'tommcdo/vim-exchange',

  -- screen navigation
  {
    'ggandor/leap.nvim',
    config = function()
      local leap = require('leap')
      leap.opts.safe_labels = {}

      vim.keymap.set('n', 's', '<Plug>(leap)')
      vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
      vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap)')

      vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
    end
  },

  -- switch between single-line and multiline constructs
  {
    'Wansmer/treesj',
    keys = {
      { 'g<Space>', '<cmd>TSJToggle<CR>', mode = { 'n' }, noremap = true, desc = 'Toggle node split' },
    },
    opts = {
      use_default_keymaps = false,
    },
  },
}
