utils = require('utils')
map = utils.map

-- It's in the runtime *shrug*
vim.api.nvim_command('runtime macros/matchit.vim')

-- vim-visual-multi {{{
if utils.plugins.has('vim-visual-multi') then
  vim.g.VM_leader = '\\'
  map.nmap('<C-j>', '<Plug>(VM-Add-Cursor-Down)')
  map.nmap('<C-k>', '<Plug>(VM-Add-Cursor-Up)')
end
-- }}}

-- telescope {{{
if utils.plugins.has('telescope.nvim') then
  map.nnoremap('<Leader>ff', '<cmd>Telescope find_files<CR>')
  map.nnoremap('<Leader>fg', '<cmd>Telescope git_files<CR>')
  map.nnoremap('<Leader><Leader>', '<cmd>Telescope git_files<CR>')
  map.nnoremap('<Leader>fr', '<cmd>Telescope live_grep<CR>')
  map.nnoremap('<Leader>fK', '<cmd>Telescope grep_string<CR>')
  map.nnoremap('<Leader>fo', '<cmd>Telescope oldfiles<CR>')
  map.nnoremap('<Leader>fe', '<cmd>Telescope file_browser<CR>')
  map.nnoremap('<Leader>fb', '<cmd>Telescope buffers<CR>')
  map.nnoremap('<Leader>ft', '<cmd>Telescope tags<CR>')
  map.nnoremap('<Leader>fh', '<cmd>Telescope help_tags<CR>')
  map.nnoremap('<Leader>fm', '<cmd>Telescope keymaps<CR>')
  map.nnoremap('<Leader>fz', '<cmd>Telescope spell_suggest<CR>')
  map.nnoremap('<Leader>fcg', '<cmd>Telescope git_commits<CR>')
  map.nnoremap('<Leader>fcb', '<cmd>Telescope git_bcommits<CR>')
  map.nnoremap('<Leader>f:', '<cmd>Telescope commands<CR>')
  map.nnoremap('<Leader>fj', '<cmd>Telescope jumplist<CR>')
  map.nnoremap('<Leader>flg0', '<cmd>Telescope lsp_document_symbols<CR>')
  map.nnoremap('<Leader>flgW', '<cmd>Telescope lsp_workspace_symbols<CR>')
  -- TODO: configure lsp-related telescope pickers
end
-- }}}

-- nvim-tree {{{
if utils.plugins.has('nvim-tree.lua') then
  map.nnoremap('<Leader>d', '<cmd>NvimTreeToggle<CR>')
  require('nvim-tree').setup {
    -- disable_netrw = false,
    auto_close = true,
  }
end
-- }}}

-- minimap {{{
if utils.plugins.has('minimap.vim') then
  vim.g.minimap_width = 25
  vim.cmd([[
    augroup minimap_group
        autocmd!
        autocmd ColorScheme * highlight MinimapSelected guifg=Magenta
    augroup END
  ]])
  vim.g.minimap_highlight = "MinimapSelected"
  map.nnoremap('<Leader>umm', '<cmd>MinimapToggle<CR>')
end
-- }}}

-- nvim-colorizer {{{
if utils.plugins.has('nvim-colorizer.lua') then
  require('colorizer').setup { 'css', 'javascript', 'typescript', 'html', 'vim' }
end
-- }}}

-- fugitive {{{
if utils.plugins.has('vim-fugitive') then
  -- open git status pane for staging/committing/etc.
  map.nnoremap('<Leader>gs', '<cmd>Gstatus<CR>')
  -- vertical split with the version at HEAD
  map.nnoremap('<Leader>gvs', '<cmd>Gvsplit<space>')
  -- vertical diff with the version at HEAD
  -- ! focuses on the window with the current version
  map.nnoremap('<Leader>gvd', '<cmd>Gvdiffsplit!<space>')
  -- :cd to repo root
  map.nnoremap('<Leader>gcd', '<cmd>Gcd<CR>')
  -- :lcd (only current window) to repo root
  map.nnoremap('<Leader>glcd', '<cmd>Glcd<CR>')
  -- :write and stage
  map.nnoremap('<Leader>gw', '<cmd>Gwrite<CR>')
end
-- }}}

-- vim-gitgutter {{{
if utils.plugins.has('vim-gitgutter') then
  map.nnoremap('<Leader>ugg', '<cmd>GitGutterToggle<CR>')
  map.nnoremap('<Leader>ugb', '<cmd>GitGutterBufferToggle<CR>')
  map.nmap('n', '<Leader>ghu', '<Plug>(GitGutterUndoHunk)', {})
  map.nmap('n', '<Leader>ghs', '<Plug>(GitGutterStageHunk)', {})
  map.nmap('n', '<Leader>ghp', '<Plug>(GitGutterPreviewHunk)', {})
end
-- }}}

-- caw {{{
if utils.plugins.has('caw.vim') then
  vim.g.caw_operator_keymappings = 1
  map.nmap('n', 'gco', '<Plug>(caw:jump:comment-next)', {})
  map.nmap('n', 'gcO', '<Plug>(caw:jump:comment-prev)', {})
end
-- }}}

-- indentLine {{{
if utils.plugins.has('indentLine') then
  vim.g.indentLine_enabled = 0
  vim.g.indentLine_char = '│'
  vim.g.indentLine_defaultGroup = 'IndentLine'
  map.nnoremap('<Leader>ui', ':IndentLinesToggle<CR>')
end
-- }}}

-- markdown-preview {{{
if utils.plugins.has('markdown-preview.nvim') then
  vim.g.mkdp_auto_close = 0
  vim.g.mkdp_preview_options = {
    disable_sync_scroll = 1,
    hide_yaml_meta = 0,
  }
end
-- }}}

-- goyo/limelight {{{
if utils.plugins.has('goyo.vim') and utils.plugins.has('limelight.vim') then
  vim.g.limelight_conceal_ctermfg = 'darkgray'
  vim.g.goyo_width = 80

  vim.cmd([[
    function! GoyoEnter()
        let b:goyo_cache = { 'showmode': &showmode, 'showcmd': &showcmd, 'signcolumn': &signcolumn, 'foldcolumn': &foldcolumn, 'list': &list, 'scrolloff': &scrolloff, 'wrap': &wrap, 'breakindent': &breakindent }
        set noshowmode noshowcmd
        set signcolumn=no foldcolumn=0
        set nolist
        set scrolloff=999
        set wrap breakindent
        Limelight
    endfunction

    function! GoyoLeave()
        let &showmode = b:goyo_cache['showmode']
        let &showcmd = b:goyo_cache['showcmd']
        let &signcolumn = b:goyo_cache['signcolumn']
        let &foldcolumn = b:goyo_cache['foldcolumn']
        let &list = b:goyo_cache['list']
        let &scrolloff = b:goyo_cache['scrolloff']
        let &wrap = b:goyo_cache['wrap']
        let &breakindent = b:goyo_cache['breakindent']
        Limelight!
    endfunction

    augroup goyo_group
        autocmd!
        autocmd! User GoyoEnter nested call GoyoEnter()
        autocmd! User GoyoLeave nested call GoyoLeave()
    augroup END
  ]])

  map.nnoremap('<Leader>ugy', '<cmd>Goyo<CR>')
end
-- }}}

-- vim: set foldmethod=marker:
