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
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      local _ = string.format('pi = %.2f', 3.14159)
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'comment', -- keyword hightlight
          'cpp',
          'css',
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
          'regex', -- required by cmdline-hl
          'rust',
          'typescript',
          'vim',
          'vimdoc',
          'xml',
        },
        highlight = { enable = true, disable = disable_ts },
        indent = { enable = false, disable = { 'python' } },
        incremental_selection = { enable = true },
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
        -- matchup = {
        --   enable = false, -- mandatory, false will disable the whole extension
        --   -- disable = { 'c', 'ruby' }, -- optional, list of language that will be disabled
        -- },
        -- nvim_next = {
        --   enable = true,
        --   textobjects = {},
        -- },
      }
    end,
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter' },
    cmd = { 'TSJToggle' },
    opts = { use_default_keymaps = false, notify = false },
  },
}
