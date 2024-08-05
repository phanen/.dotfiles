map('', ' ', '<nop>')
map('', ' ', '<ignore>') -- ??

local n = map.n
local x = map.x
local nx = map.nx

-- try fast-move
-- nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
-- nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })
nx('<down>', 'v:count ? "<down>" : "g<down>"', { expr = true, replace_keycodes = false })
nx('<up>', 'v:count ? "<up>"   : "g<up>"', { expr = true, replace_keycodes = false })

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

-- TODO: $$ ^^
nx('$', 'g_')
x('.', ':norm .<cr>')
-- https://github.com/neovim/neovim/discussions/24285
n(
  'z*',
  [[ms<cmd>let @/='\V\<'.escape(expand('<cword>'), '/\').'\>' | call histadd('/',@/) | se hls<cr>]]
)

-- FIXME: cause diagnostics error, not well for lsp
n('<a-j>', '<cmd>move+<cr>')
n('<a-k>', '<cmd>move-2<cr>')
x('<a-j>', ":move '>+<cr>gv")
x('<a-k>', ":move '<-2<cr>gv")
n('<a-h>', '<<')
n('<a-l>', '>>')
x('<a-h>', '<gv')
x('<a-l>', '>gv')

-- yank
n(' p', '<cmd>%d _ | norm VP<cr>')
n(' y', '<cmd>%y<cr>')
-- TODO: we need ignore blank delete
-- TODO: not shared amony instance

for _, k in pairs { 'd', 'D', 'c', 'C' } do
  nx(k, '"k' .. k)
  -- nx('+' .. k, k)
  -- nx(k, ([[v:count == 0 ? '"_%s' : '%s']]):format(k, k), { expr = true })
end

-- NOTE: dl???
-- n('x', [[v:count == 0 ? '"_x' : 'x']], { expr = true })
n(' j', '<cmd>t .<cr>')
x(' j', '"gy\'>"gp')
n('gy', '`[v`]')
nx('<c-p>', '"kP')

-- ?
n('[ ', u.util.blank_above)
n('] ', u.util.blank_below)

n(' gJ', function()
  -- persist?
  n('J', 'gJ')
  n('gJ', 'J')
  -- TODO: eat whitespace?
end)

x('>', ':ri<cr>')
x('<', ':le<cr>')
-- or just use 'x[p'

-- TODO: on autocmd, KeymapAdd?
-- vim.defer_fn(function()
--   local maps = api.nvim_get_keymap('o')
--   vim.iter(maps):filter(function(map) return map.lhs:match('^i') end)
-- end, 100)

vim.cmd [[
  " inoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
  " cnoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
]]

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
-- Use `:sil! dif` to suppress error
-- 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits'
-- in command window
-- map(
--   { 'n', 'x' },
--   '<C-l>',
--   [['<cmd>ec|noh|sil! dif<cr>' . (v:hlsearch ? '' : '<c-l>')]],
--   { expr = true, replace_keycodes = false }
-- )

-- nx(' -', '<cmd>e%:p:h<cr>')

n(' cc', '<cmd>try | cclose | lclose | catch | endtry <cr>')
n(' bb', '<c-^>')
n(' go', u.git.browse)

-- Fzf keymaps
n(' ff', '<cmd>FZF<cr>')

-- quickfix
n('<c-g>n', '<cmd>cnext<cr>')
n('<c-g>p', '<cmd>cprev<cr>')

-- options
n(' ob', "<cmd>if &bg == 'dark' | se bg=light | else | se bg=dark | en<cr>")
n(' oc', '<cmd>se cul! cuc!<cr>')
n(' oi', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>')
n(' oL', '<cmd>if &ls == 0 | se ls=2 | else | se ls=0 | en<cr>')

-- terminal
map.t('<c- >', '<c-\\><c-n>')
map.tn('<c-\\>', '<cmd>execute v:count . "ToggleTerm"<cr>')
