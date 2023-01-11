if vim.fn.has('nvim-0.8') == 0 then
  vim.notify('configuration requires neovim v0.8+', vim.log.levels.ERROR)
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
  local ok, _ = require('plugins')
  if ok then
    require('lsp-config')
  end
end

require('colors')
