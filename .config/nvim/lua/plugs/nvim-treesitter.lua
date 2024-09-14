-- maybe global workaround: hook `get_parser`
local disable_ts = function(_, bnr)
  return vim.bo[bnr].ft == 'tex' or api.nvim_buf_line_count(bnr) > 10000
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update { with_sync = true } end,
    -- event = { 'BufReadPre', 'BufNewFile' },
    event = { 'FileType' },
    -- lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    config = function()
      local _ = string.format('pi = %.2f', 3.14159)
      require('nvim-treesitter.configs').setup {
        ensure_installed = true and 'all' or {
          'bash',
          'c',
          'comment', -- keyword hightlight
          'cpp',
          'css',
          'doxygen', -- c comment
          'fish',
          'go',
          'html',
          'java',
          'javascript',
          'kotlin',
          'lua',
          'luap', -- lua pattern
          'markdown',
          'markdown_inline',
          'python',
          'query',
          're2c', -- c comment
          'regex', -- required by cmdline-hl
          'rust',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
        },
        highlight = { enable = true, disable = disable_ts },
        indent = { enable = false, disable = { 'python' } },
        incremental_selection = { enable = false, keymaps = { gnn = false } },
        textobjects = {
          select = { enable = true, lookahead = true, set_jumps = true },
          swap = { enable = true },
          move = { enable = true, set_jumps = true },
          lsp_interop = {
            enable = true,
            floating_preview_opts = { border = g.border },
            peek_definition_code = {
              [' df'] = '@function.outer',
              [' dF'] = '@class.outer',
            },
          },
        },
        refactor = {
          navigation = {
            enable = true,
            keymaps = {
              goto_definition = 'gnd',
              list_definitions = 'gnD',
              list_definitions_toc = 'gO',
              goto_next_usage = '<leader>*',
              goto_previous_usage = '<leader>#',
            },
          },
          -- Set to false if you have an `updatetime` of ~100.
          highlight_definitions = { enable = false, clear_on_cursor_move = true },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
            keymaps = { smart_rename = ' <c-r>' },
          },
        },
        -- mandatory, false will disable the whole extension
        -- matchup = { enable = true },
      }
    end,
  },
}
