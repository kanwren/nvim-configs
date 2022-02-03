-- When using Nix, the config will be in the Nix store, not in
-- stdpath('config'), so the nvim executable is wrapped to set
-- 'NEOVIM_NIX_STDPATH_x' for a given stdpath(x). Figuring this out is handled
-- by the 'stdpath' wrapper in lua/utils.lua, but this wouldn't be locatable
-- until &runtimepath is bootstrapped, so this check needs to be performed
-- manually at first.
local nix_nvim_config_path = vim.env['NVIM_NIX_STDPATH_config']
if nix_nvim_config_path then
  vim.opt_global.runtimepath:prepend(nix_nvim_config_path)
end

local utils = require('utils')

require('settings')

-- TODO: migrate autocmds to lua
local autocmds_path = utils.stdpath('config') .. '/au.vim'
vim.api.nvim_command('source ' .. autocmds_path)

require('mappings')

local ok, _ = require('plugins')
plugins_loaded = ok
if plugins_loaded then
  require('lsp-configs')
  require('plugin-configs')
end

-- source local init if it exists
-- (in 'data' since 'config' might contain version-controlled config)
local local_init_path = utils.stdpath('data') .. '/local_init.lua'
if utils.path_exists(local_init_path) == 'file' then
  vim.api.nvim_command('luafile ' .. local_init_path)
end
