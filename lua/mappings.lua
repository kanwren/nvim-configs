-- Note: leader mappings fall into the following groups:
-- * <Leader>l - LSP
-- * <Leader>g - git (fugitive and gitgutter)
-- * <Leader>f - telescope; find files, grep, etc.
-- * <Leader>o - option changes; indentation, etc.
-- * <Leader>s - session operations
-- * <Leader>u - enabling/disabling UI settings
-- * <Leader>i - misc. common editing operations
-- * <Leader>b - operations on buffers
-- with the following special top-level mappings for common operations:
-- * <Leader>d - open file drawer
-- * <Leader>r - register-to-register copy
-- * <Leader><Tab> - retab and remove trailing whitespace

local map = vim.api.nvim_set_keymap

-- Utility commands {{{
  -- Make unlisted scratch buffer
  vim.cmd([[
    command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  ]])

  -- Force sudo write trick
  vim.cmd([[
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!
  ]])
-- }}}

-- Leader configuration {{{
  map('', '<Space>', '<nop>', {})
  map('', '<S-Space>', '<Space>', {})
  vim.g.mapleader = ' '
-- }}}

-- Essential {{{
  -- Work by visual line without a count, but normal when used with one
  map('', 'j', "(v:count == 0 ? 'gj' : 'j')", { noremap = true, silent = true, expr = true })
  map('', 'k', "(v:count == 0 ? 'gk' : 'k')", { noremap = true, silent = true, expr = true })
  -- Makes temporary macros faster
  map('n', 'Q', '@q', { noremap = true })
  -- Repeat macros/commands across visual selections
  map('x', 'Q', '<cmd>normal @q<CR>', { noremap = true, silent = true })
  map('x', '.', '<cmd>normal .<CR>', { noremap = true, silent = true })
  -- Redraw page and clear highlights
  map('', '<C-l>', '<cmd>nohlsearch<CR><C-l>', { noremap = true, silent = true })
  -- Search word underneath cursor/selection but don't jump
  map('n', '*', '<cmd>let wv=winsaveview()<CR>*<cmd>call winrestview(wv)<CR>', { noremap = true, silent = true })
  map('n', '#', '<cmd>let wv=winsaveview()<CR>#<cmd>call winrestview(wv)<CR>', { noremap = true, silent = true })
-- }}}

-- Buffers {{{
  map('n', '<Leader>bn', '<cmd>bnext<CR>', { noremap = true })
  map('n', '<Leader>bp', '<cmd>bprevious<CR>', { noremap = true })
  map('n', '<Leader>bd', '<cmd>bdelete<CR>', { noremap = true })
  map('n', '<Leader>bx', '<cmd>bdelete!<CR>', { noremap = true })
  -- Show buffers and prompt for a buffer command
  map('n', '<Leader>b<Space>', '<cmd>buffers<CR><cmd>b', { noremap = true })
  -- Open a temporary unlisted scratch buffer
  map('n', '<Leader>bt', '<cmd>Scratch<CR>', { noremap = true })
-- }}}

-- Editing {{{
  -- Split current line by provided regex (\zs or \ze to preserve separators)
  map('n', 'gs', '<cmd>s//\\r/g<Left><Left><Left><Left><Left>', { noremap = true })

  -- Start a visual substitute
  map('x', 'gs', '<cmd>s/\\%V', { noremap = true })

  -- Delete trailing whitespace and retab
  function clean_whitespace()
    local wv = vim.fn.winsaveview()
    vim.cmd([[
      keeppatters %s/\\s\\+\\ze\\r\\=$//e
      nohlsearch
      retab
    ]])
    vim.fn.winrestview(wv)
  end
  map('n', '<Leader><Tab>', '<cmd>call v:lua.clean_whitespace()<CR>', { noremap = true, silent = true })

  -- Add blank line below/above line/selection, keep cursor in same position (can take count)
  map('n', '<Leader>in ', "<cmd><C-u>call append(line('.'), repeat([''], v:count1)) | call append(line('.') - 1, repeat([''], v:count1))<CR>", { noremap = true, silent = true })

  -- Expand line by padding visual block selection with spaces
  function expand_sel()
    local l = vim.fn.getpos("'<")
    local r = vim.fn.getpos("'>")
    vim.api.nvim_command('normal gv' .. (math.abs(r[2] + r[3] - l[2] - l[3]) + 1) .. 'I ')
  end
  map('v', '<Leader>ie', '<Esc><cmd>call v:lua.expand_sel()<CR>', { noremap = true })
-- }}}

-- Registers {{{
  -- Copy contents of register to another (provides ' as an alias for ")
  function reg_move()
    local r1 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    local r2 = (vim.fn.nr2char(vim.fn.getchar())):gsub("'", '"')
    vim.api.nvim_command('let @' .. r2 .. '=@' .. r1)
    print('Copied @' .. r1 .. ' to @' .. r2)
  end
  map('n', '<Leader>r', '<cmd>call v:lua.reg_move()<CR>', { noremap = true, silent = true })
-- }}}

-- Matching navigation commands (like in unimpaired) {{{
  for lowerkey, cmd in pairs({ b = 'b', t = 't', q = 'c', l = 'l' }) do
    local upperkey = lowerkey:upper()
    map('n', "]" .. lowerkey, "<cmd>" .. cmd .. "next<CR>",     { noremap = true })
    map('n', "[" .. lowerkey, "<cmd>" .. cmd .. "previous<CR>", { noremap = true })
    map('n', "]" .. upperkey, "<cmd>" .. cmd .. "last<CR>",     { noremap = true })
    map('n', "[" .. upperkey, "<cmd>" .. cmd .. "first<CR>",    { noremap = true })
  end
-- }}}

-- Quick settings changes {{{
  -- Edit vimrc
  map('n', '<Leader>ov', '<cmd>edit $MYVIMRC<CR>', { noremap = true })

  -- Filetype ftplugin editing
  vim.cmd([[
    command! FTPlugin execute ':edit ' . stdpath('config') . '/ftplugin/' . &filetype . '.vim'
  ]])
  map('n', '<Leader>of', '<cmd>FTPlugin<CR>', { noremap = true })

  -- Edit snippets for filetype
  map('n', '<Leader>os', '<cmd>UltiSnipsEdit<CR>', { noremap = true })

  -- Change indent level on the fly
  function change_indent()
      local indent_level = vim.fn.input('ts=sts=sw=') + 0
      if indent_level then
        vim.bo.tabstop = indent_level
        vim.bo.softtabstop = indent_level
        vim.bo.shiftwidth = indent_level
      end
      vim.api.nvim_command('redraw')
      print('ts=' .. vim.bo.tabstop .. ', sts=' .. vim.bo.softtabstop .. ', sw='  .. vim.bo.shiftwidth .. ', et='  .. (vim.bo.expandtab and 1 or 0))
  end
  map('n', '<Leader>oi', '<cmd>call v:lua.change_indent()<CR>', { noremap = true })

  function append_modeline()
    local modeline = string.format(
      " vim: set ft=%s ts=%d sts=%d sw=%d %s :",
      vim.bo.filetype,
      vim.bo.tabstop,
      vim.bo.softtabstop,
      vim.bo.shiftwidth,
      vim.bo.expandtab and 'et' or 'noet'
    )
    modeline = vim.bo.commentstring:format(modeline)
    vim.fn.append(vim.fn.line("$"), modeline)
  end
  vim.cmd([[
    command! Modeline :call v:lua.append_modeline()
  ]])
-- }}}

-- UI toggles {{{
  map('n', '<Leader>uw', '<cmd>setlocal wrap!<CR>', { noremap = true })
  map('n', '<Leader>unn', '<cmd>setlocal number!<CR>', { noremap = true })
  map('n', '<Leader>unr', '<cmd>setlocal relativenumber!<CR>', { noremap = true })
  map('n', '<Leader>usl', "':setlocal laststatus=' . (&laststatus == 0 ? '2' : '0') . '<CR>'", { noremap = true, expr = true })
  map('n', '<Leader>usc', "':setlocal signcolumn=' . (&signcolumn == 'no' ? 'yes' : 'no') . '<CR>'", { noremap = true, expr = true })
  map('n', '<Leader>ufc', "':setlocal foldcolumn=' . (&foldcolumn == 0 ? 1 : 0) . '<CR>'", { noremap = true, expr = true })
  map('n', '<Leader>ul', '<cmd>setlocal list!<CR>', { noremap = true })
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

-- Date/time abbreviations
  -- 2018-09-15
  iabbrev('xymd', os.date("%Y-%m-%d"), { expr = true })
  -- Sat 15 Sep 2018
  iabbrev('xdate', os.date("%a %d %b %Y"), { expr = true })
  -- 23:31
  iabbrev('xtime', os.date("%H:%M"), { expr = true })
  -- 2018-09-15T23:31:54
  iabbrev('xiso', os.date("%Y-%m-%dT%H:%M:%S"), { expr = true })
-- }}}

-- vim:foldmethod=marker
