return {
  {
    'ahmedkhalf/project.nvim',
    name = 'project_nvim',
    config = {
      manual_mode = true,
      silent_chdir = false,
    },
    keys = {
      { '<Leader>c', '<cmd>ProjectRoot<CR>', mode = { 'n' }, noremap = true, desc = 'cd to project root' },
    },
  },
}
