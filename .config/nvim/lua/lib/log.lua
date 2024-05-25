local M = {}

M.warn = function(info, ...) vim.notify(info:format(...), vim.log.levels.WARN) end

return M
