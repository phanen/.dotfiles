-- 'kwkarlwang/bufjump.nvim'
-- 'famiu/bufdelete.nvim'

local Bufop = {} ---@module "lib.bufop"

local jumpbackward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-o>'), 'n', false)
end

local jumpforward = function(num)
  api.nvim_feedkeys(vim.keycode(tostring(num) .. '<c-i>'), 'n', false)
end

---@param should_stop fun(frm: integer, to: integer):boolean
Bufop.backward_util = function(should_stop)
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
Bufop.forward_util = function(should_stop)
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

Bufop.backward_buf = function()
  Bufop.backward_util(function(frm, to) return frm ~= to end)
end

Bufop.backward_in_buf = function()
  Bufop.backward_util(function(frm, to) return frm == to end)
end

Bufop.forward_buf = function()
  Bufop.forward_util(function(frm, to) return frm ~= to end)
end

Bufop.forward_in_buf = function()
  Bufop.forward_util(function(frm, to) return frm == to end)
end

---@return nil
Bufop.delete = function()
  if fn.filereadable(fn.expand('%p')) == 0 and vim.bo.modified then
    local choice = fn.input('File is not saved, force delete? [y/N]')
    if choice == 'y' or choice:len() == 0 then
      -- vim.cmd('bd!')
      return api.nvim_buf_delete(0, { force = true })
    end
    return
  end

  local force = not vim.bo.buflisted or vim.bo.buftype == 'nofile'
  local buf = api.nvim_get_current_buf()
  vim.cmd(force and 'sil! bd!' or ('sil! bp | sil! bd! %s'):format(buf))
  -- lsp error: sematics token (maybe no autocmd?)
  -- api.nvim_buf_delete(0, {})
end

Bufop.delete_irrelavant = function()
  local root = fn.getcwd()
  vim
    .iter(api.nvim_list_bufs())
    :filter(
      function(buf)
        return vim.bo[buf].bt == '' and not u.fs.is_parent(root, api.nvim_buf_get_name(buf))
      end
    )
    :each(function(buf)
      if api.nvim_buf_is_valid(buf) then api.nvim_buf_delete(buf, { force = true }) end
    end)
end

return Bufop
