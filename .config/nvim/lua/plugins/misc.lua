local hl = require "utils.hl"

return {
  { "folke/lazy.nvim" },
  -- FIXME: which-key will not register _d, cannot set timeoutlen = 0
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<localleader>", "g", "z", "<c-s>" },
    -- event = "VeryLazy",
    opts = {
      plugins = { spelling = { enabled = false } },
      triggers = "auto",
      disable = { filetypes = { "man" }, buftypes = { "help" } },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree: toggle" } },
    config = function()
      vim.g.undotree_TreeNodeShape = "◦" -- Alternative: '◉'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    cond = vim.g.started_by_firenvim == nil,
    opts = {
      execution_message = { enabled = false },
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
  { "voldikss/vim-translator", cmd = "Translate", keys = { { "gk", ":Translate<cr>", mode = { "n", "x" } } } },
  {
    "itchyny/vim-highlighturl",
    event = "ColorScheme",
    config = function() vim.g.highlighturl_guifg = hl.get("@keyword", "fg") end,
  },
  { "nacro90/numb.nvim", event = "CmdlineEnter", opts = {} },
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word", cmd = { "WordCount", "WordCountLine" } },
  { "skywind3000/asyncrun.vim", cmd = "AsyncRun" },
  { "lilydjwg/fcitx.vim", event = "VeryLazy" },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
      { "<ESC>", [[<cmd>noh<CR><cmd>lua require('hlslens').stop()<CR>]] },
    },
    opts = { calm_down = true, nearest_only = true },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf", opts = {} },
  -- diagnostics icons
  { url = "https://gitlab.com/yorickpeterse/nvim-pqf", ft = "qf", opts = {} },
  {
    "Shatur/neovim-session-manager",
    keys = {
      {
        "<leader>ss",
        "<cmd>SessionManager save_current_session<cr>",
        desc = "save current session",
      },
      {
        "<leader>sl",
        "<cmd>SessionManager load_session<cr>",
        desc = "load last session",
      },
      {
        "<leader>sd",
        "<cmd>SessionManager delete_session<cr>",
        desc = "delete session",
      },
    },
    opts = function()
      return {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_last_session = false,
      }
    end,
  },
  {
    "chrishrb/gx.nvim",
    keys = { { "gl", "gx", mode = { "x", "n" }, remap = true } },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
}
