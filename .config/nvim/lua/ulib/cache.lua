local Cache = {}

-- func = cache_tablize(func), -> func[one_arg_only]
---@generic T
---@param cb fun(...): T
---@return table<string|number, T>
---@see vim.func.__memoize
Cache.tablize = function(cb)
  return setmetatable({}, {
    __index = function(t, key)
      local v = cb(key)
      rawset(t, key, v)
      return v
    end,
  })
end

-- it provide hash = resolve_hash(hash) to give key
---@generic T
---@param cb fun(...): T
---@param hash fun(...): string|number
---@return fun(...): T
---@see vim.func.__memoize
Cache.hash = function(cb, hash)
  local f = Cache.tablize(cb)
  return function(...)
    if hash then
      local key = hash(...)
      return f[key]
    end
    -- local first = ...
    return f[...]
  end
end

---@generic T
---@param cb fun(): T
---@return fun(): T
Cache.one = function(cb)
  local cache
  return function()
    if cache then return cache end
    cache = cb()
    return cache
  end
end

return Cache
