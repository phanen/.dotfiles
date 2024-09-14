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
  rust = { 'cargo', 'build' },
}

Task.termrun = function()
  local buf = vim.api.nvim_buf_get_name(0)
  local ftype = vim.filetype.match({ filename = buf })
  local exec = runners[ftype]
  if exec ~= nil then
    if type(exec) == 'string' then exec = { exec } end
    u.muxterm.scratch { cmd = vim.list_extend(exec, { buf }) }
  end
end

return Task
