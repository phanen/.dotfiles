-- maybe needless
local tolist = function(args)
  local list = {}
  for _, v in ipairs(args) do
    list[#list + 1] = v
  end
  return list
end

--- exec git command in pwd
---@param cmd table
---@param cwd string?
---@return vim.SystemObj
local exec = function(cmd, cwd) return vim.system({ 'git', unpack(cmd) }, { cwd = cwd }) end

--- @class git_args_t
--- @field cmd table? unused now
--- @field cwd string?
--- @field bufnr integer? run git on buffer with bufnr
--- @field bufname string? run git on buffer with bufname
--- @field winid integer? run git on buffer on window with winid
--- @field follow_symlinks boolean? follow buf's symlinks when determine cwd

---@module 'lib.git'
local Git = {}

---@overload fun(args: git_args_t): vim.SystemObj
local git = setmetatable(Git, {
  ---exec git in specified directory/buffer/bufname/bufnr/winid
  ---when there's no cwd, determine cwd on specified buffer or use heuristics
  __call = function(_, args)
    args = args or {}
    vim.validate { args = { args, 't', true } }
    -- all integer-indexed string as cmd
    -- this may avoid potential side effect
    local cmd = tolist(args) or args.cmd or {}
    local cwd = args.cwd
    if cwd then return exec(cmd, cwd) end

    local path = args.bufname
    if not path then
      if args.bufnr then
        -- TODO: run git on specified bufnr
        local bufnr = args.bufnr ---@type number
        path = api.nvim_buf_get_name(bufnr)
      elseif args.winid then -- winid -> bufnr -> bufname -> dirname
        local winid = args.winid ---@type integer
        local bufnr = api.nvim_win_get_buf(winid)
        path = api.nvim_buf_get_name(bufnr)
      else
        path = u.misc.bufname()
      end
    end

    if args.follow_symlinks then path = fn.resolve(path) end
    cwd = fs.dirname(path)
    return exec(cmd, cwd)
  end,
})

--- get git root of current/specified buffer
--- `follow_symlinks` not follow buffer's symlink, but not directory
--- if directory is symlinks can be handled by `git rev-parse --show-toplevel`
---@param opts { bufnr: integer?, bufname: string?, follow_symlinks: boolean? }?
---@return string?
Git.root = function(opts)
  opts = opts or {}
  local cmd = { 'rev-parse', '--show-toplevel' }
  cmd = vim.tbl_extend('error', cmd, opts)
  local obj = git(cmd):wait()
  local root = vim.trim(obj.stdout)
  if obj.code == 0 then return root end
end

---@return table?
Git.remote = function()
  local obj = git { 'remote' }:wait()
  local remotes = vim.split(obj.stdout, '\n', { trimempty = true })
  if obj.code == 0 then return remotes end
end

---@return string?
---@return string?
Git.smart_remote_url = function()
  for _, remote in ipairs { 'upstream', 'origin' } do
    local obj = git { 'remote', 'get-url', remote }:wait()
    if obj.code == 0 then return remote, vim.trim(obj.stdout) end
  end
end

---@return nil
Git.browse = function()
  local _, url = Git.smart_remote_url()
  if url then return vim.ui.open(url) end
end

---@return string?
local function get_rev(revspec)
  local obj = git { 'rev-parse', revspec }:wait()
  if obj.code == 0 then return vim.trim(obj.stdout) end
end

local function is_rev_in_remote(revspec, remote)
  assert(remote, 'remote cannot be nil')
  local output = git { 'branch', '--remotes', '--contains', revspec }
  for _, rbranch in ipairs(output) do
    if rbranch:match(remote) then return true end
  end
  return false
end

function Git.get_closest_remote_compatible_rev(remote)
  -- local upstream_rev = get_rev('upstream/master')
  -- if upstream_rev then return upstream_rev end

  -- upstream_rev = get_rev('origin/master')
  -- if upstream_rev then return upstream_rev end

  -- try upstream branch HEAD (a.k.a @{u})
  local upstream_rev = get_rev('@{u}')
  if upstream_rev then return upstream_rev end

  -- try HEAD
  if is_rev_in_remote('HEAD', remote) then
    local head_rev = get_rev('HEAD')
    if head_rev then return head_rev end
  end

  -- try last 50 parent commits
  for i = 1, 50 do
    local revspec = 'HEAD~' .. i
    if is_rev_in_remote(revspec, remote) then
      local rev = get_rev(revspec)
      if rev then return rev end
    end
  end

  -- try remote HEAD
  local remote_rev = get_rev(remote)
  if remote_rev then return remote_rev end

  vim.notify(
    string.format("Failed to get closest revision in that exists in remote '%s'", remote),
    vim.log.levels.ERROR
  )
  return nil
end

function Git.get_branch_remote()
  local remotes = Git.remote()
  if #remotes == 0 then return vim.notify('Git repo has no remote', vim.log.levels.WARN) end
  if #remotes == 1 then return remotes[1] end

  local remote_from_upstream_branch =
    git { 'rev-parse', '--abbrev-ref', '@{u}' }:wait().stdout:match('^(%S)%/')
  for _, remote in ipairs(remotes) do
    if remote_from_upstream_branch == remote then return remote end
  end
  return nil
end

return Git
