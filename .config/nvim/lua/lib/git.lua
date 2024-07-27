-- useful git wrapper
-- operation based frequency:
--   exec in buf -> exec in pwd -> exec in specified dir

-- maybe needless
local tolist = function(args)
  local list = {}
  for _, v in ipairs(args) do
    list[#list + 1] = v
  end
  return list
end

local die = function(cmd)
  local errmsg = ('[git] failed to exec `git %s`'):format(table.concat(cmd, ' '))
  -- error(errmsg)
end

--- exec git command in pwd
---@param cmd table
---@param cwd string?
---@return vim.SystemObj
local exec = function(cmd, cwd)
  local obj = vim.system({ 'git', unpack(cmd) }, { cwd = cwd })
  if __DEBUG then
    ---@diagnostic disable-next-line: inject-field
    obj.cwd = cwd
    local save_wait = obj.wait
    obj.wait = function(m)
      local _obj = save_wait(m)
      ---@diagnostic disable-next-line: inject-field
      _obj.cmd, _obj.cwd = cmd, cwd
      -- if _obj.code ~= 0 then die(cmd) end
      return _obj
    end
  end
  return obj
end

--- @class git_args_t
--- @field cmd table? unused now
--- @field cwd string?
--- @field bufnr integer? run git on buffer with bufnr
--- @field bufname string? run git on buffer with bufname
--- @field winid integer? run git on buffer on window with winid
--- @field follow_symlinks boolean? follow buf's symlinks when determine cwd

-- 目标:
-- lazy load (使用时加载)
-- 模块内部和外部用法一致, function/value
-- 模块第一次使用和后续使用用法保持一致

-- 完全替代 require? 不太可能...更可能的是在明显可以代替的地方的地方手动替换 lazy_require
--   如果依赖 require 本身的非 lazy load 的语义? 寄
--   如果依赖

-- 重新 local 声明一次可以保证不覆盖全局版本 git module 的 metatable
-- git 模块内部不带额外开销
-- 众所周知 metatable 作用是描述模块的用法, 如果用法发生改变
-- 由于目标是 lazy load, 我们不保证外部模块调用该模块是
-- 如果使用方法改变,
-- local old_mt = getmetatable(git)

local git = {} ---@module 'lib.git'

-- 分工: 要么里面改变外面行为
--       要么外面改变里面行为

-- 如果直接用 global 版本的, metatable 这时候会被覆盖掉 (导致存在语法和在外部模块使用时不一致的可能性, 引文)

setmetatable(git, {
  ---exec git in specified directory
  ---when there's no cwd, determine cwd on specified buffer or use heuristics
  ---@param _ table
  ---@param args git_args_t
  ---@return vim.SystemObj
  __call = function(_, args)
    args = args or {}
    vim.validate { args = { args, 't', true } }
    -- all integer-indexed string as cmd
    -- this may avoid potential side effect
    local cmd = tolist(args) or args.cmd or {}
    local cwd = args.cwd
    if cwd then return exec(cmd, cwd) end

    local path = args.bufname
    if args.bufname then
      path = args.bufname
    elseif args.bufnr then
      -- TODO: run git on specified bufnr
      local bufnr = args.bufnr ---@type number
      path = api.nvim_buf_get_name(bufnr)
    elseif args.winid then -- winid -> bufnr -> bufname -> dirname
      local winid = args.winid ---@type integer
      local bufnr = api.nvim_win_get_buf(winid)
      path = api.nvim_buf_get_name(bufnr)
    else
      path = u.smart.bufname()
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
git.root = function(opts)
  opts = opts or {}
  local cmd = { 'rev-parse', '--show-toplevel' }
  cmd = vim.tbl_extend('error', cmd, opts)
  local obj = git(cmd):wait()
  local root = vim.trim(obj.stdout)
  if obj.code == 0 then return root end
end

---@return table
git.remote = function()
  local obj = git { 'remote' }:wait()
  local remotes = vim.split(obj.stdout, '\n', { trimempty = true })
  return remotes
end

---@return string?
git.smart_remote_url = function()
  for _, repo in ipairs { 'upstream', 'origin' } do
    local obj = git { 'remote', 'get-url', repo }:wait()
    if obj.code == 0 then return obj.stdout end
  end
end

---@return nil
git.browse = function()
  local url = git.smart_remote_url()
  if url then return vim.ui.open(url) end
end

---Get the current branch name asynchronously
---@param bufnr integer? defaults to the current buffer
---@return string branch name
git.branch = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(bufnr) then return '' end

  local branch = vim.b[bufnr].git_branch
  if branch then return branch end

  vim.b[bufnr].git_branch = ''
  local dir = fs.dirname(api.nvim_buf_get_name(bufnr))
  if dir then
    pcall(
      vim.system,
      { 'git', '-C', dir, 'rev-parse', '--abbrev-ref', 'HEAD' },
      { stderr = false },
      function(err)
        local buf_branch = err.stdout:gsub('\n.*', '')
        pcall(api.nvim_buf_set_var, bufnr, 'git_branch', buf_branch)
      end
    )
  end
  return vim.b[bufnr].git_branch
end

---Get the diff stats for the current buffer asynchronously
---@param buf integer? buffer handler, defaults to the current buffer
---@return {added: integer?, removed: integer?, changed: integer?} diff stats
git.diffstat = function(buf)
  buf = buf or api.nvim_get_current_buf()
  if not api.nvim_buf_is_valid(buf) then return {} end

  if vim.b[buf].git_diffstat then return vim.b[buf].git_diffstat end

  vim.b[buf].git_diffstat = {}
  local path = fs.normalize(api.nvim_buf_get_name(buf))
  local dir = fs.dirname(path)
  if dir and git.branch(buf):find('%S') then
    pcall(vim.system, {
      'git',
      '-C',
      dir,
      '--no-pager',
      'diff',
      '-U0',
      '--no-color',
      '--no-ext-diff',
      '--',
      path,
    }, { stderr = false }, function(err)
      local stat = { added = 0, removed = 0, changed = 0 }
      for _, line in ipairs(vim.split(err.stdout, '\n')) do
        if line:find('^@@ ') then
          local num_lines_old, num_lines_new = line:match('^@@ %-%d+,?(%d*) %+%d+,?(%d*)')
          num_lines_old = tonumber(num_lines_old) or 1
          num_lines_new = tonumber(num_lines_new) or 1
          local num_lines_changed = math.min(num_lines_old, num_lines_new)
          stat.changed = stat.changed + num_lines_changed
          if num_lines_old > num_lines_new then
            stat.removed = stat.removed + num_lines_old - num_lines_changed
          else
            stat.added = stat.added + num_lines_new - num_lines_changed
          end
        end
      end
      pcall(api.nvm_buf_set_var, buf, 'git_diffstat', stat)
    end)
  end
  return vim.b[buf].git_diffstat
end

-- FIX
local function get_remote_uri(remote) return git { 'remote', 'get-url', remote }:wait().stdout() end

local function get_rev(revspec) return git({ 'rev-parse', revspec })[1] end

local function get_rev_name(revspec) return git({ 'rev-parse', '--abbrev-ref', revspec })[1] end

function git.is_file_in_rev(file, revspec)
  if git { 'cat-file', '-e', revspec .. ':' .. file } then return true end
  return false
end

function git.has_file_changed(file, rev)
  if git({ 'diff', rev, '--', file })[1] then return true end
  return false
end

local function is_rev_in_remote(revspec, remote)
  assert(remote, 'remote cannot be nil')
  local output = git({ 'branch', '--remotes', '--contains', revspec })
  for _, rbranch in ipairs(output) do
    if rbranch:match(remote) then return true end
  end
  return false
end

local allowed_chars = '[_%-%w%.]+'

-- strips the protocol (https://, git@, ssh://, etc)
local function strip_protocol(uri, errs)
  local protocol_schema = allowed_chars .. '://'
  local ssh_schema = allowed_chars .. '@'

  local stripped_uri = uri:match(protocol_schema .. '(.+)$') or uri:match(ssh_schema .. '(.+)$')
  if not stripped_uri then
    table.insert(errs, string.format(": remote uri '%s' uses an unsupported protocol format", uri))
    return nil
  end
  return stripped_uri
end

local function strip_dot_git(uri) return uri:match('(.+)%.git$') or uri end

local function strip_uri(uri, errs)
  local stripped_uri = strip_protocol(uri, errs)
  return strip_dot_git(stripped_uri)
end

local function parse_host(stripped_uri, errs)
  local host_capture = '(' .. allowed_chars .. ')[:/].+$'
  local host = stripped_uri:match(host_capture)
  if not host then
    table.insert(errs, string.format(": cannot parse the hostname from uri '%s'", stripped_uri))
  end
  return host
end

local function parse_port(stripped_uri, host)
  assert(host)
  local port_capture = allowed_chars .. ':([0-9]+)[:/].+$'
  return stripped_uri:match(port_capture)
end

local function parse_repo_path(stripped_uri, host, port, errs)
  assert(host)

  local pathChars = '[~/_%-%w%.%s]+'
  -- base of path capture
  local path_capture = '[:/](' .. pathChars .. ')$'

  -- if port is specified, add it to the path capture
  if port then path_capture = ':' .. port .. path_capture end

  -- add parsed host to path capture
  path_capture = allowed_chars .. path_capture

  -- parse repo path
  local repo_path = stripped_uri
    :gsub('%%20', ' ') -- decode the space character
    :match(path_capture)
    :gsub(' ', '%%20') -- encode the space character
  if not repo_path then
    table.insert(errs, string.format(": cannot parse the repo path from uri '%s'", stripped_uri))
    return nil
  end
  return repo_path
end

local function parse_uri(uri, errs)
  local stripped_uri = strip_uri(uri, errs)

  local host = parse_host(stripped_uri, errs)
  if not host then return nil end

  local port = parse_port(stripped_uri, host)

  local repo_path = parse_repo_path(stripped_uri, host, port, errs)
  if not repo_path then return nil end

  -- do not pass the port if it's NOT a http(s) uri since most likely the port
  -- is just an ssh port, so it's irrelevant to the git permalink construction
  -- (which is always an http url)
  if not uri:match('https?://') then port = nil end

  return { host = host, port = port, repo = repo_path }
end

function git.get_closest_remote_compatible_rev(remote)
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

function git.get_repo_data(remote)
  local errs = {
    string.format("Failed to retrieve repo data for remote '%s'", remote),
  }
  local remote_uri = get_remote_uri(remote)
  print(remote_uri)
  if not remote_uri then
    table.insert(errs, string.format(": cannot retrieve url from remote '%s'", remote))
    return nil
  end

  local repo = parse_uri(remote_uri, errs)
  if not repo or vim.tbl_isempty(repo) then vim.notify(table.concat(errs), vim.log.levels.ERROR) end
  return repo
end

function git.get_branch_remote()
  local remotes = git
  if #remotes == 0 then
    vim.notify('Git repo has no remote', vim.log.levels.ERROR)
    return nil
  end
  if #remotes == 1 then return remotes[1] end

  local upstream_branch = get_rev_name('@{u}')
  if not upstream_branch then return nil end

  local remote_from_upstream_branch = upstream_branch:match('^(' .. allowed_chars .. ')%/')
  if not remote_from_upstream_branch then
    error(string.format("Could not parse remote name from remote branch '%s'", upstream_branch))
    return nil
  end
  for _, remote in ipairs(remotes) do
    if remote_from_upstream_branch == remote then return remote end
  end

  error(
    string.format(
      "Parsed remote '%s' from remote branch '%s' is not a valid remote",
      remote_from_upstream_branch,
      upstream_branch
    )
  )
  return nil
end

return git
