local M = {}

---Get winbar(s)
---@param opts {win: integer?, buf: integer?}?
---@return (winbar_t?)|table<integer, winbar_t>|table<integer, table<integer, winbar_t>>
M.get = function(opts)
  opts = opts or {}
  if opts.buf then
    -- if not api.nvim_buf_is_valid(opts.buf) then return end
    if opts.win then
      -- if not api.nvim_win_is_valid(opts.win) then return end
      local bars = rawget(_G._winbar.bars, opts.buf)
      return bars and rawget(bars, opts.win)
    end
    return rawget(_G._winbar.bars, opts.buf) or {}
  end
  if opts.win then
    -- if not api.nvim_win_is_valid(opts.win) then return end
    local buf = api.nvim_win_get_buf(opts.win)
    return rawget(_G._winbar.bars, buf) and rawget(_G._winbar.bars[buf], opts.win)
  end
  return _G._winbar.bars
end

---Call method on winbar(s), given the winid and/or bufnr
---@param method string
---@param opts {win: integer?, buf: integer?, params: table?}?
---@return any?: return values of the method
M.exec = function(method, opts)
  opts = opts or {}
  opts.params = opts.params or {}
  local winbars = M.get(opts)
  if not winbars or vim.tbl_isempty(_winbar) then return end
  if opts.win then return winbars[method](winbars, unpack(opts.params)) end
  if opts.buf then
    local results = {}
    for _, winbar in pairs(winbars) do
      results[#results + 1] = { winbar[method](winbar, unpack(opts.params)) }
    end
    return results
  end
  local results = {}
  for _, buf_winbars in pairs(winbars) do
    for _, winbar in pairs(buf_winbars) do
      results[#results + 1] = { winbar[method](winbar, unpack(opts.params)) }
    end
  end
  return results
end

---@type winbar_t?
local last_hovered_winbar = nil

---Update winbar hover highlights given the mouse position
---@param mouse table
M.update_hover_hl = function(mouse)
  local winbar = M.get { win = mouse.winid }
  if not winbar or mouse.winrow ~= 1 or mouse.line ~= 0 then
    if last_hovered_winbar then
      last_hovered_winbar:update_hover_hl()
      last_hovered_winbar = nil
    end
    return
  end
  if last_hovered_winbar and last_hovered_winbar ~= winbar then
    last_hovered_winbar:update_hover_hl()
  end
  winbar:update_hover_hl(math.max(0, mouse.wincol - 1))
  last_hovered_winbar = winbar
end

return M
