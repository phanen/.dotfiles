return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    fastwarp = { map = '<c-s>', cmap = '<c-s>', faster = true },
    -- support for <c-w> https://github.com/altermo/ultimate-autopair.nvim/issues/54
    -- bs = { map = { '<bs>', '<c-h>' }, cmap = { '<bs>', '<c-h>' } },
  },
  config = function(_, opts)
    -- https://github.com/altermo/ultimate-autopair.nvim/issues/82
    local ua = require 'ultimate-autopair'
    ua.init {
      ua.extend_default(opts),
      {
        profile = 'map',
        p = -1,
        {
          'i',
          ' ',
          function()
            if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return vim.keycode(' ') end
            return vim.keycode(' <C-g>u')
          end,
        },
        {
          'i',
          '-',
          function()
            if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then return vim.keycode('-') end
            return vim.keycode('-<C-g>u')
          end,
        },
      },
    }
  end,
}
