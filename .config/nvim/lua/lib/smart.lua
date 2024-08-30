local M = {}

-- operate smartly by some heuristics

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
