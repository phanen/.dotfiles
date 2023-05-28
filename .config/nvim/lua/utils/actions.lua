local M = {}

M.toggle_bg = function() vim.o.background = (vim.o.background == 'dark' and 'light' or 'dark') end

M.next_colorscheme = (function()
  local id = 1
  local tab = { 'nordfox', 'tokyonight', 'catppuccin', 'rose-pine', 'doom-one' }
  return function()
    id = (id + 1) % #tab
    vim.cmd('colorscheme ' .. tab[id + 1])
  end
end)()

return M
