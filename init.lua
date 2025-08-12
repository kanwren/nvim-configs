if vim.fn.has('nvim-0.11') == 0 then
  vim.notify('configuration requires neovim v0.11+', vim.log.levels.ERROR)
  return
end

-- bootstrap lazy.nvim
do
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazy_path) then
    vim.notify('lazy.nvim not found, installing...', vim.log.levels.WARN)
    local output = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
    })
    local success = vim.v.shell_error == 0
    if not success then
      vim.notify('lazy.nvim installation failed: ' .. output, vim.log.levels.ERROR)
      return false, nil
    else
      vim.notify('lazy.nvim installation finished', vim.log.levels.INFO)
    end
  end
  vim.opt.rtp:prepend(lazy_path)
end

-- Settings
do
  vim.o.ffs = 'unix'
  vim.o.fixendofline = false
  vim.o.secure = true
  vim.o.spelllang = 'en_us'
  vim.o.ttimeoutlen = 0

  local state_path = vim.fn.stdpath('state')
  vim.o.directory = state_path .. '/swap//'
  vim.o.backup = true
  vim.o.backupdir = state_path .. '/backup//'
  vim.o.undofile = true
  vim.o.undodir = state_path .. '/undo//'
  for _, path in ipairs({ vim.o.directory, vim.o.backupdir, vim.o.undodir }) do
    if not vim.fn.isdirectory(path) then
      vim.fn.mkdir(path, 'p')
    end
  end
  vim.opt.diffopt:append({ 'internal', 'algorithm:patience' })

  vim.o.mouse = 'nv'

  vim.o.lazyredraw = true
  vim.o.splitbelow = true
  vim.o.splitright = true
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.cursorline = true
  vim.o.signcolumn = 'yes'
  vim.o.foldlevelstart = 99
  vim.o.colorcolumn = '+1'
  vim.o.list = true
  vim.opt.listchars = {
    tab = '␉·',
    eol = '¬',
    extends = '>',
    precedes = '<',
    nbsp = '⎵',
  }
  vim.o.statusline = '[%n] %f%< %m%y%h%w%r  %(0x%B %b%)%=%p%%  %(%l/%L%)%( | %c%V%)%( %)'

  vim.opt.wildmode = { 'longest:list', 'full' }
  vim.opt.shortmess:append({
    I = true, -- no intro message
  })
  vim.o.pumheight = 20

  vim.o.virtualedit = 'all'
  vim.opt.whichwrap:append({
    ['<'] = true,
    ['>'] = true,
    h = true,
    l = true,
    ['['] = true,
    [']'] = true,
  })
  vim.opt.cpoptions:append({
    y = true -- repeat yank with .
  })
  vim.o.showmatch = true

  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
  vim.o.expandtab = true
  vim.opt.cinoptions:append({
    ':0', -- 'case' should be inline with 'switch'
    'L0', -- labels should be inline with block
    'g0', -- C++ scope declarations should be inline with block
    'j1', -- indent Java anonymous classes correctly
    'J1', -- indent JS object declarations correctly
    '#0', -- don't indent pragma lines
  })
  vim.o.wrap = false
  vim.o.textwidth = 80
  vim.opt.formatoptions = {
    c = true,
    r = true,
    o = true,
    q = true,
    j = true,
    l = true,
    n = true,
  }
  vim.opt.comments:remove({
    'n:>',
  })
end

-- Mappings
do
  vim.g.mapleader = ' '
  vim.keymap.set({ 'n', 'x', 'o' }, '<Space>', '<nop>', { noremap = false })
  vim.keymap.set({ 'n', 'x', 'o' }, '<S-Space>', '<Space>', { noremap = false })

  -- Move by visual line without a count
  vim.keymap.set({ 'n', 'x', 'o' }, 'j', "(v:count == 0 ? 'gj' : 'j')", {
    silent = true,
    expr = true,
    noremap = true,
  })
  vim.keymap.set({ 'n', 'x', 'o' }, 'k', "(v:count == 0 ? 'gk' : 'k')", {
    silent = true,
    expr = true,
    noremap = true,
  })

  -- Repeat commands across visual selections
  vim.keymap.set({ 'x' }, '.', ':normal .<CR>', {
    desc = 'Repeat linewise',
    silent = true,
    noremap = true,
  })

  -- Redraw page and clear highlights
  vim.keymap.set({ 'n', 'v', 'o' }, '<C-l>', '<cmd>nohlsearch<CR><C-l>', {
    desc = 'Redraw',
    silent = true,
    noremap = true,
  })

  vim.keymap.set({ 'n' }, '*', '<cmd>let wv=winsaveview()<CR>*<cmd>call winrestview(wv)<CR>', {
    desc = 'Search word forwards',
    silent = true,
    noremap = true,
  })
  vim.keymap.set({ 'n' }, '#', '<cmd>let wv=winsaveview()<CR>#<cmd>call winrestview(wv)<CR>', {
    desc = 'Search word backwards',
    silent = true,
    noremap = true,
  })

  -- extra text objects
  vim.keymap.set({ 'v' }, 'af', ':<C-u>silent! normal! gg0VG$<CR>', {
    desc = 'Around file',
    noremap = true,
  })
  vim.keymap.set({ 'o' }, 'af', ':normal Vaf<CR>', {
    desc = 'Around file',
    noremap = false,
  })
  vim.keymap.set({ 'v' }, 'il', ':<C-u>silent! normal! ^vg_<CR>', {
    desc = 'Inner line',
    noremap = true,
  })
  vim.keymap.set({ 'o' }, 'il', ':normal vil<CR>', {
    desc = 'Inner line',
    noremap = false,
  })
  vim.keymap.set({ 'v' }, 'al', ':<C-u>silent! normal! 0v$<CR>', {
    desc = 'Around line',
    noremap = true,
  })
  vim.keymap.set({ 'o' }, 'al', ':normal val<CR>', {
    desc = 'Around line',
    noremap = false,
  })

  -- saving
  vim.keymap.set({ 'n' }, '<Leader>w', '<cmd>write<CR>', {
    desc = 'Write buffer',
    noremap = true,
  })

  -- changing directories
  vim.keymap.set({ 'n' }, '<Leader>mc', '<cmd>cd %:h<CR>', {
    desc = 'cd to current buffer',
    noremap = true,
  })
  vim.keymap.set({ 'n' }, '<Leader>ml', '<cmd>lcd %:h<CR>', {
    desc = 'lcd to current buffer',
    noremap = true,
  })
  vim.keymap.set(
    { 'n' },
    '<Leader>mg',
    function()
      local result = vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' })
      if vim.api.nvim_get_vvar('shell_error') ~= 0 then
        vim.notify('failed to get git root: ' .. result, vim.log.levels.ERROR)
        return
      end
      vim.cmd('cd ' .. result:gsub('\n$', ''))
    end,
    {
      desc = 'cd to git root',
      noremap = true,
    }
  )

  -- run jq commands
  vim.keymap.set({ 'n' }, '<Leader>j', ":%!jq '' <left><left>", {
    desc = 'Run a jq command',
    noremap = true,
  })
  vim.keymap.set({ 'x' }, '<Leader>j', ":!jq '' <left><left>", {
    desc = 'Run a jq command',
    noremap = true,
  })

  vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y', { desc = 'Yank to clipboard', noremap = true, })
  vim.keymap.set({ 'n', 'v' }, '<Leader>Y', '"+Y', { desc = 'Yank line to clipboard', noremap = true, })
  vim.keymap.set({ 'n', 'v' }, '<Leader>d', '"+d', { desc = 'Delete to clipboard', noremap = true, })
  vim.keymap.set({ 'n', 'v' }, '<Leader>D', '"+D', { desc = 'Delete to eol to clipboard', noremap = true, })
  vim.keymap.set({ 'n', 'v' }, '<Leader>p', '"+p', { desc = 'Paste after from clipboard', noremap = true, })
  vim.keymap.set({ 'n', 'v' }, '<Leader>P', '"+P', { desc = 'Paste before from clipboard', noremap = true, })

  vim.keymap.set({ 'n' }, '<Leader>bd', '<cmd>bdelete<CR>', {
    desc = 'Delete buffer',
    noremap = true,
  })

  -- Make unlisted scratch buffer
  vim.cmd([[command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile]])
  vim.keymap.set({ 'n' }, '<Leader>bs', '<cmd>Scratch<CR>', {
    desc = 'Open scratch buffer',
    noremap = true,
  })

  -- Split current line by provided regex (\zs or \ze to preserve separatorss)
  vim.keymap.set({ 'n' }, 'gs', ':s//\\r/g<Left><Left><Left><Left><Left>', {
    desc = 'Regex split line',
    noremap = true,
  })

  -- Start a visual substitute
  vim.keymap.set({ 'x' }, 'gs', ':s/\\%V', {
    desc = 'Visual substitute',
    noremap = true,
  })

  -- Delete trailing whitespace and retab
  vim.keymap.set(
    { 'n' },
    '<Leader><Tab>',
    function()
      local wv = vim.fn.winsaveview()
      vim.cmd([[
      keeppatterns %s/\s\+\ze\r\=$//e
      nohlsearch
      retab
    ]])
      vim.fn.winrestview(wv)
    end,
    {
      desc = 'Clean whitespace',
      silent = true,
      noremap = true,
    }
  )
end

vim.api.nvim_create_user_command(
  'JjDiff',
  function(opts)
    local revset = opts.fargs[1]
    local current_file = vim.fn.expand('%')

    vim.system(
      { 'jj', 'file', 'show', '--revision', revset, current_file },
      { text = true },
      vim.schedule_wrap(function(res)
        if res.code ~= 0 then
          vim.notify('failed to get file at revision: ' .. res.stderr, vim.log.levels.ERROR)
          return
        end

        local origwin = vim.api.nvim_get_current_win()

        -- open new empty scratch buffer
        vim.api.nvim_command('vert aboveleft new')
        local diffbuf = vim.api.nvim_get_current_buf()
        local diffwin = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value('buflisted', false, { buf = diffbuf })
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = diffbuf })
        vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = diffbuf })
        vim.api.nvim_set_option_value('swapfile', false, { buf = diffbuf })

        -- populate the scratch buffer with file contents at revision
        local lines = vim.split(res.stdout, '\n')
        if lines[#lines] == '' then
          table.remove(lines, #lines)
        end
        vim.api.nvim_buf_set_text(diffbuf, 0, 0, -1, -1, lines)

        -- start diff
        vim.api.nvim_set_current_win(diffwin)
        vim.api.nvim_command('diffthis')
        vim.api.nvim_set_current_win(origwin)
        vim.api.nvim_command('diffthis')
      end)
    )
  end,
  { nargs = 1 }
)

-- Autocommands
do
  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    group = vim.api.nvim_create_augroup('restore_position', { clear = true }),
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local line_count = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= line_count then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
        vim.api.nvim_feedkeys('zvzz', 'n', true)
      end
    end,
    desc = 'Return to last edit position when opening files',
  })

  local highlight_group = vim.api.nvim_create_augroup('highlight_group', { clear = true })

  local trailspace_group_name = 'ExtraWhitespace'
  local function trailspace_unhighlight()
    for _, match in ipairs(vim.fn.getmatches()) do
      if match.group == trailspace_group_name then
        pcall(vim.fn.matchdelete, match.id)
        return
      end
    end
  end

  vim.api.nvim_create_autocmd({ 'BufRead', 'BufWinEnter', 'InsertLeave' }, {
    group = highlight_group,
    callback = function()
      trailspace_unhighlight()
      if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == '' then
        vim.fn.matchadd(trailspace_group_name, [[\s\+$]])
      end
    end,
    desc = 'Highlight trailing whitespace',
  })
  vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
    group = highlight_group,
    callback = function()
      trailspace_unhighlight()
      if vim.api.nvim_get_option_value('buftype', { buf = 0 }) == '' then
        vim.fn.matchadd(trailspace_group_name, [[\s\+\%#\@<!$]])
      end
    end,
    desc = 'Highlight trailing whitespace in insert mode, except at end of line',
  })
  vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
    command = 'highlight ' .. trailspace_group_name .. ' guibg=DarkGray',
    desc = 'Highlight trailing whitespace',
  })
end

require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  install = {
    missing = false,
  },
})
