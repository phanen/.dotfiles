return {
  {
    "nanotee/zoxide.vim",
    cmd = {
      "Z",
      "Lz",
      "Tz",
      "Zi",
      "Lzi",
      "Tzi",
    },
    config = function()
      require("zoxide").setup {}
    end
  },
  {
    "rgroli/other.nvim",
    cond = false,
  }
}
