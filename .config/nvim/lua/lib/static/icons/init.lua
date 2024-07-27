local mt = {}

function mt:__index(key)
  for _, icons in pairs(self) do
    if icons[key] then return icons[key] end
  end
  return mt[key]
end

---Flatten the layered icons table into a single type-icon table.
---@return table<string, string>
function mt:flatten()
  local result = {}
  for _, icons in pairs(self) do
    for type, icon in pairs(icons) do
      result[type] = icon
    end
  end
  return result
end

local m = vim.g.no_nf and require('lib.static.icons._icons_no_nf')
  or require('lib.static.icons._icons')

function mt:__call() return m end

return setmetatable(m, mt)
