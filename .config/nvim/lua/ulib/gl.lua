-- 'ruifm/gitlinker.nvim'
-- 'sontungexpt/url-open'
local Gl = {}

-- this functions maybe should not kept here
local get_base_https_url = function(ctx)
  local url = 'https://' .. ctx.host
  if ctx.port then url = url .. ':' .. ctx.port end
  return url .. '/' .. ctx.path
end

local options = {
  append_line_nr = true, -- if true adds the line nr in the url for normal mode
  print_url = true, -- print the url after action
  routers = {},
}

options.routers['github.com'] = function(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/blob/' .. ctx.rev .. '/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#L' .. ctx.lstart
  if ctx.lend then url = url .. '-L' .. ctx.lend end
  return url
end

-- options.routers['gitlab.com'] = Gl.get_gitlab_type_url
-- options.routers['try.gitea.io'] = Gl.get_gitea_type_url
-- options.routers['codeberg.org'] = Gl.get_gitea_type_url
-- options.routers['bitbucket.org'] = Gl.get_bitbucket_type_url
-- options.routers['try.gogs.io'] = Gl.get_gogs_type_url
-- options.routers['git.sr.ht'] = Gl.get_srht_type_url
-- options.routers['git.launchpad.net'] = Gl.get_launchpad_type_url
-- options.routers['repo.or.cz'] = Gl.get_repoorcz_type_url
-- options.routers['git.kernel.org'] = Gl.get_cgit_type_url
-- options.routers['git.savannah.gnu.org'] = Gl.get_cgit_type_url

--- Constructs a gitea style url
function Gl.get_gitea_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/src/commit/' .. ctx.rev .. '/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#L' .. ctx.lstart
  if ctx.lend then url = url .. '-L' .. ctx.lend end
  return url
end

--- Constructs a gitlab style url
function Gl.get_gitlab_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/-/blob/' .. ctx.rev .. '/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#L' .. ctx.lstart
  if ctx.lend then url = url .. '-' .. ctx.lend end
  return url
end

--- Constructs a bitbucket style url
function Gl.get_bitbucket_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/src/' .. ctx.rev .. '/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#lines-' .. ctx.lstart
  if ctx.lend then url = url .. ':' .. ctx.lend end

  return url
end

--- Constructs a gogs style url
function Gl.get_gogs_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/src/' .. ctx.rev .. '/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#L' .. ctx.lstart
  if ctx.lend then url = url .. '-L' .. ctx.lend end

  return url
end

--- Constructs a cgit style url
function Gl.get_cgit_type_url(ctx)
  if ctx.path then ctx.path = ctx.path .. '.git/' end

  local url = 'https://' .. ctx.host
  if ctx.port then url = url .. ':' .. ctx.port end
  url = url .. '/tree/' .. ctx.file .. '?id=' .. ctx.rev
  if ctx.lstart then url = url .. '#n' .. ctx.lstart end
  return url
end

--- Constructs a sourcehut style url
function Gl.get_srht_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/tree/' .. ctx.rev .. '/item/' .. ctx.file

  if not ctx.lstart then return url end
  url = url .. '#L' .. ctx.lstart
  if ctx.lend then url = url .. '-' .. ctx.lend end

  return url
end

--- Constructs a launchpad style url
function Gl.get_launchpad_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/tree/' .. ctx.file .. '?id=' .. ctx.rev

  if ctx.lstart then url = url .. '#n' .. ctx.lstart end
  return url
end

--- Constructs a repo.or.cz style url
function Gl.get_repoorcz_type_url(ctx)
  local url = get_base_https_url(ctx)
  if not ctx.file or not ctx.rev then return url end
  url = url .. '/blob/' .. ctx.rev .. ':/' .. ctx.file
  if ctx.lstart then url = url .. '#l' .. ctx.lstart end
  return url
end

-- handle common pattern only
-- https://stackoverflow.com/questions/31801271/what-are-the-supported-git-url-formats
---@return table
local parse_url = function(url)
  local protocol, user, host, path

  local tmp = url
  url = tmp:match('(%S+)%.git$')
  if not url then
    url = tmp
  else
    tmp = url
  end

  -- https://
  protocol, url = url:match('^(%S+)://(%S+)$')
  if not protocol then
    url = tmp
  else
    tmp = url
  end

  -- user@ (usre is user_pass)
  user, url = url:match('^(%S+)@(%S+)$')
  if not user then
    url = tmp
  else
    tmp = url
  end

  -- localhost
  if url:match('^~') or url:match('^/') then
    path = url
  else -- "host:/?path", "host/path"
    host, path = url:match('^(%S+):(.*)$')
    if host then
      -- not sure...
      if path:sub(1, 1) == '/' then path = path:sub(2) end
    else
      host, path = url:match('([^/]+)/(.*)$')
      if not host then error(('path: %s, url: %s'):format(path, tmp)) end
    end
  end

  return {
    protocol = protocol,
    user = user,
    host = host,
    path = path,
  }
end

---@param root string
---@returns table?
---FIXME: in the middle of branch
local parse_url_data = function(root)
  local remote, remote_url = u.git.smart_remote_url()
  local ctx = parse_url(remote_url)
  local rev = assert(u.git.get_closest_remote_compatible_rev(remote))
  local relative_path = u.buf.relative_to(nil, root)
  -- is file in rev
  local obj = u.git { 'cat-file', '-e', rev .. ':' .. relative_path }:wait()
  if obj.code ~= 0 then return vim.notify(string.format('%s', obj.stderr), vim.log.levels.ERROR) end

  -- if file changed?
  -- if u.git { 'diff', rev, '--', relative_path }:wait().stdout == 0 then
  -- end
  local lstart, lend = u.buf.visual_line_region()
  ---@diagnostic disable-next-line: cast-local-type
  if lend == lstart then lend = nil end
  return u.merge(ctx, {
    rev = rev,
    file = relative_path,
    lstart = lstart,
    lend = lend,
  })
end

---@returns string?
local permalink = function(callback)
  return function()
    local root = assert(u.git.root())
    local ctx = assert(parse_url_data(root))
    assert(ctx.host, 'fail to get host')
    -- get host callback
    local host_callback = options.routers[ctx.host]
    assert(host_callback, ('No callback for host: %s'):format(ctx.host))
    local url = host_callback(ctx)
    if vim.is_callable(callback) then callback(url) end
    if options.print_url then vim.notify(url, vim.log.levels.WARN) end
    return url
  end
end

Gl.permalink_open = permalink(vim.ui.open)
Gl.permalink_copy = permalink(function(url) vim.cmd("let @+ = '" .. url .. "'") end)

return Gl
