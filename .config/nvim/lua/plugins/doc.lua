return {
  {
    "iamcco/markdown-preview.nvim",
    keys = { { "<leader>wm", "<cmd>MarkdownPreview<cr>" } },
    cmd = "MarkdownPreview",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0
      -- vim.g.mkdp_markdown_css = '/home/phanium/Downloads/typora-onedark-theme-1.10/theme/onedark_linux.css'
    end,
    ft = { "markdown" },
  },

  {
    "toppair/peek.nvim",
    cond = false,
    build = "deno task --quiet build:fast",
    keys = {
      {
        "<leader>wm",
        function()
          local peek = require "peek"
          if peek.is_open() then
            peek.close()
          else
            peek.open()
          end
        end,
        desc = "Peek (Markdown Preview)",
      },
    },
    opts = {},
  },

  { -- TODO: since treesitter has been a performance killer...
    "lukas-reineke/headlines.nvim",
    -- cond = false,
    ft = "markdown",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        headline_highlights = { "Headline" },
        codeblock_highlight = false,
        dash_highlight = false,
        quote_highlight = false,
        fat_headlines = false,
      },
    },
  },

  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    config = function()
      -- FIXME: cannot use opt, collision with lazyload
      require("mkdnflow").setup {
        modules = {
          bib = false,
          buffers = false,
          conceal = false,
          cursor = true,
          folds = true,
          links = true,
          lists = true,
          maps = true,
          paths = true,
          tables = true,
          yaml = false,
        },
        mappings = {
          MkdnNextHeading = { "n", "]]" },
          MkdnPrevHeading = { "n", "[[" },
          MkdnNewListItemBelowInsert = { "n", "o" },
          MkdnNewListItemAboveInsert = { "n", "O" },
          MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" }, -- see MkdnEnter
          MkdnEnter = false,
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = false,
          MkdnPrevLink = false,
          MkdnGoBack = { "n", "<BS>" },
          MkdnGoForward = { "n", "<Del>" },
          MkdnCreateLink = false, -- see MkdnEnter
          MkdnFollowLink = { "n", "gl" }, -- see MkdnEnter
          MkdnDestroyLink = { "n", "<M-CR>" },
          MkdnTagSpan = { "v", "<M-CR>" },
          MkdnMoveSource = false,
          MkdnYankAnchorLink = { "n", "ya" },
          MkdnYankFileAnchorLink = { "n", "yfa" },
          MkdnIncreaseHeading = { "n", "+" },
          MkdnDecreaseHeading = { "n", "-" },
          MkdnToggleToDo = false,
          MkdnNewListItem = false,
          MkdnExtendList = false,
          MkdnUpdateNumbering = { "n", "<leader>nn" },
          MkdnTableNextCell = { "i", "<Tab>" },
          MkdnTablePrevCell = { "i", "<S-Tab>" },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { "i", "<M-CR>" },
          MkdnTableNewRowBelow = { "n", "<leader>ir" },
          MkdnTableNewRowAbove = { "n", "<leader>iR" },
          MkdnTableNewColAfter = { "n", "<leader>ic" },
          MkdnTableNewColBefore = { "n", "<leader>iC" },
          MkdnFoldSection = false,
          MkdnUnfoldSection = false,
        },
      }
    end,
  },

  {
    "phanen/toggle-checkbox.nvim",
    ft = "markdown",
    keys = { { "<c-space>", "<cmd>lua require('toggle-checkbox').toggle()<cr>" } },
  },

  -- kitty only
  {
    "edluffy/hologram.nvim",
    cond = false,
    ft = { "markdown" },
    event = "VeryLazy",
    config = function()
      require("hologram").setup {
        auto_display = true, -- WIP automatic markdown image display, may be prone to breaking
      }
    end,
  },

  -- latex
  {
    "f3fora/nvim-texlabconfig",
    cond = false,
    config = function() require("texlabconfig").setup() end,
    ft = { "tex", "bib" }, -- for lazy loading
    build = "go build",
  },

  {
    "lervag/vimtex",
    -- :h :VimtexInverseSearch
    -- https://github.com/lervag/vimtex/pull/2560
    lazy = false,
    ft = "tex",
    keys = {
      { "<leader>vc", "<cmd>VimtexCompile<cr>" },
      { "<leader>vl", "<cmd>VimtexClean<cr>" },
      { "<leader>vs", "<cmd>VimtexCompileSS<cr>" },
      { "<leader>vv", "<plug>(vimtex-view)" },
    },
    config = function()
      -- vim.cmd[[
      --   filetype plugin indent on
      --   syntax enable
      -- ]]
      -- vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_view_method = "sioyek"
      -- vim.g.vimtex_view_general_viewer = 'okular'
      -- vim.g.vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
      -- vim.g.vimtex_compiler_method = 'latexrun'

      -- vim.opt.concealcursor = "nc"
      -- vim.opt.conceallevel = 2
      vim.g.tex_flavor = "latex"
      vim.g.tex_conceal = "abdmgs"
      vim.g.vimtex_quickfix_mode = 0
      -- vim.g.vimtex_compiler_latexmk_engines = { ["_"] = "-lualatex" }
      -- vim.g.vimtex_view_enabled = 0
      -- vim.g.vimtex_view_automatic = 0
      -- vim.g.vimtex_indent_on_ampersands = 0
      -- vim.g.syntax_conceal_disable = 1
    end,
  },

  -- math mode snippets
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    cond = false,
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function() require("luasnip-latex-snippets").setup { use_treesitter = true } end,
    ft = { "tex", "markdown" },
  },
}
