-- kwkarlwang/bufjump.nvim
-- famiu/bufdelete.nvim

local M = {}

local jumpbackward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-o>'), 'n', false)
end

local jumpforward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-i>'), 'n', false)
end

---@param stop_cond fun(from_bufnr: number, to_bufnr: number):boolean
M.backward_cond = function(stop_cond)
  local jumplist, to_pos = unpack(fn.getjumplist())
  if #jumplist == 0 or to_pos == 0 then return end

  local from_bufnr = fn.bufnr()
  local from_pos = to_pos + 1
  repeat
    local to_bufnr = jumplist[to_pos].bufnr
    if stop_cond(from_bufnr, to_bufnr) then
      jumpbackward(from_pos - to_pos)
      return
    end
    to_pos = to_pos - 1
  until to_pos == 0
end

M.backward = function()
  M.backward_cond(
    function(from_bufnr, to_bufnr) return from_bufnr ~= to_bufnr and api.nvim_buf_is_valid(to_bufnr) end
  )
end

M.backward_same_buf = function()
  M.backward_cond(
    function(from_bufnr, to_bufnr) return from_bufnr == to_bufnr and api.nvim_buf_is_valid(to_bufnr) end
  )
end

---@param stop_cond fun(from_bufnr: number, to_bufnr: number):boolean
M.forward_cond = function(stop_cond)
  local getjumplist = fn.getjumplist()
  local jumplist, from_pos = getjumplist[1], getjumplist[2] + 1
  local max_pos = #jumplist
  if max_pos == 0 or from_pos >= max_pos then return end

  local from_bufnr = fn.bufnr()
  local to_pos = from_pos + 1
  repeat
    local to_bufnr = jumplist[to_pos].bufnr
    if stop_cond(from_bufnr, to_bufnr) then
      jumpforward(to_pos - from_pos)
      return
    end
    to_pos = to_pos + 1
  until to_pos == max_pos + 1
end

M.forward = function()
  M.forward_cond(
    function(from_bufnr, to_bufnr) return from_bufnr ~= to_bufnr and api.nvim_buf_is_valid(to_bufnr) end
  )
end

M.forward_same_buf = function()
  M.forward_cond(
    function(from_bufnr, to_bufnr) return from_bufnr == to_bufnr and api.nvim_buf_is_valid(to_bufnr) end
  )
end

M.delete = function()
  if fn.filereadable(fn.expand('%p')) == 0 and vim.bo.modified then
    local choice = fn.input('File is not saved, force delete? [y/N]')
    if choice == 'y' or string.len(choice) == 0 then vim.cmd('bd!') end
    return
  end

  local force = not vim.bo.buflisted or vim.bo.buftype == 'nofile'
  local buf = api.nvim_get_current_buf()
  vim.cmd(force and 'sil! bd!' or ('sil! bp | sil! bd! %s'):format(buf))
end

return M
