---@module "lib.bufop"
local Misc = {}

---Go to the last line of current paragraph
---@return nil
Misc.goto_paragraph_lastline = function()
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
Misc.goto_paragraph_firstline = function()
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

Misc.yank_filename = function()
  -- TODO: fs.normalize fn.expand
  local path = fs.normalize(api.nvim_buf_get_name(0))
  fn.setreg('+', (path:gsub(('^%s'):format(env.HOME), '~')))
end

Misc.force_close_tabpage = function()
  if #api.nvim_list_tabpages() == 1 then
    vim.cmd('quit!')
  else
    vim.cmd('tabclose!')
  end
end

Misc.blank_above = function()
  local repeated = fn['repeat']({ '' }, vim.v.count1)
  local lnum = fn.line('.') - 1
  api.nvim_buf_set_lines(0, lnum, lnum, true, repeated)
end

Misc.blank_below = function()
  local repeated = fn['repeat']({ '' }, vim.v.count1)
  local lnum = fn.line('.')
  api.nvim_buf_set_lines(0, lnum, lnum, true, repeated)
end

Misc.quit = function()
  -- -- redirect buf open to other window
  -- au('Filetype', {
  --   pattern = { 'qf', 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
  --   callback = function(args)
  --     -- if vim.bo.bt ~= '' then map('n', 'q', '<cmd>q<cr>', { buffer = args.buf }) end
  --     -- TODO: winfixbuf not always work...
  --   end,
  -- })

  -- unknow: check ft here as workaround for autocmd not always work
  local filetypes = setmetatable({
    ['qf'] = true,
    ['NvimTree'] = true,
    ['help'] = true,
    ['man'] = true,
    ['aerial'] = true,
    ['gitcommit'] = true,
    ['git'] = true,
    ['floggraph'] = true,
  }, {
    __index = function(_, k) return k:match('fugitive*') and true or false end,
  })

  -- TODO: not sure what to do with these cases
  -- if fn.reg_recorded() ~= '' or fn.reg_executing() ~= '' then return '<ignore>' end

  local wclose = function(...) pcall(api.nvim_win_close, ...) end

  -- close current window if floating
  local curwind = api.nvim_get_current_win()
  if api.nvim_win_get_config(curwind).relative ~= '' or filetypes[vim.bo.ft] then
    return wclose(curwind, true)
  end

  -- close all focusable floating windows (:fclose! ?)
  local count = 0
  for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
    if api.nvim_win_is_valid(win) then
      local cfg = api.nvim_win_get_config(win)
      if cfg.relative ~= '' and cfg.focusable then -- skip unfocusable(e.g. fidget)
        wclose(win, false)
        count = count + 1
      end
    end
  end

  if count == 0 then -- fallback
    api.nvim_feedkeys(vim.keycode('q'), 'n', false)
  end
end

return Misc
