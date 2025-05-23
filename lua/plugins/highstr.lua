-- add temporary highlights

local keys = {
  {
    '<Leader>hr',
    ':<c-u>HSRmHighlight<CR>',
    mode = { 'n', 'x' },
    noremap = true,
    silent = true,
    desc = 'Remove highlight',
  },
  {
    '<Leader>hc',
    ':<c-u>HSRmHighlight rm_all<CR>',
    mode = 'n',
    noremap = true,
    silent = true,
    desc = 'Clear all highlights',
  },
}

for i = 0, 9 do
  keys[#keys + 1] = {
    '<Leader>h' .. i,
    ':<c-u>HSHighlight ' .. i .. '<CR>',
    mode = 'x',
    noremap = true,
    silent = true,
    desc = 'Highlight ' .. i,
  }
end

return {
  'Pocco81/HighStr.nvim',
  keys = keys,
}
