setlocal makeprg=pdflatex\ -quiet\ -aux-directory=%:h\ -output-directory\ %:h\ %

setlocal expandtab
setlocal textwidth=80
setlocal breakindent
" Automatically wrap at textwidth
setlocal formatoptions+=t

" View PDF
nnoremap <buffer> <C-p> :! zathura %<.pdf &<CR><CR>

function! s:ElongateSurrounding(start, end, surrounds) abort
    let left = a:surrounds[0]
    let right = a:surrounds[1]
    execute a:start . ',' . a:end . 's/\ze\(\\right\)\@<!' . right . '/\\right/ge'
    execute a:start . ',' . a:end . 's/\ze\(\\left\)\@<!' . left . '/\\left/ge'
endfunction

command! -range -nargs=1 Elongate call <SID>ElongateSurrounding(<line1>, <line2>, <f-args>)

