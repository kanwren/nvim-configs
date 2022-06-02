vim.o.completeopt = 'menuone,noinsert,noselect'
vim.g.completion_enable_fuzzy_match = 1
vim.g.completion_confirm_key = ''

local cmp = require('cmp')
local cmp_context = require('cmp.config.context')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

function next_item(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

function prev_item(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<C-n>'] = cmp.mapping(next_item, { 'i', 's' }),
    ['<C-p>'] = cmp.mapping(prev_item, { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(next_item, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(prev_item, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'treesitter' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'tags' },
    { name = 'rg' },
    { name = 'calc' },
    { name = 'nvim_lua' },
  }, {
    { name = 'buffer' },
  }),
  enabled = function()
    -- disable completion in comments
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not cmp_context.in_treesitter_capture("comment")
        and not cmp_context.in_syntax_group("Comment")
    end
  end,
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 70,
    })
  }
})

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
