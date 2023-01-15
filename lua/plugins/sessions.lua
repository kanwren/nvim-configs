return {
  'Shatur/neovim-session-manager',

  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    local session_manager = require('session_manager')

    session_manager.setup {
      autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
      autosave_last_session = true,
      autosave_only_in_session = true,
    }

    vim.keymap.set('n', '<Leader>ss', '<cmd>SessionManager save_current_session<CR>', {
      desc = 'save current session',
      noremap = true,
    })
    vim.keymap.set('n', '<Leader>sd', '<cmd>SessionManager delete_session<CR>', {
      desc = 'delete session',
      noremap = true,
    })
    vim.keymap.set('n', '<Leader>sl', '<cmd>SessionManager load_session<CR>', {
      desc = 'load session',
      noremap = true,
    })
    vim.keymap.set('n', '<Leader>s.', '<cmd>SessionManager load_current_dir_session<CR>', {
      desc = 'load current dir session',
      noremap = true,
    })
    vim.keymap.set('n', '<Leader>sp', '<cmd>SessionManager load_last_session<CR>', {
      desc = 'load previous session',
      noremap = true,
    })
  end
}
