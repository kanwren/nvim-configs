local ok, catppuccin = pcall(require, 'catppuccin')

if not ok then
  return
end

catppuccin.setup {
  integrations = {
    nvimtree = {
      show_root = true,
    },
    which_key = true,
  },
}

vim.g.catppuccin_flavor = 'mocha'
vim.api.nvim_command('colorscheme catppuccin')
