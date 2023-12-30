local api, fn = vim.api, vim.fn
local au = api.nvim_create_autocmd
local ag = api.nvim_create_augroup

-- highlight yank, keep pos
-- TODO: `gq`
-- TODO: TextYankPre?
au("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
    -- if vim.v.event.operator == "y" then vim.fn.setpos(".", vim.g.current_cursor_pos) end
  end,
})
-- au({ "CursorMoved" }, {
--   callback = function() vim.g.current_cursor_pos = vim.fn.getcurpos() end,
-- })

-- credit to https://github.com/jeffkreeftmeijer/vim-numbertoggle
au({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  command = [[if &nu && mode() != 'i' | set rnu   | endif]],
})
au({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  command = [[if &nu | set nornu | endif]],
})

-- restore cursor position
au({ "BufReadPost" }, {
  callback = function() api.nvim_exec('silent! normal! g`"zv', false) end,
})

-- https://www.reddit.com/r/neovim/comments/wjzjwe/how_to_set_no_name_buffer_to_scratch_buffer/
au({ "BufLeave" }, {
  callback = function()
    if fn.line "$" == 1 and fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
    end
  end,
})

-- create directories when needed, when saving a file
au("BufWritePre", {
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

-- reload buffer on focus
au({ "FocusGained", "BufEnter", "CursorHold" }, {
  callback = function()
    if vim.fn.getcmdwintype() == "" then vim.cmd "checktime" end
  end,
})
