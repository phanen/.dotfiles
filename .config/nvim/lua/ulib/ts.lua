local ts_utils = require 'nvim-treesitter.ts_utils'
local locals = require 'nvim-treesitter.locals'
local parsers = require 'nvim-treesitter.parsers'
local queries = require 'nvim-treesitter.query'

local Ts = {}

---@type table<integer, table<TSNode|nil>>
local selections = {}

function Ts.init_selection()
  local buf = api.nvim_get_current_buf()
  local node = ts_utils.get_node_at_cursor()
  selections[buf] = { [1] = node }
  ts_utils.update_selection(buf, node)
end

---@param node TSNode
---@return boolean
local function range_matches(node)
  local csrow, cscol, cerow, cecol = u.buf.visual_range()
  local srow, scol, erow, ecol = ts_utils.get_vim_range { node:range() }
  return srow == csrow and scol == cscol and erow == cerow and ecol == cecol
end

---@param get_parent fun(node: TSNode): TSNode|nil
---@return fun():nil
local function select_incremental(get_parent)
  return function()
    local buf = api.nvim_get_current_buf()
    local nodes = selections[buf]

    local csrow, cscol, cerow, cecol = u.buf.visual_range()
    -- Initialize incremental selection with current selection
    if not nodes or #nodes == 0 or not range_matches(nodes[#nodes]) then
      local root = parsers.get_parser():parse()[1]:root()
      local node = root:named_descendant_for_range(csrow - 1, cscol - 1, cerow - 1, cecol)
      ts_utils.update_selection(buf, node)
      if nodes and #nodes > 0 then
        table.insert(selections[buf], node)
      else
        selections[buf] = { [1] = node }
      end
      return
    end

    -- Find a node that changes the current selection.
    local node = nodes[#nodes] ---@type TSNode
    while true do
      local parent = get_parent(node)
      if not parent or parent == node then
        -- Keep searching in the main tree
        -- TODO: we should search on the parent tree of the current node.
        local root = parsers.get_parser():parse()[1]:root()
        parent = root:named_descendant_for_range(csrow - 1, cscol - 1, cerow - 1, cecol)
        if not parent or root == node or parent == node then
          ts_utils.update_selection(buf, node)
          return
        end
      end
      node = parent
      local srow, scol, erow, ecol = ts_utils.get_vim_range { node:range() }
      local same_range = (srow == csrow and scol == cscol and erow == cerow and ecol == cecol)
      if not same_range then
        table.insert(selections[buf], node)
        if node ~= nodes[#nodes] then table.insert(nodes, node) end
        ts_utils.update_selection(buf, node)
        return
      end
    end
  end
end

Ts.node_incremental = select_incremental(function(node) return node:parent() or node end)

Ts.scope_incremental = select_incremental(function(node)
  local lang = parsers.get_buf_lang()
  if queries.has_locals(lang) then
    return locals.containing_scope(node:parent() or node)
  else
    return node
  end
end)

Ts.node_decremental = function()
  local buf = api.nvim_get_current_buf()
  local nodes = selections[buf]
  if not nodes or #nodes < 2 then return end

  table.remove(selections[buf])
  local node = nodes[#nodes] ---@type TSNode
  ts_utils.update_selection(buf, node)
end

return Ts
