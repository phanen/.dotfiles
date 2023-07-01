local api = vim.api

local M = {}

M.toggle_bg = function() vim.o.background = (vim.o.background == 'dark' and 'light' or 'dark') end

M.next_colorscheme = (function()
  local id = 1
  local tab = { 'kanagawa-lotus', 'default', 'nordfox', 'tokyonight', 'catppuccin', 'rose-pine', 'doom-one' }
  return function()
    id = (id + 1) % #tab
    vim.cmd('colorscheme ' .. tab[id + 1])
  end
end)()


-- toggle last char (type or existance)
---@param c string
---@return function
function M.toggle_last_char(c)
  local delimiters = { ',', ';' }
  return function()
    local line = api.nvim_get_current_line()
    -- ("somestring"):sub(-1)
    local last_char = line:sub(-1)
    if last_char == c then
      api.nvim_set_current_line(line:sub(1, #line - 1))
    elseif vim.tbl_contains(delimiters, last_char) then
      api.nvim_set_current_line(line:sub(1, #line - 1) .. c)
    else
      api.nvim_set_current_line(line .. c)
    end
  end
end

return M
