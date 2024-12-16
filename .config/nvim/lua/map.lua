local n, nx, nxo, ox, x = map.n, map.nx, map.nxo, map.ox, map.x
local aug = u.aug

-- yank/paste
nx['d'] = '"-d'
nx['D'] = '"-D'
nx['c'] = '"-c'
nx['C'] = '"-C'
nx['<c-p>'] = '"-P'
n[' p'] = '<cmd>%d_|norm!VP<cr>'
n[' y'] = '<cmd>%y<cr>'
n[' j'] = '<cmd>t .<cr>'
x[' j'] = '"gy\'>"gp'

-- text move
n['<a-j>'], x['<a-j>'] = [[<cmd>exe("m+".v:count1)|norm!==<cr>]], [[:m '>+<cr>gv=gv]]
n['<a-k>'], x['<a-k>'] = [[<cmd>move-2<cr>==]], [[:m '<-2<cr>gv=gv]]

-- cursor move
nx.expr['h'] = function() return u.faster.h() end
nx.expr['l'] = function() return u.faster.l() end
nx.expr['j'] = function() return u.faster.j() end -- normal j/k: (<up>/<down>, ':normal j/k')
nx.expr['k'] = function() return u.faster.k() end
nx.expr['w'] = function() return u.faster.w() end -- foldopen
nx.expr['b'] = function() return u.faster.b() end
nx.expr['e'] = function() return u.faster.e() end
n.expr['i'] = [[v:count||getline('.')->len() ?'i' :'"_cc']] -- auto indent
n.expr['a'] = [[v:count||getline('.')->len() ?'a' :'"_cc']]

-- operator
x['.'] = ':norm .<cr>'
n['gy'] = '`[v`]'
x['gb'] = function() u.refactor.to_file(nil, true) end
x['+y'] = function() u.misc.archive() end
n[' .'] = '<cmd>Neogen<cr>'
n['<cr>'] = 'gF'
n['<tab>'], n['<c-i>'] = 'za', '<c-i>' -- https://github.com/neovim/neovim/pull/17932

-- debugprint
n.expr['g.'] = function() return require('debugprint').debugprint() end
n.expr['gm'] = function() return require('debugprint').debugprint { variable = true } end
n['+.'] = function() require('debugprint').deleteprints() end

-- text process
n['gw'] = function() u.fmt.conform() end
n['-'] = '<cmd>TSJToggle<cr>'
-- swap
nx['gs'] = function() u.swap.operator() end
-- comment
x['<c-/>'] = [[<cmd>eval 'gc'->feedkeys('m')<cr>]]
n['<c-/>'] = [[<cmd>eval (v:count == 0 ?'gcl' :v:count.'gcj')->feedkeys('m')<cr>]]
n[' <c-/>'] = [[<cmd>eval 'gcic'->feedkeys('m')<cr>]]
n['gco'] = function() u.misc.comment(0) end
n['gcO'] = function() u.misc.comment(-1) end

nx.expr[' so'] = function() return u.task.so() end
nx[' <cr>'] = function() u.task.termrun() end

-- search
n['n'] = [[<cmd>exe('norm!'.v:count1.'n')|lua require('hlslens').start()<cr>zz]]
n['N'] = [[<cmd>exe('norm!'.v:count1.'N')|lua require('hlslens').start()<cr>zz]]
n['*'] = [[*<cmd>lua require('hlslens').start()<cr>]]
n['#'] = [[#<cmd>lua require('hlslens').start()<cr>]]
n['g*'] = [[g*<cmd>lua require('hlslens').start()<cr>]]
n['g#'] = [[g#<cmd>lua require('hlslens').start()<cr>]]
n['<esc>'] = [[<cmd>noh|dif<cr><esc>]]

-- unimpaired
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
n['sj'] = function() u.repmv.next_q() end
n['sk'] = function() u.repmv.prev_q() end
n['sh'] = function() u.repmv.next_l() end
n['sl'] = function() u.repmv.prev_l() end
n[']d'] = function() u.repmv.next_d() end
n['[d'] = function() u.repmv.prev_d() end
n[']b'] = function() u.repmv.next_b() end
n['[b'] = function() u.repmv.prev_b() end
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
ox['_'] = function() u.textobj.lineCharacterwise('inner') end
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

-- inspect
n['_'] = 'K'
nx['K'] = function() lsp.buf.signature_help() end
nx[' i'] = '<cmd>Gitsigns preview_hunk<cr>'
n[' t'] = ':e /tmp/tmp/'
n[' q'] = function() u.misc.qf_or_ll_toggle() end
n[' k'] = '<cmd>NvimTreeFindFileToggle<cr>'
n[' h'] = '<cmd>AerialToggle!<cr>'
n['mk'] = '<cmd>messages clear<cr>'
n['ml'] = '<cmd>messages<cr>'
n['me'] = '<cmd>R messages<cr>'

-- file/dir
n['s'] = ''
n['sn'] = [[:Rename ]]
n['sm'] = [[:Delete!]]
n['M'] = function() u.misc.cd() end
n['L'] = function() u.dirstack.next() end
n['H'] = function() u.dirstack.prev() end

-- git
n['g<cr>'] = '<cmd>G<cr>'
n['do'] = [[<cmd>exe(&diff ?'diffget' :'Gitsigns reset_hunk')<cr>]]
n['dp'] = [[<cmd>exe(&diff ?'diffput' :'Gitsigns stage_hunk')<cr>]]
n[' b'] = '<cmd>G blame<cr>'
n[' go'] = function() u.git.browse() end
nx['gl'] = function() u.gx.open() end
nx[' gl'] = function() u.gl.permalink_open() end

-- fzf
nx['<c-l>'] = function() u.pick.files() end
nx['<c-n>'] = function() u.pick.lgrep() end
nx['<c-h>'] = function() u.pick.help_tags() end
nx[' ;'] = function() u.pick.commands() end
nx[' /'] = function() u.pick.command_history() end
nx[' <c-b>'] = function() u.pick.git_bcommits() end
n[' z'] = function() u.pick.zoxide() end
n['z='] = function() u.pick.spell_suggest() end
n['  '] = function() u.pick.resume() end
n[' a'] = function() u.pick.builtin() end
nx[' e'] = function() u.pick.notes() end
nx[' fe'] = function() u.pick.notes() end
nx[' l'] = function() u.pick.dots() end
nx[' w'] = function() u.pick.lsp_live_workspace_symbols() end
nx[' fo'] = function() u.pick.recentfiles() end
nx[' fi'] = function() u.pick.git_status() end

-- buf / win / tab
n.nowait['<c-w>'] = '<c-^>'
n['<c-b>'] = function() u.pick.buffers() end
n['<c-f>'] =
  [[<cmd>exe(tabpagenr('$')==1 ?v:count1.'bn' :((tabpagenr()-1+v:count1)%tabpagenr('$')+1).'tabn')<cr>]]
n['<c-e>'] = [[<cmd>exe(tabpagenr('$')==1 ?v:count1.'bp' :v:count1.'tabp')<cr>]]
n['+q'] = [[<cmd>exe(tabpagenr("$")==1 ?'qa!' :'tabc!')<cr>]]
n['<c-s>'] = function() u.misc.mimic_wincmd() end
n['<c-s><c-d>'] = [[<cmd>up!\|mks!/tmp/reload.vim\|cq!123<cr>]] -- in case just exec binary
n['<c-s><c-s>'] = [[<cmd>quit!<cr>]]
n['<c-s>d'] = [[<cmd>DiagFloat<cr>]]
n['<c-j>'] = function() u.misc.one_win_then('vs|winc p', 'winc w') end
n['<c-k>'] = function() u.misc.one_win_then('sp', 'winc W') end
n['q'] = function() u.misc.quit() end

-- terminal
n['<a-;>'] = function() u.muxterm.toggle() end
aug.termopen = {
  'TermOpen',
  function(_)
    local bt, bn, bnt = map[_.buf].t, map[_.buf].n, map[_.buf].tn
    bt['<c- >'] = '<c-\\><c-n>'
    if not vim.b[_.buf].is_float_muxterm then return end
    bt['<a-;>'] = function() u.muxterm.toggle() end
    bn['i'], bn['a'] = 'I', 'A' -- workaround, insert at bottom not work
    bnt['<a-j>'] = function() u.muxterm.cycle_next() end
    bnt['<a-k>'] = function() u.muxterm.cycle_prev() end
    bnt['<a-l>'] = function() u.muxterm.spawn() end
  end,
}

n['@w'] = '' -- avoid kanata typo
n[' I'] = '<cmd>Inspect<cr>'
n['S'] = '<cmd>InspectTree<cr>'
