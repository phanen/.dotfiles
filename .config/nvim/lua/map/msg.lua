-- vim-redir-output

-- n(' m;', 'g<')
map.n(' mk', '<cmd>messages clear<cr>')
-- n(' ml', '<cmd>1messages<cr>')
map.n(' ml', '<cmd>messages<cr>')
-- TODO: message is chunked, and ... paged, terrible
-- so we use a explicit "redir" wrapper now
-- TODO: toggle it
cmd('R', function(opt) u.msg.pipe_cmd(opt.args) end, {
  nargs = 1,
  complete = 'command',
})
map.n(' me', '<cmd>R messages<cr>')

-- command! -nargs=1 -complete=command Redir lua u.util.pipe_cmd(<q-args>)()
-- command! -nargs=1 RedirT silent call <SID>redir('tabnew', <f-args>)
map.n(' ma', function() u.msg.pipe_cmd('messages') end)
