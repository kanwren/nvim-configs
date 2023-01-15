-- show hex codes as colors

return {
  'norcalli/nvim-colorizer.lua',
  ft = { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' },
  config = function()
    require('colorizer').setup {
      'css',
      'javascript',
      'typescript',
      'html',
      'vim',
      'lua',
    }
  end,
}
