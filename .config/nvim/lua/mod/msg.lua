-- n(' m;', 'g<')
n(' mk', '<cmd>messages clear<cr>')
-- n(' ml', '<cmd>1messages<cr>')
n(' ml', '<cmd>messages<cr>')
-- TODO: message is chunked, and ... paged, terrible
-- so we use a explicit "redir" wrapper now
-- TODO: toggle it
cmd('R', function(opt) require('lib.util').pipe_cmd(opt.args) end, {
  nargs = 1,
  complete = 'command',
})
n(' me', '<cmd>R messages<cr>')
-- command! -nargs=1 -complete=command Redir lua require('lib.util').pipe_cmd(<q-args>)()
-- command! -nargs=1 RedirT silent call <SID>redir('tabnew', <f-args>)
n(' ma', function() require('lib.msg').pipe_cmd('messages') end)
