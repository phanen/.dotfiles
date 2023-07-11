local fn = vim.fn

return {
  -- "Pocco81/auto-save.nvim",
  -- FIXME: immediate_save actually not work
  "okuuva/auto-save.nvim",
  event = "VeryLazy",
  opts = {
    execution_message = {
      enabled = false,
    },
    debounce_delay = 0,
    condition = function(buf)
      local utils = require('auto-save.utils.data')

      -- don't save for special-buffers
      if fn.getbufvar(buf, '&buftype') ~= '' then
        return false
      end
      if utils.not_in(fn.getbufvar(buf, '&filetype'), { '' }) then
        return true
      end
      return false
    end,
    trigger_event = {
      immediate_save = { "BufLeave", "FocusLost", "InsertLeave", "TextChanged" },
      defer_save = {},
      cancel_defered_save = {},
    },

  },
}
-- au TextChanged,TextChangedI <buffer> if &readonly == 0 && filereadable(bufname('%')) | silent write | endif
