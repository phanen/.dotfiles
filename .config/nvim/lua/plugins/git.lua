return {
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<localleader>gs", function() require("neogit").open() end,               desc = "open status buffer" },
      { "<localleader>gc", function() require("neogit").open { "commit" } end,    desc = "open commit buffer" },
      { "<localleader>gl", function() require("neogit").popups.pull.create() end, desc = "open pull popup" },
      { "<localleader>gp", function() require("neogit").popups.push.create() end, desc = "open push popup" },
    },
    opts = {
      disable_signs = false,
      disable_hint = true,
      disable_commit_confirmation = true,
      disable_builtin_notifications = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" }, -- "󰁙", "󰁊"
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
      integrations = {
        diffview = true,
      },
    },
  },
}
