local leet_arg = "leetcode.nvim"
return {
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    config = function()
      require("octo").setup {}
      -- BUG: take no effect...
      -- vim.api.nvim_set_hl(0, "OctoEditable", { bg = highlight.get("NormalFloat", "bg") })
      vim.api.nvim_set_hl(0, "OctoEditable", { bg = "#e4dcd4" })
      map("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
      map("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },

  {
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
  },
}
