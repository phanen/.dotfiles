local blink = false
return {
  {
    'hrsh7th/nvim-cmp',
    -- 'iguanacucumber/magazine.nvim',
    cond = not blink,
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
              -- if c.visible() and c.get_selected_entry() then return c.confirm() end
              if c.visible() then
                -- if fn.pumvisible() == 1 then return m.select_next_item()() end
                return c.confirm({ select = not c.get_selected_entry() })
              end
              if ls.expandable() then return ls.expand() end
              return fb()
            end,
            c = m.confirm { select = true },
            s = function(fb)
              if ls.jumpable() then return ls.jump(1) end
              return fb()
            end,
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
            s = function() return ls.jump(-1) end,
          },
          ['<c-p>'] = m {
            i = function(fb)
              if ls.jumpable() then return ls.jump(-1) end
              return fb()
            end,
            s = function() return ls.jump(-1) end,
          },
          ['<c-n>'] = m {
            i = function(fb)
              if ls.jumpable() then return ls.jump(1) end
              return fb()
            end,
            s = function() return ls.jump(1) end,
          },
          ['<cr>'] = m(m.confirm(), { 'i', 'c' }),
          ['<c-l>'] = m(m.complete_common_string(), { 'i', 'c' }),
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
      c.setup.cmdline(':', {
        sources = {
          { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
          { name = 'async_path' },
          { name = 'buffer' },
        },
      })
    end,
  },
  {
    'saghen/blink.cmp',
    cond = blink,
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      highlight = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,
      },
      -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'normal',

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      -- trigger = { signature_help = { enabled = true } }
    },
  },
}
