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
      scope = { enabled = false },
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
    "SmiteshP/nvim-navic",
    cond = false,
    dependencies = "neovim/nvim-lspconfig",
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
