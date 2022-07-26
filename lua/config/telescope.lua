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

local function map_picker(mapping, picker, desc)
  vim.keymap.set('n', '<Leader>f' .. mapping, '<cmd>Telescope ' .. picker .. '<CR>', { desc = desc, noremap = true})
end

map_picker('f', 'find_files', 'files')
map_picker('g', 'git_files', 'git files')
map_picker('r', 'live_grep', 'live grep')
map_picker('b', 'buffers', 'buffers')
map_picker('h', 'help_tags', 'help tags')
map_picker('s', 'treesitter', 'treesitter')
map_picker('l', 'resume', 'resume last picker')
map_picker('t', 'tags', 'tags')
map_picker('m', 'marks', 'marks')
map_picker('o', 'oldfiles', 'recent files')
map_picker('c', 'commands', 'commands')
map_picker('v', 'vim_options', 'vim options')
map_picker('k', 'keymaps', 'keymaps')
map_picker('F', 'filetypes', 'filetypes')
map_picker('j', 'jumplist', 'jumplist')

