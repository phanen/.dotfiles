return {
  'andymass/vim-matchup',
  event = 'BufReadPost',
  keys = {
    { '%', mode = { 'n', 'x', 'o' } },
    { 'ds%', '"_<plug>(matchup-ds%)', mode = { 'n' } },
    { 'cs%', '"_<plug>(matchup-cs%)', mode = { 'n' } },
  },
  init = function() vim.g.matchup_surround_enabled = 1 end,
  config = function()
    vim.g.matchup_matchparen_enabled = 0
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_offscreen = {}
    vim.g.matchup_delim_stopline = 5000
  end,
}
