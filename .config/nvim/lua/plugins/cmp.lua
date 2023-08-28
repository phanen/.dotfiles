return {
  { "f3fora/cmp-spell", event = "InsertEnter", ft = { "gitcommit", "markdown" } },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    keys = { ":", "/" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"

      local formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format {
          mode = "symbol",
          maxwidth = math.min(50, math.floor(vim.o.columns * 0.5)),
          ellipsis_char = "…",
          before = function(_, vim_item)
            local MIN_MENU_WIDTH = 25
            local label, length = vim_item.abbr, vim.api.nvim_strwidth(vim_item.abbr)
            if length < MIN_MENU_WIDTH then vim_item.abbr = label .. string.rep(" ", MIN_MENU_WIDTH - length) end
            return vim_item
          end,
          symbol_map = { Copilot = " " },
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[lsp]",
            path = "[path]",
            luasnip = "[snip]",
            emoji = "[emoji]",
          },
        },
      }

      cmp.setup {
        experimental = {
          ghost_text = true,
        },
        -- TODO: menu width and height
        window = {
          completion = cmp.config.window.bordered {},
          documentation = cmp.config.window.bordered {},
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            -- require "clangd_extensions.cmp_scores",
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        -- disable in TelescopePrompt
        -- enabled = function() return vim.api.nvim_buf_get_option(0, "modifiable") and vim.bo.buftype ~= "prompt" end,
        mapping = {
          ["<c-\\>"] = cmp.mapping(function()
            if cmp.visible() then return cmp.abort() end
            return cmp.complete()
          end, { "i", "c" }),
          -- NOTE: use <c-i> may cause bug
          ["<tab>"] = cmp.mapping {
            i = function(fallback)
              -- visible and have selected
              if cmp.visible() and cmp.get_selected_entry() then return cmp.confirm() end
              if luasnip.jumpable() then return luasnip.jump(1) end
              if luasnip.expandable() then return luasnip.expand() end
              return fallback()
            end,
            c = cmp.mapping.select_next_item(),
            s = function(fallback)
              if luasnip.jumpable() then return luasnip.jump(1) end
              return fallback()
            end,
          },
          -- ["<s-tab>"] = cmp.mapping(function() return luasnip.jump(-1) end, { "i", "c", "s" }),
          ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          -- HACK: fallback to history navagation
          ["<c-p>"] = cmp.mapping {
            i = function(fallback)
              if luasnip.jumpable() then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            s = function() luasnip.jump(-1) end,
            c = function(fallback) return fallback() end,
          },
          ["<c-n>"] = cmp.mapping {
            i = function(fallback)
              if luasnip.jumpable() then
                luasnip.jump(1)
              else
                fallback()
              end
            end,
            s = function() luasnip.jump(1) end,
            c = function(fallback) return fallback() end,
          },
          ["<cr>"] = cmp.mapping(cmp.mapping.confirm { select = false }, { "i", "c" }),
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        sources = {
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "path" },
          {
            name = "buffer",
            options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
          },
          { name = "emoji" },
        },
        formatting = formatting,
        -- performance = { max_view_entries = 8 },
      }

      cmp.setup.cmdline("/", {
        sources = {
          { name = "buffer" },
          { name = "path" },
        },
        formatting = formatting,
      })

      cmp.setup.cmdline("?", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline(":", {
        sources = {
          {
            name = "cmdline",
            option = { ignore_cmds = { "Man", "!" } },
          },
          { name = "path" },
          -- { name = "buffer" },
        },
        formatting = formatting,
      })
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cond = false,
    dependencies = { "nvim-cmp" },
    opts = {
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = { open = "<a-cr>" },
        layout = { position = "right", ratio = 0.4 },
      },
      suggestion = {
        auto_trigger = true,
        keymap = { accept = false, accept_word = "<a-w>", accept_line = "<a-l>" },
      },
      filetypes = {
        gitcommit = false,
        NeogitCommitMessage = false,
        DressingInput = false,
        TelescopePrompt = false,
        ["dap-repl"] = false,
      },
    },
  },
}
