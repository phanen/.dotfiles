return {
  -- TODO: upstream is still working
  {
    'windwp/nvim-ts-autotag',
    -- event = 'InsertEnter',
    Filetype = { 'markdown' },
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
    -- per_filetype = {
    --   ['html'] = { enable_close = false },
    -- },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update { with_sync = true } end,
    event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'Filetype' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = vim.schedule_wrap(function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'cpp',
          'css',
          'fish',
          'go',
          'html',
          'javascript',
          'lua',
          'markdown',
          'markdown_inline',
          'python',
          'query',
          'rust',
          'typescript',
          'vimdoc',
        },
        highlight = {
          enable = true,
          disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
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
            disable = function(_, bufnr) return vim.api.nvim_buf_line_count(bufnr) > 10000 end,
            lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
            set_jumps = true, -- whether to set jumps in the jumplist
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = { ['<leader>sj'] = '@parameter.inner' },
            swap_previous = { ['<leader>sk'] = '@parameter.inner' },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']f'] = '@function.outer',
              [']m'] = '@class.outer',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']M'] = '@class.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[m'] = '@class.outer',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[M'] = '@class.outer',
            },
          },
        },
      }
    end),
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    cmd = { 'TSJToggle' },
    opts = { use_default_keymaps = false, notify = false },
  },
}
