-- meta abstractions
local M = {}

local api = vim.api

-- save old ref, safe to change vim.keymap.set after this
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
local keymap = function(mode, lhs, rhs, opts)
  -- TODO: ideally we should not need it
  -- opts = opts or {}
  opts = vim.deepcopy(opts or {}, true)

  ---@cast mode string[]
  mode = type(mode) == 'string' and { mode } or mode

  if opts.expr and opts.replace_keycodes ~= false then opts.replace_keycodes = true end

  if opts.remap == nil then
    opts.noremap = true
  else
    opts.noremap = not opts.remap
    opts.remap = nil ---@type boolean?
  end

  if type(rhs) == 'function' then
    opts.callback = rhs
    rhs = ''
  end

  if opts.buffer then
    local bufnr = opts.buffer == true and 0 or opts.buffer --[[@as integer]]
    opts.buffer = nil ---@type integer?
    for _, m in ipairs(mode) do
      api.nvim_buf_set_keymap(bufnr, m, lhs, rhs, opts)
    end
  else
    opts.buffer = nil
    for _, m in ipairs(mode) do
      api.nvim_set_keymap(m, lhs, rhs, opts)
    end
  end
end

---@param mode string[]
---@param curr_opts table<string>?
local function new_mapper(mode, curr_opts)
  return setmetatable({}, {
    __index = function(self, flag)
      -- need different opts for each meta mapper
      local next_opts = vim.deepcopy(curr_opts or {}, true)
      if type(flag) == 'number' then
        next_opts.buffer = flag
      else
        next_opts[flag] = true
      end
      rawset(self, flag, new_mapper(mode, next_opts))
      return rawget(self, flag)
    end,
    -- TODO: deprecate arg _opts
    ---@param opts table[] to be deprecated
    __call = function(_, lhs, rhs, opts)
      return keymap(mode, lhs, rhs, u.merge(curr_opts or {}, opts or {}))
    end,
    __newindex = function(_, lhs, rhs) return keymap(mode, lhs, rhs, curr_opts) end,
  })
end

---cost = O(modes * max(bufnr) * #opts!)
---@type table
M.map = setmetatable({}, {
  ---@param mode string
  __index = function(self, mode)
    rawset(self, mode, new_mapper(vim.split(mode, '')))
    return rawget(self, mode)
  end,
  __call = function(_, ...) return keymap(...) end,
})

M.augroup = setmetatable({}, {
  ---@param name string
  ---@param opts table event with handler { ev1, args1, ev2, args2, ... }
  __newindex = function(self, name, opts)
    rawset(self, name, opts)
    local id = api.nvim_create_augroup(name, {})
    for i = 1, #opts, 2 do
      local event = opts[i]
      local _opts = opts[i + 1]
      local ty = type(_opts)
      if ty == 'string' then
        _opts = { command = _opts }
      elseif ty == 'function' then
        _opts = { callback = _opts }
      end
      _opts.group = id
      api.nvim_create_autocmd(event, _opts)
    end
  end,
})

M.command = setmetatable({}, {
  --- @param name string
  --- @param opts string|function|vim.api.keyset.user_command
  __newindex = function(self, name, opts)
    rawset(self, name, opts)
    if type(opts) == 'function' or type(opts) == 'string' then
      return api.nvim_create_user_command(name, opts, {})
    end
    local command = opts[1]
    opts[1] = nil
    return api.nvim_create_user_command(name, command, opts)
  end,
})

return M
