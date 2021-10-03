augroup general_group
  autocmd!
  " Open help window on right by default
  autocmd FileType help wincmd L
  " Return to last edit position when opening files
  autocmd BufReadPost *
              \   if line("'\"") > 1 && line("'\"") <= line("$")
              \ |     execute "normal! g`\""
              \ | endif
  " Highlight trailing whitespace (except when typing at end of line)
  autocmd BufRead     * match ExtraWhitespace /\s\+$/
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
augroup END

augroup highlight_group
  autocmd!
  " Highlight trailing whitespace
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=DarkBlue guibg=#1f75fe
  " Left column
  autocmd ColorScheme *
              \   highlight FoldColumn ctermbg=NONE guibg=NONE
              \ | highlight Folded ctermbg=NONE ctermfg=DarkCyan guibg=NONE guifg=LightBlue
              \ | highlight LineNr ctermbg=NONE ctermfg=DarkCyan guibg=NONE guifg=DarkCyan
              \ | highlight CursorLineNr ctermbg=NONE ctermfg=LightGray guibg=NONE guifg=LightGray
  " Highlight text width boundary boundary
  autocmd ColorScheme * highlight ColorColumn ctermbg=DarkGray guibg=#282c34
  " Highlight TODO and spelling mistakes in intentionally red
  autocmd ColorScheme * highlight Todo ctermbg=DarkRed ctermfg=LightGray guibg=DarkRed guifg=LightGray
  autocmd ColorScheme * highlight SpellBad cterm=underline ctermfg=Red gui=underline guifg=Red
  " Highlight listchars and non-printable characters
  autocmd ColorScheme * highlight SpecialKey ctermfg=LightBlue guifg=#1f75fe
  autocmd ColorScheme * highlight NonText ctermfg=LightBlue guifg=#1f75fe
  autocmd ColorScheme * highlight Whitespace ctermfg=LightBlue guifg=Cyan
  " Highlight completion menu
  autocmd ColorScheme * highlight Pmenu ctermbg=Black ctermfg=LightGray guibg=Black guifg=LightGray
  autocmd ColorScheme * highlight PmenuSel ctermfg=White guifg=White
  " Indent lines
  autocmd ColorScheme * highlight IndentLine guifg=#111111
augroup END
