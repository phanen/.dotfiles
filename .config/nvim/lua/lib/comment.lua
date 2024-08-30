local M = {}

-- https://github.com/neovim/neovim/discussions/28995
local comment_above_or_below = function(lnum)
  local row = fn.line '.'
  local comment_row = row + lnum
  local l_cms, r_cms = string.match(vim.bo.commentstring, '(.*)%%s(.*)')
  l_cms = vim.trim(l_cms)
  r_cms = vim.trim(r_cms)
  if r_cms ~= 0 then r_cms = ' ' .. r_cms end
  api.nvim_buf_set_lines(0, comment_row, comment_row, false, { l_cms .. ' ' .. r_cms })
  api.nvim_win_set_cursor(0, { comment_row + 1, 0 })
  -- TODO: no syntax ):
  api.nvim_command('normal! ==')
  api.nvim_win_set_cursor(0, { comment_row + 1, #api.nvim_get_current_line() - #r_cms - 1 })
  api.nvim_feedkeys('a', 'ni', true)
end

-- FIXME: broken
M.comment_below = comment_above_or_below(1)
M.comment_above = comment_above_or_below(0)

return M
