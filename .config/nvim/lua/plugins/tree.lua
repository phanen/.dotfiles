local arg = vim.fn.argv()[1]
return {
  {
    "nvim-tree/nvim-tree.lua",
    tag = "nightly",
    lazy = arg == nil or not vim.fn.isdirectory(arg),
    cmd = { "NvimTreeFindFileToggle" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sync_root_with_cwd = true,
      view = {
        -- width = function() return 0.1 * vim.fn.winwidth(0) end,
        mappings = {
          custom_only = false,
          list = {
            { key = "l", action = "edit" },
            { key = "L", action = "cd" },
            { key = "H", action = "dir_up" },
            { key = "D", action = "toggle_dotfiles" },
          },
        },
      },
    },
  },
}
