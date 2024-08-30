local n = map.n[0]
local nx = map.nx[0]
local ox = map.ox[0]
local x = map.x[0]

nx('<c- >', u.lazy_req('mder.line').toggle_lines)

n('o', u.lazy_req('mder.autolist').listdn)
n('O', u.lazy_req('mder.autolist').listup)

x('<c-e>', u.lazy_req('mder.codeblock').surround)
ox('i<c-e>', u.textobj.codeblock_i)
ox('a<c-e>', u.textobj.codeblock_a)

nx(' E', ':EditCodeBlock<cr>') -- TODO: kill buffer when close

-- FIXME: markdown ft modeline...
