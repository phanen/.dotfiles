return {
  'zbirenbaum/copilot.lua', -- ? this won't prompt when edit in the middle of line
  cond = not g.leetcode,
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    panel = { layout = { position = 'right', ratio = 0.4 } },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = false,
        next = false,
        prev = false,
        dismiss = false,
      },
    },
  },
}
