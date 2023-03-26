-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  enabled = function() return vim.api.nvim_buf_get_option(0, 'modifiable') end,
  preselect = cmp.PreselectMode.None,
  mapping = {
    ['<c-e>'] = cmp.mapping.abort(),
    ['<c-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "c"}),
    ['<c-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "c"}),
    ["<c-space>"] = cmp.mapping.complete({}),
    ['<cr>'] = cmp.mapping(cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false, }), {"i"}),
    ['<tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { 'i', 's' }),
    ['<s-tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { 'i', 's' }),
  },
  -- mapping = cmp.mapping.preset.insert {
  --   ['<c-d>'] = cmp.mapping.scroll_docs(-4),
  --   ['<c-f>'] = cmp.mapping.scroll_docs(4),
  --   ['<c-s>'] = cmp.mapping.complete({}),
  --   ['<cr>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true, },
  -- },
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },

  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        buffer = "[buf]",
        nvim_lsp = "[lsp]",
        path = "[path]",
        luasnip = "[snip]",
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },

}


-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
-- cmp.event:on(
-- 'confirm_done',
-- cmp_autopairs.on_confirm_done()
-- )

-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--       {
--         name = 'cmdline',
--         option = {
--           ignore_cmds = { 'Man', '!' }
--         }
--       }
--     })
-- })
