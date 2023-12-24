return {
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    cond = vim.g.started_by_firenvim == nil,
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "[b", "<Cmd>BufferLineMovePrev<CR>", { desc = "bufferline: move next" } },
      { "]b", "<Cmd>BufferLineMoveNext<CR>", { desc = "bufferline: move prev" } },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "time wait for no man",
            highlight = "Directory",
            text_align = "left",
          },
          {
            text = "UNDOTREE",
            filetype = "undotree",
            highlight = "PanelHeading",
            separator = true,
          },
        },
      },
    },
  },
  {
    "famiu/bufdelete.nvim",
    cmd = "Bdelete",
  },
  {
    "ojroques/nvim-bufdel",
    cond = false,
    cmd = "BufDel",
    opts = { quit = false, }
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
