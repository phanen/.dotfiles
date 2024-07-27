return setmetatable({}, {
  __index = function(self, key)
    local ok, local_util = pcall(require, 'mod.winbar.utils.' .. key)
    self[key] = ok and local_util or u[key]
    return self[key]
  end,
})
