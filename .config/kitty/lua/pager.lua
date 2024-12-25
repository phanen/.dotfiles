-- https://gist.github.com/galaxia4Eva/9e91c4f275554b4bd844b6feece16b3d
local api = vim.api
local fn = vim.fn

-- print('kitty sent:', INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
vim.g.mapleader = ' '

local o = vim.opt
o.clipboard = 'unnamedplus'
o.cmdheight = 0
o.fillchars = { eob = ' ' }
o.laststatus = 0
o.report = 999999 -- arbitrary large number to hide yank messages
o.ruler = false
-- o.scrollback = INPUT_LINE_NUMBER + CURSOR_LINE
o.scrolloff = 20
o.scrollback = 99999
o.shortmess:append 'I' -- no intro message
o.showcmd = false
o.showmode = false
o.termguicolors = true
o.virtualedit = 'all' -- all or onemore for correct position
o.wrap = false
-- o.modeline = false

o.ignorecase = true
o.smartcase = true

-- setup keymap first in case we crash in half
local m = function(mode, lhs, rhs) return api.nvim_set_keymap(mode, lhs, rhs, { noremap = true }) end
m('c', '<c-f>', '<right>')
m('c', '<c-b>', '<left>')
m('c', '<c-a>', '<home>')
m('c', '<c-e>', '<end>')
m('n', '<cr>', '<cmd>sil! !kitten @launch --type overlay nvim <cfile><cr>')
m('n', 'q', '<cmd>q<cr>')
m('n', 'i', '<cmd>q<cr>')
m('n', 'a', '<cmd>q<cr>')
-- m('n', '<esc>', '<cmd>q<cr>')
m('n', '<esc>', '<cmd>noh<cr><esc>')
m('n', ' m', '<cmd>messages<cr>')

m('n', '$', 'g_')
m('n', '<c-d>', '<c-d>zz')
m('n', '<c-u>', '<c-u>zz')
m('n', 'd', '<c-d>')
m('n', 'u', '<c-u>')

-- local term_bufnr = api.nvim_get_current_buf()
-- TODO: open_term on current buf https://github.com/neovim/neovim/commit/ed089369
local term_bufnr = api.nvim_create_buf(true, false)
local term_io = api.nvim_open_term(term_bufnr, {})
local feed = api.nvim_feedkeys

-- local paddings = 10
--
local paddings = 0
---@diagnostic disable: undefined-global
---@param INPUT_LINE_NUMBER integer
---@param CURSOR_LINE integer
---@param CURSOR_COLUMN integer
return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
  local setCursor = function()
    print(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
    -- feed(INPUT_LINE_NUMBER .. 'ggzt', 'n', false)
    local line = api.nvim_buf_line_count(term_bufnr)
    ---@diagnostic disable-next-line: cast-local-type
    if CURSOR_LINE <= line then line = CURSOR_LINE end
    -- feed((line - 1) .. 'j', 'n', false)
    -- feed('0', 'n', true)
    -- feed((CURSOR_COLUMN - 1) .. 'l', 'n', false)
    local current_win = fn.win_getid()
    -- TODO: %g %h
    api.nvim_win_set_cursor(
      current_win,
      { line == 0 and line + paddings + 1 or line, CURSOR_COLUMN }
    )
  end

  api.nvim_create_autocmd('ModeChanged', {
    buffer = term_bufnr,
    callback = function()
      if api.nvim_get_mode().mode == 't' then
        vim.cmd.stopinsert()
        vim.schedule(setCursor)
        -- setCursor()
      end
    end,
  })

  api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function(ev)
      local current_win = fn.win_getid()
      local nvim_chan_send = api.nvim_chan_send

      -- padding lines
      -- for _ = 1, paddings do
      --   nvim_chan_send(term_io, '')
      --   nvim_chan_send(term_io, '\r\n')
      -- end
      print(ev.buf)
      for _, line in ipairs(api.nvim_buf_get_lines(ev.buf, 0, -2, false)) do
        nvim_chan_send(term_io, line)
        nvim_chan_send(term_io, '\r\n')
      end
      for _, line in ipairs(api.nvim_buf_get_lines(ev.buf, -2, -1, false)) do
        nvim_chan_send(term_io, line)
      end

      api.nvim_win_set_buf(current_win, term_bufnr)
      api.nvim_buf_delete(ev.buf, { force = true })
      vim.schedule(setCursor)
      -- setCursor()
    end,
  })
end
