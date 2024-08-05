local M = {}

M.yank_filename = function()
  -- TODO: fs.normalize fn.expand
  local path = fs.normalize(api.nvim_buf_get_name(0))
  fn.setreg('+', (path:gsub(('^%s'):format(env.HOME), '~')))
end

M.force_close_tabpage = function()
  if #api.nvim_list_tabpages() == 1 then
    vim.cmd('quit!')
  else
    vim.cmd('tabclose!')
  end
end

M.blank_above = function()
  local repeated = fn['repeat']({ '' }, vim.v.count1)
  local lnum = fn.line('.') - 1
  api.nvim_buf_set_lines(0, lnum, lnum, true, repeated)
end

M.blank_below = function()
  local repeated = fn['repeat']({ '' }, vim.v.count1)
  local lnum = fn.line('.')
  api.nvim_buf_set_lines(0, lnum, lnum, true, repeated)
end

return M
