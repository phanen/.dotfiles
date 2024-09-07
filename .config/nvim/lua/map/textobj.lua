local x = map.x
local o = map.o
local ox = map.ox
local nx = map.nx

ox('aa', '<cmd>TSTextobjectSelect @parameter.outer<cr>')
ox('ia', '<cmd>TSTextobjectSelect @parameter.inner<cr>')
ox('af', '<cmd>TSTextobjectSelect @function.outer<cr>')
ox('if', '<cmd>TSTextobjectSelect @function.inner<cr>')
ox('ar', '<cmd>TSTextobjectSelect @return.outer<cr>')
ox('ir', '<cmd>TSTextobjectSelect @return.outer<cr>')
ox('as', '<cmd>TSTextobjectSelect @class.outer<cr>')
ox('is', '<cmd>TSTextobjectSelect @class.inner<cr>')
ox('aj', '<cmd>TSTextobjectSelect @conditional.outer<cr>')
ox('ij', '<cmd>TSTextobjectSelect @conditional.inner<cr>')
ox('ak', '<cmd>TSTextobjectSelect @loop.outer<cr>')
ox('ik', '<cmd>TSTextobjectSelect @loop.inner<cr>')

-- TODO: dsi dsa not work?
-- TODO: restore pos after `yix`

ox('in', 'iB')
ox('an', 'aB')

-- FIXME: not work the right way
ox('in', '<cmd>lua require("various-textobjs").anyBracket("inner")<cr>')
ox('an', '<cmd>lua require("various-textobjs").anyBracket("outer")<cr>')

ox('iq', '<cmd>lua require("various-textobjs").anyQuote("inner")<cr>')
ox('aq', '<cmd>lua require("various-textobjs").anyQuote("outer")<cr>')

ox('il', '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<cr>')

ox('al', '<cmd>lua require("various-textobjs").url()<cr>')

ox('iu', '<cmd>lua require("various-textobjs").url()<cr>')

ox('id', '<cmd>lua require("various-textobjs").diagnostic("wrap")<cr>')

ox('ig', u.textobj.buffer)

-- x('ag', ':<c-u>sil! keepj norm! ggVG<cr>', { silent = true, remap = true })
-- x('ig', ':<c-u>sil! keepj norm! ggVG<cr>', { silent = true, remap = true })
-- o('ag', '<cmd>sil! norm m`Vaf<cr><cmd>sil! norm! ``<cr>', { silent = true, remap = true })
-- o('ig', '<cmd>sil! norm m`Vif<cr><cmd>sil! norm! ``<cr>', { silent = true, remap = true })

ox('ic', u.textobj.comment)
-- TODO: line before
ox('ac', u.textobj.comment)

x.expr.remap('iz', [[':<c-u>sil! keepj norm! ' . v:lua.u.textobj.fold('i') . '<cr>']])
x.expr.remap('az', [[':<c-u>sil! keepj norm! ' . v:lua.u.textobj.fold('a') . '<cr>']])
o.remap('iz', '<cmd>sil! norm Viz<cr>')
o.remap('az', '<cmd>sil! norm Vaz<cr>')

ox('ii', u.textobj.indent_i)
ox('iI', u.textobj.indent_I)
ox('ai', u.textobj.indent_a)
ox('aI', u.textobj.indent_A)

-- didn't work
ox('zz', vim.schedule_wrap(function() vim.cmd.normal { 'a', bang = true } end), { expr = true })

-- don't include extra spaces around quotes
ox.remap('a"', '2i"')
ox.remap("a'", "2i'")
ox.remap('a`', '2i`')

o.remap('g{', '<cmd>sil! norm Vg{<cr>')
o.remap('g}', '<cmd>sil! norm Vg}<cr>')
nx.remap('g{', u.misc.goto_paragraph_firstline)
nx.remap('g}', u.misc.goto_paragraph_lastline)
