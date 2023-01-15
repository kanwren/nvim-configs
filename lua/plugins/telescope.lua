return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    -- Extensions
    'nvim-telescope/telescope-ui-select.nvim',
  },

  config = function()
    local telescope = require('telescope')
    local telescope_themes = require('telescope.themes')

    telescope.setup {
      extensions = {
        ['ui-select'] = {
          telescope_themes.get_dropdown {},
        },
        aerial = {
          show_nesting = true,
        },
      },
    }

    telescope.load_extension('ui-select')
    telescope.load_extension('aerial')

    local function map_picker(mapping, picker, desc)
      vim.keymap.set('n', '<Leader>f' .. mapping, '<cmd>Telescope ' .. picker .. '<CR>', { desc = desc, noremap = true })
    end

    map_picker('f', 'find_files', 'files')
    map_picker('g', 'git_files', 'git files')
    map_picker('r', 'live_grep', 'live grep')
    map_picker('b', 'buffers', 'buffers')
    map_picker('h', 'help_tags', 'help tags')
    map_picker('s', 'treesitter', 'treesitter symbols')
    map_picker('R', 'resume', 'resume last picker')
    map_picker('t', 'tags', 'tags')
    map_picker('m', 'marks', 'marks')
    map_picker('o', 'oldfiles', 'recent files')
    map_picker(':', 'commands', 'commands')
    map_picker('v', 'vim_options', 'vim options')
    map_picker('k', 'keymaps', 'keymaps')
    map_picker('F', 'filetypes', 'filetypes')
    map_picker('j', 'jumplist', 'jumplist')
    map_picker('q', 'quickfix', 'quickfix')
    map_picker('l', 'loclist', 'loclist')
    map_picker('z', 'current_buffer_fuzzy_find skip_empty_lines=true', 'fuzzy find in buf')
    map_picker('p', 'builtin include_extensions=true', 'pickers')
    map_picker('a', 'aerial', 'aerial symbols')
  end,
}
