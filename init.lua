require('utils')

require('settings')

-- TODO: migrate autocmds to lua
local autocmds_path = vim.fn.stdpath('config') .. '/au.vim'
vim.api.nvim_command('source ' .. autocmds_path)

require('mappings')

local ok, _ = require('plugins')
plugins_loaded = ok
if plugins_loaded then
    require('lsp-configs')
    require('plugin-configs')
end

vim.api.nvim_command('colorscheme onedark')
