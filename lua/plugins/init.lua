return {
  -- nicer ui elements
  'stevearc/dressing.nvim',

  'gpanders/editorconfig.nvim',

  -- edit remote files without netrw
  'lambdalisue/vim-protocol',

  -- repeat more things with .
  'kana/vim-repeat',

  -- file operations
  {
    'tpope/vim-eunuch',
    cmd = {
      'Remove', 'Unlink', 'Delete', 'Copy', 'Duplicate', 'Move', 'Rename', 'Chmod', 'Mkdir', 'Cfind', 'Lfind', 'Clocate',
      'Llocate', 'SudoEdit', 'SudoWrite', 'Wall', 'W'
    },
  },

  -- smart substitution, spelling correction, etc.
  'tpope/vim-abolish',

  -- see more character metadata in the 'ga', output
  'tpope/vim-characterize',

  -- inserting/changing/deleting delimiters
  { 'kylechui/nvim-surround', config = true },

  -- exchanging two regions
  'tommcdo/vim-exchange',

  -- easy commenting
  { 'numToStr/Comment.nvim', config = true },

  -- switch between single-line and multiline constructs
  'AndrewRadev/splitjoin.vim',

  {
    'PotatoesMaster/i3-vim-syntax',
    ft = { 'i3' },
  },
}


-- Other plugins that look cool:
--
-- jose-elias-alvarez/null-ls.nvim
-- folke/trouble.nvim
-- rafcamlet/nvim-luapad
-- p00f/nvim-ts-rainbow
-- windwp/nvim-autopairs
-- jubnzv/virtual-types.nvim
-- kosayoda/nvim-lightbulb
