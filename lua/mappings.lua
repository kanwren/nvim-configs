local keymap = vim.keymap

-- Leader configuration {{{
  vim.g.mapleader = ' '
  keymap.set({'n', 'v', 'o'}, '<Space>', '<nop>', {})
  keymap.set({'n', 'v', 'o'}, '<S-Space>', '<Space>', {})
-- }}}

-- Essential {{{
  -- Work by visual line without a count, but normal when used with one
  keymap.set({'n', 'v', 'o'}, 'j', "(v:count == -1 ? 'gj' : 'j')", { noremap = true, silent = true, expr = true })
  keymap.set({'n', 'v', 'o'}, 'k', "(v:count == -1 ? 'gk' : 'k')", { noremap = true, silent = true, expr = true })
  -- Makes temporary macros faster
  keymap.set('n', 'Q', '@q', { desc = 'run @q', noremap = true })
  -- Repeat macros/commands across visual selections
  keymap.set('x', 'Q', ':normal @q<CR>', { desc = 'linewise @q', noremap = true, silent = true })
  keymap.set('x', '.', ':normal .<CR>', { desc = 'linewise .', noremap = true, silent = true })
  -- Redraw page and clear highlights
  keymap.set({'n', 'v', 'o'}, '<C-l>', '<cmd>nohlsearch<CR><C-l>', { desc = 'redraw', noremap = true, silent = true })
  -- Search word underneath cursor/selection but don't jump
  keymap.set('n', '*', '<cmd>let wv=winsaveview()<CR>*<cmd>call winrestview(wv)<CR>', { desc = 'search word forwards', noremap = true, silent = true })
  keymap.set('n', '#', '<cmd>let wv=winsaveview()<CR>#<cmd>call winrestview(wv)<CR>', { desc = 'search word backwards', noremap = true, silent = true })
-- }}}

-- Buffers {{{
  keymap.set('n', '<Leader>bd', '<cmd>bd<CR>', { desc = 'delete buffer', noremap = true })
  keymap.set('n', '<Leader>bX', '<cmd>bd!<CR>', { desc = 'kill buffer', noremap = true })
  keymap.set('n', '<Leader>br', '<cmd>setlocal readonly!<CR>', { desc = 'toggle readonly', noremap = true })
  -- Make unlisted scratch buffer
  vim.cmd([[command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile]])
  keymap.set('n', '<Leader>bs', '<cmd>Scratch<CR>', { desc = 'open scratch buffer', noremap = true })
-- }}}

-- Editing {{{
  -- Split current line by provided regex (\zs or \ze to preserve separators)
  keymap.set('n', 'gs', ':s//\\r/g<Left><Left><Left><Left><Left>', { desc = 'regex split line', noremap = true })

  -- Start a visual substitute
  keymap.set('x', 'gs', ':s/\\%V', { desc = 'visual substitute', noremap = true })

  -- Delete trailing whitespace and retab
  keymap.set('n', '<Leader><Tab>', function()
    local wv = vim.fn.winsaveview()
    vim.cmd([[
      keeppatterns %s/\s\+\ze\r\=$//e
      nohlsearch
      retab
    ]])
    vim.fn.winrestview(wv)
  end, { desc = 'clean whitespace', noremap = true, silent = true })
-- }}}

-- Registers {{{
  -- Copy contents of register to another (provides ' as an alias for ")
  keymap.set('n', '<Leader>r', function()
    local r1 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    local r2 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    vim.api.nvim_command('let @' .. r2 .. '=@' .. r1)
    vim.notify('Copied @' .. r1 .. ' to @' .. r2, vim.log.levels.INFO)
  end, { desc = 'register copy', noremap = true, silent = true })
-- }}}

-- Matching navigation commands (like in unimpaired) {{{
  for lowerkey, cmd_desc in pairs({ b = { 'b', 'buffer' }, t = { 't', 'tab' }, q = { 'c', 'quickfix item' }, l = { 'l', 'loclist item' } }) do
    local upperkey = lowerkey:upper()
    local cmd = cmd_desc[1]
    local desc = cmd_desc[2]
    keymap.set('n', "]" .. lowerkey, "<cmd>" .. cmd .. "next<CR>",     { desc = 'next ' .. desc, noremap = true })
    keymap.set('n', "[" .. lowerkey, "<cmd>" .. cmd .. "previous<CR>", { desc = 'previous ' .. desc, noremap = true })
    keymap.set('n', "]" .. upperkey, "<cmd>" .. cmd .. "last<CR>",     { desc = 'last ' .. desc, noremap = true })
    keymap.set('n', "[" .. upperkey, "<cmd>" .. cmd .. "first<CR>",    { desc = 'first ' .. desc, noremap = true })
  end
-- }}}

-- UI toggles {{{
  keymap.set('n', '<Leader>tw', '<cmd>setlocal wrap!<CR>', { desc = 'toggle line wrapping', noremap = true })
  keymap.set('n', '<Leader>tna', '<cmd>setlocal number norelativenumber<CR>', { desc = 'absolute line numbers', noremap = true })
  keymap.set('n', '<Leader>tnr', '<cmd>setlocal number relativenumber<CR>', { desc = 'relative line numbers', noremap = true })
  keymap.set('n', '<Leader>tnd', '<cmd>setlocal nonumber norelativenumber<CR>', { desc = 'disable line numbers', noremap = true })
  keymap.set('n', '<Leader>tb', "':setlocal laststatus=' . (&laststatus == 0 ? '2' : '0') . '<CR>'", { desc = 'toggle statusline', noremap = true, expr = true })
  keymap.set('n', '<Leader>ts', "':setlocal signcolumn=' . (&signcolumn == 'no' ? 'yes' : 'no') . '<CR>'", { desc = 'toggle sign column', noremap = true, expr = true })
  keymap.set('n', '<Leader>tf', "':setlocal foldcolumn=' . (&foldcolumn == 0 ? 1 : 0) . '<CR>'", { desc = 'toggle fold column', noremap = true, expr = true })
  keymap.set('n', '<Leader>tl', '<cmd>setlocal list!<CR>', { desc = 'toggle listchars', noremap = true })

  -- indentation
  local function trim_str(s)
    return s:match('^%s*(.-)%s*$')
  end

  local function set_indent_to(indent_level, opts)
    local use_tabs = false
    if opts then
      use_tabs = opts.tabs or false
    end
    if use_tabs then
      vim.bo.expandtab = false
      vim.bo.tabstop = indent_level
      vim.bo.softtabstop = 0
      vim.bo.shiftwidth = indent_level
    else
      vim.bo.expandtab = true
      vim.bo.tabstop = indent_level
      vim.bo.softtabstop = indent_level
      vim.bo.shiftwidth = indent_level
    end
    vim.api.nvim_command('redraw')
    print('ts=' .. vim.bo.tabstop .. ', sts=' .. vim.bo.softtabstop .. ', sw=' .. vim.bo.shiftwidth .. ', et=' .. (vim.bo.expandtab and 1 or 0))
  end

  keymap.set('n', '<Leader>ti=', function()
    local input = trim_str(vim.fn.input('ts=sts=sw='))
    local indent_level = tonumber(input)
    if indent_level then
      set_indent_to(indent_level)
    else
      print('invalid indent: ' .. input)
    end
  end, { desc = 'set indentation', noremap = true })
  keymap.set('n', '<Leader>ti2', function() set_indent_to(2) end, { desc = 'indent 4 spaces', noremap = true })
  keymap.set('n', '<Leader>ti4', function() set_indent_to(4) end, { desc = 'indent 2 spaces', noremap = true })
  keymap.set('n', '<Leader>ti<Tab>', function() set_indent_to(4, { tabs = true }) end, { desc = 'indent with tabs', noremap = true })

  -- colorcolumn
  keymap.set('n', '<Leader>tcd', '<cmd>setlocal colorcolumn=<CR>', { desc = 'disable colorcolumn', noremap = true })
  keymap.set('n', '<Leader>tc1', '<cmd>setlocal colorcolumn=+1<CR>', { desc = 'colorcolumn at textwidth + 1', noremap = true })
  keymap.set('n', '<Leader>tc=', function()
    vim.bo.colorcolumn = trim_str(vim.fn.input('colorcolumn='))
  end, { desc = 'set colorcolumn', noremap = true })
-- }}}

-- Abbreviations {{{
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

-- vim:foldmethod=marker
