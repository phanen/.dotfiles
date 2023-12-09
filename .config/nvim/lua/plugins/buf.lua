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
        mode = "buffers",
        numbers = "ordinal",
        offsets = { -- left for file explorer
          {
            filetype = "NvimTree",
            -- TODO: quoter
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
