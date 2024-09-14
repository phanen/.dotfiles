local Markup = {}

Markup.surround = function()
  local vs, ve = u.buf.visual_line_region()
  local lines = api.nvim_buf_get_lines(0, vs - 1, ve, true)
  lines = { '```', unpack(lines) }
  lines[#lines + 1] = '```'
  api.nvim_buf_set_lines(0, vs - 1, ve, true, lines)
  api.nvim_feedkeys(vim.keycode '<esc>', 'n', false)
  api.nvim_win_set_cursor(0, { vs, 3 })
  api.nvim_feedkeys('A', 'n', false)
end

-- auto list item
local autolist = function(c)
  return function()
    local row = api.nvim_win_get_cursor(0)[1]
    local line = api.nvim_buf_get_lines(0, row - 1, row, true)[1]
    for it, p in pairs {
      ['-'] = '%-',
      ['+'] = '%+',
      ['*'] = '%*',
      ['='] = '%=',
    } do
      -- if line:find("^%s*" .. p .. " %[x%]") then
      --   api.nvim_feedkeys(c .. it .. " [x] ", "n", false)
      --   return
      -- end
      -- if line:find("^%s*" .. p .. " %[ %]") then
      --   api.nvim_feedkeys(c .. it .. " [ ] ", "n", false)
      --   return
      -- end
      if line:find('^%s*' .. p .. ' ') then return api.nvim_feedkeys(c .. it .. ' ', 'n', false) end
    end
    api.nvim_feedkeys(c, 'n', false)
  end
end

Markup.listup = autolist 'O'
Markup.listdn = autolist 'o'

local checkbox = '%[x%]'
local emptybox = '%[ %]'

local contain_box = function(line, box) return line:match('^%s*[%-%+%*%=]%s' .. box) end
local make_box = function(line) return (line:gsub('^(%s*[%-%+%*%=]%s)(.*)', '%1[ ] %2', 1)) end
local make_item = function(line) return (line:gsub('^(%s*)(%S*.*)$', '%1* %2')) end

Markup.toggle_line = function(line)
  -- not contain `xx`, `**xx`
  if not line:match '^%s*[%-%+%*%=]%s*.*' or line:match '^%s*[%-%+%*%=]%S+.*' then
    return make_item(line)
  end
  if contain_box(line, checkbox) then return (line:gsub(checkbox, emptybox, 1)) end
  if contain_box(line, emptybox) then return (line:gsub(emptybox, checkbox, 1)) end
  return make_box(line)
end

Markup.toggle_lines = function()
  local vs, ve = u.buf.visual_line_region()
  local lines = api.nvim_buf_get_lines(0, vs - 1, ve, true)
  lines = vim.iter(lines):map(function(line) return Markup.toggle_line(line) end):totable()
  api.nvim_buf_set_lines(0, vs - 1, ve, true, lines)
end

-- wrap url, then paste it
local paste = function(wrap_cb, url)
  if not url then -- use url form clipboard
    local text = fn.getreg '+'
    if not text then return end
    url = text
  end
  url = url:gsub('\n', '')
  url = wrap_cb(url)
  api.nvim_paste(url, true, 1)
end

-- return line with wrapped url, or nil if no url in line
local wrap_line = function(cb, line)
  local url_patterns = { -- workaround, wikipedia '–'(0x8211) is not '-'
    '(https?://[a-zA-Z%d_/%%%-%.~@\\+#=?&:–]+)',
    '([a-zA-Z%d_/%-%.~@\\+#]+%.[a-zA-Z%d_/%%%-%.~@\\+#=?&:–]+)',
  }
  local s, e
  for _, p in ipairs(url_patterns) do
    s, e = line:find(p)
    if s then
      local ss, _ = line:find('<' .. p .. '>')
      if ss then return end
      ss, _ = line:find('%(' .. p .. '%)')
      if ss then return end
      break
    end
  end
  if not s then return end
  local url = line:sub(s, e) -- NOTE: may not contain 'https?://'
  url = cb(url)
  line = line:sub(1, s - 1) .. url .. line:sub(e + 1)
  return line
end

-- normal mode only
local wrap_or_paste = function(cb)
  local line = api.nvim_get_current_line()
  local wrapped = wrap_line(cb, line)
  if not wrapped then return paste(cb) end
  api.nvim_set_current_line(wrapped)
end

local wrap_lines = function(cb)
  -- normal: wrap or paste
  local mode = api.nvim_get_mode().mode
  if mode == 'n' then return wrap_or_paste(cb) end
  -- visual: linewise wrap
  local vs, ve = u.buf.visual_line_region()
  local lines = api.nvim_buf_get_lines(0, vs, ve, true)
  lines = vim.tbl_map(function(line) return wrap_line(cb, line) or line end, lines)
  api.nvim_buf_set_lines(0, vs, ve, true, lines)
end

-- wrap with pos indicator...
local img_cb = function(url, prefix, name)
  prefix = prefix or 'img:'
  name = name or ''
  return ('![%s%s](%s)'):format(prefix, name, url), #prefix + 3, #prefix + #name + 5
end

local raw_cb = function(url) return '<' .. url .. '>', 2 end

local link_cb = function(url, prefix, name)
  prefix = prefix or 'img:'
  name = name or ''
  return ('[%s%s](%s)'):format(prefix, name, url), #prefix + 2, #prefix + #name + 4
end

Markup.wrap_or_paste_img = function() wrap_lines(img_cb) end
Markup.wrap_or_paste_raw = function() wrap_lines(raw_cb) end
Markup.wrap_or_paste_link = function() wrap_lines(link_cb) end

return Markup
