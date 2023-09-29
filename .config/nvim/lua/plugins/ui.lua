return {
  -- tab
  {
    "akinsho/bufferline.nvim",
    event = "UIEnter",
    cond = vim.g.started_by_firenvim == nil,
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "[b", "<Cmd>BufferLineMovePrev<CR>", { desc = "bufferline: move next" } },
      { "]b", "<Cmd>BufferLineMoveNext<CR>", { desc = "bufferline: move prev" } },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        offsets = { -- left for file explorer
          {
            filetype = "NvimTree",
            -- TODO: quoter
            text = "time wait for no man",
            highlight = "Directory",
            text_align = "left",
          },
          {
            text = "UNDOTREE",
            filetype = "undotree",
            highlight = "PanelHeading",
            separator = true,
          },
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "|",
        section_separators = "",
      },
    },
  },
  {
    "nvimdev/whiskyline.nvim",
    lazy = false,
    cond = false,
    opts = {},
  },

  -- hint on indent
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPre",
    opts = {
      char = "│", -- ┆ ┊ 
      show_foldtext = false,
      context_char = "│", -- ▎
      char_priority = 12,
      show_current_context = true,
      show_current_context_start = true,
      show_current_context_start_on_current_line = false,
      show_first_indent_level = true,
      -- stylua: ignore
      filetype_exclude = {
        'NvimTree', 'log', 'gitcommit', 'git',
        'txt', 'help', 'undotree',
        'markdown', 'norg', 'org', 'orgagenda',
        '', -- for all buffers without a file type
      },
    },
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    config = function()
      local rainbow_delimiters = require "rainbow-delimiters"

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
        },
      }
    end,
  },

  -- icon
  {
    "onsails/lspkind.nvim",
    opts = { preset = "codicons", mode = "symbol_text" },
    config = function(_, opts) require("lspkind").init(opts) end,
  },

  -- disgnose
  {
    "folke/trouble.nvim",
    cond = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = true,
  },

  -- https://www.reddit.com/r/neovim/comments/12lf0ke/does_anyone_have_a_cmdheight0_setup_without/
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    cond = false,
    opts = {
      cmdline = {
        enable = true,
        format = {
          cmdline = false,
          search_down = false,
          search_up = false,
          filter = false,
          lua = false,
          help = false,
        },
      },
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true,              -- enables the Noice messages UI
        view = "notify",             -- default view for messages
        view_error = "notify",       -- view for errors
        view_warn = "notify",        -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },

  -- breadcrumbs
  {
    "glepnir/lspsaga.nvim",
    cond = vim.g.started_by_firenvim == nil,
    event = "LspAttach",
    config = true,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- ensure markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "SmiteshP/nvim-navic",
    cond = false,
    dependencies = "neovim/nvim-lspconfig",
  },
  {
    "Bekaboo/dropbar.nvim",
    cond = false,
    event = "VeryLazy",
    keys = { { "<leader>wp", function() require("dropbar.api").pick() end, desc = "winbar: pick" } },
  },

  -- outline
  {
    "SmiteshP/nvim-navbuddy",
    lazy = false,
    cond = false,
    event = "VeryLazy",
    -- keys = { "<leader>wj" },
    -- cmd = { "Navbuddy" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lsp = { auto_attach = true },
      -- icons = require('lspkind').symbol_map,
      icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    config = true,
    key = { "<leader>wo" },
    cmd = { "AerialToggle" },
    -- event = "VeryLazy",
    opts = {
      keymaps = {
        ["<C-n>"] = "actions.down_and_scroll",
        ["<C-p>"] = "actions.up_and_scroll",
        ["<C-j>"] = "",
        ["<C-k>"] = "",
        ["g?"] = "actions.show_help",
      },
    },
  },
}
