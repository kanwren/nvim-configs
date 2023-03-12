return {
  'gpanders/editorconfig.nvim',

  -- edit remote files without netrw
  'lambdalisue/vim-protocol',

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

  {
    'PotatoesMaster/i3-vim-syntax',
    ft = { 'i3' },
  },
}


-- Other plugins that look cool:
--
-- folke/trouble.nvim
-- rafcamlet/nvim-luapad
-- p00f/nvim-ts-rainbow
-- windwp/nvim-autopairs
-- jubnzv/virtual-types.nvim
-- kosayoda/nvim-lightbulb
