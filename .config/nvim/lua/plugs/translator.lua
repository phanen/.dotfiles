return {
  'voldikss/vim-translator',
  cmd = { 'Translate', 'TranslateW' },
  init = function()
    -- { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    g.translator_window_borderchars = { '━', '┃', '━', '┃', '┏', '┓', '┛', '┗' }
  end,
}
