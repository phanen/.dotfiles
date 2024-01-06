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

local item_pattern = {
  ["-"] = "%-",
  ["+"] = "%+",
  ["*"] = "%*",
  ["="] = "%=",
}

local toggle_checkbox = function()
  local C = "%[x%]"
  local E = "%[ %]"
  local toggle_line = function(line)
    local has = function(box)
      for _, pat in pairs(item_pattern) do
        if line:find("^%s*" .. pat .. " " .. box) then return true end
      end
      return false
    end
    local check = function() return line:gsub(E, C, 1) end
    local clear = function() return line:gsub(C, E, 1) end
    local make_box = function()
      for _, pat in pairs(item_pattern) do
        if line:match("^%s*" .. pat .. "%s.*$") then return line:gsub("(%s*" .. pat .. " )(.*)", "%1[ ] %2", 1) end
      end
      return line:gsub("(%S+)", "* %1", 1)
    end
    if has(C) then return clear() end
    if has(E) then return check() end
    return make_box()
  end
  local vstart, vend = vim.fn.getpos(".")[2], vim.fn.getpos("v")[2]
  if vstart > vend then
    vstart, vend = vend, vstart
  end
  vstart = vstart - 1
  local lines = vim.api.nvim_buf_get_lines(0, vstart, vend, false)
  for i, line in pairs(lines) do
    lines[i] = toggle_line(line)
  end
  vim.api.nvim_buf_set_lines(0, vstart, vend, false, lines)
end

-- context-aware item creator
local list_item = function(c)
  return function()
    local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    for it, pat in pairs(item_pattern) do
      if line:find("^%s*" .. pat .. " %[ %]") then return c .. it .. " [ ] " end
      if line:find("^%s*" .. pat .. " ") then return c .. it .. " " end
    end
    return c
  end
end

map({ "n", "x" }, "<leader>il", link_wrap "raw", { buffer = 0 })
map({ "n", "x" }, "<leader>ii", link_wrap "img", { buffer = 0 })
map({ "n", "x" }, "<c-space>", toggle_checkbox, { buffer = 0 })
map("n", "o", list_item "o", { expr = true, buffer = 0 })
map("n", "O", list_item "O", { expr = true, buffer = 0 })

vim.bo.tabstop = 4
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
