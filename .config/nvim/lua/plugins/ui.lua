return {

  -- file explorer
  {
    'nvim-tree/nvim-tree.lua', tag = 'nightly',
    lazy = false,
    opts = { hijack_netrw = true, },
    dependencies = { 'nvim-tree/nvim-web-devicons', },
  },

  -- tab
  {
    'akinsho/bufferline.nvim',
    event = 'UIEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
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
          }
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
    lazy = false,
    opts = {
      char = '│', -- ┆ ┊ 
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
    cond = false,
    config = true,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      -- Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" }
    }
  },

  {
    -- outline
    'stevearc/aerial.nvim',
    lazy = false,
    config = true,
  },

  -- scroll
  { 'karb94/neoscroll.nvim' },

  -- disgnose
  {
    "folke/trouble.nvim",
    cond = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function() require("trouble").setup {} end
  },

}
