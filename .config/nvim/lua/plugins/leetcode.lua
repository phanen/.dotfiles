local leet_arg = "leetcode.nvim"

return {
  "kawre/leetcode.nvim",
  lazy = leet_arg ~= vim.fn.argv()[1],
  cond = false,
  build = ":TSUpdate html",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    arg = leet_arg,
  },
}
