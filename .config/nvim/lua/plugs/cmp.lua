return {
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
