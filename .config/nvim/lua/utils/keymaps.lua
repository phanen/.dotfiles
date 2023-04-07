local M = {}

M.map = vim.keymap.set

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  M.map(mode, lhs, rhs, opts)
end

M.nmap = function(...) recursive_map('n', ...) end
M.imap = function(...) recursive_map('i', ...) end
M.nnoremap = function(...) M.map('n', ...) end
M.inoremap = function(...) M.map('i', ...) end
M.cnoremap = function(...) M.map('c', ...) end
M.vnoremap = function(...) M.map('v', ...) end
M.xnoremap = function(...) M.map('x', ...) end
M.onoremap = function(...) M.map('o', ...) end
M.tnoremap = function(...) M.map('t', ...) end
M.lnoremap = function(...) M.map('l', ...) end

return M
