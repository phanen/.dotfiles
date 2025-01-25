-- 'kwkarlwang/bufjump.nvim'
local Bufjump = {}

local jumpbackward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-o>'), 'n', false)
end

local jumpforward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-i>'), 'n', false)
end

---@param should_stop fun(frm: integer, to: integer):boolean
Bufjump.backward_util = function(should_stop)
  local jumplist, to_pos = unpack(fn.getjumplist())
  if #jumplist == 0 or to_pos == 0 then return end

  local frm_buf = fn.bufnr()
  local frm_pos = to_pos + 1
  repeat
    local to_buf = jumplist[to_pos].bufnr
    if api.nvim_buf_is_valid(to_buf) and should_stop(frm_buf, to_buf) then
      jumpbackward(frm_pos - to_pos)
      return
    end
    to_pos = to_pos - 1
  until to_pos == 0
end

---@param should_stop fun(frm: integer, to: integer):boolean
Bufjump.forward_util = function(should_stop)
  local getjumplist = fn.getjumplist()
  local jumplist, frm_pos = getjumplist[1], getjumplist[2] + 1
  local max_pos = #jumplist
  if max_pos == 0 or frm_pos >= max_pos then return end

  local frm_buf = fn.bufnr()
  local to_pos = frm_pos + 1
  repeat
    local to_buf = jumplist[to_pos].bufnr
    if api.nvim_buf_is_valid(to_buf) and should_stop(frm_buf, to_buf) then
      jumpforward(to_pos - frm_pos)
      return
    end
    to_pos = to_pos + 1
  until to_pos == max_pos + 1
end

Bufjump.backward_buf = function()
  Bufjump.backward_util(function(frm, to) return frm ~= to end)
end

Bufjump.backward_in_buf = function()
  Bufjump.backward_util(function(frm, to) return frm == to end)
end

Bufjump.forward_buf = function()
  Bufjump.forward_util(function(frm, to) return frm ~= to end)
end

Bufjump.forward_in_buf = function()
  Bufjump.forward_util(function(frm, to) return frm == to end)
end

return Bufjump
