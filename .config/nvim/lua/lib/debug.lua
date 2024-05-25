local M = {}

-- should be require only once
M.script_path = function() return fn.resolve(debug.getinfo(2, 'S').short_src) end

return M
