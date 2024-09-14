local R = {}

---@param modname string
---@return table
---https://github.com/neovim/neovim/pull/27216
R.req = function(modname)
  local mt = {
    __index = function(t, k)
      local v = require(modname)[k]
      --require('fidget').notify(('%s.%s'):format(modname, k))
      rawset(t, k, v)
      return v
    end,
    __call = function(_, ...) return require(modname)(...) end,
  }
  return setmetatable({}, mt)
end

R.lreg = {}

-- more lazy require, ++stacklevel
---@param modname string
---@return table
R.lreq = function(modname)
  -- local loaded = package.loaded[path]
  local lloaded = R.lreg[modname]
  if lloaded then return lloaded end
  local lmod = setmetatable({}, {
    __index = function(self, k)
      -- require('fidget').notify(('%s.%s'):format(modname, k))
      return function(...)
        local v = require(modname)[k] -- reduce stacklevel in the next reference
        if type(v) == 'function' then
          rawset(self, k, v)
          return v(...)
        end
        rawset(self, k, function() return v end)
        return v
      end
    end,
    __call = function(_, ...)
      local mod = require(modname)
      local mt = getmetatable(mod)
      if mt and mt.__call then return mod(...) end
      if type(mod) == 'function' then return mod(...) end
      return mod
    end,
  })
  rawset(R.lreg, modname, lmod)
  return lmod
end

---handle err in debug print
---@param modname string
R.xreq = function(modname)
  local ok, err = pcall(require, modname)
  -- if not ok then print(('[BAD] %s\n'):format(err)) end
end

return R
