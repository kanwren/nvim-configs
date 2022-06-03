local wk = require('which-key')

local maps = {
  ["<leader>"] = {
    ["g"] = {
      name = "+git",
      ["u"] = { name = "+ui" },
      ["h"] = { name = "+hunk" },
      ["m"] = "line commit message",
    },
    ["u"] = { name = "+ui" },
    ["f"] = { name = "+telescope" },
    ["l"] = { name = "+lsp" },
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
