local utils = require('utils')

local _colorscheme_cache_path = utils.stdpath('data') .. '/colorscheme_cache'

function _G._set_colorscheme(name)
  utils.write_file(_colorscheme_cache_path, name, "w")
end

vim.cmd([[
  command! -nargs=1 SetColorscheme call v:lua._set_colorscheme(<f-args>)
]])

if utils.path_exists(_colorscheme_cache_path) == 'file' then
  vim.api.nvim_command('colorscheme ' .. utils.read_file(_colorscheme_cache_path))
end
