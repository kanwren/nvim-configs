-- :NR command for narrowing a region

return {
  'chrisbra/NrrwRgn',

  init = function()
    vim.g.nrrw_rgn_nomap_nr = 1
    vim.g.nrrw_rgn_nomap_Nr = 1
  end,

  config = function()
    vim.g.nrrw_topbot_leftright = 'botright'
  end,

  keys = {
    {
      '<Leader>nr',
      ':NarrowRegion<CR>',
      mode = 'v',
      noremap = true,
      desc = 'narrow selected region',
    },
    {
      '<Leader>nl',
      '<cmd>NRV<CR>',
      mode = 'n',
      noremap = true,
      desc = 'narrow last selected region',
    },
    {
      '<Leader>nv',
      '<cmd>NarrowWindow<CR>',
      mode = 'n',
      noremap = true,
      desc = 'narrow visual region',
    },
    {
      '<Leader>na',
      '<cmd>NRL<CR>',
      mode = 'n',
      noremap = true,
      desc = 'reselect last narrowed region',
    },
    {
      '<Leader>nw',
      '<cmd>WidenRegion<CR>',
      mode = 'n',
      noremap = true,
      desc = 'sync narrowed changes',
    },
    {
      '<Leader>nW',
      '<cmd>WidenRegion!<CR>',
      mode = 'n',
      noremap = true,
      desc = 'sync narrowed changes and close',
    },
    {
      '<Leader>nse',
      '<cmd>NRSyncOnWrite<CR>',
      mode = 'n',
      noremap = true,
      desc = 'enable sync',
    },
    {
      '<Leader>nsd',
      '<cmd>NRNoSyncOnWrite<CR>',
      mode = 'n',
      noremap = true,
      desc = 'disable sync',
    },
  },
}
