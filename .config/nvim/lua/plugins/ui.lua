return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    opts = {
      scope = { enabled = false }, -- disable ts
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
  },
  {
    "onsails/lspkind.nvim",
    lazy = "VeryLazy",
    opts = { preset = "codicons", mode = "symbol_text" },
    config = function(_, opts) require("lspkind").init(opts) end,
  },
  {
    "folke/trouble.nvim",
    cond = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = false,
    opts = {
      cmdline = {
        enable = true,
        format = {
          cmdline = false,
          search_down = false,
          search_up = false,
          filter = false,
          lua = false,
          help = false,
        },
      },
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true,              -- enables the Noice messages UI
        view = "notify",             -- default view for messages
        view_error = "notify",       -- view for errors
        view_warn = "notify",        -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "SmiteshP/nvim-navic",
    cond = false,
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "Bekaboo/dropbar.nvim",
    cond = false,
    event = "VeryLazy",
    keys = { { "<leader>wp", function() require("dropbar.api").pick() end, desc = "winbar: pick" } },
  },
  {
    "SmiteshP/nvim-navbuddy",
    lazy = false,
    cond = false,
    event = "VeryLazy",
    -- keys = { "<leader>wj" },
    -- cmd = { "Navbuddy" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = { auto_attach = true },
      -- icons = require('lspkind').symbol_map,
    },
  },
  {
    "stevearc/aerial.nvim",
    config = true,
    key = { "<leader>wo" },
    cmd = { "AerialToggle" },
    -- event = "VeryLazy",
    opts = {
      keymaps = {
        ["<C-n>"] = "actions.down_and_scroll",
        ["<C-p>"] = "actions.up_and_scroll",
        ["<C-j>"] = "",
        ["<C-k>"] = "",
        ["g?"] = "actions.show_help",
      },
    },
  },
}
