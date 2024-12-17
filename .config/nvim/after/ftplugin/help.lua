if vim.bo.modifiable then return end
vim.cmd.runtime { 'after/ftplugin/viewonly.lua', bang = true }
