vim.g.markdown_recommended_style = 0

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

-- toggle checkbox/list
local C = "%[x%]"
local E = "%[ %]"
local ITEMS = { "%-", "%+", "%*", "%=", "%d+%." }

local has_box = function(line, box)
  return vim.iter(ITEMS):any(function(i) return line:find("^%s*" .. i .. " " .. box) end)
end

local make_box = function(line)
  for _, i in ipairs(ITEMS) do
    local new_line, ok = line:gsub("^(%s*" .. i .. "%s)(.*)", "%1[ ] %2", 1)
    if ok == 1 then return new_line end
  end
  local new_line = line:gsub("(%S*)", "* %1", 1)
  return new_line
end

local toggle_line = function(line)
  if line == "" then return "* " end
  if has_box(line, C) then
    local new_line = line:gsub(C, E, 1)
    return new_line
  end
  if has_box(line, E) then
    local new_line = line:gsub(E, C, 1)
    return new_line
  end
  return make_box(line)
end

local getvpos = function()
  local vs, ve = vim.fn.getpos(".")[2], vim.fn.getpos("v")[2]
  if vs > ve then
    vs, ve = ve, vs
  end
  return vs - 1, ve
end

local toggle = function()
  local vs, ve = getvpos()
  local lines = vim.api.nvim_buf_get_lines(0, vs, ve, false)
  vim.api.nvim_buf_set_lines(0, vs, ve, false, vim.iter(lines):map(toggle_line):totable())
end

-- context-aware item creator
local list_item = function(c)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
    for it, pat in pairs {
      ["-"] = "%-",
      ["+"] = "%+",
      ["*"] = "%*",
      ["="] = "%=",
    } do
      if line:find("^%s*" .. pat .. " %[ %]") then return c .. it .. " [ ] " end
      if line:find("^%s*" .. pat .. " ") then return c .. it .. " " end
    end
    return c
  end
end

-- surround codeblock with correct indent
local wrap_codeblock = function()
  local vs, ve = vim.fn.getpos(".")[2], vim.fn.getpos("v")[2]
  if vs > ve then
    vs, ve = ve, vs
  end
  vs = vs - 1
  local lines = vim.api.nvim_buf_get_lines(0, vs, ve, false)
  lines = { "```", unpack(lines) }
  lines[#lines + 1] = "```"
  vim.api.nvim_buf_set_lines(0, vs, ve, false, lines)

  vim.api.nvim_feedkeys(k "<esc>", "x", false)
  vim.api.nvim_win_set_cursor(0, { vs + 1, 3 })
  vim.api.nvim_feedkeys(k "A", "n", false)
end

local au = vim.api.nvim_create_autocmd
au("Filetype", {
  pattern = { "markdown", "typst" },
  callback = function()
    map({ "n", "x" }, "<c- >", toggle, { buffer = 0 })
    map("n", "o", list_item "o", { expr = true, buffer = 0 })
    map("n", "O", list_item "O", { expr = true, buffer = 0 })
    map({ "n", "x" }, "<leader>il", link_wrap "raw", { buffer = 0 })
    map({ "n", "x" }, "<leader>ii", link_wrap "img", { buffer = 0 })
    map("x", "<c-e>", wrap_codeblock)
  end,
})
