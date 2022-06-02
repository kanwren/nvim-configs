local wk = require('which-key')

return

wk.register({
  ["<leader>"] = {
    ["<Tab>"] = "retab and remove trailing whitespace",
    ["g"] = {
      name = "+git",
      ["u"] = {
        name = "+ui",
        ["d"] = "toggle deleted lines",
        ["b"] = "toggle current line blame",
      },
      ["b"] = "blame line",
      ["h"] = {
        name = "+hunk",
        ["D"] = "diffthis",
        ["d"] = "diffthis",
        ["p"] = "preview hunk",
        ["R"] = "reset buffer",
        ["u"] = "undo stage hunk",
        ["S"] = "stage buffer",
        ["r"] = "reset hunk",
        ["s"] = "stage hunk",
      },
      ["m"] = "line commit message",
    },
    ["u"] = {
      name = "+ui",
      ["u"] = "undo tree",
      ["i"] = "indent lines",
      ["mm"] = "minimap",
      ["l"] = "listchars",
      ["w"] = "line wrapping",
      ["fc"] = "fold column",
      ["sc"] = "sign column",
      ["sl"] = "statusline",
      ["nr"] = "relative line numbers",
      ["nn"] = "line numbers",
    },
    ["d"] = "file tree",
    ["f"] = {
      name = "+telescope",
      ["b"] = "buffers",
      ["r"] = "ripgrep",
      ["g"] = "git files",
      ["f"] = "files",
      ["m"] = "keymaps",
    },
    ["l"] = {
      name = "+lsp",
      ['d'] = 'diagnostic',
      ['r'] = 'rename',
      ['a'] = 'code action',
      ['x'] = 'stop LSP',
      ['X'] = 'restart LSP',
    },
    ["o"] = {
      name = "+options",
      ["i"] = "indentation",
    },
    ["r"] = "copy register",
    ["<Tab>"] = "fix whitespace",
    ["w"] = "write",
  },
  -- TODO: add other leaders (cr, gc, ys)
  ["g"] = {
    ["a"] = "character info",
    ["b"] = "block comment",
    ["c"] = "line comment",
    ["S"] = "split construct",
    ["J"] = "join construct",
    ["s"] = "split line",
  },
  ["c"] = {
    ["r"] = "coerce",
    ["x"] = "exchange",
  },
  ["\\"] = {
    name = "+visual-multi",
    ["\\"] = "add cursor",
    ["/"] = "regex search",
    ["A"] = "select all",
  },
})
