return {
  {
    -- highlight, edit, navigation
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update { with_sync = true } end,
    event = "BufReadPre",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
      -- disable for vps...
        ensure_installed = {
          -- "c",
          -- "cpp",
          -- "lua",
          -- "python",
          -- "markdown",
          -- "markdown_inline",
          -- "vimdoc",
        },

        highlight = {
          additional_vim_regex_highlighting = false,
          enable = function(_, bufnr)
            -- if vim.bo.filetype == "markdown" then return false end

            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            local file_size = vim.api.nvim_call_function("getfsize", { buf_name })
            return file_size < 128 * 1024
          end,
        },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<cr>",
            scope_incremental = "<tab>",
            node_incremental = "<cr>",
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- you can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              -- ["ac"] = "@class.outer",
              -- ["ic"] = "@class.inner",
              -- ["aC"] = "@conditional.outer",
              -- ["iC"] = "@conditional.inner",
              ["aL"] = "@assignment.lhs",
              ["aR"] = "@assignment.rhs",
            },
          },
          swap = {
            enable = true,
            swap_next = { ["<leader>an"] = "@parameter.inner" },
            swap_previous = { ["<leader>ap"] = "@parameter.inner" },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      }
      vim.treesitter.language.register("markdown", "octo")
      require("nvim-treesitter.parsers").get_parser_configs().asm = {
        install_info = {
          url = "https://github.com/rush-rs/tree-sitter-asm.git",
          files = { "src/parser.c" },
          branch = "main",
        },
      }
    end,
  },

  {
    "rush-rs/tree-sitter-asm",
    ft = "markdown",
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = false,
    event = "VeryLazy",
    opts = {
      max_lines = 4,
      multiline_threshold = 4,
      separator = { "─", "ContextBorder" }, -- alternatives: ▁ ─ ▄
      mode = "cursor",
    },
  },

  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle" },
    dependencies = { "nvim-treesitter" },
  },

  {
    "Wansmer/sibling-swap.nvim",
    cond = false,
    keys = { "]w", "[w" },
    dependencies = { "nvim-treesitter" },
    opts = {
      use_default_keymaps = true,
      highlight_node_at_cursor = true,
      keymaps = {},
    },
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    opts = { use_default_keymaps = false },
    keys = {
      { "gS", "<Cmd>TSJSplit<CR>", desc = "split expression to multiple lines" },
      { "gJ", "<Cmd>TSJJoin<CR>",  desc = "join expression to single line" },
    },
  },
  {
    "haringsrob/nvim_context_vt",
    cond = false,
    opts = {
      disable_ft = { "json", "yaml" },
      disable_virtual_lines = true,
      ---@param node TSNode
      ---@param ft string
      ---@param _ table
      custom_parser = function(node, ft, _)
        local utils = require "nvim_context_vt.utils"

        -- useless if the node is less than 10 lines
        if node:end_() - node:start() < 10 then return nil end

        if ft == "lua" and node:type() == "if_statement" then return nil end

        -- only match if alphabetical characters are present
        if not utils.get_node_text(node)[1]:match "%w" then return nil end

        return "▶ " .. utils.get_node_text(node)[1]:gsub("{", "")
      end,
    },
    event = "BufReadPre",
  },
}
