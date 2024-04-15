local n = function(...) map('n', ...) end
local x = function(...) map('x', ...) end
local t = function(...) map('t', ...) end
local i = function(...) map('i', ...) end
local nx = function(...) map({ 'n', 'x' }, ...) end
local ox = function(...) map({ 'o', 'x' }, ...) end
local ic = function(...) map('!', ...) end

-- TODO: inject a table local to file?

-- TODO: lsp rename passthrough?
---@module "util"
local util = setmetatable({}, {
  __index = function(_, k) return ([[<cmd>lua r.util.%s()<cr>]]):format(k) end,
})

do -- edit
  nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
  nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

  n('<leader>j', '<cmd>t .<cr>')
  x('<leader>j', '"gy\'>"gp')
  nx('$', 'g_')
  x('.', ':normal .<cr>')

  -- TODO: not sure what happened with c-s-v
  nx('p', 'P')
  nx('gp', 'p')

  n('<a-j>', '<cmd>move+<cr>')
  n('<a-k>', '<cmd>move-2<cr>')
  x('<a-j>', ":move '>+<cr>gv")
  x('<a-k>', ":move '<-2<cr>gv")
  n('<a-h>', '<<')
  n('<a-l>', '>>')
  x('<a-h>', '<gv')
  x('<a-l>', '>gv')
  n('<leader>p', '<cmd>%d _ | norm VP<cr>')
  n('<leader>y', '<cmd>%y<cr>')

  ic('<c-f>', '<right>')
  ic('<c-b>', '<left>')
  ic('<c-p>', '<up>')
  ic('<c-n>', '<down>')
  ic('<c-a>', '<home>')
  ic('<c-e>', '<end>')
  ic('<c-j>', '<cmd>lua require("readline").forward_word()<cr>')
  ic('<c-o>', '<cmd>lua require("readline").backward_word()<cr>')
  ic('<c-l>', '<cmd>lua require("readline").kill_word()<cr>')
  ic('<c-k>', '<cmd>lua require("readline").kill_line()<cr>')
  -- TODO: fix flick below, or make repeatable above
  -- ic('<c-j>', '<c-o>w')
  -- ic('<c-o>', '<c-o>b')
  -- ic('<c-l>', '<c-o>dw')
  -- ic('<c-k>', '<c-o>D')
  nx('-', '<cmd>TSJToggle<cr>')
  -- n('<c-h>', '<c-u>')

  nx('gw', '<cmd>lua r.conform.format { lsp_fallback = true }<cr>')

  -- upstream these garbage...
  n('<leader>rp', '<cmd>%FullwidthPunctConvert<cr>')
  x('<leader>rp', ':FullwidthPunctConvert<cr>')
  n('<leader>rs', ":%s/\\s*$//g<cr>''")
  nx('<leader>rl', ":g/^$/d<cr>''")
  x('<leader>r*', [[:s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  n('<leader>r*', [[:%s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  x('<leader>r ', [[:s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  n('<leader>r ', [[:%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  x('<leader>ro', ':!sort<cr>')

  -- textobj
  ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
  local tobj = function(c, func)
    ox('i' .. c, ([[<cmd>lua require("various-textobjs").%s("inner", "inner")<cr>]]):format(func))
    ox('a' .. c, ([[<cmd>lua require("various-textobjs").%s("outer", "outer")<cr>]]):format(func))
  end
  tobj('c', 'multiCommentedLines')
  tobj('g', 'entireBuffer')
  tobj('i', 'indentation')
  tobj('l', 'lineCharacterwise')
  tobj('n', 'anyBracket')
  tobj('q', 'anyQuote')
  tobj('u', 'url')

  -- n('giq', "<cmd>lua require('various-textobjs').anyQuote('inner', 'inner')<cr>c")
  -- n('gaq', "<cmd>lua require('various-textobjs').anyQuote('outer', 'outer')<cr>c")

  nx('d', '"_d')
  nx('D', '"_D')
  nx('c', '"_c')
  nx('C', '"_C')

  n('ge', 'G')
  -- without jumps
  nx('}', '<cmd>keepj norm! }<cr>')
  nx('{', '<cmd>keepj norm! {<cr>')

  -- expriment
  -- work for builti, textobj
  n('gi', '"_ci')
  n('ga', '"_ca')

  -- n('gaw', 'caw')
  n('giq', 'ciq')
  n('gaq', 'caq')
  -- n('<leader>gi', 'gi')
  -- n('gg', 'gg')
  -- n('g', 'c')
end

do -- comment
  map({ 'n', 'x', 'i' }, '<c-_>', '<c-/>', { remap = true })
  x('<c-/>', 'gc', { remap = true })
  -- TODO: comment empty line?
  i('<c-/>', '<cmd>norm <c-/><cr>')
  n(
    '<c-/>',
    function() return vim.v.count == 0 and 'gcl' or 'gcj' end,
    { expr = true, remap = true }
  )
  n('<leader><c-/>', '<cmd>norm vac<c-/><cr>')
end

do -- buf
  -- n('<c-f>', '<cmd>BufferLineCycleNext<cr>')
  -- n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
  n('<c-f>', '<cmd>bn<cr>')
  n('<c-e>', '<cmd>bp<cr>')
  -- TODO: bdelete last 2 tab (nvim-tree)
  -- TODO: Bdelete Man xx
  n('<c-w>', '<cmd>Bdelete!<cr>')
  n('<leader>bo', '<cmd>BufferLineCloseOthers<cr>')
  n('<leader>br', '<cmd>BufferLineCloseRight<cr>')
  n('<leader>bl', '<cmd>BufferLineCloseLeft<cr>')
  n('<leader>bi', '<cmd>buffers<cr>')
  n('<leader>bI', '<cmd>buffers!<cr>')
  n('H', '<cmd>BufferLineMovePrev<cr>')
  n('L', '<cmd>BufferLineMoveNext<cr>')
end

do -- win
  n('<c-s><c-s>', '<cmd>wincmd q<cr>')
  n('<c-s>_', '<cmd>wincmd _<cr>')
  n('<c-s>=', '<cmd>wincmd =<cr>')
  n('<c-s>-', '<cmd>resize -5<cr>')
  n('<c-s>+', '<cmd>resize +5<cr>')
  n('<c-s>|', '<cmd>wincmd |<cr>')
  n('<c-s>v', '<cmd>wincmd v<cr>')
  n('<c-s>s', '<cmd>wincmd s<cr>')
  n('<c-s>H', '<cmd>wincmd H<cr>')
  n('<c-s>J', '<cmd>wincmd J<cr>')
  n('<c-j>', '<cmd>wincmd w<cr>')
  n('<c-k>', '<cmd>wincmd W<cr>')

  -- reload current session to check whatever, with a new wrap starter .bin/nvim
  n('<c-s><c-d>', '<cmd>mksession! /tmp/reload.vim | 123cq<cr>')

  -- TODO: fail if insert
  n('q', util.q)
  n('<leader>q', util.toggle_qf)
  n('<leader>k', '<cmd>NvimTreeFindFileToggle<cr>')
  n('<leader>wo', '<cmd>AerialToggle<cr>')
  n('<leader>wl', '<cmd>Lazy<cr>')
  n('<leader>wj', '<cmd>Navbuddy<cr>')
  n('<leader>wi', '<cmd>LspInfo<cr>')
  n('<leader>wu', '<cmd>NullLsInfo<cr>')
  n('<leader>wy', '<cmd>Mason<cr>')
  n('+q', util.force_close_tabpage)
end

do -- option
  n('<leader>oc', '<cmd>set cursorline! cursorcolumn!<cr>')
  n('<leader>of', '<cmd>set foldenable!<cr>')
  n('<leader>or', '<cmd>retab<cr>')
  n('<leader>os', '<cmd>set spell!<cr>')
  n('<leader>ow', '<cmd>set wrap!<cr>')
end

do -- misc
  n('<leader>I', '<cmd>lua vim.show_pos()<cr>')
  n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
  n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
  n('<leader>m', '<cmd>messages<cr>')
  n('<leader>M', '<cmd>messages clear<cr>')
  nx('<leader>L', ':Linediff<cr>')

  n('+L', '<cmd>lua u._lazy_patch()<cr>')

  nx('<leader>E', ':EditCodeBlock<cr>')

  nx('_', 'K')
  nx('K', ':Translate<cr>')

  n('<leader>.', '<cmd>Neogen<CR>')

  n('<leader>cf', '<cmd>cd %:h<cr>')
  n('<leader>cd', util.cd_gitroot_or_parent)
  n('<leader>cn', util.yank_filename)
  n('<leader>cm', util.yank_message)
  n('<leader>cx', '<cmd>!chmod +x %<cr>')
  n('<leader>cX', '<cmd>!chmod -x %<cr>')

  t('<c- >', '<c-\\><c-n>')

  -- diagnostics
  n('<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  n('<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  n('<leader>df', '<cmd>lua vim.diagnostic.open_float()<cr>')
  n('<leader>ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')

  n('+rr', function() return ':Rename ' .. vim.api.nvim_buf_get_name(0) end, { expr = true })
  n('+rd', ':Delete')
end

-- stylua: ignore
do
  local c = function(trig, cmd)
    map('c', trig, function() return vim.fn.getcmdcompltype() == 'command' and cmd or trig end, { expr = true })
  end
  -- abbr will be trigger only type scpace
  -- local a = function(trig, cmd)
  --   map('ca', trig, function() return vim.fn.getcmdcompltype() == 'command' and cmd or trig end, { expr = true })
  -- end
  c('S', '%s/')
  c(':', 'lua ')
end

nx('<leader>so', ':so<cr>')
n('<leader>ss', '<cmd>mksession! /tmp/Session.vim<cr><cmd>q!<cr>')
n('<leader>sl', '<cmd>so /tmp/Session.vim<cr>')
