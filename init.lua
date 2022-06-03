-- When using Nix, the config will be in the Nix store, not in
-- stdpath('config'), so the nvim executable is wrapped to set
-- 'NEOVIM_NIX_STDPATH_x' for a given stdpath(x).
local nix_nvim_config_path = vim.env['NVIM_NIX_STDPATH_config']
local config_path
if nix_nvim_config_path then
  vim.opt_global.runtimepath:prepend(nix_nvim_config_path)
  config_path = nix_nvim_config_path
else
  config_path = vim.fn.stdpath('config')
end

if vim.fn.has('nvim-0.7') == 0 then
  vim.notify('configuration requires neovim v0.7+', vim.log.levels.ERROR)
  return
end

do
  local ok, _ = pcall(require, 'impatient')
  if not ok then
    vim.notify('impatient.nvim not installed', vim.log.levels.WARN)
  end
end

require('disable')
require('settings')
require('mappings')
require('autocmd')

do
  local ok, plugins = require('plugins')
  if not ok then
    return
  end
end

require('lsp-config')
require('colors')

