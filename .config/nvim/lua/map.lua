-- TODO: dsi dsa not work?
-- TODO: v:count repeat may not really needed

-- TODO: dofile + setfenv
require 'map.buf'
require 'map.edit' -- TODO: gd swapfile need refresh buffer
require 'map.msg'
require 'map.textobj'

local i = map.i
local m = map['']
local n = map.n
local nx = map.nx
local t = map.t
local tn = map.tn
local x = map.x

n(' t', ':e /tmp/tmp/')

n('cd', u.smart.cd)
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
n(' dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
n(' dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
n(' ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')
n(' dj', '<cmd>lua vim.diagnostic.jump{count = 1}<cr>')
n(' dk', '<cmd>lua vim.diagnostic.jump{count = -1}<cr>')
n(' dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)

-- terminal
t('<c- >', '<c-\\><c-n>')
tn('<c-\\>', '<cmd>execute v:count . "ToggleTerm"<cr>')

-- quickfix
n('<c-g>n', '<cmd>cnext<cr>')
n('<c-g>p', '<cmd>cprev<cr>')

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
nx(' gx', u.gx.open)

-- quickfix
n('<c-g>n', '<cmd>cnext<cr>')
n('<c-g>p', '<cmd>cprev<cr>')
n(' q', u.qf.toggle)

-- check nvim's lsp preset `:h lsp-config`
-- * tagfunc <c-]>
-- * omnifunc c-x c-o, buggy, no idea if there's really someone use omnifunc...
-- * formatexpr gq
-- * https://github.com/neovim/neovim//blob/6ad025ac88f968dbeaea05e95cf40d64782793e0/runtime/lua/vim/lsp.lua#L330
-- * https://github.com/neovim/neovim//blob/6ad025ac88f968dbeaea05e95cf40d64782793e0/src/nvim/insexpand.c#L1103
augroup('Lsp', {
  'LspAttach',
  {
    callback = function(ev)
      -- lsp.inlay_hint.enable()
      -- TODO: set a short query timeout...

      ---@diagnostic disable-next-line: redefined-local
      local n = n[ev.buf]
      n('<c-h>', lsp.buf.signature_help)
      n('_', lsp.buf.hover)
      n(' rn', lsp.buf.rename)
      n(
        ' <c-r>',
        function() return ':IncRename ' .. fn.expand('<cword>') end,
        { expr = true, replace_keycodes = true }
      )
    end,
  },
})
