return {
  'zbirenbaum/copilot.lua', -- ? this won't prompt when edit in the middle of line
  cond = fn.argv()[1] ~= 'leetcode.nvim',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    panel = { layout = { position = 'right', ratio = 0.4 } },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<a-s>',
        accept_word = '<a-f>',
        accept_line = '<a-e>',
        next = '<a-n>',
        prev = '<a-p>',
        dismiss = '<a-c>',
      },
    },
  },
}
