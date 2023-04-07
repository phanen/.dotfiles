return {

  'folke/lazy.nvim',
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = true,
  },

  'tpope/vim-sleuth', -- detect tabstop and shiftwidth automatically

  -- rust
  'simrat39/rust-tools.nvim',

  -- debug
  -- {
  --   "jayp0521/mason-nvim-dap.nvim",
  --   config = function()
  --     require("mason-nvim-dap").setup({
  --       automatic_installation = true,
  --       ensure_installed = { "codelldb" },
  --     })
  --   end,
  -- },
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',

  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig"
  },

  'theHamsta/nvim-dap-virtual-text',

  -- game
  'alec-gibson/nvim-tetris',
}
