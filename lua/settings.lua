-- Basic {{{
  vim.o.ffs = 'unix'
  vim.o.secure = true
-- }}}

-- Backups {{{
  local data_path = vim.fn.stdpath('data')
  vim.o.swapfile = true
  vim.o.directory = data_path .. '/swap//'
  vim.o.backup = true
  vim.o.writebackup = true
  vim.o.backupcopy = 'auto'
  vim.o.backupdir = data_path .. '/backup//'
  vim.o.undofile = true
  vim.o.undodir = data_path .. '/undo//'
  for _, path in ipairs({ vim.o.directory, vim.o.backupdir, vim.o.undodir }) do
    if vim.fn.isdirectory(path) then
      vim.fn.mkdir(path, 'p')
    end
  end
-- }}}

-- Colors {{{
  if vim.fn.has('termguicolors') then
    vim.o.termguicolors = true
  end
-- }}}

-- Diff algorithm {{{
  vim.opt.diffopt:append({ 'internal', 'algorithm:patience' })
-- }}}

-- Buffers {{{
  vim.o.hidden = true                  -- allow working with buffers
  vim.o.confirm = false                -- fail, don't ask to save
  vim.o.modeline = true
  vim.o.modelines = 1                  -- use one line to tell vim how to read the buffer
-- }}}

-- History {{{
  vim.o.history = 10000
  vim.o.undolevels = 10000
-- }}}

-- Navigation {{{
  vim.o.mouse = 'nv'
  vim.o.scrolloff = 0
-- }}}

-- Display {{{
  vim.o.lazyredraw = true              -- don't redraw until after command/macro
  vim.o.shortmess = vim.o.shortmess .. table.concat({
    'I', -- disable Vim intro screen
    'c', -- don't give ins-completion-menu messages
  })

  -- sensible split defaults
  vim.o.splitbelow = true
  vim.o.splitright = true

  -- line numbers
  vim.o.number = true
  vim.o.relativenumber = true

  vim.o.list = true
  vim.opt.listchars = {
    tab = '>-',
    eol = '¬',
    extends = '>',
    precedes = '<',
    nbsp = '+',
  }

  vim.o.statusline = '[%n] %f%< %m%y%h%w%r  %(0x%B %b%)%=%p%%  %(%l/%L%)%( | %c%V%)%( %)'
  vim.o.showmode = true
  vim.o.cmdheight = 1
  vim.o.showcmd = true

  vim.o.wildmenu = true
  vim.opt.wildmode = { 'longest:list', 'full' }

  vim.o.signcolumn = 'yes'
-- }}}

-- Editing {{{
  if vim.fn.has('clipboard') then
    vim.opt.clipboard = { 'unnamed' }
    if vim.fn.has('unnamedplus') then
      vim.opt.clipboard:append({ 'unnamedplus' })
    end
  end
  vim.o.virtualedit = 'all'            -- allow editing past the ends of lines
  vim.o.joinspaces = false             -- never two spaces after sentence
  vim.opt.whichwrap:append({           -- direction key wrapping
    ['<'] = true,
    ['>'] = true,
    h = true,
    l = true,
    ['['] = true,
    [']'] = true,
  })
  vim.opt.cpoptions:append({
    y = true -- let yank be repeated with . (primarily for repeating appending)
  })
-- }}}

-- Indentation {{{
  vim.o.autoindent = true
  vim.o.smarttab = true
  vim.o.tabstop = 4                  -- treat tabs as 4 spaces wide
  vim.o.expandtab = true
  vim.o.softtabstop = 4              -- expand tabs to 4 spaces
  vim.o.shiftwidth = 4               -- use 4 spaces when using > or <
  vim.o.shiftround = false
  vim.o.cinoptions = vim.o.cinoptions .. table.concat({
    ':0', -- 'case' should be inline with 'switch'
    'L0', -- labels should be inline with block
    'g0', -- C++ scope declarations should be inline with block
    'j1', -- indent Java anonymous classes correctly
    'J1', -- indent JS object declarations correctly
    '#0', -- don't indent pragma lines
  })
-- }}}

-- Formatting {{{
  vim.o.wrap = false
  vim.o.textwidth = 80
  vim.o.colorcolumn = '+1'
  vim.o.formatoptions = 'croqjln'
  vim.opt.comments:remove('n:>')     -- don't treat '>' as a default comment leader
-- }}}

-- Searching {{{
  vim.o.hlsearch = true
  vim.o.incsearch = true
  vim.o.inccommand = 'nosplit'       -- (neovim) show :s effects as you type
  vim.o.magic = true
  vim.o.ignorecase = false
  vim.o.smartcase = true
  vim.o.showmatch = true
-- }}}

-- Folds {{{
  vim.o.foldenable = true
  vim.o.foldmethod = 'manual'
  -- vim.o.foldcolumn = 1
  vim.o.foldlevelstart = 99
-- }}}

-- Spelling and thesaurus {{{
  vim.env.LANG = 'en'
  vim.o.spell = false
  vim.o.spelllang = 'en_us'
  -- Fetch from http://www.gutenberg.org/files/3202/files/mthesaur.txt
  vim.o.thesaurus = vim.fn.stdpath('data') .. '/thesaurus/mthesaur.txt'
-- }}}

-- Timeouts {{{
  -- Time out on mappings after 3 seconds
  vim.o.timeout = true
  vim.o.timeoutlen = 3000
  -- Time out immediately on key codes
  vim.o.ttimeout = true
  vim.o.ttimeoutlen = 0
  -- Diagnostic messages
  vim.o.updatetime = 300
-- }}}

-- vim:foldmethod=marker
