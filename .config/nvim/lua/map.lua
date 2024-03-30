-- stylua: ignore start
local n = function(...) map('n', ...) end
local x = function(...) map('x', ...) end
local nx = function(...) map({ 'n', 'x' }, ...) end
local ox = function(...) map({ 'o', 'x' }, ...) end
local ic = function(...) map('!', ...) end
-- stylua: ignore end

local kmp = {}

-- TODO: lsp rename passthrough?
---@module "util"
local util = setmetatable({}, {
  __index = function(_, k)
    return ([[<cmd>lua r.util.%s()<cr>]]):format(k)
  end,
})

kmp.edit = function()
  nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
  nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

  n('<leader>j', '<cmd>t .<cr>')
  x('<leader>j', '"gy\'>"gp')
  nx('$', 'g_')
  x('.', ':normal .<cr>')

  -- TODO: not sure what happened with c-s-v
  nx('p', 'P')
  nx('gp', 'p')
  nx('d', '"_d')
  nx('D', '"_D')
  nx('c', '"_c')
  nx('C', '"_C')

  n('<a-j>', '<cmd>move+<cr>')
  n('<a-k>', '<cmd>move-2<cr>')
  x('<a-j>', ":move '>+<cr>gv")
  x('<a-k>', ":move '<-2<cr>gv")
  n('<a-h>', '<<')
  n('<a-l>', '>>')
  x('<a-h>', '<gv')
  x('<a-l>', '>gv')
  n('<leader>p', '<cmd>%d _ | norm vP<cr>')
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
  n('<c-h>', '<c-u>')
end

kmp.buf = function()
  n('<c-f>', '<cmd>BufferLineCycleNext<cr>')
  n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
  -- TODO: bdelete last 2 tab (nvim-tree)
  -- TODO: Bdelete Man xx
  n('<c-w>', '<cmd>Bdelete!<cr>')
  n('<leader>bo', '<cmd>BufferLineCloseOthers<cr>')
  n('<leader>br', '<cmd>BufferLineCloseRight<cr>')
  n('<leader>bl', '<cmd>BufferLineCloseLeft<cr>')
  n('<leader>bi', '<cmd>buffers<cr>')
  n('<leader>bI', '<cmd>buffers!<cr>')
end

kmp.win = function()
  n('<c-s><c-s>', '<cmd>wincmd q<cr>')
  n('<c-s>d', '<cmd>wincmd q<cr>')
  n('<c-s>_', '<cmd>wincmd _<cr>')
  n('<c-s>=', '<cmd>wincmd =<cr>')
  n('<c-s>v', '<cmd>wincmd v<cr>')
  n('<c-s>s', '<cmd>wincmd s<cr>')
  n('<c-s>H', '<cmd>wincmd H<cr>')
  n('<c-s>J', '<cmd>wincmd J<cr>')
  n('<c-j>', '<cmd>wincmd w<cr>')
  n('<c-k>', '<cmd>wincmd W<cr>')

  n('q', util.q)
  n('<leader>q', util.toggle_qf)
  n('<leader>k', '<cmd>NvimTreeFindFileToggle<cr>')
  n('<leader>wo', '<cmd>AerialToggle<cr>')
  n('<leader>wl', '<cmd>Lazy<cr>')
  n('<leader>wj', '<cmd>Navbuddy<cr>')
  n('<leader>wi', '<cmd>LspInfo<cr>')
  n('<leader>wu', '<cmd>NullLsInfo<cr>')
  n('<leader>wy', '<cmd>Mason<cr>')
  n('<localleader>q', '<cmd>tabclose<cr>')
end

kmp.fmt = function()
  n('<leader>rp', '<cmd>%FullwidthPunctConvert<cr>')
  x('<leader>rp', ':FullwidthPunctConvert<cr>')
  n('<leader>rs', ":%s/\\s*$//g<cr>''")
  nx('<leader>rl', ":g/^$/d<cr>''")
  x('<leader>r*', [[:s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  n('<leader>r*', [[:%s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  x('<leader>r ', [[:s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  n('<leader>r ', [[:%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  x('<leader>ro', ':!sort<cr>')

  nx('gw', '<cmd>lua r.conform.format { lsp_fallback = true }<cr>')
end

kmp.option = function()
  n('<leader>oc', '<cmd>set cursorline! cursorcolumn!<cr>')
  n('<leader>of', '<cmd>set foldenable!<cr>')
  n('<leader>or', '<cmd>retab<cr>')
  n('<leader>os', '<cmd>set spell!<cr>')
  n('<leader>ow', '<cmd>set wrap!<cr>')
end

kmp.misc = function()
  n('<leader>I', '<cmd>lua vim.show_pos()<cr>')
  n('<localleader>I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
  n('<localleader>E', '<cmd>lua vim.treesitter.query.edit()<cr>')
  n('<leader>m', '<cmd>messages<cr>')
  n('<leader>M', '<cmd>messages clear<cr>')
  nx('<leader>i', 'K')
  nx('_', 'K')
  nx('K', ':Translate<cr>')
  nx('<leader>L', ':Linediff<cr>')
  nx('<leader>E', ':EditCodeBlock<cr>')

  n('<leader>cf', '<cmd>cd %:h<cr>')
  n('<leader>cd', util.cd_gitroot)
  n('<leader>cn', util.yank_filename)
  n('<leader>cx', '<cmd>!chmod +x %<cr>')

  map('t', '<c- >', '<c-\\><c-n>')

  -- diagnostics
  n('<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  n('<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  n('<leader>df', '<cmd>lua vim.diagnostic.open_float()<cr>')
  n('<leader>ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')

  n('<localleader>fr', ':Rename ')
  n('<localleader>fd', ':Delete ')
end

kmp.tobj = function()
  ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
  local tobj = function(c, t)
    ox('i' .. c, ([[<cmd>lua require("various-textobjs").%s("inner")<cr>]]):format(t))
    ox('a' .. c, ([[<cmd>lua require("various-textobjs").%s("outer")<cr>]]):format(t))
  end
  tobj('c', 'multiCommentedLines')
  tobj('g', 'entireBuffer')
  tobj('i', 'indentation')
  tobj('l', 'lineCharacterwise')
  tobj('n', 'anyBracket')
  tobj('q', 'anyQuote')
  tobj('u', 'url')
  n('<leader><c-/>', '<cmd>norm vac<c-/><cr>')
end

nx('<leader>so', '<cmd>so<cr>')

for _, fn in pairs(kmp) do
  fn()
end
