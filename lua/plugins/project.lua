return {
  {
    'ahmedkhalf/project.nvim',
    name = 'project_nvim',
    opts = {
      manual_mode = true,
      silent_chdir = false,
    },
    keys = {
      { '<Leader>mp', '<cmd>ProjectRoot<CR>', mode = { 'n' }, noremap = true, desc = 'cd to project root' },
    },
  },
}
