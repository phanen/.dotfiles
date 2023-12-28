return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
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

      local formatting = {
        fields = { "kind", "abbr", "menu" },
        format = require("lspkind").cmp_format {
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
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        -- stylua: ignore
        mapping = {
          ["<c-\\>"] = cmp.mapping(function()
            if cmp.visible() then return cmp.abort() end
            return cmp.complete()
          end),
          -- TODO: lsp performance
          ["<tab>"] = cmp.mapping {
            i = function(fb)
              if cmp.visible() and cmp.get_selected_entry() then return cmp.confirm() end
              if luasnip.jumpable() then return luasnip.jump(1) end
              if luasnip.expandable() then return luasnip.expand() end
              return fb()
            end,
            c = cmp.mapping.select_next_item(),
            s = function(fb) if luasnip.jumpable() then luasnip.jump(1) else fb() end end,
          },
          ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<c-p>"] = cmp.mapping {
            i = function(fb) if luasnip.jumpable() then luasnip.jump(-1) else fb() end end,
            s = function() luasnip.jump(-1) end,
            c = function(fb) return fb() end,
          },
          ["<c-n>"] = cmp.mapping {
            i = function(fb) if luasnip.jumpable() then luasnip.jump(1) else fb() end end,
            s = function() luasnip.jump(1) end,
            c = function(fb) return fb() end,
          },
          ["<c-o>"] = cmp.mapping(function(fb) if cmp.visible() then cmp.abort() end fb() end),
          ["<cr>"] = cmp.mapping(cmp.mapping.confirm { select = false }, { "i", "c" }),
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer", options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end } },
          { name = "emoji" },
        },
        formatting = formatting,
        performance = {
          max_view_entries = 12,
          fetching_timeout = 1,
        },
      }

      cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })
      cmp.setup.cmdline("?", { sources = { { name = "buffer" } } })
      cmp.setup.cmdline(":", {
        sources = {
          { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
          { name = "path" },
          { name = "buffer" },
        },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require "luasnip"
      local types = require "luasnip.util.types"
      local extras = require "luasnip.extras"
      local fmt = require("luasnip.extras.fmt").fmt

      ls.config.set_config {
        -- history = false,
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Operator" } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Type" } },
            },
          },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lamda,
          snippet = ls.snippet,
        },
      }

      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = "./snippets" }
      ls.filetype_extend("all", { "_" })
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<leader>.", "<cmd>Neogen<CR>", desc = "generate annotation" } },
    opts = { snippet_engine = "luasnip" },
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
  {
    "jackMort/ChatGPT.nvim",
    cond = vim.env.OPENAI_API_KEY ~= nil,
    cmd = "ChatGPT",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    opts = {},
  },
}
