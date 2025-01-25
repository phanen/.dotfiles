-- always use conform to better handle extmark
local Fmt = {}

Fmt = setmetatable({}, {
  __index = function(t, k)
    local default = { formatters = { k } }
    local f = function(opts)
      opts = u.merge(default, opts or {})
      return require('conform').format(opts)
    end
    rawset(t, k, f)
    return f
  end,
  __call = function(_, opts) return require('conform').format(opts) end,
})

return Fmt
