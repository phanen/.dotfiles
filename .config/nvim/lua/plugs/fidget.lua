return {
  'j-hui/fidget.nvim',
  event = 'LspAttach',
  opts = {
    notification = { poll_rate = 10, override_vim_notify = false },
    progress = { poll_rate = 0 },
    integration = { ['nvim-tree'] = { enable = false } },
  },
}
