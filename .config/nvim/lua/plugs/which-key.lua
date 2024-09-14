return {
  'folke/which-key.nvim',
  cond = true,
  event = 'VeryLazy',
  keys = {
    {
      '<leader>?',
      function() require('which-key').show({ global = false }) end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
  -- note:
  -- 1. <c-s> feedkey need register...
  -- 2. "_d/c still pend (since we have `ds` `c*`), workaround: maybe "undo" some map??
  opts = {
    preset = 'helix',
    delay = 200,
    plugins = { spelling = { enabled = false } },
    win = { -- `scrolloff` matter here
      border = g.border,
      title = false,
    },
    keys = { scroll_down = '<a-d>', scroll_up = '<a-u>' },
    icons = { rules = false },
    show_help = false,
    show_keys = false, -- also need `win.title = false`
  },
}
