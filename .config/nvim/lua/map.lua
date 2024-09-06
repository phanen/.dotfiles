-- TODO: dsi dsa not work?
-- TODO: v:count repeat may not really needed
-- TODO: dofile + setfenv

local i = map.i
local m = map['']
local n = map.n
local nx = map.nx
local t = map.t
local tn = map.tn
local x = map.x
local ox = map.ox
local nxo = map.nxo

local mm = {
  api = api,
  fn = fn,
  map = map,
  u = u,
  vim = vim,

  i = i,
  m = m,
  n = n,
  nx = nx,
  t = t,
  tn = tn,
  x = x,
  ox = ox,
  require = require,

  g = g,
  loadfile = loadfile,
}

local function what()
  -- mm = vim.tbl_extend('force', mm, _G)
  setfenv(loadfile(g.config_path .. '/lua/map/buf.lua'), mm)()
  --require 'map.buf'
  --loadfile(g.config_path .. '/lua/map/buf.lua')()
end
what()
--setfenv(what, mm)()

require 'map.edit' -- TODO: gd swapfile need refresh buffer
require 'map.msg'
require 'map.textobj'
require 'map.bufmap'

n(' t', ':e /tmp/tmp/')

n('cd', u.misc.cd)
n(' cf', '<cmd>cd %:h<cr>')
n(' cy', u.misc.yank_filename)
n('cx', '<cmd>!chmod +x %<cr>')
n(' cx', '<cmd>!chmod -x %<cr>')

n('+rd', ':Delete!')
n.expr('+rr', function() return ':Rename ' .. api.nvim_buf_get_name(0) end)

-- session
n(' ss', '<cmd>mks! /tmp/Session.vim<cr><cmd>q!<cr>') -- TODO: more thing need to be preserved, `SessionWritePost`
n(' sl', '<cmd>so /tmp/Session.vim<cr>')
nx(' so', ':so<cr>')

-- options
n(' ob', "<cmd>if &bg == 'dark' | se bg=light | else | se bg=dark | en<cr>")
n(' oc', '<cmd>se cul! cuc!<cr>')
n(' oi', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<cr>')
n(' oL', '<cmd>if &ls == 0 | se ls=2 | else | se ls=0 | en<cr>')
n(' ol', '<cmd>se co=80<cr>')
n(' or', '<cmd>ret<cr>')
n(' os', '<cmd>se spell!<cr>')
n(' ow', '<cmd>se wrap!<cr>')

-- diagnostic
n(' di', '<cmd>lua vim.diagnostic.open_float()<cr>')
n(' do', '<cmd>lua vim.diagnostic.setqflist()<cr>')
n(' ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')
n(' dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)

-- terminal
t('<c- >', '<c-\\><c-n>')
tn('<c-\\>', '<cmd>execute v:count . "ToggleTerm"<cr>')

-- comment
m('<c-_>', '<c-/>', { remap = true })
x('<c-/>', 'gc', { remap = true })
i('<c-/>', '<cmd>norm <c-/><cr>') -- TODO: comment empty line?
n('<c-/>', function() return vim.v.count == 0 and 'gcl' or 'gcj' end, { expr = true, remap = true })
n(' <c-/>', '<cmd>norm vic<c-/><cr>')
n('gco', u.comment.comment_below)
n('gcO', u.comment.comment_above)

-- git
n(' go', u.git.browse)
nx(' gl', u.gl.permalink) -- FIXME: normal mode Lx-Lx
nx('gl', u.gx.open)

n(' ga', '<cmd>silent G commit --amend --no-edit<cr>')
n(' gr', '<cmd>Gr<cr>')
n(' gb', '<cmd>G blame<cr>')
n(' gg', '<cmd>G<cr>')
n(' gP', '<cmd>G push<cr>')
n(' gs', '<cmd>Gwrite<cr>')
n(' gw', '<cmd>G commit<cr>')

nx(' gd', ':DiffviewOpen<cr>')
nx(' gh', ':DiffviewFileHistory %<cr>')
nx(' gf', ':Flog<cr>')
n(' gn', function() require('neogit').open { cwd = u.git.root() } end)

-- repeat move
nxo(';', u.repmove.repeat_last_move)
nxo(',', u.repmove.repeat_last_move_opposite)
nxo.expr('f', u.repmove.builtin_f_expr) -- dot repeatable (dfx)
nxo.expr('F', u.repmove.builtin_F_expr)
nxo.expr('t', u.repmove.builtin_t_expr)
nxo.expr('T', u.repmove.builtin_T_expr)
nxo('gj', u.repmove.next_hunk)
nxo('gk', u.repmove.prev_hunk)
nxo(' dj', u.repmove.next_diag)
nxo(' dk', u.repmove.prev_diag)
nxo(']d', u.repmove.next_diag)
nxo('[d', u.repmove.prev_diag)
n('<c-g>j', u.repmove.next_qfit)
n('<c-g>k', u.repmove.prev_qfit)

-- TODO: qf/ll toggle
n(' q', u.qf.toggle)

-- ts
n(' sj', '<cmd>TSTextobjectSwapNext @parameter.inner<cr>')
n(' sk', '<cmd>TSTextobjectSwapPrev @parameter.inner<cr>')

-- cmd_alias('TSTextobjectGotoPreviousStart', 'TSTextobjectGotoPrevStart')
-- TODO: wrap
-- nxo('[a', '<cmd>TSTextobjectGotoPreviousStart @parameter.inner<cr>')
nxo('[a', function()
  local ts_m = require 'nvim-treesitter.textobjects.move'
  ts_m.goto_previous_start('@parameter.inner')
end)
nxo('[f', '<cmd>TSTextobjectGotoPreviousStart @function.inner<cr>')
nxo('[s', '<cmd>TSTextobjectGotoPreviousStart @class.inner<cr>')
nxo('[k', '<cmd>TSTextobjectGotoPreviousStart @conditional.inner<cr>')
nxo('[l', '<cmd>TSTextobjectGotoPreviousStart @loop.inner<cr>')
nxo(']a', '<cmd>TSTextobjectGotoNextStart @parameter.inner<cr>')
nxo(']f', '<cmd>TSTextobjectGotoNextStart @function.inner<cr>')
nxo(']s', '<cmd>TSTextobjectGotoNextStart @class.inner<cr>')
nxo(']k', '<cmd>TSTextobjectGotoNextStart @conditional.inner<cr>')
nxo(']l', '<cmd>TSTextobjectGotoNextStart @loop.inner<cr>')

-- fzf
-- TODO: nowait gr
local f = u.lazy_req('flo') ---@module 'flo'
i('<c-x>f', f.complete_file)
i('<c-x>l', f.complete_bline)
i('<c-x>p', f.complete_path)
nx('<c-b>', f.recentfiles)
nx(' <c-f>', f.zoxide)
nx(' <c-j>', f.todo_comment)
nx('<c-l>', f.files)
nx('<c-n>', f.live_grep_glob)
nx(' e', f.find_notes)
nx(' fa', f.builtin)
nx('f<c-e>', f.grep_notes)
nx(' fc', f.awesome_colorschemes)
nx('f<c-f>', f.lazy)
nx('f<c-k>', f.keymaps)
nx('f<c-l>', f.grep_dots)
nx('f<c-o>', f.recentfiles)
nx('f<c-s>', f.commands)
nx(' fdb', f.dap_breakpoints)
nx(' fdc', f.dap_configurations)
nx(' fde', f.dap_commands)
nx(' fdf', f.dap_frames)
nx(' fdv', f.dap_variables)
nx(' f;', f.command_history)
nx(' fh', f.help_tags)
nx('+fi', f.gitignore)
nx(' fi', f.git_status)
nx(' fj', f.tagstack)
nx('+fl', f.license)
nx(' fm', f.marks)
nx(' fo', f.oldfiles)
nx(' fp', f.loclist)
nx(' fq', f.quickfix)
nx('  ', f.resume)
nx('+fr', f.rtp)
nx(' /', f.search_history)
nx(' fs', f.lsp_document_symbols)
nx('+fs', f.scriptnames)
nx(' fw', f.lsp_workspace_symbols)
nx('g<c-d>', f.lsp_declarations)
nx('g<c-i>', f.lsp_implementations)
nx('gd', f.lsp_definitions)
nx('gh', f.lsp_code_actions)
nx('gm', f.lsp_typedefs)
nx(' l', f.find_dots)
nx('+l', f.grep_dots)
nx.nowait('gr', f.lsp_references) -- note: nowait only apply to before mappings
nx('U', f.undo)
nx('z=', f.spell_suggest)

n(' <c-e>', function() vim.cmd.edit(g.local_path) end)

-- TODO: fix toggleterm mode switch
-- tn('gn', function()
--   -- vim.cmd.ToggleTerm()
--   require('toggleterm').toggle(1)
--   require('toggleterm').toggle(2)
--   -- require('toggleterm').toggle()
--   -- vim.cmd.ToggleTerm()
--   -- vim.cmd.ToggleTerm()
-- end)
--
-- tn('gp', function()
--   -- vim.cmd.ToggleTerm()
--   require('toggleterm').toggle(2)
--   require('toggleterm').toggle(1)
--   -- require('toggleterm').toggle()
--   -- vim.cmd.ToggleTerm()
--   -- vim.cmd.ToggleTerm()
-- end)
