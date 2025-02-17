-- https://github.com/rydesun/neovim-config
local Zh = {}

local han = '[\\u3400-\\u4DBF\\u4E00-\\u9FFF\\uF900-\\uFAFF\\U20000-\\U323AF]'
local latin = '[a-zA-Z0-9\'"$&`]'

function Zh.count()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, '%s/' .. han .. '//gn')
end

function Zh.typo_space()
  local cmd = [[silent! %s/\(%s\)\(%s\)/\1 \2/g]]
  vim.cmd(cmd:format('%s', han, latin))
  vim.cmd(cmd:format('%s', latin, han))
  vim.cmd.nohlsearch()
end

return Zh
