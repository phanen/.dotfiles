local highlight = require "utils.hightlights"

return {
  {
    "voldikss/vim-browser-search",
    event = "VeryLazy",
    keys = { "gx", mode = { "x" } },
    config = function() map({ "x" }, "gx", "<Plug>SearchVisual") end,
  },

  {
    -- "Pocco81/auto-save.nvim",
    -- FIXME: immediate_save actually not work
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
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
      { "<a-h>", function() require("smart-splits").resize_left() end },
      { "<a-l>", function() require("smart-splits").resize_right() end },
      -- moving between splits
      { "<c-h>", function() require("smart-splits").move_cursor_left() end },
      { "<c-j>", function() require("smart-splits").move_cursor_down() end },
      { "<c-k>", function() require("smart-splits").move_cursor_up() end },
      { "<c-l>", function() require("smart-splits").move_cursor_right() end },
      -- swapping buffers between windows
      { "<leader><leader>h", function() require("smart-splits").swap_buf_left() end, desc = { "swap left" } },
      { "<leader><leader>j", function() require("smart-splits").swap_buf_down() end, { desc = "swap down" } },
      { "<leader><leader>k", function() require("smart-splits").swap_buf_up() end, { desc = "swap up" } },
      { "<leader><leader>l", function() require("smart-splits").swap_buf_right() end, { desc = "swap right" } },
    },
  },

  {
    "karb94/neoscroll.nvim",
    cond = false,
    keys = {
      { "<c-u>", mode = { "n", "x" } },
      { "<c-d>", mode = { "n", "x" } },
      { "zt", mode = { "n", "x" } },
      { "zz", mode = { "n", "x" } },
      { "zb", mode = { "n", "x" } },
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
    event = "VeryLazy",
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
      { "ax", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
      { "ix", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
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
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = function() vim.fn["firenvim#install"](0) end,
  },
}
