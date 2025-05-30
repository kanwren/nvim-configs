if vim.fn.has('nvim-0.11') == 0 then
  vim.notify('configuration requires neovim v0.11+', vim.log.levels.ERROR)
  return
end

-- bootstrap lazy.nvim
do
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazy_path) then
    vim.notify('lazy.nvim not found, installing...', vim.log.levels.WARN)
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    local success = vim.v.shell_error == 0
    if not success then
      vim.notify('lazy.nvim installation failed: ' .. output, vim.log.levels.ERROR)
      return false, nil
    else
      vim.notify('lazy.nvim installation finished', vim.log.levels.INFO)
    end
  end
  vim.opt.rtp:prepend(lazy_path)
end

require('disable')
require('settings')
require('mappings')
require('commands')
require('autocmd')
require('lazy').setup('plugins', {
  install = {
    -- Don't install missing plugins on startup, since we usually want to
    -- restore instead of install
    missing = false,
  },
})
