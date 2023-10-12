return {
  require('plugins.lsp.snippets'),
  require('plugins.lsp.completion'),
  require('plugins.lsp.configs'),

  -- LSP status indicator
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = true,
  },
}
