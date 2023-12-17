return {
  { "EdenEast/nightfox.nvim",     lazy = false },
  { "NLKNguyen/papercolor-theme", lazy = false },
  { "igorgue/danger",             lazy = false },
  { "rebelot/kanagawa.nvim",      lazy = false },
  { "folke/tokyonight.nvim",      lazy = false },
  { "navarasu/onedark.nvim",      lazy = false },
  { "shaunsingh/nord.nvim",       lazy = false },
  { "AlexvZyl/nordic.nvim",       lazy = false },
  { "NTBBloodbath/doom-one.nvim", lazy = false },
  { "Mofiqul/dracula.nvim",       lazy = false },
  { "mswift42/vim-themes",        lazy = false },
  { "rose-pine/neovim",           lazy = false,              name = "rose-pine" },
  { "catppuccin/nvim",            lazy = false,              name = "catppuccin" },
  { "mcchrish/zenbones.nvim",     lazy = false,              dependencies = "rktjmp/lush.nvim" },

  -- tools
  { "xiyaowong/transparent.nvim", cmd = "TransparentToggle", config = true },
  {
    "4e554c4c/darkman.nvim",
    build = "go build -o bin/darkman.nvim",
    lazy = false,
    opts = {
      colorscheme = { dark = "dracula", light = "dayfox" },
    },
  },
}
