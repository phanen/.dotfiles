local api, fn = vim.api, vim.fn
local au = api.nvim_create_autocmd
local ag = api.nvim_create_augroup

-- highlight on yank
local highlight_group = ag('YankHighlight', { clear = true })
au('TextYankPost', {
  pattern = '*', -- TODO: why to wrap it
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
})

-- stash the IM when switching modes
local input_method_group = ag('InputMethod', { clear = true })

local cur_im ="keyboard-us"
au({ "InsertLeave" }, {
  pattern = "*",
  callback = function() -- inactivate and record
    cur_im = tostring(fn.system("fcitx5-remote -n"))
    fn.system("fcitx5-remote -c")
  end,
  group = input_method_group,
})

au({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    fn.system("fcitx5-remote -s" .. cur_im)
  end,
  group = input_method_group,
})

local function open_nvim_tree(data)
  if not (fn.isdirectory(data.file) == 1) then return end
  vim.cmd.cd(data.file)
  -- require("nvim-tree.api").tree.open()
end

au({ "VimEnter" }, { callback = open_nvim_tree })

-- smart number from https://github.com/jeffkreeftmeijer/vim-numbertoggle {{{
au({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    command = [[if &nu && mode() != 'i' | set rnu   | endif]],
})

au({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    command = [[if &nu | set nornu | endif]],
})

-- au({ "InsertLeave" }, {
--   pattern = '*.md',
--   command = 'w',
-- })

-- -- format on save
-- local format_group = ag("Format", { clear = true })
-- au({"BufWritePost"}, {
--   pattern = "*",
--   command = 'normal! gg=G``',
--   group = format_group
-- })

-- -- open :h in vsplit right
-- au("BufWinEnter", {
--     group = ag("HelpWindowLeft", {}),
--     pattern = { "*.txt" },
--     callback = function()
--         if vim.o.filetype == 'help' then vim.cmd.wincmd("H") end
--     end
-- })


vim.cmd[[
  au filetype man nnoremap <buffer> d <c-d>
  au filetype man nnoremap <buffer> u <c-u>
]]
