vim.filetype.add {
  extension = {
    lock = "yaml",
    nu = "nu",
  },
  filename = {
    ["NEOGIT_COMMIT_EDITMSG"] = "NeogitCommitMessage",
    [".psqlrc"] = "conf", -- TODO: find a better filetype
    ["launch.json"] = "jsonc",
    Podfile = "ruby",
    Brewfile = "ruby",
  },
  pattern = {
    [".*%.conf"] = "conf",
    [".*%.theme"] = "conf",
    [".*%.gradle"] = "groovy",
    [".*%.env%..*"] = "env",
    [".*"] = {
      priority = -math.huge,
      function(path, bufnr)
        local content = vim.filetype.getlines(bufnr, 1)
        if vim.filetype.matchregex(content, [[^#!/usr/bin/env nu]]) then return "nu" end
      end,
    },
  },
}
