local Term = u.term
local HashList = u.hashlist

local MuxTerm = {}

MuxTerm.win = nil
-- if needed, we can manage windows here...
-- (share one win for multiple Terms, also without `WinLeave`)

local slots = HashList {} ---@type HashList
MuxTerm.slots = slots
MuxTerm.curr = slots.head

MuxTerm.i = 0
MuxTerm.get_key = function()
  MuxTerm.i = MuxTerm.i + 1
  return MuxTerm.i
end

-- 1. close term win on another tabpage
-- 2. close term win on leave (e.g. for flatten.nvim)
u.aug.muxterm_auto_close_float_win = {
  'WinLeave',
  {
    pattern = 'term://*',
    callback = function(ev)
      if vim.b[ev.buf].is_float_muxterm then
        if MuxTerm.curr.data then MuxTerm.curr.data:close() end
      end
    end,
  },
}

MuxTerm.winbar = function()
  local bar = {}
  slots:foreach(function(node)
    -- local key = node.data.title or node.key
    local hl = MuxTerm.curr == node and 'TabLineSel' or 'TabLine'
    local n = #bar + 1
    bar[n] = ('%%#%s# %s %%#TabLineFill#'):format(hl, n)
  end)
  return table.concat(bar)
end

MuxTerm.update_winbar = function(win)
  if not u.is.win_valid(win) then return end
  if vim.tbl_count(slots.hash) == 1 then
    vim.wo[win].winbar = nil
    return
  end
  if not vim.wo[win].winbar or vim.wo[win].winbar == '' then
    vim.wo[win].winbar = '%{%v:lua.u.muxterm.winbar()%}'
    return
  end
end

MuxTerm.size = function() return slots.size end

---@param to HashNode
---@param opts TermConfig?
---@param should_open boolean? open or not after switch
MuxTerm.switch_to = function(to, opts, should_open)
  if to == MuxTerm.curr then return end
  -- current node may have been deleted
  if not MuxTerm.is_empty() then MuxTerm.curr.data:close() end
  if to == slots.tail or to == slots.head then
    MuxTerm.curr = to
    return
  end
  if should_open ~= false then to.data:open(opts) end
  MuxTerm.update_winbar(to.data.win)
  MuxTerm.curr = to
end

MuxTerm.get_next = function()
  return MuxTerm.curr.next ~= slots.tail and MuxTerm.curr.next or slots.head.next
end

MuxTerm.get_prev = function()
  return MuxTerm.curr.prev ~= slots.head and MuxTerm.curr.prev or slots.tail.prev
end

-- should switch to which node after current node deleted
MuxTerm.get_near = function()
  return MuxTerm.curr.next ~= slots.tail and MuxTerm.curr.next or slots.tail.prev
end

MuxTerm.cycle_next = function(opts) MuxTerm.switch_to(MuxTerm.get_next(), opts) end

MuxTerm.cycle_prev = function(opts) MuxTerm.switch_to(MuxTerm.get_prev(), opts) end

---@return boolean
MuxTerm.is_empty = function() return MuxTerm.curr == slots.head end

---@return boolean
MuxTerm.is_focusd = function() return not MuxTerm.is_empty() and MuxTerm.curr.data:is_focusd() end

---@param opts TermConfig?
---then switch to it (currently, only start exec on the first focus...)
---WIP: why open it...
MuxTerm.spawn = function(opts)
  -- hook on term close
  local delete = function()
    slots:delete(MuxTerm.curr)
    -- if current tab is open, then when it deleted, try open next
    local curr_is_open = MuxTerm.is_focusd()
    MuxTerm.switch_to(MuxTerm.get_near(), nil, curr_is_open)
  end

  local on_exit = function()
    if opts and opts.on_exit then opts.on_exit() end
    delete()
  end

  local term = Term { on_exit = on_exit }
  vim.b[term.buf].is_float_muxterm = true -- maybe we can also use filetype here
  local node = { key = MuxTerm.get_key(), data = term }
  slots:insert_after(MuxTerm.curr, node)
  MuxTerm.cycle_next(opts)
end

---@param opts TermConfig?
MuxTerm.open = function(opts)
  if not MuxTerm.is_empty() then
    MuxTerm.curr.data:open(opts)
    return
  end
  MuxTerm.spawn(opts)
end

MuxTerm.close = function()
  if MuxTerm.is_empty() then return end
  MuxTerm.curr.data:close()
end

---@param opts TermConfig?
MuxTerm.toggle = function(opts)
  if MuxTerm.is_focusd() then
    MuxTerm.close()
    return
  end
  MuxTerm.open(opts)
end

---@param cmd TermCmd
MuxTerm.send = function(cmd, do_open)
  if do_open ~= false then MuxTerm.open() end
  if MuxTerm.is_empty() then
    MuxTerm.spawn()
    vim.wait(30) -- hack: wait fish prompt...
    MuxTerm.curr.data:send(cmd)
  end
end

return MuxTerm
