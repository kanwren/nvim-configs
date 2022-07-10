local wk = require('which-key')

wk.setup {
  plugins = {
    registers = false,  -- breaks <C-r> in command line during macros
  },
}

local maps = {
  ["<leader>"] = {
    ["g"] = {
      name = "+git",
      ["u"] = { name = "+ui" },
      ["h"] = { name = "+hunk" },
      ["b"] = { name = "+buffer" },
      ["m"] = "line commit message",
    },
    ["u"] = { name = "+ui" },
    ["f"] = { name = "+telescope" },
    ["l"] = {
      name = "+lsp",
      ["g"] = { name = "+goto/query symbol" },
      ["t"] = {
        name = "+telescope",
        ["g"] = { name = "+goto/query symbol" },
        ["w"] = { name = "+workspace" },
        ["d"] = { name = "+document" },
      },
      ["c"] = { name = "+call hierarchy" },
      ["w"] = {
        name = "+workspace",
        ["f"] = { name = "+folders" },
      },
      ["d"] = { name = "+document" },
      ["q"] = { name = "+convert diagnostics" },
      ["l"] = { name = "+server op" },
    },
    ["h"] = { name = "+highlight" },
    ["o"] = { name = "+options" },
  },
  ["g"] = {
    ["a"] = "character info",
    ["S"] = "split construct",
    ["J"] = "join construct",
  },
  ["\\"] = {
    name = "+visual-multi",
    ["\\"] = "add cursor",
    ["/"] = "regex search",
    ["A"] = "select all",
  },
}

local operators = {
  ["ys"] = "surround",
  ["yS"] = "surround line",
  ["gc"] = "line comment",
  ["gb"] = "block comment",
  ["cr"] = "coerce",
  ["cx"] = "exchange",
}

local objects = {
  ["m"] = "treehopper",
}

wk.register(maps, { mode = "n" })
wk.register(operators, { mode = "n" })
wk.register(objects, { mode = "o" })
