local Refactor = {}

local fmt = {
  lua = function(content) return ('return %s'):format(content) end,
}

-- src + dst
-- src? cursor+treesitter(no motion), or cursor+motion(like `gcip`), visual

--- extract range to given path
---@param path? string
---@param delete? boolean delete sel
Refactor.to_file = function(path, delete)
  local mode = api.nvim_get_mode().mode
  local pos1, pos2 = fn.getpos '.', fn.getpos 'v'
  local lines = fn.getregion(pos1, pos2, { type = mode })
  local buf = api.nvim_get_current_buf()
  path = path or fn.expand('%:p:h') .. '/'
  vim.ui.input(
    { prompt = 'Extract to:', default = path },
    vim.schedule_wrap(function(input)
      path = vim.trim(input)
      local content = table.concat(lines, '\n')
      local f = vim.b[buf].refactor_format or fmt[vim.bo[buf].ft]
      if f then content = f(content) end
      vim.print(path)
      vim.print(content)
      u.fs.must_write_file(path, content)
      if delete and pos1 and pos2 then u.buf.delete_range(pos1, pos2, buf, mode) end
      vim.cmd.vsplit(path)
      -- local new_buf = api.nvim_get_current_buf()
      -- u.fmt.conform { async = true, bufnr = new_buf }
      -- u.fmt.conform { bufnr = buf }
    end)
  )
end

return Refactor
