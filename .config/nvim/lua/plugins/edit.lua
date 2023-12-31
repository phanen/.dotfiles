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
          change = {
            target = "^(%*%*?)().-(%*%*?)()$",
          },
        },
        ["q"] = {
          add = { '"', '"' },
          find = '".-"',
          delete = '^("?)().-("?)()$',
          change = {
            target = '^("?)().-("?)()$',
          },
        },
        ["K"] = {
          add = { "```", "```" },
          find = "```.-```",
          delete = "^(```?)().-(```?)()$",
          change = {
            target = "^(```?)().-(```?)()$",
          },
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
          change = {
            target = "^($?)().-($?)()$",
          },
        },
        ["M"] = {
          add = { "$$", "$$" },
          find = "$$.-$$",
          delete = "^($$?)().-($$?)()$",
          change = {
            target = "^($$?)().-($$?)()$",
          },
        },
        ["["] = {
          add = { "[[ ", " ]]" },
          find = "[[ .- ]]",
          delete = "^([[ ?)().-( ]]?)()$",
          change = {
            target = "^([[ ?)().-( ]]?)()$",
          },
        },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc" },
      { "gc", mode = { "n", "x" } },
      { "<leader>O" },
      { "<leader>A" },
      { "<leader>oo" },
      -- https://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
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
    opts = { extra = { above = "<leader>O", below = "<leader>oo", eol = "<leader>A" } },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      autopairs.setup {
        close_triple_quotes = true,
        check_ts = true,
        fast_wrap = { map = "<c-s>" },
        ts_config = {
          lua = { "string" },
          dart = { "string" },
          javascript = { "template_string" },
        },
      }
      -- credit: https://github.com/JoosepAlviste
      autopairs.add_rules {
        -- Typing n when the| -> then|end
        Rule("then", "end", "lua"):end_wise(function(opts) return string.match(opts.line, "^%s*if") ~= nil end),
      }
    end,
  },
  {
    "mg979/vim-visual-multi",
    keys = { "<leader>n" },
    init = function() vim.g.VM_maps = { ["Find Under"] = "<leader>n" } end,
  },
  { "tpope/vim-eunuch", cmd = { "Move", "Rename", "Remove", "Delete", "Mkdir" } },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "gbprod/substitute.nvim",
    config = true,
    keys = {
      { "<leader>S", function() require("substitute").visual() end, mode = "x" },
      { "<leader>S", function() require("substitute").operator() end, mode = "n" },
      { "<leader>x", function() require("substitute.exchange").operator() end, mode = "n" },
      { "<leader>x", function() require("substitute.exchange").visual() end, mode = "x" },
    },
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    keys = { mode = { "n", "x", "o" }, "%" },
    init = function() vim.o.matchpairs = "(:),{:},[:],<:>" end,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      { "<leader>rr", function() require("ssr").open() end, mode = { "n", "x" }, desc = "structural replace" },
    },
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n" }, function() require("flash").jump() end, desc = "Flash" },
      { "_", mode = { "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "f", mode = { "n", "x", "o" } },
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
    keys = { { "gw", [[<cmd>lua require("conform").format { lsp_fallback = true }<cr>]] } },
  },
}
