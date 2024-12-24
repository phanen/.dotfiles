-- WIP: support split,vsplit,tab
-- WIP: float (lazy.nvim)

---@alias TermCmd string|string[]|function

---@class TermConfig
---@field cmd TermCmd
---@field cwd? string
---@field clear_env? boolean
---@field env? table
---@field on_exit? function
---@field on_stdout? function
---@field on_stderr? function
---@field auto_close? boolean unused now
---@field win_config vim.api.keyset.win_config

---@type TermConfig
local defaults = {
  cmd = g.term_shell or vim.o.shell,
  clear_env = false,
  -- auto_close = true,
  win_config = {
    height = 0.95,
    width = 0.95,
    col = 0.5,
    row = 0.5,
    border = g.border or 'single',
    relative = 'editor',
    style = 'minimal',
  },
}

u.aug.termmode = {
  'ModeChanged',
  function(ev)
    if vim.bo[ev.buf].bt == 'terminal' then
      vim.b[ev.buf].termode = api.nvim_get_mode().mode
      -- u.pp(ev)
      -- u.pp('change mode to: ' .. vim.b[ev.buf].termode)
    end
  end,
  -- 'TermClose',
  -- function() u.pp('TermClose: this always stopinsert') end,
  { 'BufWinEnter', 'WinEnter' },
  function(info)
    -- u.pp('ModeKeep')
    if
      vim.bo[info.buf].bt == 'terminal'
      -- and (vim.b[info.buf].termode == 't' or not vim.b[info.buf].termode)
      and vim.b[info.buf].termode == 't'
    then
      vim.cmd.startinsert()
    end
  end,
}

---@param win_config vim.api.keyset.win_config
---@return vim.api.keyset.win_config
local get_layout = function(win_config)
  local cl = vim.o.columns
  local ln = vim.o.lines

  -- ratio to integer
  local width = math.ceil(cl * win_config.width)
  local height = math.ceil(ln * win_config.height - 4) -- maybe tabline/statusline
  local col = math.ceil((cl - width) * win_config.col)
  local row = math.ceil((ln - height) * win_config.row - 1)

  return u.merge(win_config, {
    width = width,
    height = height,
    col = col,
    row = row,
  })
end

---@class Term
---@field win integer|nil
---@field buf integer|nil
---@field term integer|nil job id
---@field config TermConfig
local Term = {}

setmetatable(Term, {
  ---@return Term
  __call = function(self, cfg)
    -- buf is always alive (to set b:var on create)
    -- or we can init win here, toggle term via hide/unhide...
    -- or init term on created
    local obj = setmetatable({
      win = nil,
      buf = api.nvim_create_buf(false, true),
      term = nil,
      config = u.merge(defaults, cfg or {}),
    }, { __index = self, __gc = self.cleanup })
    return obj
  end,
})

function Term:open_win()
  local win_config = self.config.win_config
  local lay = get_layout(win_config)
  local win = api.nvim_open_win(
    self.buf,
    true,
    u.merge(win_config, {
      width = lay.width,
      height = lay.height,
      col = lay.col,
      row = lay.row,
    })
  )
  vim.wo[win].winhl = ('Normal:%s'):format('Normal')
  self.win = win
  api.nvim_create_autocmd('VimResized', {
    callback = function()
      if not u.is.win_valid(self.win) then return true end
      api.nvim_win_set_config(self.win, get_layout(self.config.win_config))
    end,
  })
end

function Term:cleanup()
  if u.is.win_valid(self.win) then api.nvim_win_close(self.win, true) end
  if u.is.buf_valid(self.buf) then api.nvim_buf_delete(self.buf, { force = true }) end
  self.win = nil
  self.buf = nil
  self.term = nil
end

---@param term_cfg TermConfig?
function Term:spawn(term_cfg)
  local cfg = u.merge(self.config, term_cfg or {})
  self.term = fn.jobstart(u.eval(cfg.cmd), {
    term = true,
    clear_env = cfg.clear_env,
    cwd = cfg.cwd,
    env = cfg.env,
    on_stdout = cfg.on_stdout,
    on_stderr = cfg.on_stderr,
    on_exit = function(job_id, code, ...)
      if cfg.on_exit then cfg.on_exit(job_id, code, ...) end
      -- if cfg.auto_close and code == 0 then Term:cleanup() end
      self:cleanup()
    end,
  })
end

function Term:is_focusd() return u.is.win_valid(self.win) end

--- cannot create unopen term now, so just create and open it
--- buf (created on init) -> win -> term
---@param opts TermConfig?
function Term:open(opts)
  assert(u.is.buf_valid(self.buf))
  self:open_win()
  if not self.term then self:spawn(opts) end
end

function Term:close()
  if self:is_focusd() then api.nvim_win_close(self.win, true) end
  self.win = nil
end

---@param cmd TermCmd
function Term:send(cmd)
  cmd = u.eval(cmd)
  cmd = type(cmd) == 'table' and table.concat(cmd, ' ') or cmd
  api.nvim_chan_send(self.term, table.concat({ cmd, vim.keycode('<cr>') }))
end

return Term
