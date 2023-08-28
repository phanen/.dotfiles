return {
  {
    "famiu/bufdelete.nvim",
    -- keys = "c-e",
    cmd = "Bdelete",
  },

  {
    "kwkarlwang/bufjump.nvim",
    event = "VeryLazy",
    opts = {
      forward = "<leader><c-i>",
      backward = "<leader><c-o>",
      on_success = nil,
    },
  },
}
