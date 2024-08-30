local n = map.n
local nx = map.nx

-- n(' m;', 'g<')
n(' mk', '<cmd>messages clear<cr>')
-- n(' ml', '<cmd>1messages<cr>')
n(' ml', '<cmd>messages<cr>')
-- TODO: message is chunked, and ... paged, terrible
-- so we use a explicit "redir" wrapper now
-- TODO: toggle it
cmd('R', function(opt) u.msg.pipe_cmd(opt.args) end, {
  nargs = 1,
  complete = 'command',
})
n(' me', '<cmd>R messages<cr>')
n(' ma', u.msg.pipe_messages)

n(' mi', ('<cmd>!tail %s<cr>'):format(g.state_path .. '/lsp.log'))

n(' wo', '<cmd>AerialToggle!<cr>')
n(' wi', '<cmd>LspInfo<cr>')
n(' wl', '<cmd>Lazy<cr>')
n(' wm', '<cmd>Mason<cr>')
n(' wh', '<cmd>ConformInfo<cr>')

n(' bi', '<cmd>ls<cr>')
n(' bI', '<cmd>ls!<cr>')

-- misc
n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
n('+L', u.lazy.lazy_chore_update)
n(' I', '<cmd>lua vim.show_pos()<cr>')
nx(' L', ':Linediff<cr>') -- TODO: quit it

n(" '", '<cmd>marks<cr>')
n(' "', '<cmd>reg<cr>')

nx('_', 'K')
nx('K', ':Translate<cr>')
