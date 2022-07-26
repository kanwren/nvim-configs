local ok, catppuccin = pcall(require, 'catppuccin')

if not ok then
  return
end

vim.g.catppuccin_flavour = 'mocha'
catppuccin.setup {
  integrations = {
    nvimtree = {
      show_root = true,
    },
    which_key = true,
  },
}

vim.api.nvim_command('colorscheme catppuccin')
