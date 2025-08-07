return {
  'folke/which-key.nvim',

  config = function()
    local wk = require('which-key')

    wk.setup {
      plugins = {
        registers = false, -- breaks <C-r> in command line during macros
      },
    }

    wk.add({
      {
        mode = { "n" },
        { "K",           desc = "Hover" },
        { "<leader>b",   group = "buffer" },
        { "<leader>f",   group = "telescope" },
        { "<leader>g",   group = "git" },
        { "<leader>gb",  group = "buffer" },
        { "<leader>gbd", group = "diff" },
        { "<leader>gh",  group = "hunk" },
        { "<leader>gt",  group = "toggle" },
        { "<leader>gy",  desc = "Copy permalink" },
        { "<leader>m",   group = "change directory" },
        { "<leader>t",   group = "toggles" },
        { "\\",          group = "visual-multi" },
        { "\\/",         desc = "Regex search" },
        { "\\A",         desc = "Select all" },
        { "\\\\",        desc = "Add cursor" },
        { "cx",          group = "exchange" },
        { "cxc",         desc = "Cancel exchange" },
        { "cxx",         desc = "Exchange line" },
        { "g+",          desc = "Later text state" },
        { "g-",          desc = "Earlier text state" },
        { "ga",          desc = "Show character info" },
        { "gb",          group = "block comment" },
        { "gbc",         desc = "End of line" },
        { "gc",          group = "line comment" },
        { "gcc",         desc = "Current line" },
        { "gra",         desc = "Code action" },
        { "grc",         group = "callgraph" },
        { "grci",        desc = "Incoming calls" },
        { "grco",        desc = "Outgoing calls" },
        { "gri",         desc = "Goto implementation" },
        { "grn",         desc = "Rename" },
        { "grr",         desc = "Goto references" },
        { "yS",          group = "surround to line" },
        { "ySS",         desc = "Current line" },
        { "ySs",         desc = "Current line" },
        { "ys",          group = "surround" },
        { "yss",         desc = "Current line" },
      },
      {
        mode = { "x" },
        { "<leader>g",  group = "git" },
        { "<leader>gh", group = "hunk" },
        { "S",          desc = "Surround" },
        { "gS",         desc = "Virtual surround (suppress indent)" },
        { "gb",         desc = "Block comment" },
        { "gc",         desc = "Line comment" },
      },
      {
        mode = { "o" },
      },
    })
  end,
}
