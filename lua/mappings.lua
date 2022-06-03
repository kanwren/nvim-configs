-- Note: leader mappings fall into the following groups:
-- * <Leader>o - option changes; indentation, etc.
-- * <Leader>u - enabling/disabling UI settings
-- * <Leader>g - git
-- * <Leader>f - finding with telescope
-- * <Leader>l - LSP
-- with the following special top-level mappings for common operations:
-- * <Leader>r - register-to-register copy
-- * <Leader><Tab> - retab and remove trailing whitespace

local keymap = vim.keymap

-- Utility commands {{{
  -- Make unlisted scratch buffer
  vim.cmd([[command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile]])
-- }}}

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

  keymap.set('n', '<Leader>w', '<cmd>w<CR>', { desc = 'write buffer', noremap = true })
-- }}}

-- Editing {{{
  -- Split current line by provided regex (\zs or \ze to preserve separators)
  keymap.set('n', 'gs', ':s//\\r/g<Left><Left><Left><Left><Left>', { desc = 'regex split line', noremap = true })

  -- Start a visual substitute
  keymap.set('x', 'gs', ':s/\\%V', { desc = 'visual substitute', noremap = true })

  -- Delete trailing whitespace and retab
  function clean_whitespace()
    local wv = vim.fn.winsaveview()
    vim.cmd([[
      keeppatterns %s/\s\+\ze\r\=$//e
      nohlsearch
      retab
    ]])
    vim.fn.winrestview(wv)
  end
  keymap.set('n', '<Leader><Tab>', '<cmd>call v:lua.clean_whitespace()<CR>', { desc = 'clean whitespace', noremap = true, silent = true })
-- }}}

-- Registers {{{
  -- Copy contents of register to another (provides ' as an alias for ")
  function reg_move()
    local r1 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    local r2 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    vim.api.nvim_command('let @' .. r2 .. '=@' .. r1)
    vim.notify('Copied @' .. r1 .. ' to @' .. r2, vim.log.levels.INFO)
  end
  keymap.set('n', '<Leader>r', '<cmd>call v:lua.reg_move()<CR>', { desc = 'register copy', noremap = true, silent = true })
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

-- Quick settings changes {{{
  -- Change indent level on the fly
  function change_indent()
      local indent_level = tonumber(vim.fn.input('ts=sts=sw='))
      if indent_level then
        vim.bo.tabstop = indent_level
        vim.bo.softtabstop = indent_level
        vim.bo.shiftwidth = indent_level
      else
        return
      end
      vim.api.nvim_command('redraw')
      print('ts=' .. vim.bo.tabstop .. ', sts=' .. vim.bo.softtabstop .. ', sw='  .. vim.bo.shiftwidth .. ', et='  .. (vim.bo.expandtab and 1 or 0))
  end
  keymap.set('n', '<Leader>oi', '<cmd>call v:lua.change_indent()<CR>', { desc = 'set indentation', noremap = true })
-- }}}

-- UI toggles {{{
  keymap.set('n', '<Leader>uw', '<cmd>setlocal wrap!<CR>', { desc = 'toggle line wrapping', noremap = true })
  keymap.set('n', '<Leader>unn', '<cmd>setlocal number!<CR>', { desc = 'toggle line numbers', noremap = true })
  keymap.set('n', '<Leader>unr', '<cmd>setlocal relativenumber!<CR>', { desc = 'toggle relative line numbers', noremap = true })
  keymap.set('n', '<Leader>usl', "':setlocal laststatus=' . (&laststatus == 0 ? '2' : '0') . '<CR>'", { desc = 'toggle statusline', noremap = true, expr = true })
  keymap.set('n', '<Leader>usc', "':setlocal signcolumn=' . (&signcolumn == 'no' ? 'yes' : 'no') . '<CR>'", { desc = 'toggle sign column', noremap = true, expr = true })
  keymap.set('n', '<Leader>ufc', "':setlocal foldcolumn=' . (&foldcolumn == 0 ? 1 : 0) . '<CR>'", { desc = 'toggle fold column', noremap = true, expr = true })
  keymap.set('n', '<Leader>ul', '<cmd>setlocal list!<CR>', { desc = 'toggle listchars', noremap = true })
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
