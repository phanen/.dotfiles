local link_wrap = function(type)
  return function()
    local text = vim.fn.getreg "+"
    text = string.gsub(text, "\n", "")
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    if type == "raw" then
      text = "<" .. text .. ">"
    elseif type == "img" then
      text = "![img:](" .. text .. ")"
    end
    vim.api.nvim_paste(text, true, 1)
    if type == "link" or type == "img" then
      vim.api.nvim_win_set_cursor(0, { row, col + 6 })
      vim.api.nvim_feedkeys("i", "n", false)
    end
  end
end

local toggle_checkbox = function()
  local CHECK_BOX = "%[x%]"
  local EMPTY_BOX = "%[ %]"
  local PREFIX = "-"
  local toggle_line = function(line)
    local has = function(box) return line:find("^%s*- " .. box) or line:find("^%s*%d%. " .. box) end
    local check = function() return line:gsub(EMPTY_BOX, CHECK_BOX, 1) end
    local clear = function() return line:gsub(CHECK_BOX, EMPTY_BOX, 1) end
    local make_box = function()
      if line:match "^%s*-%s.*$" then return line:gsub("(%s*- )(.*)", "%1[ ] %2", 1) end
      if line:match "^%s*%d%s.*$" then return line:gsub("(%s*%d%. )(.*)", "%1[ ] %2", 1) end
      return line:gsub("(%S+)", PREFIX .. " %1", 1)
    end
    if has(CHECK_BOX) then return clear() end
    if has(EMPTY_BOX) then return check() end
    return make_box()
  end
  local vstart, vend = vim.fn.getpos(".")[2], vim.fn.getpos("v")[2]
  if vstart > vend then
    vstart, vend = vend, vstart
  end
  vstart = vstart - 1
  local lines = vim.api.nvim_buf_get_lines(0, vstart, vend, false)
  for i, line in ipairs(lines) do
    lines[i] = toggle_line(line)
  end
  vim.api.nvim_buf_set_lines(0, vstart, vend, false, lines)
end

-- context-aware item creator
local list_item = function(c)
  return function()
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    return line:find "^%s*- " and c .. "- " or c
  end
end

local m = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.buffer = 0
  map(mode, lhs, rhs, opts)
end
m({ "n", "x" }, "<leader>il", link_wrap "raw")
m({ "n", "x" }, "<leader>ii", link_wrap "img")
m({ "n", "x" }, "<c-space>", toggle_checkbox)
m("n", "o", list_item "o", { expr = true })
m("n", "O", list_item "O", { expr = true })
