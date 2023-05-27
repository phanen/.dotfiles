return {
  'folke/lazy.nvim',

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 100
      -- local presets = require("which-key.plugins.presets")
      -- presets.operators["y"] = nil
      require(('which-key')).setup({
        triggers_blacklist = {
          c = { "w" },
          -- n = { "v", "c", "d" },
        },
        disable = {
          buftypes = { 'help' },
          filetypes = { 'man' },
        },
      })
    end,
  },

  { 'tpope/vim-eunuch', cmd = { 'Move', 'Rename', 'Remove', 'Delete', 'Mkdir' } },
  { 'tpope/vim-sleuth', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },

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
