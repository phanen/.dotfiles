return {
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "H", "<cmd>BufferLineMovePrev<cr>", { desc = "bl: move next" } },
      { "L", "<cmd>BufferLineMoveNext<cr>", { desc = "bl: move prev" } },
    },
    opts = {
      options = {
        offsets = {
          { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, text_align = "left" },
          { filetype = "undotree", text = "UNDOTREE", text_align = "left" },
        },
      },
    },
  },
  { "famiu/bufdelete.nvim", cmd = "Bdelete" },
  { "ojroques/nvim-bufdel", cmd = "BufDel", opts = { quit = false } },
  {
    "kwkarlwang/bufjump.nvim",
    keys = {
      { "<leader><c-o>", "<cmd>lua require('bufjump').backward()<cr>" },
      { "<leader><c-i>", "<cmd>lua require('bufjump').forward()<cr>" },
    },
  },
}
