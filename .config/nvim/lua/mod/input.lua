_G.ic = function(...) map('!', ...) end
ic('<c-f>', '<right>')
ic('<c-b>', '<left>')
ic('<c-p>', '<up>')
ic('<c-n>', '<down>')
-- ic('<c-a>', '<home>')
-- ic('<c-a>', m.readline.back_to_indentation)
ic('<c-a>', m.readline.dwim_beginning_of_line)
ic('<c-e>', '<end>')
ic('<c-j>', m.readline.forward_word)
ic('<c-o>', m.readline.backward_word)
ic('<c-l>', m.readline.kill_word)
ic('<c-k>', m.readline.kill_line)

-- register play
-- FIXME: don't show leader
-- TODO: a editable dashbord maybe better
-- unkown: let @"=2, don't work for `p`
n(' \'', '<cmd>reg<cr>')
n(' "', '<cmd>reg<cr>')

ic("<c-r>'", '<c-r>"')
--ic("<c-s>'", '<c-r>"')
--ic('<c-r>0', '<c-r>0')
