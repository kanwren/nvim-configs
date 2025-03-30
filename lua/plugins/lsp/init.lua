return {
  require('plugins.lsp.snippets'),
  require('plugins.lsp.completion'),
  require('plugins.lsp.configs'),

  -- LSP status indicator
  {
    'j-hui/fidget.nvim',
    tag = 'v1.2.0',
    config = true,
  },
}
