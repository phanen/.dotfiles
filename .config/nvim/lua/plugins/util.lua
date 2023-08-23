local function getVisualText()
  local reg_bak = vim.fn.getreg "v"
  vim.fn.setreg("v", {})
  vim.cmd [[noau normal! "vy\<esc\>]]
  local sel_text = vim.fn.getreg "v"
  vim.fn.setreg("v", reg_bak)
  return #sel_text == 0 and "" or string.gsub(sel_text, "\n", "")
end

return {

  -- diff arbitrary blocks of text with each other
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word", cmd = { "WordCount", "WordCountLine" } },

  {
    "lalitmee/browse.nvim",
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
    },

    opts = {
      bookmarks = {
        ["github_code_search"] = "https://github.com/search?q=%s&type=code",
        ["github_repo_search"] = "https://github.com/search?q=%s&type=repositories",
      },
    },
  },
}
