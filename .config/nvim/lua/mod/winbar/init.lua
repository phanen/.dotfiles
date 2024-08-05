_G._winbar = {}

local hlgroups = require('mod.winbar.hlgroups')
local bar = require('mod.winbar.bar')
local cfg = require('mod.winbar.config')
local u = require('mod.winbar.utils')

---on_click callbacks for each winbar symbol
---@type table<string, table<string, function>>
---@see winbar_t.update
_G._winbar.callbacks = setmetatable({}, {
  __index = function(self, buf)
    self[buf] = setmetatable({}, {
      __index = function(this, win)
        this[win] = {}
        return this[win]
      end,
    })
    return self[buf]
  end,
})

---@type table<integer, table<integer, winbar_t>>
_G._winbar.bars = setmetatable({}, {
  __index = function(self, buf)
    self[buf] = setmetatable({}, {
      __index = function(this, win)
        local sources = u.eval(cfg.opts.bar.sources, buf, win) --[[@as winbar_source_t]]
        this[win] = bar.winbar_t:new { sources = sources }
        return this[win]
      end,
    })
    return self[buf]
  end,
})

---Get winbar string for current window
_G._winbar.get_winbar = function()
  local buf = api.nvim_get_current_buf()
  local win = api.nvim_get_current_win()
  return tostring(_G._winbar.bars[buf][win])
end

local id = ag('WinBar', { clear = true })

---@diagnostic disable-next-line: redefined-local
local au = function(ev, opts)
  opts = opts or {}
  opts.group = id
  api.nvim_create_autocmd(ev, opts)
end

local attach = function(buf, win)
  if u.eval(cfg.opts.enable, buf, win) then vim.wo.winbar = '%{%v:lua._winbar.get_winbar()%}' end
end

---@param opts winbar_configs_t?
local setup = function(opts)
  cfg.set(opts)
  hlgroups.init()

  -- for _, win in ipairs(api.nvim_list_wins()) do
  --   attach(api.nvim_win_get_buf(win), win)
  -- end

  au({
    'BufEnter',
    'BufWinEnter',
    'BufWritePost',
  }, {
    callback = function(ev) return attach(ev.buf, 0) end,
    desc = 'Attach winbar',
  })

  au('BufDelete', {
    callback = function(ev)
      u.bar.exec('del', { buf = ev.buf })
      _G._winbar.bars[ev.buf] = nil
      _G._winbar.callbacks[tostring(ev.buf)] = nil
    end,
    desc = 'Remove winbar from cache on buffer wipeout',
  })

  au({
    'CursorMoved',
    'CursorMovedI',
    'WinResized', -- TODO: useless?
  }, {
    callback = function(ev)
      if ev.event == 'WinResized' then
        for _, win in ipairs(vim.v.event.windows or {}) do
          u.bar.exec('update', { win = win })
        end
      else
        u.bar.exec('update', {
          win = ev.event == 'WinScrolled' and tonumber(ev.match) or api.nvim_get_current_win(),
        })
      end
      -- u.bar.exec('update', {
      --   win = api.nvim_get_current_win(),
      -- })
    end,
    desc = 'Update a single winbar',
  })

  au({
    'BufModifiedSet',
    'FileChangedShellPost',
    'TextChanged',
    'TextChangedI',
  }, {
    callback = function(ev) u.bar.exec('update', { buf = ev.buf }) end,
    desc = 'Update all winbars associated with buf',
  })

  au({
    'DirChanged',
    'VimResized',
  }, {
    callback = function() u.bar.exec('update') end,
    desc = 'Update all winbars',
  })

  au({ 'WinClosed' }, {
    callback = function(ev) u.bar.exec('del', { win = tonumber(ev.match) }) end,
    desc = 'Remove winbar from cache on window closed',
  })

  -- hover
  vim.on_key(function(k)
    if k == vim.keycode('<MouseMove>') then u.bar.update_hover_hl(fn.getmousepos()) end
  end)

  au('FocusLost', {
    callback = function() u.bar.update_hover_hl {} end,
    desc = 'Remove hover highlight on focus lost',
  })

  au('FocusGained', {
    callback = function() u.bar.update_hover_hl(fn.getmousepos()) end,
    desc = 'Update hover highlight on focus gained',
  })

  local _clear_bg = function(name)
    -- PERF: table too large?
    local hl = u.hl.get(0, { name = name, winhl_link = false })
    if hl.bg or hl.ctermbg then
      hl.bg = nil
      hl.ctermbg = nil
      api.nvim_set_hl(0, name, hl)
    end
  end

  local clear_winbar_bg = function()
    _clear_bg('WinBar')
    _clear_bg('WinBarNC')
  end
  clear_winbar_bg()
  -- FIXME: unkown? order?
  au('ColorScheme', { group = ag('WinBarHlClearBg', {}), callback = clear_winbar_bg })
end

return { setup = setup }
