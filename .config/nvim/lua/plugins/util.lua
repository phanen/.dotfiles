return {
  -- toggle fold
  -- {
  --   'jghauser/fold-cycle.nvim',
  --   config = true,
  --   keys = {
  --     { '<leader>of', function() require('fold-cycle').open() end, desc = 'fold-cycle: toggle' },
  --   },
  -- },

  -- diff arbitrary blocks of text with each other
  { "AndrewRadev/linediff.vim", cmd = "Linediff" },
  { "jspringyc/vim-word", cmd = { "WordCount", "WordCountLine" } },
}
