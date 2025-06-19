local function map(mode, k, v, opts)
  opts = opts or {}
  if opts.noremap == nil then
    opts.noremap = true
  end
  vim.keymap.set(mode, k, v, opts)
end

-- Leader configuration {{{
do
  vim.g.mapleader = ' '
  map({ 'n', 'x', 'o' }, '<Space>', '<nop>', { noremap = false })
  map({ 'n', 'x', 'o' }, '<S-Space>', '<Space>', { noremap = false })
end
-- }}}

-- Essential {{{
do
  -- Work by visual line without a count, but normal when used with one
  map({ 'n', 'x', 'o' }, 'j', "(v:count == 0 ? 'gj' : 'j')", {
    silent = true,
    expr = true,
  })
  map({ 'n', 'x', 'o' }, 'k', "(v:count == 0 ? 'gk' : 'k')", {
    silent = true,
    expr = true,
  })
  -- Repeat commands across visual selections
  map('x', '.', ':normal .<CR>', {
    desc = 'Repeat linewise',
    silent = true,
  })
  -- Redraw page and clear highlights
  map({ 'n', 'v', 'o' }, '<C-l>', '<cmd>nohlsearch<CR><C-l>', {
    desc = 'Redraw',
    silent = true,
  })
  -- Search word underneath cursor/selection but don't jump
  map('n', '*', '<cmd>let wv=winsaveview()<CR>*<cmd>call winrestview(wv)<CR>', {
    desc = 'Search word forwards',
    silent = true,
  })
  map('n', '#', '<cmd>let wv=winsaveview()<CR>#<cmd>call winrestview(wv)<CR>', {
    desc = 'Search word backwards',
    silent = true,
  })
  -- saving
  map('n', '<Leader>s', '<cmd>write<CR>', {
    desc = 'Save buffer',
  })
  -- changing directories
  map('n', '<Leader>mc', '<cmd>cd %:h<CR>', {
    desc = 'cd to current buffer',
  })
  map('n', '<Leader>ml', '<cmd>lcd %:h<CR>', {
    desc = 'lcd to current buffer',
  })
  map('n', '<Leader>mg', function()
    local result = vim.fn.system({ 'git', 'rev-parse', '--show-toplevel' })
    if vim.api.nvim_get_vvar('shell_error') ~= 0 then
      vim.notify('failed to get git root: ' .. result, vim.log.levels.ERROR)
      return
    end
    vim.cmd('cd ' .. result:gsub('\n$', ''))
  end, {
    desc = 'cd to git root',
  })
  -- run jq commands
  map('n', '<Leader>j', ":%!jq '' <left><left>", {
    desc = 'Run a jq command',
  })
  map('x', '<Leader>j', ":!jq '' <left><left>", {
    desc = 'Run a jq command',
  })
end
-- }}}

-- Clipboard {{{
do
  map({ 'n', 'v' }, '<Leader>y', '"+y', {
    desc = 'Yank to clipboard',
  })
  map({ 'n', 'v' }, '<Leader>Y', '"+Y', {
    desc = 'Yank line to clipboard',
  })
  map({ 'n', 'v' }, '<Leader>d', '"+d', {
    desc = 'Delete to clipboard',
  })
  map({ 'n', 'v' }, '<Leader>D', '"+D', {
    desc = 'Delete to eol to clipboard',
  })
  map({ 'n', 'v' }, '<Leader>p', '"+p', {
    desc = 'Paste after from clipboard',
  })
  map({ 'n', 'v' }, '<Leader>P', '"+P', {
    desc = 'Paste before from clipboard',
  })
end
-- }}}

-- Buffers {{{
do
  map('n', '<Leader>bd', '<cmd>bdelete<CR>', {
    desc = 'Delete buffer',
  })
  map('n', '<Leader>bX', '<cmd>bdelete!<CR>', {
    desc = 'Kill buffer',
  })
  map('n', '<Leader>br', '<cmd>setlocal readonly!<CR>', {
    desc = 'Toggle readonly',
  })
  -- Make unlisted scratch buffer
  vim.cmd([[command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile]])
  map('n', '<Leader>bs', '<cmd>Scratch<CR>', {
    desc = 'Open scratch buffer',
  })
end
-- }}}

-- Editing {{{
do
  -- Split current line by provided regex (\zs or \ze to preserve separators)
  map('n', 'gs', ':s//\\r/g<Left><Left><Left><Left><Left>', {
    desc = 'Regex split line',
  })

  -- Start a visual substitute
  map('x', 'gs', ':s/\\%V', {
    desc = 'Visual substitute',
  })

  -- Delete trailing whitespace and retab
  map('n', '<Leader><Tab>', function()
    local wv = vim.fn.winsaveview()
    vim.cmd([[
      keeppatterns %s/\s\+\ze\r\=$//e
      nohlsearch
      retab
    ]])
    vim.fn.winrestview(wv)
  end, {
    desc = 'Clean whitespace',
    silent = true,
  })

  -- Reverse a range of lines. Some ways to do this manually:
  -- - select lines, 'o' the cursor to <line2> and use <esc>mrgv:g/^/m'r<cr>
  -- - select lines, :g/^/m<c-r>=getpos("'<")[1]-1<cr><cr>
  vim.cmd([[
    command! -nargs=0 -bar -range=% Reverse <line1>,<line2>g/^/m<line1>-1 <bar> nohlsearch
  ]])
end
-- }}}

-- Registers {{{
do
  -- Copy contents of register to another (provides ' as an alias for ")
  map('n', '<Leader>r', function()
    local r1 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    local r2 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    vim.api.nvim_command('let @' .. r2 .. '=@' .. r1)
    vim.notify('Copied @' .. r1 .. ' to @' .. r2, vim.log.levels.INFO)
  end, {
    desc = 'Register copy',
    silent = true,
  })
end
-- }}}

-- Toggles {{{
do
  map('n', '<Leader>tw', '<cmd>setlocal wrap!<CR>', {
    desc = 'Toggle line wrapping',
  })
  map('n', '<Leader>tna', '<cmd>setlocal number norelativenumber<CR>', {
    desc = 'Absolute line numbers',
  })
  map('n', '<Leader>tnr', '<cmd>setlocal number relativenumber<CR>', {
    desc = 'Relative line numbers',
  })
  map('n', '<Leader>tnd', '<cmd>setlocal nonumber norelativenumber<CR>', {
    desc = 'Disable line numbers',
  })
  map('n', '<Leader>tb', function() vim.opt.laststatus = vim.opt.laststatus:get() == 0 and 2 or 0 end, {
    desc = 'Toggle statusline',
  })
  map('n', '<Leader>t!', function() vim.opt.signcolumn = vim.opt.signcolumn:get() == 'no' and 'yes' or 'no' end, {
    desc = 'Toggle sign column',
  })
  map('n', '<Leader>tz', '<cmd>setlocal spell!<CR>', {
    desc = 'Toggle spelling',
  })
  map('n', '<Leader>tf', function() vim.opt.foldcolumn = vim.opt.foldcolumn:get() == "0" and "1" or "0" end, {
    desc = 'Toggle fold column',
  })
  map('n', '<Leader>tl', '<cmd>setlocal list!<CR>', {
    desc = 'Toggle listchars',
  })

  -- indentation
  local function trim_str(s)
    return s:match('^%s*(.-)%s*$')
  end

  local function configure_indentation()
    -- Get a character from the user, either tab or space, and configure
    -- expand_tabs with that input
    vim.ui.select({ 'tabs', 'spaces' }, {
      prompt = 'Indentation style:',
    }, function(choice)
      if not choice then return end

      local expand_tabs = choice == 'spaces'

      vim.ui.input({ prompt = 'Indentation level:' }, function(input)
        local indent_level = tonumber(trim_str(input))
        if not indent_level then return end

        vim.bo.expandtab = expand_tabs
        vim.bo.tabstop = indent_level
        vim.bo.softtabstop = (vim.bo.expandtab and indent_level or 0)
        vim.bo.shiftwidth = indent_level

        vim.api.nvim_command('redraw')

        local msg = ''
        msg = msg .. 'ts=' .. vim.bo.tabstop
        msg = msg .. ', sts=' .. vim.bo.softtabstop
        msg = msg .. ', sw=' .. vim.bo.shiftwidth
        msg = msg .. ', et=' .. (vim.bo.expandtab and 1 or 0)
        print(msg)
      end)
    end)
  end

  map('n', '<Leader>ti', configure_indentation, {
    desc = 'Configure indentation',
  })

  -- colorcolumn
  map('n', '<Leader>tcd', '<cmd>setlocal colorcolumn=<CR>', {
    desc = 'Disable column',
  })
  map('n', '<Leader>tc1', '<cmd>setlocal colorcolumn=+1<CR>', {
    desc = 'Column at textwidth + 1',
  })
  map('n', '<Leader>tc=', function() vim.wo.colorcolumn = trim_str(vim.fn.input('colorcolumn=')) end, {
    desc = 'Set column',
  })
end
-- }}}

-- Abbreviations {{{
do
  local function iabbrev(k, v, opts)
    local optstr = ''
    if opts.expr then
      optstr = optstr .. '<expr> '
    end
    vim.api.nvim_command('iabbrev ' .. optstr .. k .. ' ' .. v)
  end

  -- Common sequences
  iabbrev('xaz', "<C-r>='abcdefghijklmnopqrstuvwxyz'<CR>", {})
  iabbrev('xAZ', "<C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>", {})
  iabbrev('x09', "<C-r>='0123456789'<CR>", {})
end
-- }}}

-- vim:foldmethod=marker
