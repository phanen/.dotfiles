-- note: to review command output: `:h g<`

-- TODO: in visual mode and non-lua filetype, guess if code is written in lua or vimscript
local handlers = {
  lua = function() return ':so<cr>' end,
  vim = function() return ':so<cr>' end,
  fish = function() return ':w !fish<cr>' end,
}

map.n(' so', function()
  local ft = vim.bo.filetype
  local h = handlers[ft]
  if h then return h() end
  return '<ignore>'
end, { expr = true })

local setup = function() end

return { setup = function() end }
