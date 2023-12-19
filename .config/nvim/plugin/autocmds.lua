local api, fn = vim.api, vim.fn
local au = api.nvim_create_autocmd
local ag = api.nvim_create_augroup

-- highlight on yank
local highlight_group = ag("YankHighlight", { clear = true })
au("TextYankPost", {
  pattern = "*", -- TODO: why to wrap it
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
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

-- -- open :h in vsplit right
-- au("BufWinEnter", {
--     group = ag("HelpWindowLeft", {}),
--     pattern = { "*.txt" },
--     callback = function()
--         if vim.o.filetype == 'help' then vim.cmd.wincmd("H") end
--     end
-- })

function NvimTree_width_ratio(percentage)
  local ratio = percentage / 100
  local width = math.floor(vim.go.columns * ratio)
  return width
end

-- restore cursor position
au({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function() api.nvim_exec('silent! normal! g`"zv', false) end,
})

-- TODO: better organized
au({ "ColorScheme" }, {
  pattern = "*",
  callback = function()
    -- local f = assert(io.open(fn.stdpath "config" .. "/theme", "w"))
    -- f:write(vim.g.colors_name)
    -- f:close()
  end,
})


-- https://www.reddit.com/r/neovim/comments/wjzjwe/how_to_set_no_name_buffer_to_scratch_buffer/
local kill_no_name_group = ag("KillNoName", { clear = true })
au({ "BufLeave" }, {
  pattern = "{}",
  callback = function()
    if fn.line "$" == 1 and fn.getline(1) == "" then
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
    end
  end,
  group = kill_no_name_group,
})

-- create directories when needed, when saving a file
au("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})
