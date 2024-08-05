-- make % usable
-- vim.cmd [[se ft=bash]]
-- workaround, mis touch
map.n('<c-o>', '<nop>', { buffer = 0 })
map.n('<c-i>', '<nop>', { buffer = 0 })

-- workaround, insert at bottom not work
map.n('i', 'A', { buffer = 0 })
