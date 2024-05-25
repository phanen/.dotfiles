return setmetatable({}, {
  __index = function(t, k)
    t[k] = require('lib.' .. k)
    return t[k]
  end,
})
