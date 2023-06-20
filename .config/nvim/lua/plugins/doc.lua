return {
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    config = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0
      -- vim.g.mkdp_markdown_css = '/home/phanium/Downloads/typora-onedark-theme-1.10/theme/onedark_linux.css'
    end,
    ft = { "markdown" },
  },

  { -- TODO lazy
    "askfiy/nvim-picgo",
    ft = { "markdown" },
    config = function() require("nvim-picgo").setup() end,
  },

  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown" },
    config = function()
      require("mkdnflow").setup {
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
          MkdnCreateLink = false,         -- see MkdnEnter
          MkdnFollowLink = { "n", "gl" }, -- see MkdnEnter
          MkdnDestroyLink = { "n", "<M-CR>" },
          MkdnTagSpan = { "v", "<M-CR>" },
          MkdnMoveSource = false,
          MkdnYankAnchorLink = { "n", "ya" },
          MkdnYankFileAnchorLink = { "n", "yfa" },
          MkdnIncreaseHeading = { "n", "+" },
          MkdnDecreaseHeading = { "n", "-" },
          MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
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
      vim.g.vimtex_view_method = 'sioyek'
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

  -- org
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neorg",
    cond = false,
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},  -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = {      -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
              },
            },
          },
        },
      }
    end,
  },
}
