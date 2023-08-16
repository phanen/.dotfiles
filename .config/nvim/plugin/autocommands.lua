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

local cur_im = "keyboard-us"
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

function NvimTree_width_ratio(percentage)
	local ratio = percentage / 100
	local width = math.floor(vim.go.columns * ratio)
	return width
end

-- resize nvimtree if window got resized
au({ "VimResized" }, {
	group = api.nvim_create_augroup("NvimTreeResize", { clear = true }),
	callback = function()
		local width = NvimTree_width_ratio(20)
		vim.cmd("tabdo NvimTreeResize " .. width)
	end,
})

-- restore cursor position
au({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		api.nvim_exec('silent! normal! g`"zv', false)
	end,
})

au({ "ColorScheme" }, {
	pattern = "*",
	callback = function() -- inactivate and record
		-- vim.fs.dirname
		local f = assert(io.open(fn.stdpath('config') .. "/theme", "w"))
		f:write(vim.g.colors_name)
		f:close()
	end,
})

-- https://stackoverflow.com/questions/19430200/how-to-clear-vim-registers-effectively
-- let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
-- for r in regs
--   call setreg(r, [])
-- endfor

-- https://www.reddit.com/r/neovim/comments/wjzjwe/how_to_set_no_name_buffer_to_scratch_buffer/
local kill_no_name_group = ag('KillNoName', { clear = true })

au({ "BufLeave" }, {
	pattern = "{}",
	callback = function()
		if fn.line("$") == 1 and fn.getline(1) == "" then
			vim.bo.buftype = "nofile"
			vim.bo.bufhidden = "wipe"
		end
	end,
	group = kill_no_name_group,
})
