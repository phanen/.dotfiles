-- vim.keymap.set("x", "a", "<Plug>(nvim-surround-visual)j")
-- vim.keymap.set("x", "i", "<Plug>(nvim-surround-visual)*")

local function getClipContent()
  return vim.fn.system { "xsel", "-ob" }
end


local function link_wrap(type)
  return function()
    local text = getClipContent()
    text = string.gsub(text, "\n", "")

    if type == "raw" then
      text = "<" .. text .. ">"
    elseif type == "link" then
      text = "[]<" .. text .. ">"
    elseif type == "img" then
      text = "![]<" .. text .. ">"
    elseif type == "git" then
      text = string.gsub(text, "(https)://github.com/", "")
      -- text = string.gsub(text, "(https%|http)://github.com/", "")
    end
    vim.api.nvim_paste(text, true, 1)
  end
end

map({ "n", "x" }, "<leader>il", link_wrap("raw"))
-- map({ "n", "x" }, "<leader>il", link_wrap("link"))
map({ "n", "x" }, "<leader>ii", link_wrap("img"))
map({ "n", "x" }, "<leader>ig", link_wrap("git"))
