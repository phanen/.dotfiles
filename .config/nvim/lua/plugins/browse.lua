return {
  {
    "phanen/browse.nvim",
    cond = false,
    branch = "visual-mode",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        mode = { "n", "x" },
        "<leader>S",
        function() require("browse").open_bookmarks() end,
      },
      {
        mode = { "n", "x" },
        "<leader>B",
        function() require("browse").browse() end,
      },
      {
        mode = { "n", "x" },
        "<leader>I",
        function() require("browse").input_search() end,
      },
    },
    opts = {
      bookmarks = {
        ["github_code"] = "https://github.com/search?q=%s&type=code",
        ["github_repo"] = "https://github.com/search?q=%s&type=repositories",
      },
    },
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gl", "gx", mode = { "x", "n" }, remap = true } },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
