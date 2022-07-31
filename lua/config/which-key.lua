local wk = require('which-key')

wk.setup {
  plugins = {
    registers = false, -- breaks <C-r> in command line during macros
  },
  operators = {
    ["gc"] = "line comment",
    ["gb"] = "block comment",
    ["cx"] = "exchange",
    ["ys"] = "surround",
    ["yS"] = "surround to line",
  },
}

wk.register({
  ["<leader>"] = {
    ["a"] = { name = "apps" },
    ["g"] = {
      name = "git",
      ["t"] = { name = "toggle" },
      ["h"] = { name = "hunk" },
      ["b"] = { name = "buffer" },
      ["m"] = "line commit message",
    },
    ["t"] = {
      name = "toggles",
      ["n"] = { name = "line numbers" },
      ["i"] = { name = "indent" },
      ["c"] = { name = "colorcolumn" },
    },
    ["f"] = { name = "telescope" },
    ["l"] = {
      name = "lsp",
      ["g"] = { name = "goto/query symbol" },
      ["q"] = {
        name = "quickfix",
        ["g"] = { name = "goto/query symbol" },
        ["w"] = { name = "workspace" },
        ["d"] = { name = "document" },
        ["c"] = { name = "call graph" },
      },
      ["c"] = { name = "call graph" },
      ["w"] = {
        name = "workspace",
        ["f"] = { name = "folders" },
      },
      ["d"] = { name = "document" },
      ["t"] = { name = "toggle" },
      ["D"] = { name = "dump diagnostics" },
      ["l"] = { name = "server op" },
    },
    ["h"] = { name = "highlight" },
    ["b"] = { name = "buffer" },
    ["s"] = { name = "session" },
    ["n"] = {
      name = "narrow",
      ["s"] = { name = "sync" },
    },
    ["w"] = {
      name = "wiki",
      ["w"] = "open wiki index",
      ["t"] = "open wiki index in new tab",
      ["s"] = "select wiki",
      ["i"] = "open diary index",
      ["d"] = "delete current wiki page",
      ["n"] = "goto/create wiki page",
      ["r"] = "rename current wiki page",
      ["h"] = { name = "wiki→html" },
      ["<leader>"] = {
        name = "diary",
        ["w"] = "make diary note",
        ["t"] = "make diary note in new tab",
        ["i"] = "generate diary links",
        ["m"] = "make tomorrow's diary note",
        ["y"] = "make yesterday's diary note",
      },
    },
  },
  ["g"] = {
    ["a"] = "character info",
    ["S"] = "split construct",
    ["J"] = "join construct",
    ["+"] = "later text state",
    ["-"] = "earlier text state",
    ["nn"] = "init incremental select",
  },
  ["cr"] = {
    name = "coerce",
    ["c"] = "camelCase",
    ["m"] = "MixedCase",
    ["_"] = "snake_case",
    ["s"] = "snake_case",
    ["u"] = "SNAKE_UPPERCASE",
    ["U"] = "SNAKE_UPPERCASE",
    ["-"] = "dash-case",
    ["k"] = "kebab-case",
    ["."] = "dot.case",
    ["<space>"] = "space case",
    ["t"] = "Title Case",
  },
  ["\\"] = {
    name = "visual-multi",
    ["\\"] = "add cursor",
    ["/"] = "regex search",
    ["A"] = "select all",
  },
  -- operators
  ["gc"] = {
    name = "line comment",
    ["c"] = "current line",
    ["A"] = "append line comment",
    ["o"] = "insert line comment below",
    ["O"] = "insert line comment above",
  },
  ["gb"] = {
    name = "block comment",
    ["c"] = "end of line",
  },
  ["ys"] = {
    name = "surround",
    ["s"] = "current line",
  },
  ["yS"] = {
    name = "surround to line",
    ["s"] = "current line",
    ["S"] = "current line",
  },
  ["cx"] = {
    name = "exchange",
    ["c"] = "cancel exchange",
    ["x"] = "exchange line",
  },
}, { mode = 'n' })

wk.register({
  ["<leader>"] = {
    ["g"] = {
      name = "git",
      ["h"] = { name = "hunk" },
    },
    ["h"] = { name = "highlight" },
    ["n"] = { name = "narrow" },
  },
  ["S"] = "surround",
  ["gc"] = "line comment",
  ["gb"] = "block comment",
  ["gS"] = "virtual surround (suppress indent)",
  ["gr"] = {
    name = "incremental select",
    ["n"] = "widen",
    ["m"] = "shrink",
    ["c"] = "scope",
  },
}, { mode = "v" })

wk.register({
  ["m"] = "treehopper",
}, { mode = "o" })
