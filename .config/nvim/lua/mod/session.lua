-- reload current session to check whatever, with a new wrap starter .bin/nvim
-- TODO: more thing need to be preserved, `SessionWritePost`
n('<c-s><c-d>', '<cmd>mksession! /tmp/reload.vim | 123cq!<cr>')
n(' ss', '<cmd>mksession! /tmp/Session.vim<cr><cmd>q!<cr>')
n(' sl', '<cmd>so /tmp/Session.vim<cr>')
-- TODO: in visual mode and non-lua filetype, guess if code is written in lua or vimscript
nx(' so', ':so<cr>')
