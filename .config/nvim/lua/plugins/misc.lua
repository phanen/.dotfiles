local hl = require "utils.hl"

return {
  { "folke/lazy.nvim", },
  -- FIXME: which-key will not register _d
  -- cannot set timeoutlen = 0
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = { enabled = false } },
      triggers = "auto",
      disable = {
        filetypes = { "man" },
        buftypes = { "help" },
      },
    }
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
    "voldikss/vim-translator",
    cmd = { "Translate", "TranslateW" },
    keys = { { "gk", ":Translate<cr>", mode = { "n", "x" } } },
  },
  {
    "rgroli/other.nvim",
    cond = false,
    -- keys = { "<leader>ga", "<cmd>Other<cr>" },
    cmd = { "Other", "OtherSplit", "OtherVsplit" },
    opts = {},
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
    config = function() vim.g.highlighturl_guifg = hl.get("@keyword", "fg") end,
  },
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
    init = function()
      if vim.g.started_by_firenvim then
        vim.o.laststatus = 0

        vim.g.firenvim_config = {
          localSettings = {
            [".*"] = { cmdline = "none" },
            ["https?://www.google.com"] = { takeover = "never", priority = 1 },
          },
        }

        vim.cmd [[
      au BufEnter leetcode*.txt set filetype=rust
      au BufEnter *ipynb*.txt set filetype=python
      au BufEnter github.com_*.txt set filetype=markdown
      " auto insert
      au FocusGained * startinsert
    ]]
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
          nested = true,
          command = "write",
        })
      end
    end,
  },
  -- diff arbitrary blocks of text with each other
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word",       cmd = { "WordCount", "WordCountLine" } },
  {
    "psliwka/vim-dirtytalk",
    lazy = false,
    build = ":DirtytalkUpdate",
    config = function() vim.opt.spelllang:append "programming" end,
  },
  { "RaafatTurki/hex.nvim",     config = true },
  { "skywind3000/asyncrun.vim", cmd = "AsyncRun" },
  -- no delay, friendly to mapped readline
  { "lilydjwg/fcitx.vim",       event = "VeryLazy", },
  {
    "kevinhwang91/nvim-hlslens",
    lazy = false,
    keys = {
      { "n",     [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { "N",     [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>zz]] },
      { "*",     [[*<Cmd>lua require('hlslens').start()<CR>]] },
      { "#",     [[#<Cmd>lua require('hlslens').start()<CR>]] },
      { "g*",    [[g*<Cmd>lua require('hlslens').start()<CR>]] },
      { "g#",    [[g#<Cmd>lua require('hlslens').start()<CR>]] },
      { "<ESC>", [[<cmd>noh<CR><cmd>lua require('hlslens').stop()<CR>]] },
    },
    opts = {
      calm_down = true,
      nearest_only = true,
    }
  }
}
