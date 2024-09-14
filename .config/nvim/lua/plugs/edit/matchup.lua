return { -- not ready for main treesitter (but i don't use it anyway...)
  -- this cannot lazyload... or % don't work without :e
  -- https://github.com/andymass/vim-matchup/issues/327
  'andymass/vim-matchup',
  event = 'BufReadPost',
  keys = {
    { '%', '<plug>(matchup-%)', mode = { 'n', 'x', 'o' } },
    { 'ds%', '"_<plug>(matchup-ds%)', mode = { 'n' } },
    { 'cs%', '"_<plug>(matchup-cs%)', mode = { 'n' } },
  },
  init = function() vim.g.matchup_surround_enabled = 1 end,
  config = function()
    g.matchup_matchparen_enabled = 0
    g.matchup_matchparen_deferred = 1
    g.matchup_matchparen_offscreen = {}
    g.matchup_delim_stopline = 5000
  end,
}
