local M = {}

M.qf_toggle = function()
  if vim.iter(vim.fn.getwininfo()):any(function(win) return win.quickfix == 1 end) then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end

M.qf_delete = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local qflist = vim.fn.getqflist()
  local linenr = vim.api.nvim_win_get_cursor(0)[1]
  local mode = vim.api.nvim_get_mode().mode
  if mode:match('[vV]') then
    local first_line = vim.fn.getpos("'<")[2]
    local last_line = vim.fn.getpos("'>")[2]
    qflist = vim
      .iter(qflist)
      :filter(function(_, i) return i < first_line or i > last_line end)
      :totable()
  else
    table.remove(qflist, linenr)
  end
  -- replace items in the current list, do not make a new copy of it; this also preserves the list title
  vim.fn.setqflist({}, 'r', { items = qflist })
  vim.fn.setpos('.', { bufnr, linenr, 1, 0 }) -- restore current line
end

return M
