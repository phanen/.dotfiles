return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { component_separators = "|", section_separators = "" } },
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
        ["<c-n>"] = "actions.down_and_scroll",
        ["<c-p>"] = "actions.up_and_scroll",
        -- FIXME: switch window
        ["<c-j>"] = "<cmd>wincmd j<cr>",
        ["<c-k>"] = "<cmd>wincmd k<cr>",
      },
    },
  },
}
