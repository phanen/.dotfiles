local i, n, nx, nxo, ox, t, x = map.i, map.n, map.nx, map.nxo, map.ox, map.t, map.x
local aug = u.aug

-- yank/paste (yank -> '+', delete/change -> 'k')
nx.expr['d'] = [[v:register ==# '+' ? '"kd' : '"'.v:register.'d']]
nx.expr['D'] = [[v:register ==# '+' ? '"kD' : '"'.v:register.'D']]
nx.expr['c'] = [[v:register ==# '+' ? '"kc' : '"'.v:register.'c']]
nx.expr['C'] = [[v:register ==# '+' ? '"kC' : '"'.v:register.'C']]
nx['<c-p>'] = '"kP'
n[' p'] = '<cmd>%d _ | norm VP<cr>'
n[' y'] = '<cmd>%y<cr>'
n[' j'] = '<cmd>t .<cr>'
x[' j'] = '"gy\'>"gp'

-- cursor move
nx.expr['h'] = function() return u.faster.h() end
nx.expr['l'] = function() return u.faster.l() end
nx.expr['j'] = function() return u.faster.j() end -- normal j/k: (<up>/<down>, ':normal j/k')
nx.expr['k'] = function() return u.faster.k() end
nx.expr['<c-d>'] = function() return u.faster.cd() end
nx.expr['<c-u>'] = function() return u.faster.cu() end
nx['$'] = 'g_'

-- text move/swap
x['>'] = ':ri<cr>'
x['<'] = ':le<cr>'
n['<a-j>'] = '<cmd>move+<cr>==' -- append `=` to smart indent it
x['<a-j>'] = ":move '>+<cr>gv=gv"
n['<a-k>'] = '<cmd>move-2<cr>==' -- FIXME: may cause lsp diagnostics error
x['<a-k>'] = ":move '<-2<cr>gv=gv"
n['<a-h>'] = '<<'
n['<a-l>'] = '>>'
x['<a-h>'] = '<gv'
x['<a-l>'] = '>gv'
nx['<a-n>'] = '<cmd>ISwapNodeWithRight<cr>'
nx['<a-p>'] = '<cmd>ISwapNodeWithLeft<cr>'
n['g_'] = function() require('substitute.exchange').operator() end
x['g_'] = function() require('substitute.exchange').visual() end

-- magic
x['.'] = ':norm .<cr>'
n['gy'] = '`[v`]'
n.expr['i'] = [[v:count || len(getline('.')) ? 'i' : '"_cc']] -- auto indent
n.expr['a'] = [[v:count || len(getline('.')) ? 'a' : '"_cc']]
n.expr[' rn'] = [[':IncRename ' . expand('<cword>')]] -- FIXME: trigger hl on enter
n['@w'] = '<nop>' -- avoid kanata typo

-- unimpaired + repeat
nxo[';'] = function() return u.repmove.repeat_last_move() end
nxo[','] = function() return u.repmove.repeat_last_move_opposite() end
nxo.expr['f'] = function() return u.repmove.builtin_f_expr() end -- dot repeatable (dfx)
nxo.expr['F'] = function() return u.repmove.builtin_F_expr() end
nxo.expr['t'] = function() return u.repmove.builtin_t_expr() end
nxo.expr['T'] = function() return u.repmove.builtin_T_expr() end
n['gj'] = function() return u.repmove.next_h() end
n['gk'] = function() return u.repmove.prev_h() end
n['<c-g>j'] = function() return u.repmove.next_q() end
n['<c-g>k'] = function() return u.repmove.prev_q() end
n[' dj'] = function() return u.repmove.next_d() end
n[' dk'] = function() return u.repmove.prev_d() end
n[']b'] = function() return u.repmove.next_b() end
n['[b'] = function() return u.repmove.prev_b() end
n['[o'] = function() return u.repmove.prev_o() end
n[']o'] = function() return u.repmove.next_o() end
n['[s'] = function() return u.repmove.prev_s() end
n[']s'] = function() return u.repmove.next_s() end -- inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
n['<a-o>'] = function() return u.bufop.backward_in_buf() end
n['<a-i>'] = function() return u.bufop.forward_in_buf() end
n['[a'] = '<cmd>TSTextobjectGotoPreviousStart @parameter.inner<cr>'
n[']a'] = '<cmd>TSTextobjectGotoNextStart @parameter.inner<cr>'
n['[f'] = '<cmd>TSTextobjectGotoPreviousStart @function.inner<cr>'
n[']f'] = '<cmd>TSTextobjectGotoNextStart @function.inner<cr>'
-- n['[s'] = '<cmd>TSTextobjectGotoPreviousStart @class.inner<cr>'
-- n[']s'] = '<cmd>TSTextobjectGotoNextStart @class.inner<cr>'
n['[k'] = '<cmd>TSTextobjectGotoPreviousStart @conditional.inner<cr>'
n[']k'] = '<cmd>TSTextobjectGotoNextStart @conditional.inner<cr>'
n['[l'] = '<cmd>TSTextobjectGotoPreviousStart @loop.inner<cr>'
n[']l'] = '<cmd>TSTextobjectGotoNextStart @loop.inner<cr>'

-- textobj
ox['aa'] = '<cmd>TSTextobjectSelect @parameter.outer<cr>'
ox['ia'] = '<cmd>TSTextobjectSelect @parameter.inner<cr>'
ox['af'] = '<cmd>TSTextobjectSelect @function.outer<cr>'
ox['if'] = '<cmd>TSTextobjectSelect @function.inner<cr>'
ox['ar'] = '<cmd>TSTextobjectSelect @return.outer<cr>'
ox['ir'] = '<cmd>TSTextobjectSelect @return.outer<cr>'
ox['as'] = '<cmd>TSTextobjectSelect @class.outer<cr>'
ox['is'] = '<cmd>TSTextobjectSelect @class.inner<cr>'
ox['aj'] = '<cmd>TSTextobjectSelect @conditional.outer<cr>'
ox['ij'] = '<cmd>TSTextobjectSelect @conditional.inner<cr>'
ox['ak'] = '<cmd>TSTextobjectSelect @loop.outer<cr>'
ox['ik'] = '<cmd>TSTextobjectSelect @loop.inner<cr>'
ox['in'] = '<cmd>lua require("various-textobjs").anyBracket("inner")<cr>'
ox['an'] = '<cmd>lua require("various-textobjs").anyBracket("outer")<cr>'
ox['iq'] = '<cmd>lua require("various-textobjs").anyQuote("inner")<cr>'
ox['aq'] = '<cmd>lua require("various-textobjs").anyQuote("outer")<cr>'
ox['il'] = '<cmd>lua require("various-textobjs").lineCharacterwise("inner")<cr>'
ox['iu'] = '<cmd>lua require("various-textobjs").url()<cr>'
ox['id'] = '<cmd>lua require("various-textobjs").diagnostic("wrap")<cr>'
ox['ig'] = function() return u.textobj.buffer() end
ox['ag'] = function() return u.textobj.buffer() end
ox['ic'] = function() return u.textobj.comment() end
ox['ac'] = function() return u.textobj.comment() end -- TODO: line before
ox['ii'] = function() return u.textobj.indent_i() end
ox['iI'] = function() return u.textobj.indent_I() end
ox['ai'] = function() return u.textobj.indent_a() end
ox['aI'] = function() return u.textobj.indent_A() end
ox['ih'] = ':<c-u>Gitsigns select_hunk<cr>'
ox['ah'] = ':<c-u>Gitsigns select_hunk<cr>'

-- inspect
nx['_'] = 'K'
nx['K'] = ':TranslateW<cr>'
n[' I'] = '<cmd>lua vim.show_pos()<cr>'
n['+E'] = '<cmd>lua vim.treesitter.query.edit()<cr>'
n['+T'] = ':EditFtplugin '
n['+I'] = '<cmd>lua vim.treesitter.inspect_tree()<cr>'
n['+L'] = function() return u.script.update_chore() end
nx['+y'] = function() return u.misc.archive() end
n[' <c-d>'] = '<cmd>lua vim.diagnostic.open_float()<cr>'
nx[' L'] = ':Linediff<cr>' -- TODO: quit it
n[' t'] = ':e /tmp/tmp/'
n[' q'] = function() return u.misc.qf_or_ll_toggle() end
n[" '"] = '<cmd>marks<cr>'
n[' "'] = '<cmd>reg<cr>'
n[' wo'] = '<cmd>AerialToggle!<cr>'
n['go'] = '<cmd>AerialNavToggle<cr>'
n[' wi'] = '<cmd>LspInfo<cr>'
n[' wl'] = '<cmd>Lazy<cr>'
n[' wm'] = '<cmd>Mason<cr>'
n[' wh'] = '<cmd>ConformInfo<cr>'
n[' wn'] = '<cmd>Neogit<cr>'
n[' k'] = '<cmd>NvimTreeFindFileToggle<cr>'

-- messages
n[' mk'] = '<cmd>messages clear<cr>'
n[' ml'] = '<cmd>messages<cr>'
n[' me'] = '<cmd>R messages<cr>'
n[' mi'] = [[<cmd>exe '!tail ' .. v:lua.lsp.get_log_path()<cr>]]

-- file
n['cd'] = function() return u.misc.cd() end
n['cx'] = '<cmd>!chmod +x %<cr>'
n['cX'] = '<cmd>!chmod -x %<cr>'
n['cy'] = [[:call setreg('+', '<c-r>=expand('%:p')<cr>')<cr>]]
n.expr['cn'] = [[':sil! Rename '.bufname()]]
n.expr['cm'] = [[':sil! Delete!']]
-- dir
n[' ck'] = function() return u.dirstack.prev() end
n[' cj'] = function() return u.dirstack.next() end
n[' cl'] = function() return u.dirstack.hist() end

-- quickfix
n[' dq'] = '<cmd>lua vim.diagnostic.setqflist()<cr>'
n[' dl'] = '<cmd>lua vim.diagnostic.setloclist()<cr>'

-- format
nx['ga'] = '<plug>(EasyAlign)'
n['gw'] = function() return u.fmt.conform() end
n[' ff'] = vim.lsp.buf.format
n['-'] = '<cmd>TSJToggle<cr>'
n[' rp'] = [[:%FullwidthPunctConvert<cr>]]
x[' rp'] = ':FullwidthPunctConvert<cr>' -- TODO: not change cursor pos
x[' rr'] = [[:s/\(\s\+\)/\r/g<cr>]] -- PERF: delim, indent
n[' rj'] = ':Pangu<cr>'
x[' ro'] = ':!sort<cr>'
n[' rs'] = [[:s/\s*$//g<cr>``]]
n[' rl'] = [[:g/^$/d]]
n[' r*'] = [[:s/^\([  ]*\)- \(.*\)/\1* \2/g]]
n[' r '] = [[:s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]]

-- comment
x.remap['<c-/>'] = 'gc'
i['<c-/>'] = '<cmd>norm <c-/><cr>' -- TODO: comment empty line?
n.expr.remap['<c-/>'] = function() return vim.v.count == 0 and 'gcl' or 'gcj' end
n[' <c-/>'] = '<cmd>norm vic<c-/><cr>'
n['gco'] = function() return u.misc.comment(0) end
n['gcO'] = function() return u.misc.comment(-1) end

-- git
n[' ga'] = '<cmd>silent G commit --amend --no-edit<cr>'
n[' gr'] = '<cmd>Gr<cr>'
n[' gb'] = '<cmd>G blame<cr>'
-- github
n[' go'] = function() return u.git.browse() end
nx['gx'] = function() return u.gx.open() end
nx[' gl'] = function() return u.gl.permalink_open() end
nx['+gl'] = function() return u.gl.permalink_copy() end
-- hunk
n[' hs'] = '<cmd>Gitsigns stage_hunk<cr>'
n[' hu'] = '<cmd>Gitsigns undo_stage_hunk<cr>'
n[' hr'] = '<cmd>Gitsigns reset_hunk<cr>'
nx[' i'] = '<cmd>Gitsigns preview_hunk<cr>'
n[' gu'] = '<cmd>Gitsigns reset_buffer_index<cr>'
n[' hd'] = '<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>'
n['+gb'] = '<cmd>Gitsigns blame<cr>'

n[' gg'] = '<cmd>Neogit<cr>'
n[' gP'] = '<cmd>G push<cr>'
n[' gs'] = '<cmd>Gwrite<cr>'
n[' gw'] = '<cmd>G commit<cr>'
n[' gd'] = ':DiffviewOpen<cr>'
nx[' gh'] = ':DiffviewFileHistory %<cr>'

-- fzf
nx['<c-l>'] = function() return u.pick.files() end
nx['<c-n>'] = function() return u.pick.lgrep() end
nx[' e'] = function() return u.pick.notes() end
nx[' l'] = function() return u.pick.dots() end
nx[' ;'] = function() return u.pick.commands() end

n[' <c-b>'] = function() return u.pick.git_bcommits() end
n[' <c-f>'] = function() return u.pick.zoxide() end
n[' <c-j>'] = function() return u.pick.todo_comment() end
n['z='] = function() return u.pick.spell_suggest() end
n['  '] = function() return u.pick.resume() end
n[' a'] = function() return u.pick.builtin() end

nx[' fh'] = function() return u.pick.help_tags() end
nx[' fo'] = function() return u.pick.recentfiles() end
nx[' fi'] = function() return u.pick.git_status() end
nx[' fn'] = function() return u.pick.nvim() end
nx[' fr'] = function() return u.pick.rtp() end
nx[' fl'] = function() return u.pick.scriptnames() end
nx[' fq'] = function() return u.pick.lgrep_quickfix() end
nx[' f;'] = function() return u.pick.command_history() end
nx[' f/'] = function() return u.pick.search_history() end
nx[' fw'] = function() return u.pick.lsp_workspace_symbols() end
nx[' fs'] = function() return u.pick.lsp_document_symbols() end
nx[' fc'] = function() return u.pick.awesome_colorschemes() end
nx[' fb'] = '<cmd>Telescope builtin<cr>'

n['gd'] = function() return u.pick.lsp_definitions() end
n['gh'] = function() return u.pick.lsp_code_actions() end
n['gm'] = function() return u.pick.lsp_typedefs() end
n.nowait['gr'] = function() return u.pick.lsp_references() end -- note: nowait only apply to before mappings
n['g<c-d>'] = function() return u.pick.lsp_declarations() end
n['g<c-i>'] = function() return u.pick.lsp_implementations() end

n[' <c-e>'] = [[:exe 'edit' . g:local_path<cr>]]

-- buf / win / tab
n.nowait['<c-w>'] = '<c-^>'
nx['<c-b>'] = function() return u.pick.buffers() end
n['<c-f>'] = function() return u.misc.tabnext_or_tabnew() end
n['<c-e>'] = vim.cmd.tabprev
n.expr['<c-s>'] = function() return u.misc.mimic_wincmd() end
n.expr['+q'] = [[tabpagenr("$") == 1 ? ":quitall!<cr>" : ":tabclose!<cr>"]]
n['<c-s><c-d>'] = [[<cmd>up!\|mks!/tmp/reload.vim\|cq!123<cr>]] -- in case just exec binary
n['<c-s><c-s>'] = [[<cmd>quit!<cr>]]
n['<c-left>'] = '<cmd>wincmd 10<<cr>'
n['<c-right>'] = '<cmd>wincmd 10><cr>'
n['<c-up>'] = '<cmd>resize +5<cr>'
n['<c-down>'] = '<cmd>resize -5<cr>'

n['<c-j>'] = function() return u.misc.one_win_then('vs|winc p', 'winc w') end
n['<c-k>'] = function() return u.misc.one_win_then('sp', 'winc W') end
n['q'] = function() return u.misc.quit() end
n['+z'] = function() return u.zen.toggle() end

-- debugprint
n.expr['g<c-h>'] = function() return require('debugprint').debugprint() end
n.expr[' <c-h>'] = function() return require('debugprint').debugprint { variable = true } end
n['+<c-h>'] = function() return require('debugprint').deleteprints() end

-- nx(' wn', ':GpChatNew<cr>')
-- nx(' wk', ':GpChatToggle<cr>')
-- nx(' wf', ':GpChatFinder<cr>')
-- nx(' wp', ':GpChatPaste<cr>')

nx.expr[' so'] = function() return u.task.so() end
nx[' <cr>'] = function() u.task.termrun() end

-- block refactor
-- x.expr['gb'] = [[':Refactor extract_to_file '.expand('%:p:h').'/']]
x['gb'] = function() return u.extract.to_file() end
nx[' re'] = ':Refactor extract '
x[' iI'] = ':Refactor extract_to_file '
x[' rv'] = ':Refactor extract_var '
nx[' ri'] = ':Refactor inline_var'
n[' rI'] = ':Refactor inline_func'
n[' rb'] = ':Refactor extract_block'
n[' rbf'] = ':Refactor extract_block_to_file'

-- profile
n['+ps'] = function() require('plenary.profile').start('profile.log', { flame = true }) end
n['+pe'] = function() require('plenary.profile').stop() end

-- local map
local map_treesitter = function(_)
  if not u.is.has_ts(0) then return end
  local bn = map.n[_.buf]
  local bx = map.x[_.buf]
  bn['<cr>'] = function() return u.ts.init_selection() end
  bx['<cr>'] = function() return u.ts.node_incremental() end
  bx['<s-cr>'] = function() return u.ts.node_decremental() end
  bx['<s-tab>'] = function() return u.ts.scope_incremental() end
end

local map_cmdwin = function(_)
  local bn = map.n[_.buf]
  bn['<cr>'] = 'a<cr>'
  bn['q'] = '<cmd>q<cr>'
  bn['s'] = 's' -- FIXME: flash.nvim crash
end

-- terminal
n['<a-;>'] = function() u.muxterm.toggle() end
local map_term = function(_)
  local bt = map.t[_.buf]
  t['<c- >'] = '<c-\\><c-n>'

  if not vim.b[_.buf].is_float_muxterm then return end
  -- if not vim.b[ev.buf].term then return end
  local bn = map.n[_.buf]
  local btn = map.tn[_.buf]
  bn['<c-o>'] = '<nop>' -- workaround, mis touch
  bn['<c-i>'] = '<nop>'
  bn['i'] = 'A' -- workaround, insert at bottom not work
  bn['a'] = 'A'

  -- don't tmap <a-;> to avoid it work in fzf
  bt['<a-;>'] = function() u.muxterm.toggle() end

  btn['<a-k>'] = function() u.muxterm.cycle_prev() end
  btn['<a-e>'] = function() u.muxterm.cycle_prev() end
  btn['<a-j>'] = function() u.muxterm.cycle_next() end
  btn['<a-f>'] = function() u.muxterm.cycle_next() end
  btn['<a-l>'] = function() u.muxterm.insert_then_switch() end
end

aug.k_ft = { 'Filetype', map_treesitter }
aug.k_cmdwin = { 'CmdwinEnter', map_cmdwin }
aug.k_term = { 'TermOpen', map_term }
