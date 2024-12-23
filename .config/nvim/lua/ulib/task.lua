local Task = {}

local so_handlers = {
  lua = function() return ':so<cr>' end,
  vim = function() return ':so<cr>' end,
  fish = function() return ':w !fish<cr>' end,
}

Task.so = function()
  local ft = vim.bo.filetype
  local h = so_handlers[ft]
  if h then return h() end
  return '<ignore>'
end

-- Code Runner - execute commands in a floating terminal
local runners = {
  -- lua = 'lua',
  lua = { 'nvim', '-l' },
  javascript = 'node',
  rust = { 'cargo', 'run' },
}

Task.termrun = function()
  ---@diagnostic disable-next-line: param-type-mismatch
  local cmd = vim.deepcopy(assert(runners[vim.bo.ft]))
  if cmd then
    if type(cmd) == 'string' then cmd = { cmd } end
    cmd[#cmd + 1] = api.nvim_buf_get_name(0)
    u.muxterm.send(cmd, false)
  end
end

return Task
