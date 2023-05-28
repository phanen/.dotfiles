local M = {}

M.map = vim.keymap.set

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map(mode, lhs, rhs, opts)
end

-- `:h map-table`

M.nremap = function(...) recursive_map('n', ...) end
M.iremap = function(...) recursive_map('i', ...) end
M.nmap = function(...) M.map('n', ...) end
M.imap = function(...) M.map('i', ...) end
M.cmap = function(...) M.map('c', ...) end
M.vmap = function(...) M.map('v', ...) end
M.xmap = function(...) M.map('x', ...) end
M.omap = function(...) M.map('o', ...) end
M.tmap = function(...) M.map('t', ...) end
M.lmap = function(...) M.map('l', ...) end

return M
