-- :NR command for narrowing a region

return {
  'chrisbra/NrrwRgn',
  init = function()
    vim.g.nrrw_rgn_nomap_nr = 1
    vim.g.nrrw_rgn_nomap_Nr = 1
  end,
  config = function() 
    local keymap = vim.keymap

    vim.g.nrrw_topbot_leftright = 'botright'

    keymap.set('v', '<Leader>nr', ':NarrowRegion<CR>', { desc = 'narrow selected region', noremap = true })
    keymap.set('n', '<Leader>nl', '<cmd>NRV<CR>', { desc = 'narrow last selected region', noremap = true })
    keymap.set('n', '<Leader>nv', '<cmd>NarrowWindow<CR>', { desc = 'narrow visual region', noremap = true })
    keymap.set('n', '<Leader>na', '<cmd>NRL<CR>', { desc = 'reselect last narrowed region', noremap = true })
    keymap.set('n', '<Leader>nw', '<cmd>WidenRegion<CR>', { desc = 'sync narrowed changes', noremap = true })
    keymap.set('n', '<Leader>nW', '<cmd>WidenRegion!<CR>', { desc = 'sync narrowed changes and close', noremap = true })
    keymap.set('n', '<Leader>nse', '<cmd>NRSyncOnWrite<CR>', { desc = 'enable sync', noremap = true })
    keymap.set('n', '<Leader>nsd', '<cmd>NRNoSyncOnWrite<CR>', { desc = 'disable sync', noremap = true })
  end,
}
