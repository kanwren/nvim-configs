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

  -- see more character metadata in the 'ga', output
  'tpope/vim-characterize',
}
