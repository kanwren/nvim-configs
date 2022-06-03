local telescope = require('telescope')
local telescope_themes = require('telescope.themes')

telescope.setup {
  extensions = {
    ["ui-select"] = {
      telescope_themes.get_dropdown {},
    },
    packer = {},
  },
}

telescope.load_extension('ui-select')
telescope.load_extension('packer')

vim.keymap.set('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'files', noremap = true })
vim.keymap.set('n', '<Leader>fg', '<cmd>Telescope git_files<CR>', { desc = 'git files', noremap = true })
vim.keymap.set('n', '<Leader>fr', '<cmd>Telescope live_grep<CR>', { desc = 'live grep', noremap = true })
vim.keymap.set('n', '<Leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'buffers', noremap = true })
