require('utils')

local ok, _ = require('plugins')
_G.plugins_loaded = ok
if plugins_loaded then
    require('lsp-configs')
    require('plugin-configs')
end

