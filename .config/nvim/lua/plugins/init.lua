return {
  'folke/lazy.nvim',

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      local presets = require("which-key.plugins.presets")
      presets.operators["v"] = nil
      presets.operators["c"] = nil
      presets.operators["y"] = nil
      vim.o.timeout = true
      vim.o.timeoutlen = 100
      require('which-key').setup({
        triggers_blacklist = {
          -- list of mode / prefixes that should never be hooked by WhichKey
          -- this is mostly relevant for keymaps that start with a native binding
          i = { "j", "k" },
          v = { "j", "k" },
          c = { "w",},
        },
        disable = {
          buftypes = {'help'},
          filetypes = {'man'},
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
