-- code minimap

return {
  'wfxr/minimap.vim',

  keys = {
    {
      '<Leader>am',
      '<cmd>MinimapToggle<CR>',
      mode = 'n',
      noremap = true,
      desc = 'toggle minimap',
    }
  },
}
