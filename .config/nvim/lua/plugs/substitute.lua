return {
  {
    'cshuaimin/ssr.nvim',
    cond = false,
    keys = { { '+r', function() require('ssr').open() end, mode = { 'n', 'x' } } },
  },
  {
    'gbprod/substitute.nvim',
    cond = false,
    keys = {
      { '+s', function() require('substitute.exchange').operator() end, mode = 'n' },
      { '+s', function() require('substitute.exchange').visual() end, mode = 'x' },
    },
    config = true,
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
