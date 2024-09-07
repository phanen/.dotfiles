-- a meta abstract for vim.api.nvim_{buf_}set_keymap
-- vim.keymap.set is used to handle callback/commands (wip: which can be integrated here)
-- like vim.bo[bufnr], here is map.n[bufnr](lhs, rhs)
-- for more flags, curry feature maybe desired...
-- e.g. map.n[bufnr].expr.silent(lhs, rhs)
-- e.g. map.n.expr.silent(lhs, rhs)
-- e.g. map.n.expr[bufnr].silent(lhs, rhs)

-- save old ref, safe to change vim.keymap.set after this
-- TODO: maybe can reord its the args
-- TODO: how about n[bufnr](lhs, rhs).silent = 'desc string'
-- TODO: function... hashing picker
local keymap = vim.keymap.set

---@param mode string[]
---@param curr_opts table<string>?
local function new_mapper(mode, curr_opts)
  return setmetatable({}, {
    __index = function(curr, k)
      -- need different opts for each meta mapper
      local next_opts = vim.deepcopy(curr_opts or {}, true)
      if type(k) == 'number' then
        next_opts.buffer = k
      else
        next_opts[k] = true
      end
      local next = new_mapper(mode, next_opts)
      rawset(curr, k, next)
      return next
    end,
    -- TODO: deprecate arg _opts
    ---@param opts table[] to be deprecated
    __call = function(_, lhs, rhs, opts)
      -- if lhs == ' i' then u.print(lhs, rhs, curr_opts, opts) end
      return keymap(mode, lhs, rhs, vim.tbl_extend('force', curr_opts or {}, opts or {}))
    end,
  })
end

---cost = O(modes * max(bufnr) * #opts!)
return setmetatable({}, {
  ---@param mode string
  __index = function(map, mode)
    local next = new_mapper(vim.split(mode, ''))
    rawset(map, mode, next)
    return next
  end,
  __call = function(_, ...) return keymap(...) end,
})
