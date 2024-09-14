-- WIP: support split,vsplit,tab
-- WIP: multiple win (in multiple tab)

---@alias TermCmd string|string[]|function

---@class TermConfig
---@field cmd TermCmd
---@field clear_env boolean
---@field env? table
---@field on_exit? function
---@field on_stdout? function
---@field on_stderr? function
---@field auto_close boolean
---@field win_config vim.api.keyset.win_config

---@type TermConfig
local defaults = {
  cmd = g.term_shell or vim.o.shell,
  clear_env = false,
  auto_close = true,
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
  'TermOpen',
  function()
    -- u.pp('TermOpen: startinsert')
    vim.cmd.startinsert()
  end,
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
    return setmetatable({
      win = nil,
      buf = api.nvim_create_buf(false, true),
      term = nil,
      config = u.merge(defaults, cfg or {}),
    }, { __index = self })
  end,
})

---@return Term
function Term:create_win()
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
  return self
end

function Term:cleanup()
  if u.is.win_valid(self.win) then api.nvim_win_close(self.win, true) end
  if u.is.buf_valid(self.buf) then api.nvim_buf_delete(self.buf, { force = true }) end
  self.win = nil
  self.buf = nil
  self.term = nil
end

---@return Term
function Term:open_term()
  local cfg = self.config
  self.term = fn.termopen(u.eval(cfg.cmd), {
    clear_env = cfg.clear_env,
    env = cfg.env,
    on_stdout = cfg.on_stdout,
    on_stderr = cfg.on_stderr,
    on_exit = function(job_id, code, ...)
      if cfg.on_exit then cfg.on_exit(job_id, code, ...) end
      -- if cfg.auto_close and code == 0 then Term:cleanup() end
      self:cleanup()
    end,
  })
  return self
end

function Term:toggle()
  if u.is.win_valid(self.win) then
    self:close()
  else
    self:open()
  end
end

--- cannot create unopen term now, so just create and open it
--- buf -> win -> term
function Term:open()
  assert(u.is.buf_valid(self.buf))
  if self.term then
    self:create_win()
    return
  end
  self:create_win()
  self:open_term()
end

function Term:close()
  if u.is.win_valid(self.win) then api.nvim_win_close(self.win, true) end
  self.win = nil
end

---@param cmd TermCmd
---@return Term
function Term:run(cmd)
  self:open()
  cmd = u.eval(cmd)
  cmd = type(cmd) == 'table' and table.concat(cmd, ' ') or cmd
  api.nvim_chan_send(self.term, table.concat({ cmd, vim.keycode('<cr>') }))
  return self
end

return Term
