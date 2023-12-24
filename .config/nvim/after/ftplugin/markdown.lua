local link_wrap = function(type)
  return function()
    local text = vim.fn.getreg("+")
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

vim.api.nvim_create_autocmd("Filetype", {
  group = vim.api.nvim_create_augroup("latex_group", { clear = true }),
  pattern = { "markdown", },
  callback = function()
    local m = function(lhs, rhs)
      map({ "n", "x" }, lhs, rhs, { buffer = 0 })
    end
    m("<leader>il", link_wrap "raw")
    m("<leader>ii", link_wrap "img")
  end
})
