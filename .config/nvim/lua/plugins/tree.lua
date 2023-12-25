local arg = vim.fn.argv()[1]
return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = arg == nil or not vim.fn.isdirectory(arg),
    cmd = { "NvimTreeFindFileToggle" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "stevearc/dressing.nvim",
        opts = { input = { mappings = { i = { ["<c-p>"] = "HistoryPrev", ["<c-n>"] = "HistoryNext" } } } },
      },
    },
    opts = {
      sync_root_with_cwd = true,
      actions = { change_dir = { enable = true, global = true } },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        local n = function(lhs, rhs, desc) return map("n", lhs, rhs, { desc = desc, buffer = bufnr }) end
        n("h", api.tree.change_root_to_parent, "up")
        n("l", api.node.open.edit, "edit")
        n("_", api.tree.change_root_to_node, "cd")
      end,
    },
  },
}
