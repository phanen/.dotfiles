---@diagnostic disable: undefined-global
vim.loader.enable()
vim.g.mapleader = ' '

local fn = vim.fn

local o = vim.opt
o.clipboard = 'unnamedplus'
o.cmdheight = 0
o.fillchars = { eob = ' ' }
o.laststatus = 0
o.report = 999999 -- arbitrary large number to hide yank messages
o.ruler = false
o.scrollback = 100000
o.scrolloff = 999
o.shortmess:append 'I' -- no intro message
o.showmode = false
o.termguicolors = true -- highlight
o.virtualedit = 'all' -- all or onemore for correct position
o.wrap = false

o.ignorecase = true
o.smartcase = true

local m = vim.keymap.set
local root = fn.stdpath 'data' .. '/lazy'
local plug = function(basename)
  vim.opt.rtp:prepend(root .. '/' .. basename)
  local packname = fn.trim(basename, '.nvim')
  return function(opts) require(packname).setup(opts) end
end

plug 'kitty-scrollback.nvim' {
  custom = function(_)
    return {
      -- keymaps_enabled = false,
      paste_window = { yank_register_enabled = false },
      restore_options = true,
      highlight_overrides = { KittyScrollbackNvimVisual = { bg = 'Cyan', fg = 'Black' } },
    }
  end,
  last_cmd_output = function()
    return {
      paste_window = { yank_register_enabled = false },
      restore_options = true,
      highlight_overrides = { KittyScrollbackNvimVisual = { bg = 'Cyan', fg = 'Black' } },
      kitty_get_text = { extent = 'last_cmd_output', ansi = true },
    }
  end,
}

plug 'flash.nvim' { modes = { search = { enabled = false } } }
m({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end)
m({ 'n', 'x', 'o' }, 's', function() require('flash').jump() end)

m('c', '<c-f>', '<right>')
m('c', '<c-b>', '<left>')
m('c', '<c-p>', '<up>')
m('c', '<c-n>', '<down>')
m('c', '<c-a>', '<home>')
m('c', '<c-e>', '<end>')

-- avoid going back to term mode(paste_window)
m('n', 'i', '<Plug>(KsbCloseOrQuitAll)')
m('n', 'a', '<Plug>(KsbCloseOrQuitAll)')
m('n', 'q', '<Plug>(KsbCloseOrQuitAll)')
m('n', 'a', '<Plug>(KsbCloseOrQuitAll)')
m('n', '<c-c>', 'y')
m('n', 'u', '<c-u>')
m('n', 'd', '<c-d>')
m({ 'n', 'o', 'x' }, 'ga', 'G')

m(
  'n',
  '<leader><leader>',
  function() return '/' .. vim.env.USER .. '@' .. fn.system { 'hostnamectl', 'hostname' } end,
  { expr = true }
)
