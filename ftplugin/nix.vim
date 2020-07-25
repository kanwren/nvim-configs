setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Update rev/sha256 when inside a fetchFromGitHub block
" Assumes fields are ordered as owner, repo, rev, sha256
nnoremap <buffer> <Leader>NU vaB%<Esc>:let @h=@/<CR>/owner<CR>f""jyi"j0f""kyi":NPG <C-r>j <C-r>k<CR>jdjkk=j:let @/=@h<CR>:noh<CR>

" Pre-fill NPG information from surrounding block, with the same restrictions as
" above
nnoremap <buffer> <Leader>NP vaB%<Esc>:let @h=@/<CR>/owner<CR>f""jyi"j0f""kyi":NPG <C-r>j <C-r>k

