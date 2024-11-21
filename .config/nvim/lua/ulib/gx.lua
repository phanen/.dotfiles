-- 'chrishrb/gx.nvim'
local Gx = {}

---@class GxHandler
---@field filetype string|string[]?
---@field filename string?
---@field disable boolean?
---@field handle string|fun(mode: string, text: string): string?

---@class GxOptions
---@field leave_visual boolean
---@field search_engine "google"|"bing"|"duckduckgo"|"ecosia"|"yandex"
---@field handlers table<string, GxHandler>

---@class GxSelection
---@field name string
---@field url string

---@type GxOptions
local options = {
  leave_visual = true,
  search_engine = 'google',
  handlers = {},
}
options.handlers.brewfile = {
  filename = 'Brewfile',
  handle = function(text)
    -- navigate to Homebrew Formulae url
    local brew_pattern = 'brew ["]([^%s]*)["]'
    local cask_pattern = 'cask ["]([^%s]*)["]'
    local brew = text:match(brew_pattern)
    local cask = text:match(cask_pattern)
    if brew then return 'https://formulae.brew.sh/formula/' .. brew end
    if cask then return 'https://formulae.brew.sh/cask/' .. cask end
  end,
}
options.handlers.cargo = {
  filename = 'Cargo.toml',
  handle = function(text)
    local crate = text:match('(%w+)%s-=%s')
    if crate then return 'https://crates.io/crates/' .. crate end
  end,
}
options.handlers.commit = {
  handle = function(text)
    local commit_hash = text:match('(%x%x%x%x%x%x%x+)')
    if not commit_hash or #commit_hash > 40 then return end
    local _, git_url = u.git.smart_remote_url()
    if not git_url then return end
    git_url = git_url:gsub('%.git$', '')
    return git_url .. '/commit/' .. commit_hash
  end,
}
options.handlers.cve = {
  handle = function(text)
    local cve_id = text:match('(CVE[%d-]+)')
    if not cve_id or #cve_id > 20 then return end
    return 'https://nvd.nist.gov/vuln/detail/' .. cve_id
  end,
}
options.handlers.github = {
  handle = function(text)
    local match = text:match('([%w-_.]+/[%w-_.]+#%d+)')
    if not match then match = text:match('([%w-_.]+#%d+)') end
    if not match then match = text:match('(#%d+)') end
    if not match then return end
    local owner, repo, issue = match:match('([^/#]*)/?([^#]*)#(.+)')

    local _, git_url = u.git.smart_remote_url() -- get_remote_url(remotes, push, owner, repo)
    if not git_url then return end
    git_url = git_url:gsub('%.git$', '')
    return git_url .. '/issues/' .. issue
  end,
}
options.handlers.go = {
  filetype = { 'go' },
  handle = function()
    local node = vim.treesitter.get_node()
    if not node then return end
    if node:type() ~= 'import_spec' then
      if node:type() == 'import_declaration' then
        node = node:named_child(0)
      else
        node = node:parent()
      end
      if not node then return end
      if node:type() ~= 'import_spec' then return end
    end

    local path_node = node:field('path')[1]
    local start_line, start_col, end_line, end_col = path_node:range()

    local text = api.nvim_buf_get_lines(0, start_line, end_line + 1, false)[1]
    local pkg = text:sub(start_col + 2, end_col - 1) -- remove quotes
    return 'https://pkg.go.dev/' .. pkg
  end,
}
options.handlers.markdown = {
  filetype = { 'markdown' },
  handle = '%[[%a%d%s.,?!:;@_{}~]*%]%((https?://[a-zA-Z0-9_/%-%.~@\\+#=?&]+)%)',
}
options.handlers.nvim_plugin = {
  filetype = { 'lua', 'vim' },
  filename = nil,
  handle = function(text)
    local username_repo = text:match('["\']([^%s~/]*/[^%s~/]*)["\']')
    if username_repo then return 'https://github.com/' .. username_repo end
  end,
}
options.handlers.package_json = {
  filetype = { 'json' },
  filename = 'package.json',
  handle = function(text)
    local npm_package = text:match('["]([^%s]*)["]:')
    if not npm_package then return end
    return 'https://www.npmjs.com/package/' .. npm_package
  end,
}
options.handlers.search = {
  handle = function(text)
    local search_url = setmetatable({
      google = 'https://www.google.com/search?q=',
      bing = 'https://www.bing.com/search?q=',
      duckduckgo = 'https://duckduckgo.com/?q=',
      ecosia = 'https://www.ecosia.org/search?q=',
      yandex = 'https://ya.ru/search?text=',
    }, { __index = function(_, url) return url end })

    ---@param url string?
    ---@return string?
    local urlencode = function(url)
      if url == nil then return end
      url = url:gsub('\n', '\r\n')
      url = string.gsub(url, '([^%w _%%%-%.~])', vim.text.hexdecode)
      url = url:gsub(' ', '+')
      return url
    end

    return search_url[options.search_engine] .. urlencode(text)
  end,
}
options.handlers.url_scheme = { -- get url from text (with http/s)
  handle = '(https?://[a-zA-Z%d_/%%%-%.~@\\+#=?&:–]+)',
  -- handle = function(_) return vim.ui._get_urls()[1] end,
}

---@type fun(mode: string): string?
local get_text = function(mode)
  mode = mode or api.nvim_get_mode().mode

  local text = nil
  -- if mode == 'n' or mode == 'nt' then
  if mode:match('n') then
    -- text = api.nvim_get_current_line()
    text = fn.expand('<cWORD>')
  elseif mode:match('[vV\022]') then
    text = table
      .concat(fn.getregion(fn.getpos('.'), fn.getpos('v'), { type = fn.mode() }), '\n')
      :gsub('\n', '')
  end
  return text
end

---@param text string?
---@return nil
Gx.open = function(text)
  local mode = api.nvim_get_mode().mode
  text = text or get_text(mode)
  if not text then return nil end

  -- better than tbl_filter, since this can iterate non-list table
  local hs = vim.iter(options.handlers):filter(function(_, h)
    if h.filetype and vim.tbl_contains(h.filetype, vim.bo.filetype) then return true end
    if h.filename and api.nvim_buf_get_name(0):match(h.filename) then return true end
    return not h.filetype and not h.filename and not h.disable
  end)

  ---@type GxSelection[]
  ---compounded type?
  -- iterate each handler to collect the result
  -- todo: maybe we can sort by priority
  local urls = hs:fold({}, function(urls, name, h)
    local url
    if type(h.handle) == 'string' then
      url = text:match(h.handle)
    else
      url = h.handle(text)
    end
    if url and not urls[url] then
      local i = #urls + 1
      urls[i] = { name = name, url = url }
      urls[url] = true -- check if we already found this url
      urls[name] = i -- used to remove search optionally laterly
    end
    return urls
  end)

  if options.leave_visual then
    api.nvim_feedkeys(api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
  end

  -- just use url if we found scheme
  ---@cast urls table<string, integer>
  local url_scheme_index = urls.url_scheme
  if url_scheme_index then
    local url = urls[url_scheme_index].url
    return vim.ui.open(url)
  end

  -- ignore "search" handler in this case
  ---@cast urls table<string, integer>
  if #urls >= 2 and urls.search then table.remove(urls, urls.search) end

  local n_urls = #urls
  if n_urls == 0 then return nil end
  if n_urls == 1 then return vim.ui.open(urls[1].url) end

  -- should jump to single result?
  vim.ui.select(urls, {
    prompt = 'Multiple patterns match. Select:',
    format_item = function(item)
      local pad_str = (' '):rep(15 - #item.name)
      return ('(%s)%s %s'):format(item.name, pad_str, item.url)
    end,
  }, function(selected)
    if not selected then return end
    return vim.ui.open(selected.url)
  end)
end

return Gx
