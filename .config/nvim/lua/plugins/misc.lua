return {
  -- buf {{{
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "H", "<cmd>BufferLineMovePrev<cr>", { desc = "bl: move next" } },
      { "L", "<cmd>BufferLineMoveNext<cr>", { desc = "bl: move prev" } },
    },
    opts = {
      options = {
        offsets = {
          { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, text_align = "left" },
          { filetype = "undotree", text = "UNDOTREE", text_align = "left" },
        },
      },
    },
  },
  { "famiu/bufdelete.nvim", cmd = "Bdelete" },
  { "ojroques/nvim-bufdel", cmd = "BufDel", opts = { quit = false } },
  {
    "kwkarlwang/bufjump.nvim",
    keys = {
      { "<leader><c-o>", "<cmd>lua require('bufjump').backward()<cr>" },
      { "<leader><c-i>", "<cmd>lua require('bufjump').forward()<cr>" },
    },
  },
  -- }}}
  -- color {{{
  { "EdenEast/nightfox.nvim" },
  -- { "NLKNguyen/papercolor-theme" },
  -- { "igorgue/danger" },
  -- { "rebelot/kanagawa.nvim" },
  { "folke/tokyonight.nvim" },
  -- { "navarasu/onedark.nvim" },
  -- { "shaunsingh/nord.nvim" },
  -- { "AlexvZyl/nordic.nvim" },
  -- { "NTBBloodbath/doom-one.nvim" },
  -- { "mswift42/vim-themes" },
  -- { "marko-cerovac/material.nvim" },
  -- { "dracula/vim", name = "dracula.vim" },
  -- { "rose-pine/neovim", name = "rose-pine" },
  -- { "catppuccin/nvim", name = "catppuccin" },
  -- { "mcchrish/zenbones.nvim", dependencies = "rktjmp/lush.nvim" },
  -- tools
  { "xiyaowong/transparent.nvim", cmd = "TransparentToggle", config = true },
  {
    "4e554c4c/darkman.nvim",
    event = "VeryLazy",
    build = "go build -o bin/darkman.nvim",
    opts = { colorscheme = { dark = "tokyonight", light = "dayfox" } },
  },
  { "norcalli/nvim-colorizer.lua" },
  -- syntax highlight
  { "kovetskiy/sxhkd-vim", cond = false, ft = "sxhkd" },
  { "kmonad/kmonad-vim", cond = false, ft = "kbd" },
  -- }}}
  -- doc {{{
  {
    "iamcco/markdown-preview.nvim",
    cmd = "MarkdownPreview",
    build = "cd app && npm install",
    ft = { "markdown" },
  },
  { "dhruvasagar/vim-table-mode", cond = false, ft = { "markdown", "org" } },
  {
    "lervag/vimtex",
    -- :h :VimtexInverseSearch
    -- https://github.com/lervag/vimtex/pull/2560
    cond = false,
    lazy = false,
    ft = "tex",
    keys = {
      { "<leader>vc", "<cmd>VimtexCompile<cr>" },
      { "<leader>vl", "<cmd>VimtexClean<cr>" },
      { "<leader>vs", "<cmd>VimtexCompileSS<cr>" },
      { "<leader>vv", "<plug>(vimtex-view)" },
    },
    config = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.tex_flavor = "latex"
      vim.g.tex_conceal = "abdmgs"
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
  {
    "iurimateus/luasnip-latex-snippets.nvim",
    cond = false,
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function() require("luasnip-latex-snippets").setup { use_treesitter = true } end,
    ft = { "tex", "markdown" },
  },
  {
    "3rd/image.nvim",
    cond = false,
    ft = "markdown",
    opts = {},
    init = function()
      -- Example for configuring Neovim to load user-installed installed Lua rocks:
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?/init.lua;"
      package.path = package.path .. ";" .. vim.fn.expand "$HOME" .. "/.luarocks/share/lua/5.1/?.lua;"
    end,
  },
  -- }}}
  -- git {{{
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>" },
      { "<leader>gD", "<cmd>G diff<cr>" },
      { "<leader>gs", "<cmd>G<cr>" },
      { "<leader>ga", "<cmd>Gwrite<cr>" },
      { "<leader>gc", "<cmd>G commit<cr>" },
      { "<leader>gb", "<cmd>G blame<cr>" },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    keys = { { "<localleader>gs", "<cmd>Gitsigns<cr>" } },
    dependencies = "stevearc/dressing.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local m = function(mode, l, r, desc)
          if desc then desc = "gs: " .. desc end
          map(mode, l, r, { buffer = bufnr, desc = desc })
        end
        m("n", "]h", gs.next_hunk, "next_hunk")
        m("n", "[h", gs.prev_hunk, "prev_hunk")
        m("n", "<leader>hs", gs.stage_hunk, "stage_hunk")
        m("n", "<leader>hr", gs.reset_hunk, "reset_hunk")
        m("n", "<leader>hu", gs.undo_stage_hunk, "undo_stage_hunk")
        m("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "stage_hunk")
        m("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "reset_hunk")
        m("n", "<leader>hS", gs.stage_buffer, "stage_buffer")
        m("n", "<leader>hR", gs.reset_buffer, "reset_buffer")
        m("n", "<leader>hb", function() gs.blame_line { full = true } end, "blame_line")
        m("n", "<leader>hp", gs.preview_hunk, "preview_hunk")
        m("n", "<leader>hd", gs.diffthis, "diffthis")
        m("n", "<leader>hD", function() gs.diffthis "~" end, "diffthis")
        m({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", "select_hunk")
      end,
    },
  },
  {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { { "<localleader>gn", [[<cmd>lua require("neogit").open()<cr>]] } },
    opts = {
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = {
        section = { "", "" },
        item = { "▸", "▾" },
        hunk = { "󰐕", "󰍴" },
      },
    },
  },
  --- }}}
  -- term {{{
  {
    "akinsho/toggleterm.nvim",
    keys = { [[<c-\>]] },
    opts = {
      open_mapping = [[<c-\>]],
      start_in_insert = true,
      direction = "float",
      shell = "/bin/fish",
      highlights = {
        -- NormalFloat = { link = "", cterm = "bold" },
        -- NormalFloat = { guibg = "#1a1b26", guifg = "#a9b1d6" },
        -- NormalFloat = { guibg = "#192330", guifg = "#81b29a" },
      },
    },
  },
  --- }}}
  -- tree {{{
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    lazy = not vim.fn.argv()[1],
    cmd = { "NvimTreeFindFileToggle" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "stevearc/dressing.nvim",
        opts = { input = { mappings = { i = { ["<c-p>"] = "HistoryPrev", ["<c-n>"] = "HistoryNext" } } } },
      },
    },
    opts = {
      sync_root_with_cwd = true,
      actions = { change_dir = { enable = true, global = true } },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        local n = function(lhs, rhs, desc) return map("n", lhs, rhs, { desc = desc, buffer = bufnr }) end
        n("h", api.tree.change_root_to_parent, "up")
        n("l", api.node.open.edit, "edit")
        n("_", api.tree.change_root_to_node, "cd")
      end,
    },
  },
  -- }}}
  -- tobj {{{
  {
    "glts/vim-textobj-comment",
    dependencies = { { "kana/vim-textobj-user", dependencies = { "kana/vim-operator-user" } } },
    init = function() vim.g.textobj_comment_no_default_key_mappings = 1 end,
    keys = {
      { "ac", "<Plug>(textobj-comment-a)", mode = { "x", "o" } },
      { "ic", "<Plug>(textobj-comment-i)", mode = { "x", "o" } },
      { "<leader><c-_>", "<cmd>norm vac<c-_><cr>", mode = { "n" } },
      { "<leader><c-/>", "<cmd>norm vac<c-/><cr>", mode = { "n" } },
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
  -- }}}
  -- tool {{{
  { "folke/lazy.nvim" },
  -- FIXME: register _d, cannot set timeoutlen = 0
  { "folke/which-key.nvim", event = "VeryLazy", opts = { plugins = { spelling = { enabled = false } } } },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  { "voldikss/vim-translator", cmd = "Translate", keys = { { "gk", ":Translate<cr>", mode = { "n", "x" } } } },
  { "nacro90/numb.nvim", event = "CmdlineEnter", opts = {} },
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word", cmd = { "WordCount", "WordCountLine" } },
  { "skywind3000/asyncrun.vim", cmd = "AsyncRun" },
  { "lilydjwg/fcitx.vim", event = "VeryLazy" },
  { "chrishrb/gx.nvim", keys = "gx", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree: toggle" } },
    config = function()
      vim.g.undotree_TreeNodeShape = "◦"
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      execution_message = { enabled = false },
      debounce_delay = 125,
      condition = function(bufnr)
        local utils = require "auto-save.utils.data"
        if vim.fn.getbufvar(bufnr, "&buftype") ~= "" then return false end
        if utils.not_in(vim.fn.getbufvar(bufnr, "&filetype"), { "" }) then return true end
        return false
      end,
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      { "n", [[<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>zz]] },
      { "N", [[<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>zz]] },
      { "*", [[*<cmd>lua require('hlslens').start()<cr>]], { remap = true } },
      { "#", [[#<cmd>lua require('hlslens').start()<cr>]] },
      { "g*", [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { "g#", [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        "<esc>",
        function()
          vim.cmd.noh()
          require("hlslens").stop()
          vim.api.nvim_feedkeys(vim.keycode "<esc>", "n", false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
  {
    "Shatur/neovim-session-manager",
    keys = {
      { "<leader>ss", "<cmd>SessionManager save_current_session<cr>" },
      { "<leader>sl", "<cmd>SessionManager load_session<cr>" },
      { "<leader>sd", "<cmd>SessionManager delete_session<cr>" },
    },
    opts = function()
      return {
        autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
        autosave_last_session = false,
      }
    end,
  },
  {
    "phanen/dirstack.nvim",
    event = "DirChangedPre",
    keys = {
      { "<c-p>", function() require("dirstack").prev() end },
      { "<c-n>", function() require("dirstack").next() end },
      { "<c-g>", function() require("dirstack").info() end },
    },
    config = true,
  },
  -- }}}
  -- ui {{{
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { component_separators = "|", section_separators = "" } },
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle" },
    opts = {
      keymaps = {
        ["<c-n>"] = "actions.down_and_scroll",
        ["<c-p>"] = "actions.up_and_scroll",
        -- FIXME: switch window
        ["<c-j>"] = "<cmd>wincmd j<cr>",
        ["<c-k>"] = "<cmd>wincmd k<cr>",
      },
    },
  },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  { "HiPhish/rainbow-delimiters.nvim", event = "VeryLazy" },
  { "itchyny/vim-highlighturl", event = "ColorScheme" },
  -- }}}
}
-- vim:foldmethod=marker
