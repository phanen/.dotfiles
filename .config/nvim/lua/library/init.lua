local M = {}

function M.mux(cond, lhs, rhs) return (cond and { lhs } or { rhs })[1] end

return M
