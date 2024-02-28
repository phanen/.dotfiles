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
          find = "%*%*.-%*%*",
          delete = "^(%*%*?)().-(%*%*?)()$",
          change = { target = "^(%*%*?)().-(%*%*?)()$" },
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
    keys = { "<leader>n" },
    init = function() vim.g.VM_maps = { ["Find Under"] = "<leader>n" } end,
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
    -- TODO: stylua -> no align, lua_ls(EmmyLua) -> no trailing comma
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
      },
    },
  },
}
