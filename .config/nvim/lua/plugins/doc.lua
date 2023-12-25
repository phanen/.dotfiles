return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = "MarkdownPreview",
    build = "cd app && npm install",
    ft = { "markdown" },
  },
  {
    "lukas-reineke/headlines.nvim",
    ft = "markdown",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        codeblock_highlight = false,
        dash_highlight = false,
        quote_highlight = false,
        fat_headlines = false,
      },
    },
  },
  { "dhruvasagar/vim-table-mode", cond = false, ft = { "markdown", "org" } },
  {
    "lervag/vimtex",
    -- :h :VimtexInverseSearch
    -- https://github.com/lervag/vimtex/pull/2560
    cond = false,
    lazy = false,
    ft = "tex",
    keys = {
      { "<leader>vc", "<cmd>VimtexCompile<cr>" },
      { "<leader>vl", "<cmd>VimtexClean<cr>" },
      { "<leader>vs", "<cmd>VimtexCompileSS<cr>" },
      { "<leader>vv", "<plug>(vimtex-view)" },
    },
    config = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.tex_flavor = "latex"
      vim.g.tex_conceal = "abdmgs"
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    cond = false,
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function() require("luasnip-latex-snippets").setup { use_treesitter = true } end,
    ft = { "tex", "markdown" },
  },
  {
    "3rd/image.nvim",
    enbaled = false,
    ft = "markdown",
    opts = {},
    init = function()
      -- Example for configuring Neovim to load user-installed installed Lua rocks:
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua;"
    end,
  },
}
