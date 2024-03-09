return {
  -- buf {{{
  { "famiu/bufdelete.nvim", cmd = "Bdelete" },
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "H", "<cmd>BufferLineMovePrev<cr>" },
      { "L", "<cmd>BufferLineMoveNext<cr>" },
    },
    opts = {
      options = {
        show_buffer_close_icons = false,
        hover = { enabled = false },
        offsets = {
          { filetype = "NvimTree", text = function() return vim.fn.getcwd() end, text_align = "left" },
          { filetype = "undotree", text = "UNDOTREE", text_align = "left" },
        },
      },
    },
  },
  {
    "kwkarlwang/bufjump.nvim",
    keys = {
      { "<leader><c-o>", "<cmd>lua require('bufjump').backward()<cr>" },
      { "<leader><c-i>", "<cmd>lua require('bufjump').forward()<cr>" },
    },
  },
  -- }}}
  -- doc {{{
  { "hotoo/pangu.vim", keys = { { mode = "x", "<leader>lj", ":Pangu<cr>" } }, cmd = "Pangu", ft = "markdown" },
  { "jspringyc/vim-word", cmd = { "WordCount", "WordCountLine" } },
  { "cissoid/vim-fullwidth-punct-convertor", cmd = "FullwidthPunctConvert" },
  { "chomosuke/typst-preview.nvim", ft = "typst", build = function() require("typst-preview").update() end },
  { "kaarmu/typst.vim", ft = "typst" },
  { "nvim-orgmode/orgmode", dependencies = "nvim-treesitter/nvim-treesitter", ft = "org", config = true },
  { "phanen/mder.nvim", ft = "markdown", config = true },
  {
    "3rd/image.nvim",
    ft = { "markdown", "org" },
    opts = { integrations = { markdown = { only_render_image_at_cursor = true } } },
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
  {
    "linrongbin16/gitlinker.nvim",
    keys = {
      { "<localleader>gl", "<cmd>GitLink!<cr>", mode = { "n", "x" } },
      { "<localleader>gb", "<cmd>GitLink! blame<cr>", mode = { "n", "x" } },
    },
    cmd = "GitLink",
    opts = {
      router = {
        browse = {
          ["^ssh%.github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blob/"
            .. "{_A.REV}/"
            .. "{_A.FILE}?plain=1" -- '?plain=1'
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
        blame = {
          ["^ssh%.github%.com"] = "https://github.com/"
            .. "{_A.ORG}/"
            .. "{_A.REPO}/blame/"
            .. "{_A.REV}/"
            .. "{_A.FILE}?plain=1" -- '?plain=1'
            .. "#L{_A.LSTART}"
            .. "{(_A.LEND > _A.LSTART and ('-L' .. _A.LEND) or '')}",
        },
      },
    },
  },
  --- }}}
  -- tree {{{
  {
    "nvim-tree/nvim-tree.lua",
    -- workaround for open dir
    lazy = not vim.fn.argv()[1],
    keys = "gf",
    event = "CmdlineEnter",
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
      view = { adaptive_size = true },
      -- hijack_directories = { enable = false },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        api.config.mappings.default_on_attach(bufnr)
        local n = function(lhs, rhs, desc) return map("n", lhs, rhs, { desc = desc, buffer = bufnr }) end

        local node_path_dir = function()
          local node = require("nvim-tree.api").tree.get_node_under_cursor()
          if not node then return end
          if node.parent and node.type == "file" then return node.parent.absolute_path end
          return node.absolute_path
        end
        -- picker on dir, prefer node path
        local pn = function(picker, dirs)
          return function()
            local ndir = nil
            local ft = vim.api.nvim_get_option_value("filetype", {})
            if ft == "NvimTree" then ndir = node_path_dir() end
            require("telescope.builtin")[picker] {
              search_dirs = ndir and { ndir } or dirs,
              previewer = picker == "live_grep",
            }
          end
        end
        n("h", api.tree.change_root_to_parent, "up")
        n("l", api.node.open.edit, "edit")
        n("o", api.tree.change_root_to_node, "cd")
        n("<c-p>", require("dirstack").prev)
        n("<c-n>", require("dirstack").next)
        n("<c-e>", pn "live_grep")
        n("<c-f>", pn "find_files")
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
  { "folke/tokyonight.nvim" },
  -- FIXME: register _d, cannot set timeoutlen = 0
  { "folke/which-key.nvim", event = "VeryLazy", opts = { plugins = { spelling = { enabled = false } } } },
  { "voldikss/vim-translator", cmd = "Translate", keys = { { "gk", ":Translate<cr>", mode = { "n", "x" } } } },
  { "AndrewRadev/linediff.vim", cmd = "Linediff", keys = { { mode = "x", "<leader>ld", ":Linediff<cr>" } } },
  { "lilydjwg/fcitx.vim", event = "InsertEnter" },
  { "tpope/vim-eunuch", cmd = { "Move", "Rename", "Remove", "Delete", "Mkdir" } },
  { "mikesmithgh/kitty-scrollback.nvim" },
  { "polirritmico/lazy-local-patcher.nvim", ft = "lazy", config = true },
  {
    -- TODO: upstream
    "sportshead/gx.nvim",
    branch = "git-handler",
    cmd = "Browse",
    keys = { { "gl", "<cmd>Browse<cr>", mode = { "n", "x" } } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
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
      { "n", [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]] },
      { "N", [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]] },
      { "*", [[*<cmd>lua require('hlslens').start()<cr>]], { remap = true } },
      { "#", [[#<cmd>lua require('hlslens').start()<cr>]] },
      { "g*", [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { "g#", [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        "<esc>",
        function()
          vim.cmd.noh()
          require("hlslens").stop()
          vim.api.nvim_feedkeys(k "<esc>", "n", false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
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
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "DiffviewOpen",
    config = true,
  },
  {
    "kawre/leetcode.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cond = vim.fn.argv()[1] == "leetcode.nvim",
    lazy = false,
    keys = {
      { "<localleader>a", "<cmd>Leet lang<cr>" },
      { "<localleader>c", "<cmd>Leet console<cr>" },
      { "<localleader>d", "<cmd>Leet desc<cr>" },
      { "<localleader>i", "<cmd>Leet info<cr>" },
      { "<localleader>l", "<cmd>Leet list<cr>" },
      { "<localleader>r", "<cmd>Leet run<cr>" },
      { "<localleader>s", "<cmd>Leet submit<cr>" },
      { "<localleader>t", "<cmd>Leet tabs<cr>" },
      { "<localleader>y", "<cmd>Leet yank<cr>" },
      {
        "<localleader>o",
        function()
          vim.ui.open("https://leetcode.cn/problems/" .. vim.fn.expand("%:t:r"):gsub("%d+%.", "", 1) .. "/solutions/")
        end,
      },
    },
    opts = {
      cn = { enabled = true },
      injector = {
        ["cpp"] = {
          before = { "#include <bits/stdc++.h>", '#include "lib.h"', "using namespace std;" },
          after = "int main() {}",
        },
      },
      storage = { home = "~/c/leetcode" },
      image_support = false,
    },
  },
  -- }}}
  -- ui {{{
  { "stevearc/aerial.nvim", cmd = "AerialToggle", opts = { keymaps = { ["<C-k>"] = false, ["<C-j>"] = false } } },
  { "HiPhish/rainbow-delimiters.nvim", event = { "BufReadPre", "BufNewFile" } },
  -- https://github.com/neovim/neovim/pull/27132
  { "itchyny/vim-highlighturl", event = "ColorScheme" },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<c-\\>" },
    opts = { open_mapping = "<c-\\>", direction = "float", shell = "/bin/fish" },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        should_preview_cb = function(bufnr, _)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if bufname:match "^fugitive://" then return false end
          if fsize > 100 * 1024 then return false end
          return true
        end,
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    event = "LspAttach",
    dependencies = "nvim-telescope/telescope-fzf-native.nvim",
  },
  -- }}}
}
-- vim:foldmethod=marker
