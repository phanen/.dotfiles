return {
  { "phanen/readline.nvim", branch = "fix-dir-structure" },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "yss", "yS", "cs", "ds", { "s", mode = "x" }, { "`", "<Plug>(nvim-surround-visual)`", mode = "x" } },
    opts = {
      keymaps = { visual = "s" },
      surrounds = {
        ["j"] = {
          add = { "**", "**" },
          delete = "^(%*%*?)().-(%*%*?)()$",
          change = { target = "^(%*%*?)().-(%*%*?)()$" },
        },
        ["M"] = { add = { "$$", "$$" } },
        ["["] = { add = { "[[ ", " ]]" } },
      },
      aliases = {
        ["n"] = "}",
        ["q"] = '"',
        ["m"] = "$",
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
    "altermo/ultimate-autopair.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    cond = false,
    opts = { cmap = false },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = true,
  },
  {
    "mg979/vim-visual-multi",
    keys = {
      { "<leader>n", mode = { "n", "x" } },
      { "\\\\A", mode = { "n", "x" } },
      { "\\\\/", mode = { "n", "x" } },
    },
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<leader>n",
        ["Find Subword Under"] = "<leader>n",
      }
    end,
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
    },
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
        treesitter = { labels = "asdfghjklqwertyuiopzxcvbnm", highlight = { backdrop = true } },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        json = { "prettier" },
      },
    },
  },
  { "junegunn/vim-easy-align", keys = { { "ga", "<plug>(EasyAlign)", mode = { "n", "x" } } } },
  {
    "monaqa/dial.nvim",
    keys = {
      { "<c-a>", "<plug>(dial-increment)" },
      { "<c-x>", "<plug>(dial-decrement)" },
      { "g<c-a>", "g<plug>(dial-increment)" },
      { "g<c-x>", "g<plug>(dial-decrement)" },
      { "<c-a>", "<plug>(dial-increment)", mode = "x" },
      { "<c-x>", "<plug>(dial-decrement)", mode = "x" },
      { "g<c-a>", "g<plug>(dial-increment)", mode = "x" },
      { "g<c-x>", "g<plug>(dial-decrement)", mode = "x" },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
        },
      }
    end,
  },
}
