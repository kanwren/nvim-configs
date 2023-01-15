-- code minimap

return {
  'wfxr/minimap.vim',

  config = function()
    vim.keymap.set('n', '<Leader>am', '<cmd>MinimapToggle<CR>', {
      desc = 'toggle minimap',
      noremap = true,
    })
  end,
}
