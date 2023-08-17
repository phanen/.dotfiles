return {
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<c-\>]] },
    opts = {
      open_mapping = [[<c-\>]],
      start_in_insert = true,
      direction = "float",

      highlights = {
        FloatBorder = { link = "FloatBorder" },
        NormalFloat = { link = "NormalFloat" },
      },
    },
  },
}
