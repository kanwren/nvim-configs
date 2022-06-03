local gitsigns = require('gitsigns')

gitsigns.setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']h', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { desc = 'next hunk', expr = true })

    map('n', '[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { desc = 'previous hunk', expr = true })

    map({'n', 'v'}, '<Leader>ghs', ':Gitsigns stage_hunk<CR>', { desc = 'stage hunk' })
    map({'n', 'v'}, '<Leader>ghr', ':Gitsigns reset_hunk<CR>', { desc = 'reset hunk' })
    map('n', '<Leader>ghS', gs.stage_buffer, { desc = 'stage buffer' })
    map('n', '<Leader>ghu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
    map('n', '<Leader>ghR', gs.reset_buffer, { desc = 'reset buffer' })
    map('n', '<Leader>ghp', gs.preview_hunk, { desc = 'preview hunk' })
    map('n', '<Leader>ghd', gs.diffthis, { desc = 'diffthis' })
    map('n', '<Leader>ghD', function() gs.diffthis('~') end, { desc = 'diffthis' })
    map('n', '<Leader>gb', function() gs.blame_line{full = true} end, { desc = 'blame line' })
    map('n', '<Leader>gub', gs.toggle_current_line_blame, { desc = 'toggle line blame overlay' })
    map('n', '<Leader>gud', gs.toggle_deleted, { desc = 'toggle deleted lines' })
  end
}

-- TODO: add to statusline
