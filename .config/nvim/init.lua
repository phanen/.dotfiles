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

-- theme
local f = assert(io.open(fn.expand("$XDG_CONFIG_HOME") .. "/nvim/theme", "r"))
cmd("colorscheme " .. f:read("*all"))
-- cmd("set bg=" .. fn.system("darkman get"))
f:close()
