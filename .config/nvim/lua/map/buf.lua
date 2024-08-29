local n = map.n

-- buf
n(']b', '<cmd>exec v:count1 . "bn"<cr>')
n('[b', '<cmd>exec v:count1 . "bp"<cr>')
n('<leader>vb', '<cmd>ls<cr>')
n('<leader>vB', '<cmd>ls!<cr>')
n('<leader>vl', '<cmd>se buflisted<cr>')
n('<leader>vu', '<cmd>se nobuflisted<cr>')
n(']->', '<cmd>exec v:count1 . "bn"<cr>')
n('[->', '<cmd>exec v:count1 . "bp"<cr>')

n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
n('<c-f>', '<cmd>BufferLineCycleNext<cr>')

-- n('<c-h>', '<c-^>')
n('H', '<cmd>BufferLineMovePrev<cr>')
n('L', '<cmd>BufferLineMoveNext<cr>')
n(' bi', '<cmd>buffers<cr>')
n(' bI', '<cmd>buffers!<cr>')
n(' bl', '<cmd>BufferLineCloseLeft<cr>')
n(' bo', '<cmd>BufferLineCloseOthers<cr>')
n(' br', '<cmd>BufferLineCloseRight<cr>')

n('<c-w>', u.bufop.delete)
n(' <c-o>', u.bufop.backward_buf)
n(' <c-i>', u.bufop.forward_buf)
n('<a-o>', u.bufop.backward_in_buf)
n('<a-i>', u.bufop.forward_in_buf)
