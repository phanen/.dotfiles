return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update { with_sync = true } end,
    event = { 'BufReadPre', 'BufNewFile' },
    -- event = { 'Filetype' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      { 'windwp/nvim-ts-autotag', event = 'InsertEnter', opts = {} },
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
            enable = false,
            set_jumps = true, -- whether to set jumps in the jumplist
          },
        },
        autotag = {
          enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
          filetypes = { 'javascript', 'html', 'xml' },
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
