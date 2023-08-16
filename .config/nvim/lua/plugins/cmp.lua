return {
  { "f3fora/cmp-spell", event = "InsertEnter", ft = { "gitcommit", "markdown", } },
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
        fields = { 'kind', 'abbr', 'menu' },
        format = lspkind.cmp_format {
          mode = 'symbol',
          symbol_map = {
            Copilot = " ",
            Class = "󰆧 ",
            Color = "󰏘 ",
            Constant = "󰏿 ",
            Constructor = " ",
            Enum = " ",
            EnumMember = " ",
            Event = "",
            Field = " ",
            File = "󰈙 ",
            Folder = "󰉋 ",
            Function = "󰊕 ",
            Interface = " ",
            Keyword = "󰌋 ",
            Method = "󰊕 ",
            Module = " ",
            Operator = "󰆕 ",
            Property = " ",
            Reference = "󰈇 ",
            Snippet = " ",
            Struct = "󰆼 ",
            Text = "󰉿 ",
            TypeParameter = "󰉿 ",
            Unit = "󰑭",
            Value = "󰎠 ",
            Variable = "󰀫 ",
          },
          menu = {
            buffer = "[buf]",
            nvim_lsp = "[lsp]",
            path = "[path]",
            luasnip = "[snip]",
            emoji = "[emoji]",
            nvim_lua = '[lua]',
          },
        },
      }

      cmp.setup {
        enabled = function() return vim.api.nvim_buf_get_option(0, "modifiable") and vim.bo.buftype ~= "prompt" end,
        mapping = {
          ["<c-l>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
          ["<c-i>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<c-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<c-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", }),
          ["<c-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<c-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", }),
          ["<cr>"] = cmp.mapping(cmp.mapping.confirm { select = false }, { "i", "c" }),
        },
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end, },
        sources = {
          { name = "nvim_lsp", },
          { name = "nvim_lsp_signature_help", },
          { name = "luasnip", },
          -- { name = "nvim_lua" },
          { name = "path", },
          {
            name = 'buffer',
            options = { get_bufnrs = function() return vim.api.nvim_list_bufs() end },
          },
          { name = "emoji", },
        },

        formatting = formatting,
        performance = { max_view_entries = 8, },
      }

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
          { name = 'path' },
        },
        formatting = formatting,
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'path' },
          {
            name = 'cmdline',
            option = { ignore_cmds = { 'Man', '!' } },
          }
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
