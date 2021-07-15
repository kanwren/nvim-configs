setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Pre-fill NPG information from surrounding block
" Assumes fields are ordered as owner, repo, rev, sha256
nnoremap <buffer> <Leader>NP vaB%<Esc>:let @h=@/<CR>/owner<CR>f""jyi"j0f""kyi":NPG <C-r>j <C-r>k

function! ConvertHash(hash, to, ...) abort
    let hash = a:hash
    " If hash doesn't start with format specifier
    if a:hash !~ ':'
        " Prepend format specifier, defaulting to sha256
        if a:0 < 1
            let hash = 'sha256:' . hash
        else
            let hash = a:1 . ':' . hash
        endif
    endif
    " Do the conversion
    return trim(system('nix hash to-' . a:to . ' ' . hash))
endfunction

" Common case: convert SHA256 hash to SRI
vnoremap <buffer> <Leader>NHSRI ygv"=ConvertHash(getreg('"'), 'sri', 'sha256')<CR>P

