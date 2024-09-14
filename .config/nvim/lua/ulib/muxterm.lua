local Term = u.term
local HashList = u.hashlist

local MuxTerm = {}
local slots = HashList {} ---@type HashList
MuxTerm.slots = slots
MuxTerm.curr = slots.head
local i = 1

local get_key = function()
  local key = i
  i = i + 1
  return key
end

-- 1. close term win on another tabpage
-- 2. close term win on leave (e.g. for flatten.nvim)
u.aug.muxterm_auto_close_float_win = {
  'WinLeave',
  {
    pattern = 'term://*',
    callback = function(ev)
      -- u.sysp('eeeeee')
      if vim.b[ev.buf].is_float_muxterm then
        if MuxTerm.curr.data then MuxTerm.curr.data:close() end
      end
    end,
  },
}

local update_winbar = function(win)
  if not u.is.win_valid(win) then return end
  if vim.tbl_count(slots.hash) == 1 then
    -- print('win2', win)
    vim.wo[win].winbar = nil
    return
  end
  if not vim.wo[win].winbar or vim.wo[win].winbar == '' then
    -- print('win3', win)
    vim.wo[win].winbar = '%{%v:lua.u.muxterm.winbar()%}'
    return
  end
end

local switch_to = function(to)
  if to == MuxTerm.curr then return end
  MuxTerm.curr.data:close()
  to.data:open()
  update_winbar(to.data.win)
  MuxTerm.curr = to
end

MuxTerm.winbar = function()
  local bar = {}
  slots:foreach(function(node)
    local key = node.data.title or node.key
    local hl = MuxTerm.curr == node and 'TabLineSel' or 'TabLine'
    bar[#bar + 1] = ('%%#%s# %s %%#TabLineFill#'):format(hl, key)
    -- { "%#TabLine# 1 %#TabLineFill#", "%#TabLine# 2 %#TabLineFill#", "%#TabLineSel# 3 %#TabLineFill#" }
  end)
  return table.concat(bar)
end

local delete = function()
  MuxTerm.slots:delete(MuxTerm.curr)
  local next_term =
    assert(MuxTerm.curr.next ~= MuxTerm.slots.tail and MuxTerm.curr.next or MuxTerm.slots.tail.prev)
  -- MuxTerm.curr.data:close(true)
  if next_term ~= slots.head then
    next_term.data:open()
    update_winbar(next_term.data.win)
  end
  MuxTerm.curr = next_term
end

MuxTerm.insert = function()
  local term = Term {
    auto_close = false, -- we handle all close procedure
    on_exit = function() delete() end,
  }
  -- maybe we can also use filetype here
  vim.b[term.buf].is_float_muxterm = true
  slots:insert_after(MuxTerm.curr, { key = get_key(), data = term })
end

MuxTerm.insert_then_switch = function()
  MuxTerm.insert()
  MuxTerm.cycle_next()
end

MuxTerm.toggle = function()
  -- no term now, create one
  if MuxTerm.curr == slots.head then
    MuxTerm.insert()
    local next_term = assert(MuxTerm.curr.next)
    next_term.data:open()
    MuxTerm.curr = next_term
    return
  end

  MuxTerm.curr.data:toggle()
end

MuxTerm.cycle_next = function()
  switch_to(MuxTerm.curr.next ~= slots.tail and MuxTerm.curr.next or slots.head.next)
end

MuxTerm.cycle_prev = function()
  switch_to(MuxTerm.curr.prev ~= slots.head and MuxTerm.curr.prev or slots.tail.prev)
end

return MuxTerm
