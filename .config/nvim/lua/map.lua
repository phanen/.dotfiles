-- vim:fdm=marker
local n, nx, nxo, ox, x, i, c = map.n, map.nx, map.nxo, map.ox, map.x, map.i, map.c
local aug = u.aug

-- yank/paste {{{
nx['d'] = '"-d'
nx['D'] = '"-D'
nx['c'] = '"-c'
nx['C'] = '"-C'
nx['X'] = '"-X'
n['x'] = '"-x'
nx['<c-p>'] = '"-P'
n[' p'] = '<cmd>%d_|norm!VP<cr>'
n[' y'] = '<cmd>%y<cr>'
n[' j'] = '<cmd>t .<cr>'
x[' j'] = '"gy\'>"gp'
-- }}}

-- cursor move {{{
nx.expr['h'] = function() return u.faster.h() end
nx.expr['l'] = function() return u.faster.l() end
nx.expr['j'] = function() return u.faster.j() end -- normal j/k: (<up>/<down>, ':normal j/k')
nx.expr['k'] = function() return u.faster.k() end
nx.expr['w'] = function() return u.faster.w() end -- foldopen
nx.expr['b'] = function() return u.faster.b() end
nx.expr['e'] = function() return u.faster.e() end
n.expr['i'] = [[v:count||getline('.')->len() ?'i' :'"_cc']] -- auto indent
n.expr['a'] = [[v:count||getline('.')->len() ?'a' :'"_cc']]
-- }}}

-- operator {{{
x['.'] = ':norm .<cr>'
n['gy'] = '`[v`]'
x['gb'] = function() u.refactor.to_file(nil, true) end
x['+y'] = function() u.misc.archive() end
n[' .'] = '<cmd>Neogen<cr>'
nx['<cr>'] = 'gF'
n['<tab>'], n['<c-i>'] = 'za', '<c-i>' -- https://github.com/neovim/neovim/pull/17932

nx.expr['s;'] = function() return u.task.so() end
nx[' <cr>'] = function() u.task.termrun() end
x[' d'] = ':Linediff<cr>'
n[' d'] = '<Plug>(linediff-operator)'
-- }}}

-- debugprint {{{
-- for c, typed printf...
n['gm'] = function() return require('debugprint').debugprint() end
n['g.'] = function() return require('debugprint').debugprint { variable = true } end
n['+.'] = function() require('debugprint').deleteprints() end
-- }}}

-- text process {{{
n['<a-j>'], x['<a-j>'] = [[<cmd>exe("m+".v:count1)|norm!==<cr>]], [[:m '>+<cr>gv=gv]]
n['<a-k>'], x['<a-k>'] = [[<cmd>move-2<cr>==]], [[:m '<-2<cr>gv=gv]]
nx['gw'] = function() u.fmt.conform() end
n['-'] = '<cmd>TSJToggle<cr>'
nx.expr['gs'] = function() return u.swap.swap() end
-- comment
x['<c-/>'] = [[<cmd>eval 'gc'->feedkeys('m')<cr>]]
n['<c-/>'] = [[<cmd>eval (v:count == 0 ?'gcl' :v:count.'gcj')->feedkeys('m')<cr>]]
n[' <c-/>'] = [[<cmd>eval 'gcic'->feedkeys('m')<cr>]]
n['gco'] = function() u.misc.comment(0) end
n['gcO'] = function() u.misc.comment(-1) end
-- }}}

-- search (hls) {{{
n['n'] = [[<cmd>exe('norm!'.v:count1.'n')|lua require('hlslens').start()<cr>zz]]
n['N'] = [[<cmd>exe('norm!'.v:count1.'N')|lua require('hlslens').start()<cr>zz]]
n['*'] = [[*<cmd>lua require('hlslens').start()<cr>]]
n['#'] = [[#<cmd>lua require('hlslens').start()<cr>]]
n['g*'] = [[g*<cmd>lua require('hlslens').start()<cr>]]
n['g#'] = [[g#<cmd>lua require('hlslens').start()<cr>]]
n['<esc>'] = [[<cmd>noh|dif<cr><esc>]]
-- }}}

-- unimpaired & textobj {{{
nxo.expr[';'] = function() return u.repmv.forward(';') end
nxo.expr[','] = function() return u.repmv.backward(',') end
nxo.expr['f'] = function() return u.repmv.builtin('f') end
nxo.expr['F'] = function() return u.repmv.builtin('F') end
nxo.expr['t'] = function() return u.repmv.builtin('t') end
nxo.expr['T'] = function() return u.repmv.builtin('T') end
n['gj'] = function() u.repmv.next_h() end
n['gk'] = function() u.repmv.prev_h() end
n['zj'] = function() u.repmv.next_z() end
n['zk'] = function() u.repmv.prev_z() end
n[']q'] = function() u.repmv.next_q() end
n['[q'] = function() u.repmv.prev_q() end
n[']l'] = function() u.repmv.next_l() end
n['[l'] = function() u.repmv.prev_l() end
n[']d'] = function() u.repmv.next_d() end
n['[d'] = function() u.repmv.prev_d() end
n[']e'] = function() u.repmv.next_e() end
n['[e'] = function() u.repmv.prev_e() end
n['g<tab>'] = 'g<tab>'
n['g<c-i>'] = function() u.repmv.next_o() end
n['g<c-o>'] = function() u.repmv.prev_o() end
n[' <c-i>'] = function() u.repmv.next_O() end
n[' <c-o>'] = function() u.repmv.prev_O() end
n['[s'] = function() u.repmv.prev_s() end
n[']s'] = function() u.repmv.next_s() end
n['s<cr>'] = function() require('treesitter-context').go_to_context(vim.v.count1) end

n['[a'] = function() u.ts.goto_prev_start '@parameter.inner' end
n[']a'] = function() u.ts.goto_next_start '@parameter.inner' end
n['[f'] = function() u.ts.goto_prev_start '@function.inner' end
n[']f'] = function() u.ts.goto_next_start '@function.inner' end

-- textobj
ox['aa'] = function() u.ts.select_textobject('@parameter.outer') end
ox['ia'] = function() u.ts.select_textobject('@parameter.inner') end
ox['af'] = function() u.ts.select_textobject('@function.outer') end
ox['if'] = function() u.ts.select_textobject('@function.inner') end
ox['in'] = function() u.textobj.anyBracket('inner') end
ox['an'] = function() u.textobj.anyBracket('outer') end
ox['iq'] = function() u.textobj.anyQuote('inner') end
ox['aq'] = function() u.textobj.anyQuote('outer') end
ox['il'] = function() u.textobj.lineCharacterwise('inner') end
ox['iu'] = function() u.textobj.url() end
ox['id'] = function() u.textobj.diagnostic('wrap') end
ox['ig'] = function() u.textobj.buffer() end
ox['ag'] = function() u.textobj.buffer() end
ox['ic'] = function() u.textobj.comment() end
ox['ac'] = function() u.textobj.comment() end
ox['ii'] = function() u.textobj.indent_i() end
ox['iI'] = function() u.textobj.indent_I() end
ox['ai'] = function() u.textobj.indent_a() end
ox['aI'] = function() u.textobj.indent_A() end
ox['ih'] = ':<c-u>Gitsigns select_hunk<cr>' -- find hunk
-- }}}

-- inspect {{{
nx['_'] = function()
  local mode = api.nvim_get_mode().mode
  if mode:match('[vV\022]') and #table.concat(u.buf.getregion(mode), '\n') == 1 then
    u.textobj.lineCharacterwise('inner')
  else -- not sure if hover work in visual mode
    api.nvim_feedkeys('K', 'n', false)
  end
end
nx['K'] = function() lsp.buf.signature_help() end -- hover
nx[' i'] = '<cmd>Gitsigns preview_hunk<cr>'
n[' t'] = ':e /tmp/tmp/'
n[' q'] = function() u.misc.qf_or_ll_toggle() end
n[' k'] = '<cmd>NvimTreeFindFileToggle<cr>'
n[' h'] = '<cmd>AerialToggle!<cr>'
n['mk'] = '<cmd>messages clear<cr>'
n['ml'] = '<cmd>messages<cr>'
n['me'] = '<cmd>R messages<cr>'
n['md'] = [[<cmd>DiagFloat<cr>]]
-- }}}

-- file/dir {{{
n['s'] = ''
n['sn'] = [[:Rename ]]
n['sm'] = [[:Delete!]]
n['M'] = function() u.misc.cd() end
n['L'] = function() u.dirstack.next() end
n['H'] = function() u.dirstack.prev() end
-- }}}

-- git {{{
n['g<cr>'] = '<cmd>G<cr>'
n['do'] = [[<cmd>exe(&diff ?'diffget' :'Gitsigns reset_hunk')<cr>]]
n['dp'] = [[<cmd>exe(&diff ?'diffput' :'Gitsigns stage_hunk')<cr>]]
n[' b'] = '<cmd>G blame<cr>'
n[' go'] = function() u.git.browse() end
nx['gl'] = function() u.gx.open() end
nx[' gl'] = function() u.gl.permalink_open() end
-- }}}

-- fzf {{{
nx['<c-l>'] = function() u.pick.files() end
nx['<c-n>'] = function() u.pick.lgrep() end
nx['<c-h>'] = function() u.pick.help_tags() end
nx['<c-m>'] = function() u.pick.man_pages() end
nx[' ;'] = function() u.pick.commands() end
nx[' /'] = function() u.pick.command_history() end
nx[' <c-b>'] = function() u.pick.git_bcommits() end
n[' <c-f>'] = function() u.pick.zoxide() end
n['z='] = function() u.pick.spell_suggest() end
n['  '] = function() u.pick.resume() end
n[' a'] = function() u.pick.builtin() end
nx['sl'] = function() u.pick.grep() end
nx[' e'] = function() u.pick.notes() end
nx[' fe'] = function() u.pick.notes() end
nx[' l'] = function() u.pick.dots() end
nx[' w'] = function() u.pick.lsp_live_workspace_symbols() end
nx[' fo'] = function() u.pick.recentfiles() end
nx[' fi'] = function() u.pick.git_status() end
-- }}}

-- buf / win / tab {{{
n.nowait['<c-w>'] = '<c-^>'
n['<c-b>'] = function() u.pick.buffers() end
n['<c-f>'] =
  [[<cmd>exe(tabpagenr('$')==1 ?v:count1.'bn' :((tabpagenr()-1+v:count1)%tabpagenr('$')+1).'tabn')<cr>]]
n['<c-e>'] = [[<cmd>exe(tabpagenr('$')==1 ?v:count1.'bp' :v:count1.'tabp')<cr>]]
n['s'] = '<c-w>'
n['<c-j>'] = function() u.misc.one_win_then('vs|winc p', 'winc w') end
n['<c-k>'] = function() u.misc.one_win_then('vs|winc T', 'winc W') end
n.expr['q'] = function() return u.misc.quit() end
-- }}}

-- terminal {{{
n['<a-;>'] = function() u.muxterm.toggle() end
aug.termopen = {
  'TermOpen',
  function(_)
    local bt, bn, bnt = map[_.buf].t, map[_.buf].n, map[_.buf].tn
    bt['<c- >'] = '<c-\\><c-n>'
    if not vim.b[_.buf].is_float_muxterm then return end
    bn['<cr>'] = '<cmd>tabnew <cfile><cr>'
    bt['<a-;>'] = function() u.muxterm.toggle() end
    bn['i'], bn['a'] = 'I', 'A' -- workaround, insert at bottom not work
    bnt['<a-j>'] = function() u.muxterm.cycle_next() end
    bnt['<a-k>'] = function() u.muxterm.cycle_prev() end
    bnt['<a-l>'] = function() u.muxterm.spawn() end
  end,
}
-- }}}

-- profile {{{
n['+r'] = function() require('plenary.profile').start('profile.log', { flame = true }) end
n['+s'] = function()
  require('plenary.profile').stop()
  if not uv.fs_stat('profile.log') then return end
  fn.system('inferno-flamegraph profile.log > profile.svg')
  vim.system { env.BROWSER, 'profile.svg' }
end
-- }}}

-- insert & command mode {{{
i.expr['<c-f>'] = function() return u.rl.expr_accept_or_forward_char() end
i.expr['<c-e>'] = function() return u.rl.expr_accept_or_end_of_line() end
i['<c-j>'] = function() u.rl.accept_or_forward_word() end
i.expr['<c-p>'] = function() return u.rl.expr_cs_prev_or_fallback() end
i.expr['<c-n>'] = function() return u.rl.expr_cs_next_or_fallback() end
i['<c-b>'] = '<left>'
i['<c-a>'] = function() u.rl.dwim_beginning_of_line() end
i['<c-o>'] = function() u.rl.backward_word() end
i['<c-l>'] = function() u.rl.kill_word() end
i['<c-k>'] = function() u.rl.kill_line() end
i['<c-u>'] = function() u.rl.dwim_backward_kill_line() end
i['<c-bs>'] = '<c-w>'

for _, char in ipairs { ' ', '-', '_', ':', '.', '/' } do
  i.expr[char] = function() return vim.v.count > 0 and char or char .. '<c-g>u' end
end

i['<c-x>f'] = function() return u.pick.complete_file() end
i['<c-x>l'] = function() return u.pick.complete_bline() end
i['<c-x>p'] = function() return u.pick.complete_path() end

c['<a-p>'], c['<a-n>'] = '<up>', '<down>'
c['<c-f>'], c['<c-b>'] = '<right>', '<left>'
c['<c-a>'], c['<c-e>'] = function() u.rl.dwim_beginning_of_line() end, '<end>'
c['<c-d>'] = '<del>'
c['<c-j>'] = function() u.rl.forward_word() end
c['<c-o>'] = function() u.rl.backward_word() end
c['<c-l>'] = function() u.rl.kill_word() end
c['<c-k>'] = function() u.rl.kill_line() end
c['<c-u>'] = function() u.rl.dwim_backward_kill_line() end
c['<c-bs>'] = '<c-w>'
--- }}}

n['sd'] = [[<cmd>sil!wa!|mks!/tmp/reload-nvim.vim|cq!123<cr>]] -- in case just exec binary
n['s '] = [[<cmd>sil!wa!|mks!/tmp/reload-nvim.vim|cq!124<cr>]]
n['sc'] = [[<cmd>quit!<cr>]]
n.nowait['<c-s>'] = [[<cmd>quit!<cr>]]
nx['@w'], nx['@^'] = '', '' -- avoid kanata typo
n[' I'] = '<cmd>Inspect<cr>'
n['S'] = '<cmd>InspectTree<cr>'
n[' Q'] = '<cmd>qa!<cr>'
n['?'] = '<cmd>Lazy<cr>'
n[' '] = ''
