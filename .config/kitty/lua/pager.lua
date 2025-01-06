-- https://gist.github.com/galaxia4Eva/9e91c4f275554b4bd844b6feece16b3d
local api = vim.api
local o = vim.opt
o.clipboard = 'unnamedplus'
o.cmdheight = 0
o.fillchars = { eob = ' ' }
o.laststatus = 0
o.report = 999999 -- arbitrary large number to hide yank messages
o.ruler = false
o.scrolloff = 20
o.scrollback = 99999
o.shortmess:append 'I' -- no intro message
o.showcmd = false
o.showmode = false
o.termguicolors = true
-- o.virtualedit = 'all' -- all or onemore for correct position
o.wrap = false
o.ignorecase = true
o.smartcase = true
local m = function(mode, lhs, rhs) return api.nvim_set_keymap(mode, lhs, rhs, { noremap = true }) end
m('c', '<c-f>', '<right>')
m('c', '<c-b>', '<left>')
m('c', '<c-a>', '<home>')
m('c', '<c-e>', '<end>')
m('n', '<cr>', '<cmd>sil! !kitten @launch --type overlay nvim <cfile><cr>')
m('n', 'q', '<cmd>q<cr>')
m('n', 'i', '<cmd>q<cr>')
m('n', 'a', '<cmd>q<cr>')
m('n', '<esc>', '<cmd>noh<cr><esc>')
m('n', ' m', '<cmd>messages<cr>')
m('n', '$', 'g_')
m('n', '<c-d>', '<c-d>zz')
m('n', '<c-u>', '<c-u>zz')
m('n', 'd', '<c-d>')
m('n', 'u', '<c-u>')

-- https://github.com/neovim/neovim/commit/ed089369
local buf = api.nvim_create_buf(false, false)
local win = api.nvim_get_current_win()
local chan = api.nvim_open_term(buf, {})

-- TODO: catcat
---@param INPUT_LINE_NUMBER integer the first shown line's offset from the last line in the first page (+ 1)
---@param CURSOR_LINE integer relative line (1-based, when equal to 0, there's no cursor in screen)
---@param CURSOR_COLUMN integer relative column (1-based)
return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
  -- convert 1-base col to 1-base byte (when overflow, narrow to line's byte len)
  local width2byte = function(str, col)
    local len, byte, strlen = 0, 0, str:len()
    while len < col and byte < strlen do
      local off = vim.str_utf_end(str, byte + 1)
      len = len + api.nvim_strwidth(str:sub(byte + 1, byte + 1 + off))
      byte = byte + 1 + off
    end
    return byte
  end
  local setCursor = function()
    vim.wait(10)
    local row, col, off = CURSOR_LINE, CURSOR_COLUMN, INPUT_LINE_NUMBER
    row = row == 0 and math.floor((vim.o.lines + 1) / 2) or row -- no cursor, then focus the middle line (scrolloff)
    row = math.min(api.nvim_buf_line_count(buf), row + off - 1)
    local line = api.nvim_buf_get_lines(buf, row - 1, row, true)[1]
    col = math.max(1, width2byte(line, col))
    local save_scrolloff = vim.o.scrolloff
    vim.o.scrolloff = 999
    api.nvim_win_set_cursor(win, { row, col - 1 })
    vim.o.scrolloff = save_scrolloff
  end
  api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function(ev)
      api.nvim_chan_send(chan, table.concat(api.nvim_buf_get_lines(ev.buf, 0, -1, false), '\n'))
      api.nvim_win_set_buf(win, buf)
      api.nvim_buf_delete(ev.buf, { force = true })
      vim.schedule(setCursor)
    end,
  })
end
