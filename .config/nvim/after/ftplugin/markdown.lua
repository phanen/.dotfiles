local n = map.n[0]
local nx = map.nx[0]
local ox = map.ox[0]
local x = map.x[0]

vim.o.wrap = true

nx['<c-t>'] = u.markup.toggle_lines
n['o'] = u.markup.listdn
n['O'] = u.markup.listup
x['<c-e>'] = u.markup.surround
ox['i<c-e>'] = u.textobj.codeblock_i
ox['a<c-e>'] = u.textobj.codeblock_a
nx[' E'] = ':EditCodeBlock<cr>'
