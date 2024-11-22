_list-recipes:
    @just --list --unsorted

update-plugins:
    nvim --headless +'Lazy! sync' +'qall'

sync-plugins:
    nvim --headless +'Lazy! restore' +'qall'

update-treesitter:
    nvim --headless +'TSUpdate all' +'qall'
