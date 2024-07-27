-- TODO: dsi dsa not work?

g.mapleader = ' '
g.maplocalleader = '+'

-- motion
map('', ' ', '<nop>')
map('', ' ', '<ignore>') -- ??

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
for _, k in pairs({ 'd', 'D', 'c', 'C' }) do
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

-- comment
map({ 'n', 'x', 'i' }, '<c-_>', '<c-/>', { remap = true })
x('<c-/>', 'gc', { remap = true })
-- TODO: comment empty line?
map('i', '<c-/>', '<cmd>norm <c-/><cr>')
n('<c-/>', function() return vim.v.count == 0 and 'gcl' or 'gcj' end, { expr = true, remap = true })
n(' <c-/>', '<cmd>norm vic<c-/><cr>')
n('gco', function() require('lib.comment').comment_above_or_below(0) end)
n('gcO', function() require('lib.comment').comment_above_or_below(-1) end)

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

n('<c-w>', u.buf.delete)
n(' <c-o>', u.buf.backward)
n(' <c-i>', u.buf.forward)
n('<a-o>', u.buf.backward_same_buf)
n('<a-i>', u.buf.forward_same_buf)

-- win
n('<c-j>', '<cmd>wincmd w<cr>')
n('<c-k>', '<cmd>wincmd W<cr>')

-- TODO: make resize repeatable
n('<c-s>', function()
  api.nvim_feedkeys(vim.keycode '<c-w>', 'n', true)
  local char = fn.getcharstr()
  if char == 'k' then
  elseif char == 'j' then
  else
    api.nvim_feedkeys(char, 'n', true)
  end
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
n(' q', u.qf.qf_toggle)
n('+q', u.util.force_close_tabpage)
n('q', u.smart.quit)
n(' wo', '<cmd>AerialToggle!<cr>')
-- n(' wo', '<cmd>Outline<cr>')
n(' wi', '<cmd>LspInfo<cr>')
n(' wl', '<cmd>Lazy<cr>')
n(' wm', '<cmd>Mason<cr>')
n(' wh', '<cmd>ConformInfo<cr>')

-- n(' Q', '<cmd>quitall!<cr>')
n(' Q', '<cmd>=os.exit()<cr>')

-- tabpages
local tabswitch = function(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = fn.tabpagenr('$')
    if count <= num_tabs then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end

n('gt', tabswitch(vim.cmd.tabnext))
n('gT', tabswitch(vim.cmd.tabprev))

-- TODO: don't create annoying raw buffer
n(' 0', '<cmd>0tabnew<cr>')
for i = 1, 9 do
  n(' ' .. tostring(i), tabswitch(vim.cmd.tabnext, i))
end
-- for i = 1, 9 do
--   n(tostring(i), '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>')
-- end

-- options
n(' ob', "<cmd>if &bg == 'dark' | se bg=light | else | se bg=dark | en<cr>")
n(' oc', '<cmd>se cul! cuc!<cr>')
n(' oi', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>')
n(' oL', '<cmd>if &ls == 0 | se ls=2 | else | se ls=0 | en<cr>')
-- FIXME: se co=9999
n(' ol', '<cmd>se co=80<cr>')
n(' or', '<cmd>ret<cr>')
n(' os', '<cmd>se spell!<cr>')
n(' ow', '<cmd>se wrap!<cr>')

-- misc
n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
-- you know the trick
n('+L', u.lazy.lazy_chore_update)
n(' I', '<cmd>lua vim.show_pos()<cr>')
-- TODO: kill buffer when close
nx(' E', ':EditCodeBlock<cr>')
nx(' L', ':Linediff<cr>')

n(" '", '<cmd>marks<cr>')
n(' "', '<cmd>reg<cr>')

n('-', '<cmd>TSJToggle<cr>')
nx('_', 'K')
nx('K', ':Translate<cr>')

n(' cd', u.smart.cd)
n(' cf', '<cmd>cd %:h<cr>')
n(' cy', u.util.yank_filename)

-- https://github.com/search?q=cgn+lang:vim
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
n(' dj', '<cmd>lua vim.diagnostic.jump{count = 1}<cr>')
n(' dk', '<cmd>lua vim.diagnostic.jump{count = -1}<cr>')
n(' dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)

n('+rd', ':Delete!')
n('+rr', function() return ':Rename ' .. api.nvim_buf_get_name(0) end, { expr = true })

n('i', function()
  if vim.v.count > 0 then return 'i' end
  if #api.nvim_get_current_line() == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

-- more break point
for _, char in ipairs({ ' ', '-', '_', ':', '.', '/' }) do
  map('i', char, function() return char .. '<c-g>u' end, { expr = true })
end

n('[ ', u.util.blank_above)
n('] ', u.util.blank_below)

n(' gJ', function()
  -- persist?
  n('J', 'gJ')
  n('gJ', 'J')
  -- TODO: eat whitespace?
end)

-- x('>', ':ri<cr>')
x('<', ':le<cr>')
-- or just use 'x[p'

-- TODO: on autocmd, KeymapAdd?
-- vim.defer_fn(function()
--   local maps = api.nvim_get_keymap('o')
--   vim.iter(maps):filter(function(map) return map.lhs:match('^i') end)
-- end, 100)

-- vim.cmd [[
-- inoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
-- cnoremap <c-x><c-o> <cmd>lua require('cmp').complete()<cr>
-- ]]

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

-- TODO: restore pos after `yix`
local ox = function(...) map({ 'o', 'x' }, ...) end
local x = function(...) map('x', ...) end
local o = function(...) map('o', ...) end

ox('in', 'iB')
ox('an', 'aB')

-- FIXME: not work the right way
ox('in', '<cmd>lua require("various-textobjs").anyBracket("inner")<cr>')
ox('an', '<cmd>lua require("various-textobjs").anyBracket("outer")<cr>')

ox('iq', '<cmd>lua require("various-textobjs").anyQuote("inner")<cr>')
ox('aq', '<cmd>lua require("various-textobjs").anyQuote("outer")<cr>')

-- FIXME: vil<esc>, then hang
ox('il', '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<cr>')

ox('al', '<cmd>lua require("various-textobjs").url()<cr>')

ox('iu', '<cmd>lua require("various-textobjs").url()<cr>')

ox('id', '<cmd>lua require("various-textobjs").diagnostic("wrap")<cr>')

ox('ig', u.textobj.buffer)
-- x('ag', ':<c-u>sil! keepj norm! ggVG<cr>', { silent = true, remap = true })
-- x('ig', ':<c-u>sil! keepj norm! ggVG<cr>', { silent = true, remap = true })
-- o('ag', '<cmd>sil! norm m`Vaf<cr><cmd>sil! norm! ``<cr>', { silent = true, remap = true })
-- o('ig', '<cmd>sil! norm m`Vif<cr><cmd>sil! norm! ``<cr>', { silent = true, remap = true })

ox('ic', u.textobj.comment)

x(
  'iz',
  [[':<c-u>sil! keepj norm! ' . v:lua.require'lib.textobj'.fold('i') . '<cr>']],
  { silent = true, expr = true, remap = true }
)
x(
  'az',
  [[':<c-u>sil! keepj norm! ' . v:lua.require'lib.textobj'.fold('a') . '<cr>']],
  { silent = true, expr = true, remap = true }
)
o('iz', '<cmd>sil! norm Viz<cr>', { silent = true, remap = true })
o('az', '<cmd>sil! norm Vaz<cr>', { silent = true, remap = true })

ox('ii', u.textobj.indent_i)
ox('iI', u.textobj.indent_I)
ox('ai', u.textobj.indent_a)
ox('aI', u.textobj.indent_A)

-- didn't work
-- ox('zz', function() vim.cmd.normal { 'a', bang = true } end, { expr = true })

-- don't include extra spaces around quotes
ox('a"', '2i"', { remap = true })
ox("a'", "2i'", { remap = true })
ox('a`', '2i`', { remap = true })

nx(' -', '<cmd>e%:p:h<cr>')

o('g{', '<Cmd>sil! norm Vg{<CR>', { remap = true })
o('g}', '<Cmd>sil! norm Vg}<CR>', { remap = true })
nx('g{', u.misc.goto_paragraph_firstline, { remap = true })
nx('g}', u.misc.goto_paragraph_lastline, { remap = true })

n(' cc', '<cmd>try | cclose | lclose | catch | endtry <cr>')
n(' bb', '<c-^>')
n(' go', u.git.browse)

-- Fzf keymaps
n(' ff', '<cmd>FZF<cr>')

n('<c-g>n', '<cmd>cnext<cr>')
n('<c-g>p', '<cmd>cprev<cr>')
