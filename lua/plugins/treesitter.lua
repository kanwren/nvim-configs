return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'mfussenegger/nvim-treehopper',
    },
    build = function()
      vim.api.nvim_command('TSUninstall all | TSInstall all')
    end,
    opts = function()
      local treesitter_configs = require('nvim-treesitter.configs')

      treesitter_configs.setup {
        ensure_installed = {},
        ignore_install = {},
        modules = {},
        sync_install = false,
        auto_install = false,
        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = false,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "+",
            node_incremental = "+",
            scope_incremental = "<CR>",
            node_decremental = "-",
          },
        },
      }

      -- nvim-ts-hint-textobject
      vim.keymap.set('o', 'm', ":<C-U>lua require('tsht').nodes()<CR>", { silent = true })
      vim.keymap.set('x', 'm', ":lua require('tsht').nodes()<CR>", { noremap = true, silent = true })
    end,
  },

  'JoosepAlviste/nvim-ts-context-commentstring',
}
