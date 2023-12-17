return {
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<c-\>]] },
    opts = {
      open_mapping = [[<c-\>]],
      start_in_insert = true,
      direction = "float",
      shell = "/bin/fish",
      highlights = {
        -- NormalFloat = { link = "", cterm = "bold" },
        -- NormalFloat = { guibg = "#1a1b26", guifg = "#a9b1d6" },
        -- NormalFloat = { guibg = "#192330", guifg = "#81b29a" },
      },
    },
  },
}
