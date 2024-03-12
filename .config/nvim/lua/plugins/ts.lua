return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function()
      require('nvim-treesitter.install').update { with_sync = true }
    end,
    event = 'FileType',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      vim.schedule(function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = {
            'c',
            'go',
            'javascript',
            'lua',
            'markdown',
            'markdown_inline',
            'rust',
            'typescript',
            'vimdoc',
          },
          highlight = {
            enable = true,
            disable = function(_, bufnr)
              return vim.api.nvim_buf_line_count(bufnr) > 10000
            end,
          },
          indent = { enable = true, disable = { 'python' } },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<cr>',
              node_incremental = '<cr>',
              node_decremental = '<s-cr>',
            },
          },
          textobjects = {
            select = {
              enable = true,
              disable = function(_, bufnr)
                return vim.api.nvim_buf_line_count(bufnr) > 10000
              end,
              lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
              },
            },
            swap = {
              enable = true,
              swap_next = { ['<c-,>'] = '@parameter.inner' },
              swap_previous = { ['<c-.>'] = '@parameter.inner' },
            },
            move = {
              enable = false,
              set_jumps = true, -- whether to set jumps in the jumplist
            },
          },
        }
      end)
      -- local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      -- -- TODO: make all similar op repeatable
      -- map({ "n", "x", "o" }, "]]", ts_repeat_move.repeat_last_move_next)
      -- map({ "n", "x", "o" }, "[[", ts_repeat_move.repeat_last_move_previous)
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    cmd = { 'TSJToggle' },
    opts = { use_default_keymaps = false },
  },
}
