-- https://github.com/hrsh7th/cmp-cmdline/issues/101
fn.getcompletion = (function(cb)
  return function(...) return vim.F.npcall(cb, ...) or {} end
end)(fn.getcompletion)

return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'https://codeberg.org/FelipeLema/cmp-async-path',
  },
  config = function()
    local c = require 'cmp'
    local ls = require 'luasnip'
    local m = c.mapping
    local wopts = {
      -- winblend = 10,
      -- winhighlight = 'Normal:Normal',
      winhighlight = 'Visual:Visual',
      -- border = g.border,
    }
    c.setup {
      window = { completion = wopts, documentation = wopts },
      sorting = {
        comparators = {
          c.config.compare.offset,
          c.config.compare.exact,
          c.config.compare.recently_used,
          c.config.compare.kind,
          c.config.compare.sort_text,
          c.config.compare.length,
          c.config.compare.order,
        },
      },
      mapping = {
        ['<c-d>'] = m(m.scroll_docs(4), { 'i', 'c' }),
        ['<c-u>'] = m(m.scroll_docs(-4), { 'i', 'c' }),
        ['<a-;>'] = m(function()
          if c.visible() then return c.abort() end
          return c.complete()
        end, { 'i', 'c' }),
        ['<c-k>'] = m(m.select_prev_item(), { 'i', 'c' }),
        ['<c-j>'] = m(m.select_next_item(), { 'i', 'c' }),
        ['<c-i>'] = m(function(fb)
          if c.visible() then
            if not c.get_selected_entry() and ls.locally_jumpable(1) then return ls.jump(1) end
            return c.confirm { select = true }
          end
          if ls.locally_jumpable(1) then return ls.jump(1) end
          return fb()
        end, { 'i', 'c', 's' }),
        ['<c-o>'] = m(function(fb)
          if ls.locally_jumpable(-1) then return ls.jump(-1) end
          if c.visible() then c.close() end
          return fb()
        end, { 'i', 'c', 's' }),
        ['<cr>'] = m(m.confirm(), { 'i', 'c' }),
      },
      snippet = { expand = function(args) ls.lsp_expand(args.body) end },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
        { name = 'async_path' },
        { name = 'buffer' },
      },
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = require('lspkind').cmp_format {
          mode = 'symbol',
          maxwidth = math.min(50, math.floor(vim.o.columns * 0.5)),
          ellipsis_char = '…',
          before = function(_, item)
            local min_width = 10
            local length = api.nvim_strwidth(item.abbr)
            item.abbr = item.abbr .. (' '):rep(math.max(0, min_width - length))
            return item
          end,
          menu = {
            buffer = '[B]',
            nvim_lsp = '[L]',
            async_path = '[P]',
            nvim_lsp_signature_help = '[H]',
            luasnip = '[S]',
          },
        },
      },
      -- no total limit, use it as workaround
      performance = {
        debounce = 30,
        throttle = 30,
        fetching_timeout = 500,
        confirm_resolve_timeout = 80,
        async_budget = 1,
        max_view_entries = 200,
      },
    }

    -- TODO: reverse cmdline view?
    c.setup.cmdline(':', {
      sources = {
        { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
        { name = 'async_path' },
        { name = 'buffer' },
      },
    })
  end,
}
