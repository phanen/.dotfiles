return {
  {
    "famiu/bufdelete.nvim",
    -- keys = "c-e",
    cmd = "Bdelete",
  },

  {
    "kwkarlwang/bufjump.nvim",
    cond = false,
    event = "VeryLazy",
    opts = {
      forward = "<leader><c-n>",
      backward = "<leader><c-p>",
      on_success = nil,
    },
  },
}
