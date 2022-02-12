function _G.dump(...)
  print(unpack(vim.tbl_map(vim.inspect, { ... })))
end

local M = {}

M.log = {}
function M.log.echom(msg)
  local lines = vim.fn.split(msg, "\n")
  for _, line in ipairs(lines) do
    vim.cmd("echom '" .. line:gsub("'", "''") .. "'")
  end
end

function M.log.echo_hl(hl, msg)
  vim.cmd('echohl ' .. hl)
  M.log.echom(msg)
  vim.cmd('echohl None')
end

M.log.info = function(msg) M.log.echo_hl('Directory', msg) end
M.log.warn = function(msg) M.log.echo_hl('WarningMsg', msg) end
M.log.err = function(msg) M.log.echo_hl('ErrorMsg', msg) end

-- Check if a plugin is installed. When 'plugin_debug' is set, error out when a
-- plugin is expected but not installed
M.plugins = {}
function M.plugins.has(name)
  if not packer_plugins[name] then
    if plugin_debug then
      M.err(name .. ' not installed')
    else
      return false
    end
  else
    return true
  end
end

function M.read_file(filename)
  local fd = assert(vim.loop.fs_open(filename, "r", 438))
  local stat = assert(vim.loop.fs_fstat(fd))
  local data = assert(vim.loop.fs_read(fd, stat.size, 0))
  assert(vim.loop.fs_close(fd))
  return data
end

function M.write_file(filename, contents, flag, mode)
  local fd = assert(vim.loop.fs_open(filename, flag, mode or 438))
  local stat = assert(vim.loop.fs_write(fd, contents, -1))
  assert(vim.loop.fs_close(fd))
end

function M.path_exists(filename)
  local stat = vim.loop.fs_stat(filename)
  return stat and stat.type or false
end

function M.stdpath(p)
  local val = vim.env['NVIM_NIX_STDPATH_' .. p]
  if val then
    return val
  else
    return vim.fn.stdpath(p)
  end
end

return M
