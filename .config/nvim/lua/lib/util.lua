local M = {}

-- -- redirect buf open to other window
-- au('Filetype', {
--   pattern = { 'qf', 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
--   callback = function(args)
--     -- if vim.bo.bt ~= '' then map('n', 'q', '<cmd>q<cr>', { buffer = args.buf }) end
--     -- TODO: winfixbuf not always work...
--   end,
-- })

-- UNKOWN: check ft here as workaround for autocmd not always work
local ft_tbl = setmetatable({
  ['qf'] = true,
  ['NvimTree'] = true,
  ['help'] = true,
  ['man'] = true,
  ['aerial'] = true,
}, {
  __index = function(_, k) return k:match('fugitive*') and true or false end,
})

M.smart_quit = function()
  -- close floating window
  local curwind = vim.api.nvim_get_current_win()
  if vim.api.nvim_win_get_config(curwind).relative ~= '' or ft_tbl[vim.bo.ft] then
    return vim.api.nvim_win_close(curwind, true)
  end

  -- close all focusable floating windows
  -- :fclose! ?
  local count = 0
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= '' and cfg.focusable then -- unfocusable(e.g. fidget)
        vim.api.nvim_win_close(win, false)
        count = count + 1
      end
    end
  end

  if count == 0 then -- fallback
    vim.api.nvim_feedkeys(vim.keycode('q'), 'n', false)
  end
end

M.gitroot = function(bufname)
  local path = vim.fs.dirname(bufname)
  local obj = vim.system { 'git', '-C', path, 'rev-parse', '--show-toplevel' }:wait()
  if obj.code == 0 then
    return vim.trim(obj.stdout)
  else
    for dir in vim.fs.parents(bufname) do
      if vim.fn.isdirectory(dir .. '/.git') == 1 then return dir end
    end
  end
end

-- iterate window to find good bufname
-- the buffer you are working on...
M.smart_bufname = function()
  -- current win should be check first...
  local wins = vim.api.nvim_list_wins() -- nvim_tabpage_list_wins(0)
  local curwinid = vim.api.nvim_get_current_win()
  -- btw, nvim-tree/neo-tree has a bufname...
  if vim.fn.win_gettype(curwinid) == '' then
    local bufnr = vim.api.nvim_win_get_buf(curwinid)
    if vim.bo[bufnr].bt ~= 'nofile' then
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname ~= '' then return bufname end
    end
  end
  for _, winid in pairs(wins) do
    if winid ~= curwinid then
      local wt = vim.fn.win_gettype(winid)
      if wt == '' then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].bt ~= 'nofile' then
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname ~= '' then return bufname end
        end
      end
    end
  end
end

-- gitroot or parent of `working buffer`
M.smart_root = function()
  local bufname = vim.fn.resolve(M.smart_bufname()) -- follow symbolic link
  local root = M.gitroot(bufname)

  -- not in gitroot
  -- or in homedir(repo), but ignored
  local homedir = vim.env.HOME
  if
    not root
    or root == homedir
      and 0 == vim.system { 'git', '-C', homedir, 'check-ignore', '-q', bufname }:wait().code
  then
    return vim.fs.dirname(bufname)
  end
  return root
end

M.smart_cd = function() vim.api.nvim_set_current_dir(M.smart_root()) end

M.yank_filename = function()
  local path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
  vim.fn.setreg('+', (path:gsub(('^%s'):format(vim.env.HOME), '~')))
end

M.yank_last_message = function() vim.fn.setreg('+', vim.trim(vim.fn.execute('1message'))) end

M.force_close_tabpage = function()
  if #vim.api.nvim_list_tabpages() == 1 then
    vim.cmd('quit!')
  else
    vim.cmd('tabclose!')
  end
end

return M
