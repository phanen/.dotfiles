vim.g.markdown_recommended_style = 0

do
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
  map({ "n", "x" }, "<leader>il", link_wrap "raw", { buffer = 0 })
  map({ "n", "x" }, "<leader>ii", link_wrap "img", { buffer = 0 })
end

-- toggle checkbox/list
do
  local item_pattern = {
    ["-"] = "%-",
    ["+"] = "%+",
    ["*"] = "%*",
    ["="] = "%=",
  }

  local items = { "%-", "%+", "%*", "%=", "%d+%." }
  local C = "%[x%]"
  local E = "%[ %]"
  local has_box = function(line, box)
    return vim.iter(items):any(function(i) return line:find("^%s*" .. i .. " " .. box) end)
  end

  local make_box = function(line)
    local ok
    for _, i in ipairs(items) do
      line, ok = line:gsub("^(%s*" .. i .. "%s)(.*)", "%1[ ] %2", 1)
      if ok == 1 then return line end
    end
    return ({ line:gsub("(%S*)", "* %1", 1) })[1]
  end

  local toggle_line = function(line)
    if line == "" then return "* " end
    if has_box(line, C) then return ({ line:gsub(C, E, 1) })[1] end
    if has_box(line, E) then return ({ line:gsub(E, C, 1) })[1] end
    return make_box(line)
  end

  local toggle = function()
    local vstart, vend = vim.fn.getpos(".")[2], vim.fn.getpos("v")[2]
    if vstart > vend then
      vstart, vend = vend, vstart
    end
    vstart = vstart - 1
    local lines = vim.api.nvim_buf_get_lines(0, vstart, vend, false)
    vim.api.nvim_buf_set_lines(0, vstart, vend, false, vim.iter(lines):map(toggle_line):totable())
  end
  -- context-aware item creator
  local list_item = function(c)
    return function()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
      for it, pat in pairs(item_pattern) do
        if line:find("^%s*" .. pat .. " %[ %]") then return c .. it .. " [ ] " end
        if line:find("^%s*" .. pat .. " ") then return c .. it .. " " end
      end
      return c
    end
  end
  map({ "n", "x" }, "<c- >", toggle, { buffer = 0 })
  map("n", "o", list_item "o", { expr = true, buffer = 0 })
  map("n", "O", list_item "O", { expr = true, buffer = 0 })
end
