local M = {}

M.warn = function(info, ...) vim.notify(info:format(...), vim.log.levels.WARN) end

-- make it simple...
M.ferr = function(msg, ...) api.nvim_err_writeln(msg:format(...)) end
M.fwarn = function(msg, ...) api.nvim_echo({ { msg:format(...), 'WarningMsg' } }, true, {}) end
M.finff = function(msg, ...) api.nvim_echo({ { msg:format(...), 'MoreMsg' } }, true, {}) end

M.hl_echo = function(msg, hl) return api.nvim_echo({ { msg, hl } }, true, {}) end

return M
