return {
  -- syntax highlight
  { "kovetskiy/sxhkd-vim", ft = "sxhkd" },

  { "Fymyte/rasi.vim", ft = "rasi" },

  { "kmonad/kmonad-vim", ft = "kbd" },

  -- nushell
  {
    "zioroboco/nu-ls.nvim",
    cond = false,
    ft = "nu",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "jose-elias-alvarez/null-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    config = function()
      require("null-ls").setup {
        sources = { require "nu-ls" },
      }
    end,
  },
  {
    "LhKipp/nvim-nu",
    cond = false,
    lazy = false,
  },
}
