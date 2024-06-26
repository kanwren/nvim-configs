return {
  'folke/which-key.nvim',

  -- defining prefixes which are later assigned mappings is broken in 1.5.0 due
  -- to https://github.com/folke/which-key.nvim/issues/482
  version = '1.4.x',

  config = function()
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
        ["c"] = { name = "creatures" },
        ["m"] = { name = "change directory" },
        ["g"] = {
          name = "git",
          ["y"] = { name = "copy permalink" },
          ["t"] = { name = "toggle" },
          ["h"] = { name = "hunk" },
          ["b"] = {
            name = "buffer",
            ["d"] = { name = "diff" },
          },
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
          ["p"] = { name = "preview" },
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
          ["x"] = { name = "server" },
        },
        ["h"] = { name = "highlight" },
        ["b"] = { name = "buffer" },
        ["w"] = { name = "wiki" },
      },
      ["g"] = {
        ["a"] = "character info",
        ["S"] = "split construct",
        ["J"] = "join construct",
        ["+"] = "later text state",
        ["-"] = "earlier text state",
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
      },
      ["S"] = "surround",
      ["gc"] = "line comment",
      ["gb"] = "block comment",
      ["gS"] = "virtual surround (suppress indent)",
    }, { mode = "x" })

    wk.register({
      ["m"] = "treehopper",
    }, { mode = "o" })
  end,
}
