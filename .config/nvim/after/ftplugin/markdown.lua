local function getClipContent()
  return vim.fn.system { "xsel", "-ob" }
end


local function link_wrap(type)
  return function()
    local text = getClipContent()
    text = string.gsub(text, "\n", "")

    local line_no, col_no = unpack(vim.api.nvim_win_get_cursor(0))
    if type == "raw" then
      text = "<" .. text .. ">"
    elseif type == "link" then
      text = "[link:](" .. text .. ")"
    elseif type == "img" then
      text = "![img:](" .. text .. ")"
    elseif type == "git" then
      text = string.gsub(text, "https://github.com/", "")
      text = string.gsub(text, "http://github.com/", "")
      text = string.gsub(text, "git@github.com:", "")
      text = string.gsub(text, "github.com/", "")
    end

    vim.api.nvim_paste(text, true, 1)

    if type == "link" or type == "img" then
      vim.api.nvim_win_set_cursor(0, { line_no, col_no + 6 })
      vim.api.nvim_feedkeys("i", "n", false)
    end
  end
end

map({ "x" }, "`", "<Plug>(nvim-surround-visual)`")

map({ "n", "x" }, "<leader>il", link_wrap("raw"))
-- map({ "n", "x" }, "<leader>il", link_wrap("link"))
map({ "n", "x" }, "<leader>ii", link_wrap("img"))
map({ "n", "x" }, "<leader>ig", link_wrap("git"))
