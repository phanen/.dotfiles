-- https://github.com/hrsh7th/cmp-cmdline/issues/101
fn.getcompletion = (function(cb)
  return function(...) return vim.F.npcall(cb, ...) or {} end
end)(fn.getcompletion)

local cmp = {
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
        ['<c-k>'] = m(m.select_prev_item(), { 'i', 'c' }),
        ['<c-j>'] = m(m.select_next_item(), { 'i', 'c' }),
        ['<cr>'] = m(m.confirm(), { 'i', 'c' }),
        ['<a-;>'] = m(function()
          if c.visible() then return c.abort() end
          return c.complete()
        end, { 'i', 'c' }),
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
      },
      snippet = {
        expand = function(args)
          vim.print(args.body)
          ls.lsp_expand(args.body)
        end,
      },
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

    c.setup.cmdline(':', {
      sources = {
        { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
        { name = 'async_path' },
        { name = 'buffer' },
      },
    })
    lsp.config('*', { capablities = require('cmp_nvim_lsp').capablities })
  end,
}

local blink = {
  'Saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = 'v0.10.*',
  config = function()
    local ls = require 'luasnip'
    require('blink.cmp').setup {
      signature = { enabled = true },
      fuzzy = { prebuilt_binaries = { download = true, ignore_version_mismatch = true } },
      completion = {
        trigger = { prefetch_on_insert = true, show_on_keyword = true },
        list = {
          selection = { preselect = false, auto_insert = true },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
        menu = {
          auto_show = true,
          winblend = vim.o.winblend,
          draw = { treesitter = { 'lsp' } },
        },
        documentation = {
          window = { winblend = vim.o.winblend },
          auto_show = false,
          -- auto_show_delay_ms = 0,
          -- update_delay_ms = 0,
        },
      },

      snippets = {
        preset = 'luasnip',
        expand = function(s) ls.lsp_expand(s) end,
        active = function(opts)
          if opts and opts.direction then return ls.locally_jumpable(opts.direction) end
          return ls.in_snippet()
        end,
        jump = function(direction) ls.jump(direction) end,
      },

      keymap = {
        preset = 'none',
        ['<c-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<c-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<c-k>'] = { 'select_prev', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
        ['<a-;>'] = { 'show', 'hide' },
        ['<cr>'] = { 'accept', 'fallback' },
        ['<c-i>'] = { -- schedule wrap needed https://github.com/Saghen/blink.cmp/issues/533
          function(c)
            if c.is_visible() then
              if not c.get_selected_item() and ls.locally_jumpable(1) then
                vim.schedule(function() ls.jump(1) end)
                return true
              end
              return c.select_and_accept()
            end
            if ls.locally_jumpable(1) then
              vim.schedule(function() ls.jump(1) end)
              return true
            end
          end,
          'fallback',
        },
        ['<c-o>'] = {
          function()
            if ls.locally_jumpable(-1) then
              vim.schedule(function() ls.jump(-1) end)
              return true
            end
          end,
          'fallback',
        },
      },
      sources = {
        default = { 'lsp', 'path', 'buffer' },
        cmdline = function()
          local type = vim.fn.getcmdtype()
          if type == ':' or type == '@' then return { 'cmdline', 'path', 'buffer' } end
          return {}
        end,
      },
    }
  end,
}

return true and blink or cmp
