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

local wclose = function(...) pcall(api.nvim_win_close, ...) end

Misc.quit = function()
  if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then
    return api.nvim_feedkeys('q', 'n', false)
  end

  -- close current floating windows
  if api.nvim_win_get_config(0).relative ~= '' then return vim.cmd.quit { bang = true } end

  -- close all focusable floating windows (:fclose! ?)
  local count = 0
  vim
    .iter(api.nvim_tabpage_list_wins(0))
    :filter(api.nvim_win_is_valid)
    :filter(function(win) -- -- skip unfocusable(e.g. fidget)
      local cfg = api.nvim_win_get_config(win)
      return cfg.relative ~= '' and cfg.focusable and true or false
    end)
    :each(function(win)
      wclose(win, false)
      count = count + 1
    end)

  if count == 0 then -- fallback
    return api.nvim_feedkeys('q', 'n', false)
  end
end

-- operate smartly by some heuristics

--- find "correct" buffer
--- prefer informative buffer than infoless ones(e.g. `noname`, `nofile`)
--- useful to run cmd(e.g. git) on correct buffer
---@return { winid: integer, bufnr: integer, bufname: string }
Misc.find_best_winbuf = function()
  local wins = api.nvim_list_wins()
  local curwinid = api.nvim_get_current_win()
  local curbufnr = api.nvim_win_get_buf(curwinid)
  local curbufname = api.nvim_buf_get_name(curbufnr)

  if fn.win_gettype(curwinid) == '' then
    if vim.bo[curbufnr].bt ~= 'nofile' then
      -- btw, nvim-tree/neo-tree has a bufname...
      -- curbufname:match('NvimTree_1')
      if curbufname ~= '' then
        return {
          winid = curwinid,
          bufnr = curbufnr,
          bufname = curbufname,
        }
      end
    end
  end

  for _, winid in pairs(wins) do
    if winid ~= curwinid then
      local wt = fn.win_gettype(winid)
      if wt == '' then
        local bufnr = api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].bt ~= 'nofile' then
          local bufname = api.nvim_buf_get_name(bufnr)
          if bufname ~= '' then
            return {
              winid = winid,
              bufnr = bufnr,
              bufname = bufname,
            }
          end
        end
      end
    end
  end

  return {
    winid = curwinid,
    bufnr = curbufnr,
    bufname = curbufname,
  }
end

Misc.bufname = function() return Misc.find_best_winbuf().bufname end

Misc.bufnr = function() return Misc.find_best_winbuf().bufnr end

Misc.winid = function() return Misc.find_best_winbuf().winid end

--- get git root of given buffer
--- if files fallback into dotfiles (but `gitignored`)
---    or files is not managed in git root
---@return string
local root = function()
  local bufname = Misc.bufname()
  bufname = fn.resolve(bufname)
  local root = u.git.root { bufname = bufname }
  local home = uv.os_get_passwd().homedir
  if
    not root
    or root == home and u.git { 'check-ignore', '-q', bufname, cwd = home }:wait().code == 0
  then
    return fs.dirname(bufname)
  end
  return root
end

-- uv.chdir (no event?), fn.chdir, cmd.cd
Misc.cd = function()
  local path = root()
  api.nvim_set_current_dir(path)
end

return Misc
