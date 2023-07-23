return {
  -- tab
  {
    'akinsho/bufferline.nvim',
    event = 'UIEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '[b', '<Cmd>BufferLineMovePrev<CR>', { desc = 'bufferline: move next' } },
      { ']b', '<Cmd>BufferLineMoveNext<CR>', { desc = 'bufferline: move prev' } },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        offsets = { -- left for file explorer
          {
            filetype = "NvimTree",
            text = "time wait for no man",
            highlight = "Directory",
            text_align = "left"
          },
          {
            text = 'UNDOTREE',
            filetype = 'undotree',
            highlight = 'PanelHeading',
            separator = true,
          },

        }
      }
    }
  },

  -- statusline
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      }
    },
  },

  -- hint on indent
  {
    'lukas-reineke/indent-blankline.nvim',
    event = "BufReadPre",
    opts = {
      char = '│',       -- ┆ ┊ 
      show_foldtext = false,
      context_char = '│', -- ▎
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

  -- icon
  {
    'onsails/lspkind.nvim',
    opts = { preset = 'codicons', mode = 'symbol_text' },
    config = function(_, opts) require('lspkind').init(opts) end,
  },

  -- outline
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = true,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
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
        enable = false,
        -- format = {
        --   IncRename = { title = ' Rename ' },
        --   substitute = { pattern = '^:%%?s/', icon = ' ', ft = 'regex', title = '' },
        --   input = { icon = ' ', lang = 'text', view = 'cmdline_popup', title = '' },
        -- },
      },
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = false,             -- enables the Noice messages UI
        view = "notify",             -- default view for messages
        view_error = "notify",       -- view for errors
        view_warn = "notify",        -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },

      popupmenu = {
        enable = false,
        backend = 'nui',
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },

  -- breadcrumbs
  {
    "SmiteshP/nvim-navic",
    conf = false,
    event = "VeryLazy",
    dependencies = "neovim/nvim-lspconfig"
  },
  {
    'Bekaboo/dropbar.nvim',
    event = 'VeryLazy',
    keys = { { '<leader>wp', function() require('dropbar.api').pick() end, desc = 'winbar: pick' } },
  }

}
