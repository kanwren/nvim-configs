local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local function path_exists(path)
  return vim.fn.empty(vim.fn.glob(path)) == 0
end

local packer_bootstrapped = false
if not path_exists(packer_path) then
  local function install_packer()
    local output = vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
    local success = vim.v.shell_error == 0
    return success, output
  end

  vim.notify('packer.nvim not found, installing...', vim.log.levels.WARN)
  local success, output = install_packer()
  if not success then
    vim.notify('packer.nvim installation failed: ' .. output, vim.log.levels.ERROR)
    return false, nil
  else
    vim.api.nvim_command('packadd packer.nvim')
    vim.notify('packer.nvim installation finished', vim.log.levels.INFO)
    packer_bootstrapped = true
  end
end

local packer_compile_path = vim.fn.stdpath('data') .. '/site/lua/packer_compiled.lua'
local packer_config = {
  -- NOTE: this has to be in &runtimepath
  compile_path = packer_compile_path
}

local function setup_plugins(use)
  -- TODO: write a modified 'use' that works with nix-pinned plugins

  use 'wbthomason/packer.nvim'   -- plugin manager
  use 'lewis6991/impatient.nvim' -- speed up loading lua modules

  -- Functionality
  use 'kana/vim-repeat'          -- repeat more things with .
  use {                          -- File operations
    'tpope/vim-eunuch',
    cmd = { 'Remove', 'Unlink', 'Delete', 'Copy', 'Duplicate', 'Move', 'Rename', 'Chmod', 'Mkdir', 'Cfind', 'Lfind', 'Clocate', 'Llocate', 'SudoEdit', 'SudoWrite', 'Wall', 'W' },
    enable = false,
  }
  use 'tpope/vim-abolish'        -- Smart substitution, spelling correction, etc.
  use 'lambdalisue/vim-protocol' -- edit remote files without netrw

  -- Settings
  use 'editorconfig/editorconfig-vim'

  -- Editing
  use 'tpope/vim-surround'        -- inserting/changing/deleting delimiters
  use {                           -- multiple cursors
    'mg979/vim-visual-multi',
    config = function() require('config.vim-visual-multi') end,
  }
  use 'tommcdo/vim-exchange'      -- exchanging two regions
  use {                           -- easy commenting
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end,
  }
  use 'AndrewRadev/splitjoin.vim' -- switch between single-line and multiline constructs
  use {                           -- :NR command for narrowing a region
    'chrisbra/NrrwRgn',
    setup = function() require('setup.NrrwRgn') end,
  }

  -- LSP
  use 'neovim/nvim-lspconfig'          -- common LSP configurations
  use {                                -- LSP status indicator
    'j-hui/fidget.nvim',
    config = function() require('fidget').setup() end,
  }
  -- highlighting
  use {
    'nvim-treesitter/nvim-treesitter', -- tree-sitter-based highlighting/indentation/etc.
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'mfussenegger/nvim-treehopper',
    },
    config = function() require('config.treesitter') end,
  }
  -- snippets
  use {
    'L3MON4D3/LuaSnip',
    requires = { 'rafamadriz/friendly-snippets' },
    config = function() require('config.snippets') end,
  }
  -- completion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      -- sources
      'hrsh7th/cmp-nvim-lsp',                                          -- from LSP
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },                    -- from buffer
      { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },              -- from luasnip for snippets
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },                   -- from cmdline
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },                      -- from path
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },                  -- from lua api
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },  -- from textDocument/documentSymbol
      { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },                      -- from math
      { 'quangnguyen30192/cmp-nvim-tags', after = 'nvim-cmp' },        -- from tags

      -- UI
      'hrsh7th/cmp-nvim-lsp-signature-help',                           -- highlight current arg in function signature
      'onsails/lspkind-nvim',                                          -- icons in completion menu
      'lukas-reineke/cmp-under-comparator',                            -- sort leading underscores to end of list
    },
    after = { 'LuaSnip', 'nvim-treesitter' },
    config = function() require('config.completion') end,
  }

  -- UI
  use {                          -- search
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      -- Extensions
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-packer.nvim',
    },
    config = function() require('config.telescope') end,
  }
  use {                          -- file browser
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('config.nvim-tree') end,
  }
  use {                          -- undo tree
    'sanfusu/neovim-undotree',
    config = function() require('config.undotree') end,
  }
  use {                          -- statusline
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('config.statusline') end,
  }
  use {                          -- keybindings popup
    'folke/which-key.nvim',
    config = function() require('config.which-key') end,
  }
  use {                          -- code minimap
    'wfxr/minimap.vim',
    config = function() require('config.minimap') end,
  }
  use {                          -- show indent levels
    'lukas-reineke/indent-blankline.nvim',
    config = function() require('config.indent-line') end,
  }
  use {                          -- add temporary highlights
    'Pocco81/HighStr.nvim',
    config = function() require('config.highstr') end,
  }
  use {                          -- show hex codes as colors
    'norcalli/nvim-colorizer.lua',
    ft = { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' },
    config = function() require('colorizer').setup { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' } end,
  }
  use 'tpope/vim-characterize'   -- see more character metadata in the 'ga' output

  -- VCS
  use 'rhysd/committia.vim'      -- better commit message editing
  -- TODO: decide if this is needed, what with gitsigns <Leader>gb
  use {                          -- see commit message of last commit under cursor (<Leader>gm)
    'rhysd/git-messenger.vim',
    config = function() require('config.git-messenger') end,
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('config.gitsigns') end,
  }

  -- Tools
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = { 'md' },
    config = function() require('config.markdown-preview') end,
  }

  -- Colors
  use { 'catppuccin/nvim', as = 'catppuccin' }

  -- Language-specific
  use {
    'PotatoesMaster/i3-vim-syntax',
    ft = { 'i3' },
  }
  -- use {
  --   'unisonweb/unison',
  --   branch = 'trunk',
  --   rtp = 'editor-support/vim',
  --   ft = { 'u' },
  -- }

  if packer_bootstrapped then
    require('packer').sync()
  end
end

local plugins = require('packer').startup({
  setup_plugins,
  config = packer_config
})

if path_exists(packer_compile_path) then
  require('packer_compiled')
else
  vim.notify('packer not compiled, lazy-loading not initialized', vim.log.levels.WARNING)
end

return true, plugins
