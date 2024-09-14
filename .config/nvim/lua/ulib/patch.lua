-- patch vim's lua runtime lib

local Patch = vim.defaulttable()

-- upstream: https://github.com/LuaLS/lua-language-server/issues/2451
-- note: this patch not work for fzf-lua
--   since it rewrite its own `localtion_handler`
--   and use `vim.lsp.utils.locations_to_items` item by item
Patch.lsp.util.locations_to_items = (function(overriden)
  return function(locations, offset_encoding)
    local lines = {}
    local new_locations = {}
    for _, loc in ipairs(locations) do
      local uri = loc.uri or loc.targetUri
      local range = loc.range or loc.targetSelectionRange
      if not lines[uri .. range.start.line] then
        new_locations[#new_locations + 1] = loc
        lines[uri .. range.start.line] = true
      end
    end
    return overriden(new_locations, offset_encoding)
  end
end)(vim.lsp.util.locations_to_items)

Patch.ui = u.req('ulib.patch.ui')

Patch.text = u.req('ulib.patch.text')

return Patch
