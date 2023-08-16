vim.filetype.add {
  extension = {
    lock = "yaml",
    nu = "nu",
  },
  filename = {
    ["launch.json"] = "jsonc",
    Podfile = "ruby",
    Brewfile = "ruby",
  },
  pattern = {
    [".*%.conf"] = "conf",
    [".*%.theme"] = "conf",
    [".*%.gradle"] = "groovy",
    [".*%.env%..*"] = "env",
  },
}
