local M = {}

-- operate smartly by some heuristics

-- -- redirect buf open to other window
-- au('Filetype', {
--   pattern = { 'qf', 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
--   callback = function(args)
--     -- if vim.bo.bt ~= '' then map('n', 'q', '<cmd>q<cr>', { buffer = args.buf }) end
--     -- TODO: winfixbuf not always work...
--   end,
-- })

-- unknow: check ft here as workaround for autocmd not always work
local ft_tbl = setmetatable({
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

M.quit = function()
  -- TODO: not sure what to do with these cases
  -- if fn.reg_recorded() ~= '' or fn.reg_executing() ~= '' then return '<ignore>' end

  local wclose = function(...) pcall(api.nvim_win_close, ...) end

  -- close current window if floating
  local curwind = api.nvim_get_current_win()
  if api.nvim_win_get_config(curwind).relative ~= '' or ft_tbl[vim.bo.ft] then
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

--- find "correct" buffer
--- prefer informative buffer than infoless ones(e.g. `noname`, `nofile`)
--- useful to run cmd(e.g. git) on correct buffer
---@return { winid: integer, bufnr: integer, bufname: string }
M.find_best_winbuf = function()
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

M.bufname = function() return M.find_best_winbuf().bufname end

M.bufnr = function() return M.find_best_winbuf().bufnr end

M.winid = function() return M.find_best_winbuf().winid end

--- get git root of given buffer
--- if files fallback into dotfiles (but `gitignored`)
---    or files is not managed in git root
---@return string
M.root = function()
  local bufname = M.bufname()
  bufname = fn.resolve(bufname)
  local root = u.git.root { bufname = bufname }
  local home = vim.uv.os_get_passwd().homedir
  if
    not root
    or root == home and u.git { 'check-ignore', '-q', bufname, cwd = home }:wait().code == 0
  then
    return fs.dirname(bufname)
  end
  return root
end

-- uv.chdir (no event?), fn.chdir, cmd.cd
M.cd = function()
  local path = M.root()
  api.nvim_set_current_dir(path)
end

return M
