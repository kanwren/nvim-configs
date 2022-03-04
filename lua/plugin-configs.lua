local utils = require('utils')

local make_map = vim.api.nvim_set_keymap

-- It's in the runtime *shrug*
vim.api.nvim_command('runtime macros/matchit.vim')

-- vim-visual-multi {{{
if utils.plugins.has('vim-visual-multi') then
  vim.g.VM_leader = '\\'
  make_map('n', '<C-j>', '<Plug>(VM-Add-Cursor-Down)', {})
  make_map('n', '<C-k>', '<Plug>(VM-Add-Cursor-Up)', {})
end
-- }}}

-- telescope {{{
if utils.plugins.has('telescope.nvim') then
  make_map('n', '<Leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true })
  make_map('n', '<Leader>fg', '<cmd>Telescope git_files<CR>', { noremap = true })
  make_map('n', '<Leader><Leader>', '<cmd>Telescope git_files<CR>', { noremap = true })
  make_map('n', '<Leader>fr', '<cmd>Telescope live_grep<CR>', { noremap = true })
  make_map('n', '<Leader>fK', '<cmd>Telescope grep_string<CR>', { noremap = true })
  make_map('n', '<Leader>fo', '<cmd>Telescope oldfiles<CR>', { noremap = true })
  make_map('n', '<Leader>fe', '<cmd>Telescope file_browser<CR>', { noremap = true })
  make_map('n', '<Leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true })
  make_map('n', '<Leader>ft', '<cmd>Telescope tags<CR>', { noremap = true })
  make_map('n', '<Leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true })
  make_map('n', '<Leader>fm', '<cmd>Telescope keymaps<CR>', { noremap = true })
  make_map('n', '<Leader>fz', '<cmd>Telescope spell_suggest<CR>', { noremap = true })
  make_map('n', '<Leader>fcg', '<cmd>Telescope git_commits<CR>', { noremap = true })
  make_map('n', '<Leader>fcb', '<cmd>Telescope git_bcommits<CR>', { noremap = true })
  make_map('n', '<Leader>f:', '<cmd>Telescope commands<CR>', { noremap = true })
  make_map('n', '<Leader>fj', '<cmd>Telescope jumplist<CR>', { noremap = true })
  make_map('n', '<Leader>flg0', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true })
  make_map('n', '<Leader>flgW', '<cmd>Telescope lsp_workspace_symbols<CR>', { noremap = true })
  -- TODO: configure lsp-related telescope pickers
end
-- }}}

-- nvim-tree {{{
if utils.plugins.has('nvim-tree.lua') then
  make_map('n', '<Leader>d', '<cmd>NvimTreeToggle<CR>', { noremap = true })
  require('nvim-tree').setup {
    disable_netrw = false,
    hijack_netrw = false,
    auto_close = false,
  }
end
-- }}}

-- nvim-colorizer {{{
if utils.plugins.has('nvim-colorizer.lua') then
  require('colorizer').setup { 'css', 'javascript', 'typescript', 'html', 'vim', 'lua' }
end
-- }}}

-- fugitive {{{
if utils.plugins.has('vim-fugitive') then
  -- open git status pane for staging/committing/etc.
  make_map('n', '<Leader>gs', '<cmd>Gstatus<CR>', { noremap = true })
  -- vertical split with the version at HEAD
  make_map('n', '<Leader>gvs', '<cmd>Gvsplit<space>', { noremap = true })
  -- vertical diff with the version at HEAD
  -- ! focuses on the window with the current version
  make_map('n', '<Leader>gvd', '<cmd>Gvdiffsplit!<space>', { noremap = true })
  -- :cd to repo root
  make_map('n', '<Leader>gcd', '<cmd>Gcd<CR>', { noremap = true })
  -- :lcd (only current window) to repo root
  make_map('n', '<Leader>glcd', '<cmd>Glcd<CR>', { noremap = true })
  -- :write and stage
  make_map('n', '<Leader>gw', '<cmd>Gwrite<CR>', { noremap = true })
end
-- }}}

-- vim-gitgutter {{{
if utils.plugins.has('vim-gitgutter') then
  make_map('n', '<Leader>ugg', '<cmd>GitGutterToggle<CR>', { noremap = true })
  make_map('n', '<Leader>ugb', '<cmd>GitGutterBufferToggle<CR>', { noremap = true })
  make_map('n', '<Leader>ghu', '<Plug>(GitGutterUndoHunk)', {})
  make_map('n', '<Leader>ghs', '<Plug>(GitGutterStageHunk)', {})
  make_map('n', '<Leader>ghp', '<Plug>(GitGutterPreviewHunk)', {})
end
-- }}}

-- indentLine {{{
if utils.plugins.has('indentLine') then
  vim.g.indentLine_enabled = 0
  vim.g.indentLine_char = '│'
  vim.g.indentLine_defaultGroup = 'IndentLine'
  make_map('n', '<Leader>ui', ':IndentLinesToggle<CR>', { noremap = true })
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

  make_map('n', '<Leader>ugy', '<cmd>Goyo<CR>', { noremap = true })
end
-- }}}

-- HighStr {{{
if utils.plugins.has('HighStr.nvim') then
  for i = 0, 9 do
    make_map("v", "<Leader>h" .. i, ":<c-u>HSHighlight " .. i .. "<CR>", { noremap = true, silent = true })
  end
  make_map("v", "<Leader>h1", ":<c-u>HSHighlight 1<CR>", { noremap = true, silent = true })
  make_map("n", "<Leader>hr", ":<c-u>HSRmHighlight<CR>", { noremap = true, silent = true })
  make_map("v", "<Leader>hr", ":<c-u>HSRmHighlight<CR>", { noremap = true, silent = true })
  make_map("n", "<Leader>hc", ":<c-u>HSRmHighlight rm_all<CR>", { noremap = true, silent = true })
end
-- }}}

-- unison {{{
if utils.plugins.has('unison') then
  vim.g.unison_api_port = 6789
  vim.g.unison_api_token = 'local_ucm'
end
-- }}}

-- vim: set foldmethod=marker:
