local function hatch(key, creature, speed, description)
  return {
    '<Leader>c' .. key,
    function()
      local duck = require('duck')
      local count = vim.v.count
      if count == 0 then
        count = 1
      end
      for _ = 1, count do
        duck.hatch(creature, speed)
      end
    end,
    mode = 'n',
    noremap = true,
    desc = 'Hatch ' .. description,
  }
end

local colorizer_filetypes = {
  'css',
  'javascript',
  'javascriptreact',
  'typescript',
  'typescriptreact',
  'html',
  'vim',
  'lua',
}

return {
  -- nicer vim.ui.input (e.g. renaming) and vim.ui.select (e.g. code actions)
  {
    'stevearc/dressing.nvim',
    opts = {
      select = {
        enabled = false, -- use telescope-ui-select instead
      },
    },
  },

  -- sets vim.ui.select to telescope
  'nvim-telescope/telescope-ui-select.nvim',

  -- nicer vim.notify
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require('notify')
      vim.notify = notify
      notify.setup({
        timeout = 3000,
        stages = 'fade',
      })
    end,
  },

  -- LSP status indicator
  {
    'j-hui/fidget.nvim',
    tag = 'v1.2.0',
    config = true,
  },

  -- indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local ibl = require('ibl')
      ibl.setup({
        enabled = true,
        scope = {
          enabled = true,
        },
        indent = {
          char = '│',
        },
      })

      vim.keymap.set('n', '<Leader>t<Tab>', '<cmd>IBLToggle<CR>', {
        noremap = true,
        desc = 'Toggle indent guides',
      })
    end,
  },

  -- show hex codes as colors: #b4befe, #94e2d5
  {
    'norcalli/nvim-colorizer.lua',
    ft = colorizer_filetypes,
    config = function()
      require('colorizer').setup(colorizer_filetypes)
    end,
  },

  -- the duck
  {
    'tamton-aquib/duck.nvim',
    keys = {
      {
        '<Leader>ck',
        function()
          local duck = require('duck')
          local count = vim.v.count
          if count == 0 then
            count = 1
          end
          for _ = 1, count do
            duck.cook()
          end
        end,
        mode = 'n',
        noremap = true,
        desc = 'Remove a critter',
      },
      hatch('c', '🦀', 5, 'a crab'),
      hatch('d', '🦆', 2, 'a duck'),
      hatch('s', '🐑', 3, 'a sheep'),
      hatch('t', '🦃', 3, 'a turkey'),
      hatch('m', '🐁', 6, 'a mouse'),
      hatch('r', '🐀', 6, 'a rat'),
      hatch('h', '🦔', 2, 'a hedgehog'),
      hatch('l', '🐌', 0.1, 'a snail'),
      {
        '<Leader>cf',
        function()
          local duck = require('duck')
          local choices = {
            { '🐳', 2 },
            { '🐋', 2 },
            { '🐬', 3 },
            { '🦈', 4 },
            { '🐟', 5 },
            { '🐠', 5 },
            { '🐡', 5 },
            { '🦐', 1 },
            { '🦞', 1 },
            { '🦑', 2 },
            { '🐙', 2 },
            { '🪼', 1 },
          }
          local count = vim.v.count
          if count == 0 then
            count = 1
          end
          for _ = 1, count do
            local choice = choices[math.random(#choices)]
            duck.hatch(choice[1], choice[2])
          end
        end,
        noremap = true,
        desc = 'Hatch a sea creature',
      },
      hatch('a', 'ඞ', 4, 'an amogus'),
    },
  },
}
