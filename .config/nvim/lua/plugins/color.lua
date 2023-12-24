return {
  { "EdenEast/nightfox.nvim" },
  { "NLKNguyen/papercolor-theme" },
  { "igorgue/danger" },
  { "rebelot/kanagawa.nvim" },
  { "folke/tokyonight.nvim" },
  { "navarasu/onedark.nvim" },
  { "shaunsingh/nord.nvim" },
  { "AlexvZyl/nordic.nvim" },
  { "NTBBloodbath/doom-one.nvim" },
  { "mswift42/vim-themes" },
  { "marko-cerovac/material.nvim" },
  { "phanen/dracula.nvim", branch = "fix" },
  { "dracula/vim", name = "dracula.vim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim" },
  {
    "rockyzhang24/arctic.nvim",
    branch = "v2",
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      -- vim.cmd([[colorscheme arctic]])
    end,
  },
  -- tools
  { "xiyaowong/transparent.nvim", cmd = "TransparentToggle", config = true },
  {
    "4e554c4c/darkman.nvim",
    lazy = false,
    build = "go build -o bin/darkman.nvim",
    opts = { colorscheme = { dark = "tokyonight", light = "dayfox" } },
  },
  { "norcalli/nvim-colorizer.lua" },
  -- syntax highlight
  { "kovetskiy/sxhkd-vim", ft = "sxhkd" },
  { "kmonad/kmonad-vim", ft = "kbd" },
}
