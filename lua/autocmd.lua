local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general_group = augroup('general_group', { clear = true })

autocmd({ 'FileType' }, {
  group = general_group,
  pattern = 'help',
  command = 'wincmd L',
  desc = 'Open help window on right by default',
})

autocmd({ 'BufReadPost' }, {
  group = general_group,
  command = [[
    if line("'\"") > 1 && line("'\"") <= line("$")
      execute "normal! g`\""
    endif
  ]],
  desc = 'Return to last edit position when opening files',
})

autocmd({ 'BufRead', 'BufWinEnter', 'InsertLeave' }, {
  group = general_group,
  command = [[match ExtraWhitespace /\s\+$/]],
  desc = 'Highlight trailing whitespace',
})
autocmd({ 'InsertEnter' }, {
  group = general_group,
  command = [[match ExtraWhitespace /\s\+\%#\@<!$/]],
  desc = 'Highlight trailing whitespace in insert mode, except at end of line',
})
autocmd({ 'FileType' }, {
  group = general_group,
  pattern = 'aerial',
  command = [[highlight clear ExtraWhitespace]],
  desc = 'Remove trailing whitespace highlights for plugin filetypes',
})

local highlight_group = augroup('highlight_group', { clear = true })

autocmd({ 'ColorScheme' }, {
  command = 'highlight ExtraWhitespace guibg=DarkGray',
  desc = 'Highlight trailing whitespace',
})

autocmd({ 'ColorScheme' }, {
  group = highlight_group,
  command = 'highlight SpecialKey guifg=LightBlue',
  desc = 'Highlight non-printable characters',
})
autocmd({ 'ColorScheme' }, {
  group = highlight_group,
  command = 'highlight NonText guifg=LightBlue',
  desc = 'Highlight listchars',
})
autocmd({ 'ColorScheme' }, {
  group = highlight_group,
  command = 'highlight Whitespace guifg=LightBlue',
})
