vim.cmd.runtime { 'after/ftplugin/viewonly.lua', bang = true }
map[0].n.gO = [[:lua require'man'.show_toc()<CR>]]
-- make ression reload work
vim.bo.bt = 'nowrite'
vim.bo.keywordprg = ':Man'
