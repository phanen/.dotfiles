return {
  'altermo/ultimate-autopair.nvim',
  event = { 'InsertEnter', 'CmdlineEnter' },
  opts = {
    fastwarp = { map = '<c-s>', cmap = '<c-s>', faster = true },
    -- support for <c-w> https://github.com/altermo/ultimate-autopair.nvim/issues/54
    -- bs = { map = { '<bs>', '<c-h>' }, cmap = { '<bs>', '<c-h>' } },
  },
  -- force insert )... e.g. <c-r>)
  config = function(_, opts)
    -- https://github.com/altermo/ultimate-autopair.nvim/issues/82
    local ua = require 'ultimate-autopair'
    ua.init {
      ua.extend_default(opts),
      {
        profile = 'map',
        p = -1,
        { 'i', ' ', function() return vim.v.count > 0 and ' ' or vim.keycode(' <C-g>u') end },
        { 'i', '-', function() return vim.v.count > 0 and '-' or vim.keycode('-<C-g>u') end },
      },
    }
  end,
}
