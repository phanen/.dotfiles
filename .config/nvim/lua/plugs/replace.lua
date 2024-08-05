return {
  {
    'cshuaimin/ssr.nvim',
    keys = { { '+s', function() require('ssr').open() end, mode = { 'n', 'x' } } },
    opts = {
      border = vim.g.border,
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_confirm = '<cr>',
        replace_all = '<leader><cr>',
      },
    },
  },
  {
    'gbprod/substitute.nvim',
    cond = false,
    keys = {
      { '+s', function() require('substitute.exchange').operator() end, mode = 'n' },
      { '+s', function() require('substitute.exchange').visual() end, mode = 'x' },
    },
    opts = {},
  },
  {
    'johmsalas/text-case.nvim',
    cond = false,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('textcase').setup({})
      require('telescope').load_extension('textcase')
    end,
    keys = {
      'ga', -- Default invocation prefix
      { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      'Subs',
      'TextCaseOpenTelescope',
      'TextCaseOpenTelescopeQuickChange',
      'TextCaseOpenTelescopeLSPChange',
      'TextCaseStartReplacingCommand',
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
}
