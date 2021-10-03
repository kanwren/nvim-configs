local fn = vim.fn
local command = vim.api.nvim_command

local function exists(filename)
  local stat = vim.loop.fs_stat(filename)
  return stat and stat.type or false
end

local packer_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local function packer_exists()
  return exists(packer_path) == 'directory'
end

if not packer_exists() then
  function _G.install_packer()
    if not packer_exists() then
      local output = fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
      if vim.v.shell_error > 0 then
        error('Packer installation failed: ' .. output)
      else
        command 'packadd packer.nvim'
        print('Finished packer installation; restart vim and sync plugins')
      end
    end
  end
  command [[command! InstallPacker call v:lua.install_packer()]]
  print("Warning: packer not installed; try running :InstallPacker")
  return false, nil
end

-- Compile plugins after editing file
vim.api.nvim_exec([[
augroup compile_plugins
  autocmd! BufWritePost plugins.lua source <afile> | PackerCompile
augroup END
]], false)

vim.cmd [[packadd packer.nvim]]

local packer_compile_path = fn.stdpath('data') .. '/site/lua/packer_compiled.lua'
local packer_config = {
  -- NOTE: this has to be in &runtimepath
  compile_path = packer_compile_path
}

local function setup_plugins()
  use 'wbthomason/packer.nvim'

  -- Functionality
  use 'tpope/vim-fugitive'                -- Git integration
  use 'editorconfig/editorconfig-vim'

  -- Utility
  use 'tpope/vim-surround'                -- Mappings for inserting/changing/deleting surrounding characters/elements
  use 'mg979/vim-visual-multi'            -- Multiple cursors (I will fight about this)
  use 'airblade/vim-rooter'               -- cd to project root
  use 'tpope/vim-eunuch'                  -- File operations
  use 'tyru/caw.vim'                      -- Easy commenting
  use 'kana/vim-repeat'                   -- Repeat more things with .
  use 'kana/vim-operator-user'            -- User-defined operators (needed for caw)
  use 'tpope/vim-abolish'                 -- Smart substitution, spelling correction, etc.
  use 'tommcdo/vim-exchange'              -- Operators for exchanging text
  use {
    'jiangmiao/auto-pairs',
    ft = { 'rust', 'java', 'c', 'cpp', 'javascript', 'typescript' },
  }

  -- Fuzzy finding
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    }
  }

  -- UI
  use {                                   -- file browser
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use 'airblade/vim-gitgutter'            -- git gutter
  use 'wfxr/minimap.vim'                  -- VS Code-like minimap
  use 'Yggdroot/indentLine'               -- show indent markers
  use 'norcalli/nvim-colorizer.lua'       -- show hex codes as colors
  use 'junegunn/goyo.vim'                 -- distraction-free writing
  use 'junegunn/limelight.vim'            -- only highlight current paragraph

  -- LSP
  use 'neovim/nvim-lspconfig'             -- common LSP configurations
  use {                                   -- tree-sitter-based highlighting/indentation/etc.
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
  }
  use 'nvim-lua/lsp-status.nvim'          -- generating statusline components from LSP
  -- completion
  use {
    'nvim-lua/completion-nvim',
    -- 'nvim-treesitter/completion-treesitter',
    -- 'steelsojka/completion-buffers',
  }
  use 'SirVer/ultisnips'

  -- Language-specific plugins
  use {
    'PotatoesMaster/i3-vim-syntax',
    ft = { 'i3' },
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
  }

  -- Colorschemes
  use 'romainl/vim-dichromatic'          -- For taking screenshots that might be read by colorblind students

  -- Collection of language packs
  -- This should be loaded after language-specific plugins
  use 'sheerun/vim-polyglot'
end

local plugins = require('packer').startup({ setup_plugins, config = packer_config })

if exists(packer_compile_path) then
  require'packer_compiled'
else
  print('Warning: packer not compiled, lazy-loading not initialized')
end

return true, plugins
