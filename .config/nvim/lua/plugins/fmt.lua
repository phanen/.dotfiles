return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {
    formatters_by_ft = {
      -- TODO: stylua cannot align
      -- but lua_ls(EmmyLuaCodeStyle) cannot trailing cooma
      lua = { "stylua" },
      python = { "isort", "black" },
      go = { "gofumpt", "goimports" },
      html = { "prettier" },
      css = { "prettier" },
      less = { "prettier" },
      scss = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
    },
  },
  keys = {
    {
      "gw",
      function() require("conform").format { lsp_fallback = true } end,
      desc = "format",
      mode = { "n", "v" },
    },
  },
}
