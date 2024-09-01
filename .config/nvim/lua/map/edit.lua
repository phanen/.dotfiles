local i = map.i
local m = map['']
local n = map.n
local nx = map.nx
local x = map.x

-- FIXME: if in the start/end, go to next start/end
-- FIXME: if in the first line/ last line
-- nx('{', '<cmd>keepj norm! {j<cr>')
-- nx(
--   '}',
--   function()
--     return fn.line('.') == fn.line('$') and '<cmd>keepj norm! }<cr>'
--       or '<cmd>keepj norm! }k<cr>'
--   end,
--   { expr = true }
-- )

-- TODO: harpoon feature
-- n('<c-h>', '<c-^>')

n(' c*', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]]) -- https://github.com/search?q=cgn+lang:vim
x(' c*', [[sy:let @/=@s<cr>cgn]])
n( -- https://github.com/neovim/neovim/discussions/24285
  'z*',
  [[ms<cmd>let @/='\V\<'.escape(expand('<cword>'), '/\').'\>' | call histadd('/',@/) | se hls<cr>]]
)

m(' ', '<nop>')
n('-', '<cmd>TSJToggle<cr>')
nx(' -', '<cmd>e%:p<cr>')
nx('$', 'g_') -- TODO: $$ ^^ like twin (when not in macro mode)
x('.', ':norm .<cr>')
n('[ ', u.misc.blank_above)
n('] ', u.misc.blank_below)
n('gy', '`[v`]')
nx(' gJ', function()
  n('J', 'gJ') -- TODO: toggle
  n('gJ', 'J') -- TODO: eat whitespace?
end)

n.expr('i', function()
  if vim.v.count > 0 then return 'i' end
  if #api.nvim_get_current_line() == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end)

nx.expr('h', u.faster.h)
nx.expr('l', u.faster.l)
nx.expr('j', u.faster.j) -- normal j/k: (<up>/<down>, ':normal j/k')
nx.expr('k', u.faster.k)
nx.expr('<c-d>', u.faster['<c-d>'])
nx.expr('<c-u>', u.faster['<c-u>'])

n(' p', '<cmd>%d _ | norm VP<cr>')
n(' y', '<cmd>%y<cr>')
n(' j', '<cmd>t .<cr>')
x(' j', '"gy\'>"gp')
nx('d', '"kd')
nx('D', '"kD')
nx('c', '"kc')
nx('C', '"kC')
nx('<c-p>', '"kP')

n('<a-k>', '<cmd>move-2<cr>==') -- FIXME: may cause lsp diagnostics error
n('<a-j>', '<cmd>move+<cr>==') -- append `=` to smart indent it
x('<a-j>', ":move '>+<cr>gv=gv")
x('<a-k>', ":move '<-2<cr>gv=gv")
n('<a-h>', '<<')
n('<a-l>', '>>')
x('<a-h>', '<gv')
x('<a-l>', '>gv')
n('<a-n>', '<cmd>ISwapNodeWithRight<cr>')
n('<a-p>', '<cmd>ISwapNodeWithLeft<cr>')
x('>', ':ri<cr>')
x('<', ':le<cr>')
n('<c-h>', '==')
x('<c-h>', '=') -- fix indent (another way: `x[p`)

-- fmt
n('gw', [[<cmd>lua require('conform').format { lsp_fallback = true }<cr>]])
x('gw', [[:lua require('conform').format { lsp_fallback = true }<cr>]])
local s = function(lhs, pattern)
  n(lhs, ('<cmd>%%%s<cr>``'):format(pattern))
  x(lhs, (':%s<cr>``'):format(pattern))
end
s(' rp', [[FullwidthPunctConvert]])
-- x(' rp', ':FullwidthPunctConvert<cr>') -- TODO: not change cursor pos
n(' rj', ':Pangu<cr>') -- TODO: not change cursor pos
x(' ro', ':!sort<cr>')
s(' rs', [[s/\s*$//g<cr>``]])
s(' rl', [[g/^$/d]])
s(' r*', [[s/^\([  ]*\)- \(.*\)/\1* \2/g]])
s(' r ', [[s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]])
