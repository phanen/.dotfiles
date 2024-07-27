return {
  {
    'hrsh7th/nvim-cmp',
    -- cond = false,
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      {
        'onsails/lspkind.nvim',
        opts = { preset = 'codicons', mode = 'symbol_text' },
        config = function(_, opts) require('lspkind').init(opts) end,
      },
    },
    config = function()
      local c = require 'cmp'
      local ls = require 'luasnip'
      local m = c.mapping
      local wopts = {
        winblend = 1,
        winhighlight = 'Normal:Normal',
        border = vim.g.border,
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
          ['<c-\\>'] = m(
            function() return c.visible() and c.abort() or c.complete() end,
            { 'i', 'c' }
          ),
          ['<c-k>'] = m {
            i = m.select_prev_item(),
            c = m.select_prev_item(),
            s = function() ls.jump(-1) end,
          },
          ['<c-j>'] = m {
            i = m.select_next_item(),
            c = m.select_next_item(),
            s = function() ls.jump(1) end,
          },
          ['<c-i>'] = m {
            i = function(fb)
              if c.visible() and c.get_selected_entry() then return c.confirm() end
              if ls.jumpable(1) then return ls.jump(1) end
              return ls.expandable() and ls.expand() or fb()
            end,
            c = m.confirm { select = true },
            s = function(fb) return ls.jumpable() and ls.jump(1) or fb() end,
          },
          ['<c-o>'] = m {
            i = function(fb)
              -- if ls.jumpable() then return ls.jump(-1) end
              if c.visible() then c.abort() end
              return fb()
            end,
            c = function(fb)
              if c.visible() then c.abort() end
              return fb()
            end,
            s = function() ls.jump(-1) end,
          },
          ['<c-p>'] = m {
            i = function(fb) return ls.jumpable() and ls.jump(-1) or fb() end,
            s = function() return ls.jump(-1) end,
          },
          ['<c-n>'] = m {
            i = function(fb) return ls.jumpable() and ls.jump(1) or fb() end,
            s = function() return ls.jump(1) end,
          },
          ['<cr>'] = m(m.confirm(), { 'i', 'c' }),
          ['<c-l>'] = m(m.complete_common_string(), { 'i', 'c' }),
        },
        snippet = { expand = function(args) ls.lsp_expand(args.body) end },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
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
              buffer = '[buf]',
              nvim_lsp = '[lsp]',
              path = '[path]',
              luasnip = '[snip]',
            },
          },
        },
        performance = {
          -- NOTE: no total limit, use it as workaround
          max_view_entries = 12,
        },
      }
      -- FIXME: search up/down
      -- c.setup.cmdline('/', { sources = { { name = 'buffer' } } })
      c.setup.cmdline(':', {
        sources = {
          { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
          { name = 'path' },
          { name = 'buffer' },
        },
      })
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    -- cond = false,
    event = 'InsertEnter',
    build = 'make install_jsregexp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_lua').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load()
      require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets' }
      require('luasnip').filetype_extend('all', { '_' })
    end,
  },
  {
    -- TODO: not prompt edit in the middle of line
    'zbirenbaum/copilot.lua',
    cond = fn.argv()[1] ~= 'leetcode.nvim',
    cmd = 'Copilot',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {
      panel = { layout = { position = 'right', ratio = 0.4 } },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<a-s>',
          accept_word = '<a-f>',
          accept_line = '<a-e>',
          next = '<a-n>',
          prev = '<a-p>',
          dismiss = '<a-c>',
        },
      },
    },
  },
}
