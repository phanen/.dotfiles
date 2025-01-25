local Repmv = {}

---@class repmv.state
---protocol pair
---@field fn_forward? function
---@field fn_backward? function
---protocol mux
---@field fn_nav? fun(opts: { forward: boolean }, ...)
---@field opts? { forward: boolean }
---@field args? table more args

---@type repmv.state?
local state = nil

Repmv.pair_wrap = function(fn_next, fn_prev)
  fn_prev, fn_next = vim.F.nil_wrap(fn_prev), vim.F.nil_wrap(fn_next)
  local n = function(...)
    state = { fn_forward = fn_next, fn_backward = fn_prev }
    return fn_next(...)
  end
  local p = function(...)
    state = { fn_forward = fn_prev, fn_backward = fn_next }
    return fn_prev(...)
  end
  return n, p
end

Repmv.wrap = function(fn_nav)
  fn_nav = vim.F.nil_wrap(fn_nav)
  return function(opts, ...)
    state = { fn_nav = fn_nav, opts = opts, args = { ... } }
    return fn_nav(opts, ...)
  end
end

Repmv.forward = function(m)
  if not state then return m end
  if state.fn_forward and state.fn_backward then -- pairwise case
    return vim.schedule(function() return state.fn_forward() end)
  end
  return vim.schedule(function() state.fn_nav(state.opts, unpack(state.args)) end)
end

Repmv.backward = function(m)
  if not state then return m end
  if state.fn_forward and state.fn_backward then
    return vim.schedule(function() return state.fn_backward() end)
  end
  local opts = vim.deepcopy(assert(state.opts), true)
  opts.forward = not opts.forward
  return vim.schedule(function() state.fn_nav(opts, unpack(state.args)) end)
end

---@param m "f" | "t" | "F" | "T"
Repmv.builtin = function(m)
  state = nil
  return m
end

local next_hunk = function() -- gitsigns handle v:count by itself
  if vim.wo.diff then return vim.cmd.normal { ']c', bang = true } end
  require('gitsigns').nav_hunk('next', { target = 'all' })
end
local prev_hunk = function()
  if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
  require('gitsigns').nav_hunk('prev', { target = 'all' })
end

local next_diag = function()
  return vim.diagnostic.jump { count = vim.v.count1, float = false, wrap = vim.o.wrapscan }
end
local prev_diag = function()
  return vim.diagnostic.jump { count = -vim.v.count1, float = false, wrap = vim.o.wrapscan }
end
local next_err = function()
  return vim.diagnostic.jump {
    count = vim.v.count1,
    float = false,
    wrap = vim.o.wrapscan,
    severity = vim.diagnostic.severity.ERROR,
  }
end
local prev_err = function()
  return vim.diagnostic.jump {
    count = -vim.v.count1,
    float = false,
    wrap = vim.o.wrapscan,
    severity = vim.diagnostic.severity.ERROR,
  }
end

local next_spel = function() return (pcall(vim.cmd.normal, { vim.v.count1 .. ']s', bang = true })) end
local prev_spel = function() return (pcall(vim.cmd.normal, { vim.v.count1 .. '[s', bang = true })) end

local next_fold = function() return (pcall(vim.cmd.normal, { vim.v.count1 .. 'zj', bang = true })) end
local prev_fold = function() return (pcall(vim.cmd.normal, { vim.v.count1 .. 'zk', bang = true })) end

local make_func = function(cmd_next, cmd_prev, cmd_head, cmd_tail)
  local n = function()
    if pcall(vim.cmd[cmd_next], { count = vim.v.count1 }) then return end
    if vim.o.wrapscan and cmd_head then return (pcall(vim.cmd[cmd_head], {})) end
  end
  local p = function()
    if pcall(vim.cmd[cmd_prev], { count = vim.v.count1 }) then return end
    if vim.o.wrapscan and cmd_tail then return (pcall(vim.cmd[cmd_tail], {})) end
  end
  return n, p
end

-- WIP: conflict, comment block, diagnostic-with-level, travel-tree, arglist, tabpage, taglist...
Repmv.next_h, Repmv.prev_h = Repmv.pair_wrap(next_hunk, prev_hunk)
Repmv.next_d, Repmv.prev_d = Repmv.pair_wrap(next_diag, prev_diag)
Repmv.next_e, Repmv.prev_e = Repmv.pair_wrap(next_err, prev_err)
Repmv.next_q, Repmv.prev_q = Repmv.pair_wrap(make_func('cnext', 'cprev', 'cfirst', 'clast'))
Repmv.next_l, Repmv.prev_l = Repmv.pair_wrap(make_func('lnext', 'lprev', 'lfirst', 'llast'))
Repmv.next_b, Repmv.prev_b = Repmv.pair_wrap(make_func('bnext', 'bprev', 'bfirst', 'blast'))
Repmv.next_s, Repmv.prev_s = Repmv.pair_wrap(next_spel, prev_spel)
Repmv.next_z, Repmv.prev_z = Repmv.pair_wrap(next_fold, prev_fold)
Repmv.next_O, Repmv.prev_O = Repmv.pair_wrap(u.bufjump.forward_buf, u.bufjump.backward_buf)
Repmv.next_o, Repmv.prev_o = Repmv.pair_wrap(u.bufjump.forward_in_buf, u.bufjump.backward_in_buf)

-- useful for dap mode
Repmv.hydra = function(keys)
  -- this will keep the popup open until you hit <esc>
  return require('which-key').show { keys = keys, loop = true }
end

return Repmv
