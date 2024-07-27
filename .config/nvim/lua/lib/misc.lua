local M = {}

---Go to the last line of current paragraph
---@return nil
M.goto_paragraph_lastline = function()
  local chunk_size = 10
  local lnr = fn.line('.')
  local buf_line_count = api.nvim_buf_line_count(0)
  local count = vim.v.count1

  -- If current line is the last line of paragraph, move one line
  -- downwards first to goto the last line of next paragraph
  if buf_line_count - lnr >= 1 then
    local lines = api.nvim_buf_get_lines(0, lnr - 1, lnr + 1, false)
    if lines[1]:match('%S') and lines[2]:match('^$') then lnr = lnr + 1 end
  end

  while lnr <= buf_line_count do
    local chunk = api.nvim_buf_get_lines(0, lnr, lnr + chunk_size, false)
    for i, line in ipairs(chunk) do
      local current_linenr = lnr + i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr - 1))
          return
        end
      elseif current_linenr >= buf_line_count then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd(tostring(buf_line_count))
        return
      end
    end
    lnr = lnr + chunk_size
  end
end

---@return nil
M.goto_paragraph_firstline = function()
  local chunk_size = 10
  local lnr = fn.line('.')
  local count = vim.v.count1

  -- If current line is the first line of paragraph, move one line
  -- upwards first to goto the first line of previous paragraph
  if lnr >= 2 then
    local lines = api.nvim_buf_get_lines(0, lnr - 2, lnr, false)
    if lines[1]:match('^$') and lines[2]:match('%S') then lnr = lnr - 1 end
  end

  while lnr >= 1 do
    local chunk = api.nvim_buf_get_lines(0, math.max(0, lnr - chunk_size - 1), lnr - 1, false)
    for i, line in ipairs(vim.iter(chunk):rev():totable()) do
      local current_linenr = lnr - i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr + 1))
          return
        end
      elseif current_linenr <= 1 then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd('1')
        return
      end
    end
    lnr = lnr - chunk_size
  end
end

---@param ms integer
---@param fn function
local debounce = function(ms, fn)
  ---@diagnostic disable-next-line: undefined-field
  local timer = uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
