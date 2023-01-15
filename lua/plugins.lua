local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  local function install_lazy()
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    local success = vim.v.shell_error == 0
    return success, output
  end

  vim.notify('lazy.nvim not found, installing...', vim.log.levels.WARN)
  local success, output = install_lazy()
  if not success then
    vim.notify('lazy.nvim installation failed: ' .. output, vim.log.levels.ERROR)
    return false, nil
  else
    vim.notify('lazy.nvim installation finished', vim.log.levels.INFO)
  end
end

vim.opt.rtp:prepend(lazy_path)

local plugin_configs = {
  -- Functionality
  -- repeat more things with .
  'kana/vim-repeat',
  -- File operations
  {
    'tpope/vim-eunuch',
    cmd = {
      'Remove', 'Unlink', 'Delete', 'Copy', 'Duplicate', 'Move', 'Rename', 'Chmod', 'Mkdir', 'Cfind', 'Lfind', 'Clocate',
      'Llocate', 'SudoEdit', 'SudoWrite', 'Wall', 'W'
    },
  },
  -- Smart substitution, spelling correction, etc.
  'tpope/vim-abolish',
  -- edit remote files without netrww
  'lambdalisue/vim-protocol',
  {
    'Shatur/neovim-session-manager',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function() require('config.sessions') end
  },

  -- Settings
  'gpanders/editorconfig.nvim',

  -- Editing
  -- inserting/changing/deleting delimiters
  {
    'kylechui/nvim-surround',
    config = function() require('nvim-surround').setup() end,
  },
  -- multiple cursors
  {
    'mg979/vim-visual-multi',
    config = function() require('config.vim-visual-multi') end,
  },
  -- exchanging two regions
  'tommcdo/vim-exchange',
  -- easy commenting
  {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
  },
  -- switch between single-line and multiline constructs
  'AndrewRadev/splitjoin.vim',
  -- :NR command for narrowing a region
  {
    'chrisbra/NrrwRgn',
    init = function() require('init.NrrwRgn') end,
    config = function() require('config.NrrwRgn') end,
  },

  -- LSP
  -- common LSP configurations
  'neovim/nvim-lspconfig',
  -- LSP status indicator
  {
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end,
  },
  -- highlighting
  -- tree-sitter-based highlighting/indentation/etc.
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'mfussenegger/nvim-treehopper',
    },
    build = function() vim.api.nvim_command('TSUpdate') end,
    config = function() require('config.treesitter') end,
  },
  -- snippets
  {
    'L3MON4D3/LuaSnip',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function() require('config.snippets') end,
  },
  -- completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- sources
      'hrsh7th/cmp-nvim-lsp', -- from LSP
      'hrsh7th/cmp-buffer', -- from buffer
      'saadparwaiz1/cmp_luasnip', -- from luasnip for snippets
      'hrsh7th/cmp-cmdline', -- from cmdline
      'hrsh7th/cmp-path', -- from path
      'hrsh7th/cmp-nvim-lua', -- from lua api
      'hrsh7th/cmp-nvim-lsp-document-symbol', -- from textDocument/documentSymbol
      'hrsh7th/cmp-calc', -- from math
      'quangnguyen30192/cmp-nvim-tags', -- from tags
      -- UI
      'hrsh7th/cmp-nvim-lsp-signature-help', -- highlight current arg in function signature
      'onsails/lspkind-nvim', -- icons in completion menu
      'lukas-reineke/cmp-under-comparator', -- sort leading underscores to end of list
    },
    config = function() require('config.completion') end,
  },

  -- UI
  { -- search
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      -- Extensions
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function() require('config.telescope') end,
  },
  -- file browser
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('config.nvim-tree') end,
  },
  -- undo tree
  {
    'sanfusu/neovim-undotree',
    config = function() require('config.undotree') end,
  },
  -- symbol tree
  {
    'stevearc/aerial.nvim',
    config = function() require('config.aerial') end,
  },
  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('config.statusline') end,
  },
  -- keybindings popup
  {
    'folke/which-key.nvim',
    config = function() require('config.which-key') end,
  },
  -- code minimap
  {
    'wfxr/minimap.vim',
    config = function() require('config.minimap') end,
  },
  -- show indent levels
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function() require('config.indent-line') end,
  },
  -- add temporary highlights
  {
    'Pocco81/HighStr.nvim',
    config = function() require('config.highstr') end,
  },
  {
    'folke/twilight.nvim',
    config = function() require('config.twilight') end,
  },
  -- show hex codes as colors
  {
    'norcalli/nvim-colorizer.lua',
    ft = { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' },
    config = function() require('colorizer').setup { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' } end,
  },
  -- see more character metadata in the 'ga', output
  'tpope/vim-characterize',

  -- VCS
  -- better commit message editing
  'rhysd/committia.vim',
  -- see commit message of last commit under cursor (<Leader>gm)
  'rhysd/git-messenger.vim',
  {
    'lewis6991/gitsigns.nvim',
    config = function() require('config.gitsigns') end,
  },

  -- Tools
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && yarn install',
    ft = { 'markdown' },
    config = function() require('config.markdown-preview') end,
  },

  -- Colors
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },

  -- Language-specific
  {
    'PotatoesMaster/i3-vim-syntax',
    ft = { 'i3' },
  },
}

local plugins = require('lazy').setup(plugin_configs)

return true, plugins

-- Other plugins that look cool:
--
-- jose-elias-alvarez/null-ls.nvim
-- folke/trouble.nvim
-- rafcamlet/nvim-luapad
-- p00f/nvim-ts-rainbow
-- windwp/nvim-autopairs
-- jubnzv/virtual-types.nvim
