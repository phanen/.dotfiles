-- extract visual selection to somewhere
local Extract = {}

local fmtter = {
  lua = function(content) return ('return %s'):format(content) end,
}

--- extract range to given path
---@param path? string
---@param keep? boolean don't delete previous one
Extract.to_file = function(path, keep)
  local mode = api.nvim_get_mode().mode
  assert(mode:match('[vV]'), 'Should in visual mode now')
  local pos1, pos2 = fn.getpos '.', fn.getpos 'v'
  local lines = fn.getregion(pos1, pos2, { type = mode })
  local buf = api.nvim_get_current_buf()
  path = path or fn.expand('%:p:h') .. '/'
  vim.ui.input({ prompt = 'Extract to:', default = path }, function(input)
    path = vim.trim(input)
    local content = table.concat(lines, '\n')
    local f = vim.b[buf].extract_formatter or fmtter[vim.bo[buf].ft]
    if f then content = f(content) end
    if not keep then u.fs.must_write_file(path, content) end
    u.buf.delete_range(pos1, pos2, buf, mode)
    vim.cmd.vsplit(path)
    -- local new_buf = api.nvim_get_current_buf()
    -- u.fmt.conform { async = true, bufnr = new_buf }
    -- u.fmt.conform { bufnr = buf }
  end)
end

return Extract
