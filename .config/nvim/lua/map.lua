-- TODO: dsi dsa not work?

-- motion
map('', ' ', '<nop>')

-- try fast-move
-- nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
-- nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

-- FIXME: if in the start/end, go to next start/end
-- FIXME: if in the first line/ last line
-- nx('{', '<cmd>keepj norm! {j<cr>')
-- nx(
--   '}',
--   function()
--     return vim.fn.line('.') == vim.fn.line('$') and '<cmd>keepj norm! }<cr>'
--       or '<cmd>keepj norm! }k<cr>'
--   end,
--   { expr = true }
-- )

nx('$', 'g_')
x('.', ':norm .<cr>')
-- https://github.com/neovim/neovim/discussions/24285
n(
  'z*',
  [[ms<cmd>let @/='\V\<'.escape(expand('<cword>'), '/\').'\>' | call histadd('/',@/) | set hlsearch<cr>]]
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
for _, k in pairs({ 'd', 'D', 'c', 'C' }) do
  nx(k, '"k' .. k)
  -- nx('+' .. k, k)
  -- nx(k, ([[v:count == 0 ? '"_%s' : '%s']]):format(k, k), { expr = true })
end
-- NOTE: dl???
n('x', [[v:count == 0 ? '"_x' : 'x']], { expr = true })
n(' j', '<cmd>t .<cr>')
x(' j', '"gy\'>"gp')
n('gy', '`[v`]')
nx('<c-p>', '"kP')

-- comment
map({ 'n', 'x', 'i' }, '<c-_>', '<c-/>', { remap = true })
x('<c-/>', 'gc', { remap = true })
-- TODO: comment empty line?
map('i', '<c-/>', '<cmd>norm <c-/><cr>')
n('<c-/>', function() return vim.v.count == 0 and 'gcl' or 'gcj' end, { expr = true, remap = true })
n(' <c-/>', '<cmd>norm vic<c-/><cr>')

-- buf
n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
n('<c-f>', '<cmd>BufferLineCycleNext<cr>')
-- n('<c-h>', '<c-^>')
n('<c-w>', r('lib.buf').delete)
n('H', '<cmd>BufferLineMovePrev<cr>')
n('L', '<cmd>BufferLineMoveNext<cr>')
n(' bi', '<cmd>buffers<cr>')
n(' bI', '<cmd>buffers!<cr>')
n(' bl', '<cmd>BufferLineCloseLeft<cr>')
n(' bo', '<cmd>BufferLineCloseOthers<cr>')
n(' br', '<cmd>BufferLineCloseRight<cr>')

n(' <c-o>', r('lib.buf').backward)
n(' <c-i>', r('lib.buf').forward)
n('<a-o>', r('lib.buf').backward_same_buf)
n('<a-i>', r('lib.buf').forward_same_buf)

-- win
n('<c-j>', '<cmd>wincmd w<cr>')
n('<c-k>', '<cmd>wincmd W<cr>')

-- TODO: make resize repeatable
n('<c-s>', function()
  api.nvim_feedkeys(vim.keycode '<c-w>', 'n', true)
  local char = fn.getcharstr()
  api.nvim_feedkeys(char, 'n', true)
  -- thiss work, but not trigger pending
  -- but use <c-g> trigger a pending
  -- if char ~= 'g' then return end
  -- weird
  -- api.nvim_feedkeys(fn.getcharstr(), 'n', true)
end, { expr = true })

-- smart shrink/expand
n('<c-s><', '<cmd>wincmd 10<<cr>')
n('<c-s>>', '<cmd>wincmd 10><cr>')

-- n('<c-s>g', function()
--   api.nvim_feedkeys(vim.keycode '<c-w><c-g>', 'n', true)
--   -- api.nvim_feedkeys(vim.keycode '<c-w>g', 'n', true)
--   -- api.nvim_feedkeys('g', 'n', true)
--   -- api.nvim_feedkeys(vim.keycode '<c-g><c-g>', 'n', true)
--   api.nvim_feedkeys(fn.getcharstr(), 'n', true)
-- end)
-- a.md

n('<c-s>+', '<cmd>resize +5<cr>')
n('<c-s>-', '<cmd>resize -5<cr>')
n('<c-s><c-s>', '<cmd>wincmd q<cr>')
-- n('<c-s>gf', '<cmd>wincmd gf<cr>')
n(' k', '<cmd>NvimTreeFindFileToggle<cr>')
n(' q', r('lib.qf').qf_toggle)
n('+q', r('lib.util').force_close_tabpage)
-- n('q', r('lib.util').smart_quit)
n('q', r('lib.util').smart_quit)
n(' wo', '<cmd>AerialToggle!<cr>')
-- n(' wo', '<cmd>Outline<cr>')
n(' wi', '<cmd>LspInfo<cr>')
n(' wl', '<cmd>Lazy<cr>')
n(' wm', '<cmd>Mason<cr>')
n(' wh', '<cmd>ConformInfo<cr>')

-- n(' Q', '<cmd>quitall!<cr>')
n(' Q', '<cmd>=os.exit()<cr>')

-- for i = 1, 9 do
--   n(tostring(i), '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>')
-- end

-- options
n(' oc', '<cmd>set cursorline! cursorcolumn!<cr>')
n(' or', '<cmd>retab<cr>')
n(' os', '<cmd>set spell!<cr>')
n(' ow', '<cmd>set wrap!<cr>')
n(' ol', '<cmd>set columns=80<cr>')
n(' oL', '<cmd>if &laststatus == 0 | set laststatus=2 | else | set laststatus=0 | endif<cr>')
n(' oi', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>')

-- misc
n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
-- you know the trick
n('+L', r('lib.lazy').lazy_chore_update)
n(' I', '<cmd>lua vim.show_pos()<cr>')
nx(' E', ':EditCodeBlock<cr>')
nx(' L', ':Linediff<cr>')

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
n(' ma', function() require('lib.util').pipe_cmd('messages') end)

n('-', '<cmd>TSJToggle<cr>')
nx('_', 'K')
nx('K', ':Translate<cr>')

n(' cd', r('lib.util').smart_cd)
n(' cf', '<cmd>cd %:h<cr>')
n(' cy', r('lib.util').yank_filename)
-- https://github.com/search?q=cgn+lang:vim
--
n(' c*', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]])
x(' c*', [[sy:let @/=@s<cr>cgn]])

n(' cx', '<cmd>!chmod +x %<cr>')
n(' cX', '<cmd>!chmod -x %<cr>')

map('t', '<c- >', '<c-\\><c-n>')
map({ 't', 'n' }, '<c-\\>', '<cmd>execute v:count . "ToggleTerm"<cr>')

-- diagnostics
n(' di', '<cmd>lua vim.diagnostic.open_float()<cr>')
n(' do', '<cmd>lua vim.diagnostic.setqflist()<cr>')
n(' dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
n(' dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
n(' ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')

n('+rd', ':Delete!')
n('+rr', function() return ':Rename ' .. vim.api.nvim_buf_get_name(0) end, { expr = true })

n('i', function()
  if vim.v.count > 0 then return 'i' end
  if #vim.api.nvim_get_current_line() == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

-- more break point
for _, char in ipairs({ ' ', '-', '_', ':', '.', '/' }) do
  map('i', char, function() return char .. '<c-g>u' end, { expr = true })
end

n('[ ', r('lib.util').blank_above)
n('] ', r('lib.util').blank_below)

n(' gJ', function()
  -- persist?
  n('J', 'gJ')
  n('gJ', 'J')
end)

-- x('>', ':ri<cr>')
x('<', ':le<cr>')
-- or just use 'x[p'

-- TODO: on autocmd, KeymapAdd?
-- vim.defer_fn(function()
--   local maps = vim.api.nvim_get_keymap('o')
--   vim.iter(maps):filter(function(map) return map.lhs:match('^i') end)
-- end, 100)

-- vim.cmd [[
-- inoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
-- cnoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
-- ]]
--
--
n('<leader>vb', '<cmd>ls<cr>', { desc = 'Show (listed) [b]uffers (:ls)' })
n('<leader>vB', '<cmd>ls!<cr>', { desc = 'Show all [b]uffers (:ls!)' })
n('<leader>vl', '<cmd>set buflisted<cr>', { desc = '[L]ist current buffer in buffer list' })
n('<leader>vu', '<cmd>set nobuflisted<cr>', { desc = '[U]nlist current buffer' })
