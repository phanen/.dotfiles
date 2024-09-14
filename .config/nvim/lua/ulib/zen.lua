-- WIP:
local Zen = {}

local options = {
  border = 'none',
  zindex = 40, -- less than 50, which is the float default
  font = '+4',
  window = { backdrop = 1, width = 85, height = 1.0 },
  hook = {},
}

options.hook.kitty = function(is_open)
  if not fn.executable('kitty') then return end
  local socket = env.KITTY_LISTEN_ON
  local cmd = { 'kitty', '@', '--to', socket, 'set-font-size' }
  cmd[#cmd + 1] = is_open and options.font or '0'
  vim.print(cmd)
  return vim.system(cmd)
end

Zen.is_open = function() return u.is.win_valid(Zen.fg_win) end

Zen.toggle = function(opts)
  if Zen.is_open() then return Zen.close() end
  return Zen.open(opts)
end

Zen.open = function(opts)
  if Zen.is_open() then return end

  opts = u.merge(options, opts or {})

  Zen.prev_win = api.nvim_get_current_win()

  vim.iter(options.hook):each(function(_, fn)
    if vim.is_callable(fn) then fn(true) end
  end)

  Zen.bg_buf = vim.api.nvim_create_buf(false, true)
  Zen.bg_win = vim.api.nvim_open_win(Zen.bg_buf, false, {
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines - vim.o.cmdheight,
    relative = 'editor',
    focusable = false,
    style = 'minimal',
    zindex = opts.zindex - 10,
  })

  local buf = api.nvim_get_current_buf()
  Zen.fg_win = api.nvim_open_win(buf, true, {
    row = 30,
    col = 40,
    width = vim.o.columns,
    height = vim.o.lines - vim.o.cmdheight,
    relative = 'editor',
    zindex = opts.zindex,
    border = opts.border,
  })

  vim.wo[Zen.fg_win].winblend = 0
  vim.wo[Zen.fg_win].winhl = 'NormalFloat:Normal,FloatBorder:ZenBorder'
  vim.wo[Zen.bg_win].winblend = 0
  vim.wo[Zen.bg_win].winhl = 'NormalFloat:ZenBg,FloatBorder:ZenBorder'
end

Zen.close = function()
  if api.nvim_win_get_buf(Zen.prev_win) == api.nvim_win_get_buf(Zen.win) then
    api.nvim_win_set_cursor(Zen.prev_win, api.nvim_win_get_cursor(Zen.win))
  end

  if u.is.win_valid(Zen.fg_win) then api.nvim_win_close(Zen.fg_win, true) end
  Zen.fg_win, Zen.bg_win, Zen.bg_buf = nil, nil, nil

  vim.iter(options.hook):each(function(_, fn)
    if vim.is_callable(fn) then fn(false) end
  end)

  if u.is.win_valid(Zen.prev_win) then api.nvim_set_current_win(Zen.prev_win) end
end

return Zen
