local M = {}
M.toggle_bg = function() vim.o.background = vim.o.background == 'dark' and 'light' or 'dark' end
return M
