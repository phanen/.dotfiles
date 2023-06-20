local g, fn, opt, loop, env, cmd = vim.g, vim.fn, vim.opt, vim.loop, vim.env, vim.cmd

-- g.os = loop.os_uname().sysname

g.mapleader = " "
g.maplocalleader = ","

for _, source in ipairs {
  "keymaps",
  "settings",
  "commands",
  "pacman",
} do
  local ok, fault = pcall(require, source)
  if not ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

-- filter down a quickfix list
cmd.packadd "cfilter"

local cur_hour = tonumber(fn.system "date +%H")
if env.TERM == "linux" then
  g.colorscheme = "default"
elseif cur_hour >= 18 or cur_hour <= 6 then
  g.colorscheme = "kanagawa-wave"
else
  g.colorscheme = "kanagawa-lotus"
end
vim.cmd("colorscheme " .. "kanagawa-lotus")
-- vim.cmd("colorscheme " .. "catppuccin")
-- vim.cmd("colorscheme " .. "doom-one")
