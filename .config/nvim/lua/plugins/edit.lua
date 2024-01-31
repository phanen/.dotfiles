return {
  { "phanen/readline.nvim", branch = "fix-dir-structure" },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "yss", "yS", "cs", "ds", { "s", mode = "x" }, { "`", "<Plug>(nvim-surround-visual)`", mode = "x" } },
    opts = {
      move_cursor = true,
      keymaps = { visual = "s" },
      surrounds = {
        ["j"] = {
          add = { "**", "**" },
          find = "%*%*.-%*%*",
          delete = "^(%*%*?)().-(%*%*?)()$",
          change = { target = "^(%*%*?)().-(%*%*?)()$" },
        },
        ["K"] = {
          add = { "```", "```" },
          find = "```.-```",
          delete = "^(```?)().-(```?)()$",
          change = { target = "^(```?)().-(```?)()$" },
        },
        ["n"] = {
          add = { "{", "}" },
          find = "{.-}",
          delete = "^({?)().-(}?)()$",
          change = {},
          target = "^({?)().-(}?)()$",
        },
        ["m"] = {
          add = { "$", "$" },
          find = "$.-$",
          delete = "^($?)().-($?)()$",
          change = { target = "^($?)().-($?)()$" },
        },
        ["M"] = {
          add = { "$$", "$$" },
          find = "$$.-$$",
          delete = "^($$?)().-($$?)()$",
          change = { target = "^($$?)().-($$?)()$" },
        },
        ["["] = {
          add = { "[[ ", " ]]" },
          find = "[[ .- ]]",
          delete = "^([[ ?)().-( ]]?)()$",
          change = { target = "^([[ ?)().-( ]]?)()$" },
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc" },
      { "gc", mode = { "n", "x" } },
      { "<leader>O", "gcO", remap = true },
      { "<leader>A", "gcA", remap = true },
      { "<c-_>", "<c-/>", remap = true, mode = { "n", "x", "i" } },
      {
        "<c-/>",
        function()
          return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
            or "<Plug>(comment_toggle_linewise_count)"
        end,
        expr = true,
      },
      { "<c-/>", "<cmd>norm <Plug>(comment_toggle_linewise_current)<cr>", mode = "i" },
      { "<c-/>", "<Plug>(comment_toggle_linewise_visual)", mode = "v" },
    },
    config = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = true,
  },
  {
    "mg979/vim-visual-multi",
    keys = { "<leader>n" },
    init = function() vim.g.VM_maps = { ["Find Under"] = "<leader>n" } end,
  },
  {
    "gbprod/substitute.nvim",
    keys = {
      { "<localleader>s", function() require("substitute.exchange").operator() end, mode = "n" },
      { "<localleader>s", function() require("substitute.exchange").visual() end, mode = "x" },
    },
    config = true,
  },
  {
    "cshuaimin/ssr.nvim",
    keys = { { "<localleader>r", function() require("ssr").open() end, mode = { "n", "x" } } },
  },
  {
    "andymass/vim-matchup", -- TODO: slow when use flash.nvim
    event = "BufReadPost",
    keys = { mode = { "n", "x", "o" }, "%" },
    init = function() vim.o.matchpairs = "(:),{:},[:],<:>" end,
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
      { "_", mode = { "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "f", mode = { "n", "x", "o" } },
      { "F", mode = { "n", "x", "o" } },
    },
    opts = {
      modes = {
        search = { enabled = false },
        treesitter = { labels = "asdfghjklqwertyuiopzxcvbnm", highlight = { backdrop = true } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    keys = { { "gw", [[<cmd>lua require("conform").format { lsp_fallback = true }<cr>]] } },
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
  },
}
