local map = map[0]
vim.o.wrap = true

map.nx['<c-t>'] = u.markup.toggle_lines
map.n['o'] = u.markup.listdn
map.n['O'] = u.markup.listup
map.x['<c-e>'] = u.markup.surround
map.ox['i<c-e>'] = u.textobj.codeblock_i
map.ox['a<c-e>'] = u.textobj.codeblock_a
