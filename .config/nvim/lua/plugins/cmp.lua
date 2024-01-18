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
      {
        "onsails/lspkind.nvim",
        opts = { preset = "codicons", mode = "symbol_text" },
        config = function(_, opts) require("lspkind").init(opts) end,
      },
    },
    config = function()
      local cmp = require "cmp"
      local ls = require "luasnip"
      local m = cmp.mapping
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
          ["<c-\\>"] = m(function() if cmp.visible() then cmp.abort() else cmp.complete() end end, { "i", "c" }),
          ["<tab>"] = m {
            i = function(fb)
              if cmp.visible() and cmp.get_selected_entry() then return cmp.confirm() end
              if ls.jumpable() then return ls.jump(1) end
              if ls.expandable() then return ls.expand() end
              return fb()
            end,
            c = m.select_next_item(),
            s = function(fb) if ls.jumpable() then ls.jump(1) else fb() end end,
          },
          ["<c-k>"] = m(m.select_prev_item(), { "i", "c" }),
          ["<c-j>"] = m(m.select_next_item(), { "i", "c" }),
          ["<c-p>"] = m {
            i = function(fb) if ls.jumpable() then ls.jump(-1) else fb() end end,
            s = function() ls.jump(-1) end,
          },
          ["<c-n>"] = m {
            i = function(fb) if ls.jumpable() then ls.jump(1) else fb() end end,
            s = function() ls.jump(1) end,
          },
          ["<c-o>"] = m(function(fb) if cmp.visible() then cmp.abort() end fb() end, { "i", "c" }),
          ["<cr>"] = m(m.confirm { select = false }, { "i", "c" }),
        },
        snippet = { expand = function(args) ls.lsp_expand(args.body) end },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer", options = { get_bufnrs = vim.api.nvim_list_bufs } },
          { name = "emoji" },
        },
        formatting = formatting,
        performance = {
          max_view_entries = 12,
          fetching_timeout = 0,
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
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = "./snippets" }
      require("luasnip").filetype_extend("all", { "_" })
    end,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<leader>.", "<cmd>Neogen<CR>" } },
    opts = { snippet_engine = "luasnip" },
  },
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    dependencies = { "nvim-cmp" },
    opts = {
      panel = { layout = { position = "right", ratio = 0.4 } },
      suggestion = { auto_trigger = true, keymap = { accpet = "<a-s>", accpet_line = "<a-l>", accpet_word = "<a-f>" } },
    },
  },
  {
    "jackMort/ChatGPT.nvim",
    cond = vim.env.OPENAI_API_KEY ~= nil,
    cmd = "ChatGPT",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = true,
  },
}
