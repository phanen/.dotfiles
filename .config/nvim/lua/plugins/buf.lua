return {
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    cond = vim.g.started_by_firenvim == nil,
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "H", "<cmd>bufferlinemoveprev<cr>", { desc = "bufferline: move next" } },
      { "L", "<cmd>bufferlinemovenext<cr>", { desc = "bufferline: move prev" } },
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
