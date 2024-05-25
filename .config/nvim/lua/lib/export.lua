local M = {}

-- HACK: register string named local variable to m
-- idk if its the right way...
M.export = function(m, t)
  for _, v in ipairs(t) do
    m[v] = v
  end

  m[table] = debug.getlocal(2, 1)
  m[table] = debug.getlocal()
end

return M
