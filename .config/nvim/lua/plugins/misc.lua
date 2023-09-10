local highlight = require "utils.hightlights"

return {
  {
    "voldikss/vim-browser-search",
    event = "VeryLazy",
    keys = {
      { "gl", mode = { "x", "n" } },
    },
    config = function()
      map({ "x" }, "gl", "<Plug>SearchVisual")
      -- https://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser
      map({ "n" }, "gl", "<cmd>execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>")
    end,
  },

  {
    -- "Pocco81/auto-save.nvim",
    -- FIXME: immediate_save actually not work
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    cond = vim.g.started_by_firenvim == nil,
    opts = {
      execution_message = {
        enabled = false,
      },
      debounce_delay = 0,
      condition = function(buf)
        local utils = require "auto-save.utils.data"

        -- don't save for special-buffers
        if vim.fn.getbufvar(buf, "&buftype") ~= "" then return false end
        if utils.not_in(vim.fn.getbufvar(buf, "&filetype"), { "" }) then return true end
        return false
      end,
      trigger_event = {
        immediate_save = { "BufLeave", "FocusLost", "InsertLeave", "TextChanged" },
        defer_save = {},
        cancel_defered_save = {},
      },
      -- au TextChanged,TextChangedI <buffer> if &readonly == 0 && filereadable(bufname('%')) | silent write | endif
    },
  },

  {
    "mrjones2014/smart-splits.nvim",
    cond = false,
    config = true,
    build = "./kitty/install-kittens.bash",
    keys = {
      { "<a-h>",             function() require("smart-splits").resize_left() end },
      { "<a-l>",             function() require("smart-splits").resize_right() end },
      -- moving between splits
      { "<c-h>",             function() require("smart-splits").move_cursor_left() end },
      { "<c-j>",             function() require("smart-splits").move_cursor_down() end },
      { "<c-k>",             function() require("smart-splits").move_cursor_up() end },
      { "<c-l>",             function() require("smart-splits").move_cursor_right() end },
      -- swapping buffers between windows
      { "<leader><leader>h", function() require("smart-splits").swap_buf_left() end,    desc = { "swap left" } },
      { "<leader><leader>j", function() require("smart-splits").swap_buf_down() end,    { desc = "swap down" } },
      { "<leader><leader>k", function() require("smart-splits").swap_buf_up() end,      { desc = "swap up" } },
      { "<leader><leader>l", function() require("smart-splits").swap_buf_right() end,   { desc = "swap right" } },
    },
  },

  {
    "karb94/neoscroll.nvim",
    cond = false,
    keys = {
      { "<c-u>", mode = { "n", "x" } },
      { "<c-d>", mode = { "n", "x" } },
      { "zt",    mode = { "n", "x" } },
      { "zz",    mode = { "n", "x" } },
      { "zb",    mode = { "n", "x" } },
    },
    config = true,
  },

  {
    "voldikss/vim-translator",
    cmd = { "Translate", "TranslateW" },
    keys = { { "<leader>K", "<cmd>Translate<cr>", mode = { "n", "x" } } },
  },

  {
    "vifm/vifm.vim",
    cond = false,
    lazy = "VeryLazy",
  },
  {
    "nanotee/zoxide.vim",
    cmd = { "Z", "Lz", "Tz", "Zi", "Lzi", "Tzi" },
    config = function() require("zoxide").setup {} end,
  },

  {
    "rgroli/other.nvim",
    cond = false,
    -- keys = { "<leader>ga", "<cmd>Other<cr>" },
    cmd = { "Other", "OtherSplit", "OtherVsplit" },
    opts = {},
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>L",
        ":TodoTelescope cwd=" .. require("utils").get_root() .. "<CR>",
        silent = true,
      },
    },
    opts = { highlight = { keyword = "bg" } },
  },

  {
    "glts/vim-textobj-comment",
    dependencies = { { "kana/vim-textobj-user", dependencies = { "kana/vim-operator-user" } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { "ac", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
      { "ic", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
    },
  },
  {
    "LeonB/vim-textobj-url",
    dependencies = "kana/vim-textobj-user",
    keys = {
      { "au", mode = { "x", "o" } },
      { "iu", mode = { "x", "o" } },
    },
  },

  {
    "chaoren/vim-wordmotion",
    cond = false,
    lazy = false,
    init = function() vim.g.wordmotion_spaces = { "-", "_", "\\/", "\\." } end,
  },

  {
    "itchyny/vim-highlighturl",
    event = "ColorScheme",
    -- HACK: fix ?
    config = function() vim.g.highlighturl_guifg = highlight.get("@keyword", "fg") end,
  },

  -- peek line
  {
    "nacro90/numb.nvim",
    event = "CmdlineEnter",
    opts = {},
  },

  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    cond = false,
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function() vim.fn["firenvim#install"](0) end,
  },

  -- diff arbitrary blocks of text with each other
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word",       cmd = { "WordCount", "WordCountLine" } },

  {
    "phanen/browse.nvim",
    branch = "visual-mode",
    dependencies = { "nvim-telescope/telescope.nvim" },
    keys = {
      {
        mode = { "n", "x" },
        "<leader>S",
        function() require("browse").open_bookmarks() end,
      },
      {
        mode = { "n", "x" },
        "<leader>B",
        function() require("browse").browse() end,
      },
      {
        mode = { "n", "x" },
        "<leader>I",
        function() require("browse").input_search() end,
      },
    },

    opts = {
      bookmarks = {
        -- ["github_code"] = "https://github.com/search?q=%s&type=code",
        ["github_repo"] = "https://github.com/search?q=%s&type=repositories",
      },
    },
  },

  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    config = function()
      require("octo").setup {}
      -- BUG: take no effect...
      -- vim.api.nvim_set_hl(0, "OctoEditable", { bg = highlight.get("NormalFloat", "bg") })
      vim.api.nvim_set_hl(0, "OctoEditable", { bg = "#e4dcd4" })
      map("i", "@", "@<C-x><C-o>", { silent = true, buffer = true })
      map("i", "#", "#<C-x><C-o>", { silent = true, buffer = true })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "psliwka/vim-dirtytalk",
    lazy = false,
    build = ":DirtytalkUpdate",
    config = function() vim.opt.spelllang:append "programming" end,
  },
  {
    "RaafatTurki/hex.nvim",
    config = true,
  },
}
