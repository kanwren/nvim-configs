return {
  -- sign column
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- navigation
        map('n', ']h', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { desc = 'Next hunk', expr = true })
        map('n', '[h', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { desc = 'Previous hunk', expr = true })
        -- line operations
        map('n', '<Leader>gl', function() gs.blame_line { full = true } end, { desc = 'Blame line' })
        -- hunk operations
        map({ 'n', 'x' }, '<Leader>ghs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
        map({ 'n', 'x' }, '<Leader>ghr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
        map('n', '<Leader>ghu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
        map('n', '<Leader>ghp', gs.preview_hunk, { desc = 'Preview hunk' })
        -- buffer operations
        map('n', '<Leader>gbdi', gs.diffthis, { desc = 'Diff against index' })
        map('n', '<Leader>gbdp', function() gs.diffthis('~') end, { desc = 'Diff against parent' })
        map('n', '<Leader>gbdd', function() gs.diffthis(vim.fn.input('ref: '):match('^%s*(.-)%s*$')) end,
          { desc = 'Custom diff' })
        map('n', '<Leader>gbs', gs.stage_buffer, { desc = 'Stage buffer' })
        map('n', '<Leader>gbr', gs.reset_buffer, { desc = 'Reset buffer' })
        -- UI stuff
        map('n', '<Leader>gtb', gs.toggle_current_line_blame, { desc = 'Toggle line blame overlay' })
        map('n', '<Leader>gtd', gs.toggle_deleted, { desc = 'Toggle deleted lines' })
      end
    },
  },

  -- github permalinks
  {
    'ruifm/gitlinker.nvim',
    config = function()
      local gitlinker = require('gitlinker')
      gitlinker.setup {
        mappings = '<leader>gy'
      }
    end,
  },
}
