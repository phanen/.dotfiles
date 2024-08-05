map.nx('<c- >', u.lazy_req('mder.line').toggle_lines, { buffer = 0 })
map.x('<c-e>', u.lazy_req('mder.codeblock').surround, { buffer = 0 })
map.n('o', u.lazy_req('mder.autolist').listdn, { buffer = 0 })
map.n('O', u.lazy_req('mder.autolist').listup, { buffer = 0 })

map.ox('i<c-e>', u.textobj.codeblock_i, { buffer = 0 })
map.ox('a<c-e>', u.textobj.codeblock_a, { buffer = 0 })

-- TODO: markdown ft modeline...
