return {
  {
    "tpope/vim-fugitive",
    cmd = { "G" },
    keys = {
      { "<leader>ga", "<cmd>G<cr>" },
      { "<leader>gb", "<cmd>G blame<cr>" },
      { "<leader>gc", "<cmd>G commit<cr>" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>" },
      { "<leader>gr", "<cmd>Gr<cr>" },
      { "<leader>gs", "<cmd>Gwrite<cr>" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = { { "<localleader>gs", "<cmd>Gitsigns<cr>" } },
    dependencies = "stevearc/dressing.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(_)
        n("gj", "<cmd>Gitsigns next_hunk<cr>")
        n("gk", "<cmd>Gitsigns prev_hunk<cr>")
        n("<leader>hs", "<cmd>Gitsigns stage_hunk<cr>")
        n("<leader>hu", "<cmd>Gitsigns undo_stage_hunk<cr>")
        n("<leader>hr", "<cmd>Gitsigns reset_hunk<cr>")
        n("<leader>hi", "<cmd>Gitsigns preview_hunk<cr>")
        n("<leader>gu", "<cmd>Gitsigns reset_buffer_index<cr>")
        n("<leader>gu", "<cmd>Gitsigns reset_buffer_index<cr>")
        n("<leader>gr", "<cmd>Gitsigns reset_buffer<cr>")
        n("<leader>hd", "<cmd>Gitsigns toggle_deleted<bar>Gitsigns toggle_word_diff<cr>")
      end,
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<localleader>gn", "<cmd>Neogit<cr>" } },
    opts = {
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" },
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    keys = {
      { "<localleader>gl", "<cmd>GitLink!<cr>", mode = { "n", "x" } },
      { "<localleader>gb", "<cmd>GitLink! blame<cr>", mode = { "n", "x" } },
    },
    cmd = "GitLink",
    opts = {
      router = {
        browse = {
          ["^ssh%.github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}?plain=1" -- '?plain=1'
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
        blame = {
          ["^ssh%.github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blame/"
            .. "{_A.REV}/"
            .. "{_A.FILE}?plain=1" -- '?plain=1'
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
      },
    },
  },
}
