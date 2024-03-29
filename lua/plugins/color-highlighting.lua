-- show hex codes as colors
-- #b4befe, #94e2d5

local filetypes = {
  'css',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'html',
  'vim',
  'lua',
}

return {
  'norcalli/nvim-colorizer.lua',
  ft = filetypes,
  config = function()
    require('colorizer').setup(filetypes)
  end,
}
