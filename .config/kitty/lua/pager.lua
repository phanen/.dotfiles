---@diagnostic disable: undefined-global
---@param INPUT_LINE_NUMBER string
---@param CURSOR_LINE string
---@param CURSOR_COLUMN string
-- https://gist.github.com/galaxia4Eva/9e91c4f275554b4bd844b6feece16b3d
return function(INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)
  -- print('kitty sent:', INPUT_LINE_NUMBER, CURSOR_LINE, CURSOR_COLUMN)

  vim.loader.enable()
  vim.g.mapleader = ' '

  local o = vim.opt
  o.clipboard = 'unnamedplus'
  o.cmdheight = 0
  o.fillchars = { eob = ' ' }
  o.laststatus = 0
  o.report = 999999 -- arbitrary large number to hide yank messages
  o.ruler = false
  -- o.scrollback = INPUT_LINE_NUMBER + CURSOR_LINE
  o.scrollback = 99999
  o.shortmess:append 'I' -- no intro message
  o.showcmd = false
  o.showmode = false
  o.termguicolors = true
  o.virtualedit = 'all' -- all or onemore for correct position
  o.wrap = false
  -- o.modeline = false

  vim.opt.ignorecase = true
  vim.opt.smartcase = true

  -- setup keymap first in case we crash in half
  local m = vim.keymap.set
  m({ 'n', 'x', 'o' }, 's', "<cmd>lua require('flash').jump()<cr>")
  m({ 'n', 'x', 'o' }, 's', "<cmd>lua require('flash').jump()<cr>")
  -- m({ 'n', 'x', 'o' }, '<c-s>', "<cmd>lua require('flash').jump()<cr>")
  m('c', '<c-f>', '<right>')
  m('c', '<c-b>', '<left>')
  m('c', '<c-p>', '<up>')
  m('c', '<c-n>', '<down>')
  m('c', '<c-a>', '<home>')
  m('c', '<c-e>', '<end>')

  m('n', '<c-f>', '<nop>')
  m('n', '<c-b>', '<nop>')
  m('n', 'q', '<cmd>q<cr>')
  m('n', 'i', '<cmd>q<cr>')
  m('n', 'a', '<cmd>q<cr>')
  -- m('n', '<esc>', '<cmd>q<cr>')
  m('n', ' m', '<cmd>messages<cr>')

  m('n', '$', 'g_')
  m('n', '<c-d>', '<c-d>zz')
  m('n', '<c-u>', '<c-u>zz')

  local term_bufnr = vim.api.nvim_create_buf(true, false)
  local term_io = vim.api.nvim_open_term(term_bufnr, {})

  local setCursor = function()
    vim.api.nvim_feedkeys(tostring(INPUT_LINE_NUMBER) .. 'ggzt', 'n', true)
    local line = vim.api.nvim_buf_line_count(term_bufnr)
    ---@diagnostic disable-next-line: cast-local-type
    if CURSOR_LINE <= line then line = CURSOR_LINE end
    vim.api.nvim_feedkeys(tostring(line - 1) .. 'j', 'n', true)
    vim.api.nvim_feedkeys('0', 'n', true)
    vim.api.nvim_feedkeys(tostring(CURSOR_COLUMN - 1) .. 'l', 'n', true)
  end

  vim.api.nvim_create_autocmd('ModeChanged', {
    buffer = term_bufnr,
    callback = function()
      if vim.api.nvim_get_mode().mode == 't' then
        vim.cmd.stopinsert()
        vim.schedule(setCursor)
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    once = true,
    callback = function(args)
      local current_win = vim.fn.win_getid()
      for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, -2, false)) do
        vim.api.nvim_chan_send(term_io, line)
        vim.api.nvim_chan_send(term_io, '\r\n')
      end
      for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, -2, -1, false)) do
        vim.api.nvim_chan_send(term_io, line)
      end

      vim.api.nvim_win_set_buf(current_win, term_bufnr)
      vim.api.nvim_buf_delete(args.buf, { force = true })
      vim.schedule(setCursor)
    end,
  })

  local root = vim.env.XDG_DATA_HOME .. '/nvim/lazy'

  local plug = function(basename)
    vim.opt.rtp:prepend(root .. '/' .. basename)
    local packname = vim.fn.trim(basename, '.nvim')
    return function(opts) require(packname).setup(opts) end
  end
  plug 'flash.nvim' { modes = { search = { enabled = false } } }

  vim.api.nvim_set_hl(0, 'Visual', { bg = 'Cyan', fg = 'Black' })
end
