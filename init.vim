" Settings {{{
" Basic
    set ffs=unix

" Backups
    set swapfile directory=~/.local/share/nvim/swap//
    set backup writebackup backupcopy=auto
    set backupdir=~/.local/share/nvim/backup//
    set undofile undodir=~/.local/share/nvim/undo//
    for d in [&directory, &backupdir, &undodir]
        if !isdirectory(d) | call mkdir(d, 'p') | endif
    endfor

" Colors
    if has("termguicolors")
        set termguicolors
    endif

" Diff algorithm
    set diffopt+=internal,algorithm:patience

" Buffers
    set hidden                           " allow working with buffers
    set noconfirm                        " fail, don't ask to save
    set modeline modelines=1             " use one line to tell vim how to read the buffer

" History
    set history=10000
    set undolevels=10000

" Navigation
    set mouse=nv
    set scrolloff=0

" Display
    set lazyredraw                       " don't redraw until after command/macro
    set shortmess+=I                     " disable Vim intro screen
    set shortmess+=c                     " don't give ins-completion-menu messages
    set splitbelow splitright            " sensible split defaults
    set number relativenumber            " use Vim properly
    set list listchars=tab:>-,eol:¬,extends:>,precedes:<,nbsp:+
    set nocursorline nocursorcolumn
    set statusline=[%n]\ %f%<\ %m%y%h%w%r\ \ %(0x%B\ %b%)%=%p%%\ \ %(%l/%L%)%(\ \|\ %c%V%)%(\ %)
    set showmode
    set cmdheight=1
    set showcmd
    set wildmenu
    set wildmode=longest:list,full
    set signcolumn=yes

" Editing
    if has('clipboard')
        set clipboard=unnamed
        if has('unnamedplus')
            set clipboard+=unnamedplus
        endif
    endif
    set virtualedit=all                  " allow editing past the ends of lines
    set nojoinspaces                     " never two spaces after sentence
    set whichwrap+=<,>,h,l,[,]           " direction key wrapping
    set cpoptions+=y                     " let yank be repeated with . (primarily for repeating appending)

" Indentation
    set autoindent smarttab              " enabled by default
    set tabstop=4                        " treat tabs as 4 spaces wide
    set expandtab softtabstop=4          " expand tabs to 4 spaces
    set shiftwidth=4                     " use 4 spaces when using > or <
    set noshiftround
    set cinoptions+=:0L0g0j1J1#0         " indent distance for case, jumps, scope declarations, and pragmas

" Formatting
    set nowrap
    set textwidth=80
    set colorcolumn=+1
    set formatoptions=croqjln

" Searching
    set hlsearch incsearch               " enabled by default
    set inccommand=nosplit               " (neovim) show :s effects as you type
    set magic
    set noignorecase smartcase
    set showmatch

" Folds
    set foldenable
    set foldmethod=manual
    " set foldcolumn=1
    set foldlevelstart=99

" Spelling and thesaurus
    let $LANG='en'
    set nospell spelllang=en_us
    let &thesaurus=stdpath('data') . '/thesaurus/mthesaur.txt'

" Timeouts
    " Time out on mappings after 3 seconds
    set timeout timeoutlen=3000
    " Time out immediately on key codes
    set ttimeout ttimeoutlen=0
    " Diagnostic messages
    set updatetime=300
" }}}

" Autocommands/highlighting {{{
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
    " Highlighting
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
" }}}

" Functions/commands {{{
    " Make unlisted scratch buffer
    command! Scratch new | setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    " Force sudo write trick
    command! WS :execute ':silent w !sudo tee % > /dev/null' | :edit!
    " Show calendar and date/time
    command! Cal :!clear && cal -y; date -R

    function! RandomSha() abort
        return trim(system("fold -w 256 /dev/urandom | head -n1 | sha256sum | awk '{print $1}'"))
    endfunction
" }}}

" Mappings {{{

" Leader configuration
    map <Space> <nop>
    map <S-Space> <Space>
    let mapleader=" "
    " Note: leader mappings fall into the following groups:
    " - <Leader>l - LSP
    " - <Leader>g - git (fugitive and gitgutter)
    " - <Leader>f - telescope; find files, grep, etc.
    " - <Leader>o - option changes; indentation, etc.
    " - <Leader>s - session operations
    " - <Leader>u - enabling/disabling UI settings
    " - <Leader>i - misc. common editing operations
    " - <Leader>b - operations on buffers
    " with the following special top-level mappings for common operations:
    " - <Leader>d - open file drawer
    " - <Leader>r - register-to-register copy
    " - <Leader><Tab> - retab and remove trailing whitespace

" Essential
    " Work by visual line without a count, but normal when used with one
    noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
    noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
    " Makes temporary macros faster
    nnoremap Q @q
    " Repeat macros/commands across visual selections
    xnoremap <silent> Q :normal @q<CR>
    xnoremap <silent> . :normal .<CR>
    " Redraw page and clear highlights
    noremap <silent> <C-l> :nohlsearch<CR><C-l>
    " Search word underneath cursor/selection but don't jump
    nnoremap <silent> * :let wv=winsaveview()<CR>*:call winrestview(wv)<CR>
    nnoremap <silent> # :let wv=winsaveview()<CR>#:call winrestview(wv)<CR>

" Buffers
    nnoremap <Leader>bn :bnext<CR>
    nnoremap <Leader>bp :bprevious<CR>
    nnoremap <Leader>bd :bdelete<CR>
    nnoremap <Leader>bx :bdelete!<CR>
    " Show buffers and prompt for a buffer command
    nnoremap <Leader>b<Space> :buffers<CR>:b
    " Open a temporary unlisted scratch buffer
    nnoremap <Leader>bt :Scratch<CR>

" Editing
    " Split current line by provided regex (\zs or \ze to preserve separators)
    nnoremap gs :s//\r/g<Left><Left><Left><Left><Left>
    " Start a visual substitute
    xnoremap gs :s/\%V
    " Delete trailing whitespace and retab
    nnoremap <silent> <Leader><Tab> :let wv=winsaveview()<CR>:keeppatterns %s/\s\+\ze\r\=$//e \| nohlsearch \| retab<CR>:call winrestview(wv) \| unlet wv<CR>
    " Add blank line below/above line/selection, keep cursor in same position (can take count)
    nnoremap <silent> <Leader>in :<C-u>call append(line("."), repeat([''], v:count1)) \| call append(line(".") - 1, repeat([''], v:count1))<CR>
    " Expand line by padding visual block selection with spaces
    function! s:Expand() abort
        let l = getpos("'<")
        let r = getpos("'>")
        execute 'normal gv' . (abs(r[2] + r[3] - l[2] - l[3]) + 1) . 'I '
    endfunction
    vnoremap <Leader>ie <Esc>:call <SID>Expand()<CR>

" Registers
    " Copy contents of register to another (provides ' as an alias for ")
    function! s:RegMove() abort
        let r1 = substitute(nr2char(getchar()), "'", "\"", "")
        let r2 = substitute(nr2char(getchar()), "'", "\"", "")
        execute 'let @' . r2 . '=@' . r1
        echo "Copied @" . r1 . " to @" . r2
    endfunction
    nnoremap <silent> <Leader>r :call <SID>RegMove()<CR>

" Matching navigation commands, like in unimpaired
    for [l, c] in [["b", "b"], ["t", "t"], ["q", "c"], ["l", "l"]]
        let u = toupper(l)
        execute "nnoremap ]" . l . " :" . c . "next<CR>"
        execute "nnoremap [" . l . " :" . c . "previous<CR>"
        execute "nnoremap ]" . u . " :" . c . "last<CR>"
        execute "nnoremap [" . u . " :" . c . "first<CR>"
    endfor

" Quick settings changes
    " Edit vimrc
    nnoremap <Leader>ov :e $MYVIMRC<CR>
    " Filetype ftplugin editing
    command! FTPlugin execute ':edit ' . stdpath('config') . '/ftplugin/' . &filetype . '.vim'
    nnoremap <Leader>of :FTPlugin<CR>
    " Edit snippets for filetype
    nnoremap <Leader>os :UltiSnipsEdit<CR>
    " Change indent level on the fly
    function s:ChangeIndent() abort
        let i=input('ts=sts=sw=')
        if i
            execute 'setlocal tabstop=' . i . ' softtabstop=' . i . ' shiftwidth=' . i
        endif
        redraw
        echo 'ts=' . &tabstop . ', sts=' . &softtabstop . ', sw='  . &shiftwidth . ', et='  . &expandtab
    endfunction
    nnoremap <Leader>oi :call <SID>ChangeIndent()<CR>

    function! AppendModeline()
      let l:modeline = printf(" vim: set ft=%s ts=%d sts=%d sw=%d %set :",
            \ &filetype, &tabstop, &softtabstop, &shiftwidth, &expandtab ? '' : 'no')
      let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
      call append(line("$"), l:modeline)
    endfunction
    command! Modeline :call AppendModeline()

" UI toggles
    nnoremap <Leader>uw :set wrap!<CR>
    nnoremap <Leader>unn :set number!<CR>
    nnoremap <Leader>unr :set relativenumber!<CR>
    nnoremap <expr> <Leader>usl (':set laststatus=' . (&laststatus == 0 ? '2' : '0') . '<CR>')
    nnoremap <expr> <Leader>usc (':set signcolumn=' . (&signcolumn == 'no' ? 'yes' : 'no'))
    nnoremap <Leader>ul :set list!<CR>
" }}}

" Abbreviations {{{
" Common sequences
    iabbrev xaz <C-r>='abcdefghijklmnopqrstuvwxyz'<CR>
    iabbrev xAZ <C-r>='ABCDEFGHIJKLMNOPQRSTUVWXYZ'<CR>
    iabbrev x09 <C-r>='0123456789'<CR>

" Date/time abbreviations
    if exists('*strftime')
        " 2018-09-15
        iabbrev <expr> xymd strftime("%Y-%m-%d")
        " Sat 15 Sep 2018
        iabbrev <expr> xdate strftime("%a %d %b %Y")
        " 23:31
        iabbrev <expr> xtime strftime("%H:%M")
        " 2018-09-15T23:31:54
        iabbrev <expr> xiso strftime("%Y-%m-%dT%H:%M:%S")
    endif
" }}}

lua << EOF
    require('core')
EOF

" Colors {{{
    let &t_ti.="\e[1 q"
    let &t_SI.="\e[5 q"
    let &t_EI.="\e[1 q"
    let &t_te.="\e[0 q"

    colorscheme onedark
" }}}

set secure

" vim:foldmethod=marker
