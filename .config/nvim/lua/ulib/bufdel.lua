-- 'famiu/bufdelete.nvim'
-- 'folke/snacks.nvim'

-- delete buf while keep window layout
local Bufdel = {}

---@alias Bufdel.opts { filter: integer|integer[]|(fun(buf: integer):boolean), cmd: 'bdelete'|'bwipeout' }

-- single buf, multiple bufs, or filter on all buf
---@param opts? Bufdel.opts
function Bufdel.del(opts)
  opts = opts or {}
  local bufs = type(opts.filter) == 'function' ---@diagnostic disable-next-line: param-type-mismatch
      and vim.tbl_filter(opts.filter, api.nvim_list_bufs())
    or type(opts.filter) == 'table' and opts.filter
    or { opts.filter or api.nvim_get_current_buf() }

  ---@param buf integer
  local del_buf = function(buf)
    buf = buf == 0 and api.nvim_get_current_buf() or buf -- win_findbuf don't accept 0
    vim -- ensure buf is hidden in all window (by alt/bp/enew)
      .iter(fn.win_findbuf(buf))
      :filter(api.nvim_win_is_valid)
      :each(function(win)
        local alt = api.nvim_buf_call(buf, function() return fn.bufnr('#') end)
        if alt ~= buf and fn.buflisted(alt) == 1 then
          api.nvim_win_set_buf(win, alt)
          return
        end
        -- double check (bp may do nothing)
        if pcall(vim.cmd.bprev) and buf ~= api.nvim_win_get_buf(win) then return end
        local new_buf = api.nvim_create_buf(true, false)
        api.nvim_win_set_buf(win, new_buf)
      end)
    if not api.nvim_buf_is_valid(buf) then return end
    local cmd = vim.cmd[opts.cmd or 'bdelete']
    pcall(cmd, { bang = true, args = { buf } })
  end

  vim -- align
    .iter(bufs)
    :filter(function(buf) return vim.bo[buf].buflisted end)
    :each(del_buf)
end

function Bufdel.all()
  return Bufdel.del { filter = function() return true end }
end

function Bufdel.only()
  return Bufdel.del { filter = function(b) return b ~= api.nvim_get_current_buf() end }
end

return Bufdel
