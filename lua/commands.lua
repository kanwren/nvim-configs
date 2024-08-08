vim.api.nvim_create_user_command(
  'JjDiff',
  function(opts)
    local revset = opts.fargs[1]
    local current_file = vim.fn.expand('%')

    vim.system(
      { 'jj', 'file', 'show', '--revision', revset, current_file },
      { text = true },
      vim.schedule_wrap(function(res)
        if res.code ~= 0 then
          vim.notify('failed to get file at revision: ' .. res.stderr, vim.log.levels.ERROR)
          return
        end

        local origwin = vim.api.nvim_get_current_win()

        -- open new empty scratch buffer
        vim.api.nvim_command('vert aboveleft new')
        local diffbuf = vim.api.nvim_get_current_buf()
        local diffwin = vim.api.nvim_get_current_win()
        vim.api.nvim_set_option_value('buflisted', false, { buf = diffbuf })
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = diffbuf })
        vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = diffbuf })
        vim.api.nvim_set_option_value('swapfile', false, { buf = diffbuf })

        -- populate the scratch buffer with file contents at revision
        local lines = vim.split(res.stdout, '\n')
        if lines[#lines] == '' then
          table.remove(lines, #lines)
        end
        vim.api.nvim_buf_set_text(diffbuf, 0, 0, -1, -1, lines)

        -- start diff
        vim.api.nvim_set_current_win(diffwin)
        vim.api.nvim_command('diffthis')
        vim.api.nvim_set_current_win(origwin)
        vim.api.nvim_command('diffthis')
      end)
    )
  end,
  { nargs = 1 }
)
