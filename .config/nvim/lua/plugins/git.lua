return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>" },
      { "<leader>gD", "<cmd>G diff<cr>" },
      { "<leader>gs", "<cmd>G<cr>" },
      { "<leader>ga", "<cmd>Gwrite<cr>" },
      { "<leader>gc", "<cmd>G commit<cr>" },
      { "<leader>gb", "<cmd>G blame<cr>" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = { { "<localleader>gs", "<cmd>Gitsigns<cr>" } },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local m = function(mode, l, r, desc)
          if desc then desc = "gs: " .. desc end
          map(mode, l, r, { buffer = bufnr, desc = desc })
        end
        m("n", "]h", gs.next_hunk, "next_hunk")
        m("n", "[h", gs.prev_hunk, "prev_hunk")
        m("n", "<leader>hs", gs.stage_hunk, "stage_hunk")
        m("n", "<leader>hr", gs.reset_hunk, "reset_hunk")
        m("n", "<leader>hu", gs.undo_stage_hunk, "undo_stage_hunk")
        m("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "stage_hunk")
        m("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "reset_hunk")
        m("n", "<leader>hS", gs.stage_buffer, "stage_buffer")
        m("n", "<leader>hR", gs.reset_buffer, "reset_buffer")
        m("n", "<leader>hb", function() gs.blame_line { full = true } end, "blame_line")
        m("n", "<leader>hp", gs.preview_hunk, "preview_hunk")
        m("n", "<leader>hd", gs.diffthis, "diffthis")
        m("n", "<leader>hD", function() gs.diffthis "~" end, "diffthis")
        m({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", "select_hunk")
      end,
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<localleader>gn", function() require("neogit").open() end, desc = "neogit" } },
    opts = {
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" },
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
      integrations = { diffview = true, },
    },
  },
}
