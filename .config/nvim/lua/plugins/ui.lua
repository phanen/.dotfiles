return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        component_separators = "|",
        section_separators = "",
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    opts = { scope = { enabled = false } },
  },
  { "HiPhish/rainbow-delimiters.nvim", event = "VeryLazy" },
  {
    "onsails/lspkind.nvim",
    lazy = "VeryLazy",
    opts = { preset = "codicons", mode = "symbol_text" },
    config = function(_, opts) require("lspkind").init(opts) end,
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    opts = {
      keymaps = {
        ["<C-n>"] = "actions.down_and_scroll",
        ["<C-p>"] = "actions.up_and_scroll",
        ["<C-j>"] = "",
        ["<C-k>"] = "",
      },
    },
  },
}
