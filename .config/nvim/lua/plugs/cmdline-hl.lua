return {
  -- crash on '/'
  {
    'Sam-programs/cmdline-hl.nvim',
    cond = false,
    event = 'VimEnter',
    config = function()
      local cl = require('cmdline-hl')
      require('cmdline-hl.scripts').Cd_command()
      cl.setup({
        custom_types = {
          ['Cd'] = { show_cmd = true },
        },
        aliases = {
          ['cd'] = { str = 'Cd' },
        },
      })
    end,
  },
}
