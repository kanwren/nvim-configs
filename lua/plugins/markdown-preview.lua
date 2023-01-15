return {
  'iamcco/markdown-preview.nvim',
  build = 'cd app && yarn install',
  ft = { 'markdown' },
  config = function() 
    vim.g.mkdp_auto_close = 0
    vim.g.mkdp_preview_options = {
      disable_sync_scroll = 1,
      hide_yaml_meta = 0,
    }
  end,
}
