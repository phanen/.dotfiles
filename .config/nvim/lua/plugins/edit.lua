return {
  {
    "phanen/readline.nvim",
    branch = "fix-dir-structure",
    -- stylua: ignore
    keys = {
      { "<c-f>",  "<right>",                                               mode = "!" },
      { "<c-b>",  "<left>",                                                mode = "!" },
      { "<c-p>",  "<up>",                                                  mode = "!" },
      { "<c-n>",  "<down>",                                                mode = "!" },
      { "<m-f>",  function() require("readline").forward_word() end,       mode = "!" },
      { "<c-j>",  function() require("readline").forward_word() end,       mode = "!" },
      { "<m-b>",  function() require("readline").backward_word() end,      mode = "!" },
      { "<c-o>",  function() require("readline").backward_word() end,      mode = "!" },
      { "<c-a>",  function() require("readline").beginning_of_line() end,  mode = "!" },
      { "<c-e>",  function() require("readline").end_of_line() end,        mode = "!" },
      -- { '<c-w>', function() require('readline').unix_word_rubout() end, mode = '!' },
      { "<m-bs>", function() require("readline").backward_kill_word() end, mode = "!" },
      { "<m-d>",  function() require("readline").kill_word() end,          mode = "!" },
      { "<c-l>",  function() require("readline").kill_word() end,          mode = "!" },
      { "<c-k>",  function() require("readline").kill_line() end,          mode = "!" },
      { "<c-u>",  function() require("readline").backward_kill_line() end, mode = "!" },
    },
  },

  {
    "kylechui/nvim-surround",
    -- lazy = false,
    keys = {
      { "s",            mode = "x" },
      -- "<C-g>s",
      -- "<C-g>S",
      "ys",
      "yss",
      "yS",
      "cs",
      "ds",
      { mode = { "x" }, "`",       "<Plug>(nvim-surround-visual)`" },
    },
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
        ["k"] = {
          add = { "`", "`" },
          find = "`.-`",
          delete = "^(`?)().-(`?)()$",
          change = {
            target = "^(`?)().-(`?)()$",
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
      { "gc",        mode = { "n", "v" } },
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
        mode = { "n" },
      },
      -- FIXME: position of cursor should not move
      { "<c-/>", "<cmd>norm <Plug>(comment_toggle_linewise_current)<cr>", mode = { "i" } },
      { "<c-/>", "<Plug>(comment_toggle_linewise_visual)",                mode = { "v" } },
      {
        "<c-_>",
        function()
          return vim.v.count == 0 and "<Plug>(comment_toggle_linewise_current)"
              or "<Plug>(comment_toggle_linewise_count)"
        end,
        expr = true,
        mode = { "n" },
      },
      -- FIXME: position of cursor should not move
      { "<c-_>", "<cmd>norm <Plug>(comment_toggle_linewise_current)<cr>", mode = { "i" } },
      { "<c-_>", "<Plug>(comment_toggle_linewise_visual)",                mode = { "v" } },
    },
    opts = {
      padding = true,
      sticky = true,
      ignore = nil,
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gc", block = "gb" },
      extra = { above = "<leader>O", below = "<leader>oo", eol = "<leader>A" },
      mappings = { basic = true, extra = true },
      pre_hook = nil,
      post_hook = nil,
    },
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
    "smjonas/inc-rename.nvim",
    keys = {
      {
        "<leader>rn",
        function() return vim.fmt(":IncRename %s", vim.fn.expand "<cword>") end,
        expr = true,
        silent = false,
        desc = "lsp: incremental rename",
      },
    },
  },

  {
    "mg979/vim-visual-multi",
    keys = "<c-n>",
  },

  { "tpope/vim-eunuch", cmd = { "Move", "Rename", "Remove", "Delete", "Mkdir" } },
  { "tpope/vim-sleuth", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    "vim-scripts/DrawIt",
    cond = false,
  },

  {
    "gbprod/substitute.nvim",
    config = true,
    keys = {
      -- { "<leader>S",  function() require("substitute").visual() end,            mode = "x" },
      -- { "<leader>S",  function() require("substitute").operator() end,          mode = "n" },
      { "<leader>X",  function() require("substitute.exchange").operator() end, mode = "n" },
      { "<leader>X",  function() require("substitute.exchange").visual() end,   mode = "x" },
      { "<leader>Xc", function() require("substitute.exchange").cancel() end,   mode = { "n", "x" } },
    },
  },
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function() vim.o.matchpairs = "(:),{:},[:],<:>" end,
    config = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      plugins = {
        gitsigns = true,
        tmux = true,
        kitty = { enabled = false, font = "+2" },
      },
    },
    keys = { { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" } },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    enabled = false,
    opts = {},

    init = function()
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end)
      vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end)
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>rr",
        function() require("ssr").open() end,
        mode = { "n", "x" },
        desc = "Structural Replace",
      },
    },
  },
}
