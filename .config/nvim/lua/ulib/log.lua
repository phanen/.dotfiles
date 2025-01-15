local M = {}

M.warn = function(info, ...) vim.notify(info:format(...), vim.log.levels.WARN) end

-- make it simple...
M.ferr = function(msg, ...) api.nvim_echo({ { msg:format(...) } }, true, { err = true }) end
M.fwarn = function(msg, ...) api.nvim_echo({ { msg:format(...), 'WarningMsg' } }, true, {}) end
M.finfo = function(msg, ...) api.nvim_echo({ { msg:format(...), 'MoreMsg' } }, true, {}) end

M.hl_echo = function(msg, hl) return api.nvim_echo({ { msg, hl } }, true, {}) end

return M
