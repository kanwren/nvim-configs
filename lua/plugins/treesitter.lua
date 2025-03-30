return {
  {
    'nvim-treesitter/nvim-treesitter',
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
    end,
  },

  'JoosepAlviste/nvim-ts-context-commentstring',
}
