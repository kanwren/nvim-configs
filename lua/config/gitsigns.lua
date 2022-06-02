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
    end, { expr = true })

    map('n', '[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map({'n', 'v'}, '<Leader>ghs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<Leader>ghr', ':Gitsigns reset_hunk<CR>')
    map('n', '<Leader>ghS', gs.stage_buffer)
    map('n', '<Leader>ghu', gs.undo_stage_hunk)
    map('n', '<Leader>ghR', gs.reset_buffer)
    map('n', '<Leader>ghp', gs.preview_hunk)
    map('n', '<Leader>ghd', gs.diffthis)
    map('n', '<Leader>ghD', function() gs.diffthis('~') end)
    map('n', '<Leader>gb', function() gs.blame_line{full = true} end)
    map('n', '<Leader>gub', gs.toggle_current_line_blame)
    map('n', '<Leader>gud', gs.toggle_deleted)
  end
}

-- TODO: add to statusline
