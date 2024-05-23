local M = {}

M.qf_toggle = function()
  local has_qf = vim.iter(fn.getwininfo()):any(function(win) return win.quickfix == 1 end)
  vim.cmd[has_qf and 'cclose' or 'copen']()
end

M.qf_delete = function()
  local bufnr = api.nvim_get_current_buf()
  local qflist = fn.getqflist()
  local lnum = fn.line '.'
  local mode = api.nvim_get_mode().mode
  if mode:match('[vV]') then
    api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
    local first_lnum = fn.line "'<"
    local last_lnum = fn.line "'>"
    print(first_lnum, last_lnum)

    qflist = vim
      .iter(ipairs(qflist))
      :filter(function(i)
        vim.print(i)
        return i < first_lnum or i > last_lnum
      end)
      :totable()
  else
    table.remove(qflist, lnum)
  end

  -- replace items in the current list, do not make a new copy of it; this also preserves the list title
  fn.setqflist({}, 'r', { items = qflist })
  fn.setpos('.', { bufnr, lnum, 1, 0 }) -- restore current line
end

return M
