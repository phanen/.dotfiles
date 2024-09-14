return {
  'okuuva/auto-save.nvim',
  cond = true,
  event = { 'InsertLeave', 'TextChanged' },
  opts = {
    execution_message = { enabled = false },
    debounce_delay = 125,
    condition = function(bufnr)
      local utils = require 'auto-save.utils.data'
      if fn.getbufvar(bufnr, '&buftype') ~= '' then return false end
      if utils.not_in(fn.getbufvar(bufnr, '&filetype'), { '' }) then return true end
      return false
    end,
  },
}
