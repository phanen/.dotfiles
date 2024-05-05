local n = function(...) map('n', ...) end
local x = function(...) map('x', ...) end
local nx = function(...) map({ 'n', 'x' }, ...) end
local ox = function(...) map({ 'o', 'x' }, ...) end
local ic = function(...) map('!', ...) end

---@module "util"
local util = setmetatable({}, {
  __index = function(_, k) return ([[<cmd>lua r.util.%s()<cr>]]):format(k) end,
})

do -- first
  -- reload current session to check whatever, with a new wrap starter .bin/nvim
  -- TODO: more thing need to be preserved, `SessionWritePost`
  n('<c-s><c-d>', '<cmd>mksession! /tmp/reload.vim | 123cq!<cr>')
  n('<leader>ss', '<cmd>mksession! /tmp/Session.vim<cr><cmd>q!<cr>')
  n('<leader>sl', '<cmd>so /tmp/Session.vim<cr>')
  nx('<leader>so', ':so<cr>')
end

do -- motion
  map('', ' ', '<nop>')
  nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
  nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

  nx('}', '<cmd>keepj norm! }k<cr>')
  nx('{', '<cmd>keepj norm! {j<cr>')

  nx('$', 'g_')
  x('.', ':normal .<cr>')

  -- https://github.com/neovim/neovim/discussions/24285
  -- stationary
  vim.cmd [[
    nnoremap <silent> z*  ms:<c-u>let @/='\V\<'.escape(expand('<cword>'), '/\').'\>'<bar>call histadd('/',@/)<bar>set hlsearch<cr>
  ]]

  n('<a-j>', '<cmd>move+<cr>')
  n('<a-k>', '<cmd>move-2<cr>')
  x('<a-j>', ":move '>+<cr>gv")
  x('<a-k>', ":move '<-2<cr>gv")
  n('<a-h>', '<<')
  n('<a-l>', '>>')
  x('<a-h>', '<gv')
  x('<a-l>', '>gv')

  ic('<c-f>', '<right>')
  ic('<c-b>', '<left>')
  ic('<c-p>', '<up>')
  ic('<c-n>', '<down>')
  ic('<c-a>', '<home>')
  ic('<c-e>', '<end>')
  ic('<c-a>', '<cmd>lua require("readline").dwim_beginning_of_line()<cr>')
  -- ic('<c-e>', '<cmd>lua require("readline").dwim_end_of_line()<cr>')
  -- ic('<a-m>', 'v:lua.require("readline").back_to_indentation()', { expr = true })
  -- ic('<c-w>', '<cmd>lua require("readline").backward_kill_word()<cr>')
  ic('<c-j>', '<cmd>lua require("readline").forward_word()<cr>')
  ic('<c-o>', '<cmd>lua require("readline").backward_word()<cr>')
  ic('<c-l>', '<cmd>lua require("readline").kill_word()<cr>')
  ic('<c-k>', '<cmd>lua require("readline").kill_line()<cr>')
end

do -- yank
  n('<leader>p', '<cmd>%d _ | norm VP<cr>')
  n('<leader>y', '<cmd>%y<cr>')

  -- FIXME: this makes register unusable
  for _, k in pairs({ 'd', 'D', 'c', 'C' }) do
    nx(k, '"_' .. k)
    nx('+' .. k, k)
  end
  -- NOTE: 2dl ???
  -- n('x', "v:count == 0 ? 'x' : 'x'", { expr = true })

  n('<leader>j', '<cmd>t .<cr>')
  x('<leader>j', '"gy\'>"gp')

  n('gy', '`[v`]')
end

do -- textobj
  ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
  local tobj = function(c, func)
    ox('i' .. c, ([[<cmd>lua require("various-textobjs").%s("inner", "inner")<cr>]]):format(func))
    ox('a' .. c, ([[<cmd>lua require("various-textobjs").%s("outer", "outer")<cr>]]):format(func))
  end
  tobj('c', 'multiCommentedLines')
  tobj('g', 'entireBuffer')
  tobj('i', 'indentation')
  tobj('l', 'lineCharacterwise')
  -- tobj('n', 'anyBracket')
  tobj('q', 'anyQuote')
  tobj('u', 'url')
  ox('in', 'iB')
  ox('an', 'aB')
end

do
  nx('gw', '<cmd>lua r.conform.format { lsp_fallback = true }<cr>')
  local s = function(lhs, pattern)
    n(lhs, ('<cmd>%%%s<cr>``'):format(pattern))
    x(lhs, (':%s<cr>``'):format(pattern))
  end
  -- formatter
  s('<leader>rp', [[FullwidthPunctConvert]])
  -- x('<leader>rp', ':FullwidthPunctConvert<cr>') -- TODO: not change cursor pos
  n('<leader>rj', ':Pangu<cr>') -- TODO: not change cursor pos
  x('<leader>ro', ':!sort<cr>')
  s('<leader>rs', [[s/\s*$//g<cr>``]])
  s('<leader>rl', [[g/^$/d]])
  s('<leader>r*', [[s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  s('<leader>r ', [[s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]])
end

do -- comment
  map({ 'n', 'x', 'i' }, '<c-_>', '<c-/>', { remap = true })
  x('<c-/>', 'gc', { remap = true })
  -- TODO: comment empty line?
  map('i', '<c-/>', '<cmd>norm <c-/><cr>')
  n(
    '<c-/>',
    function() return vim.v.count == 0 and 'gcl' or 'gcj' end,
    { expr = true, remap = true }
  )
  n('<leader><c-/>', '<cmd>norm vac<c-/><cr>')
end

do -- buf
  n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
  n('<c-f>', '<cmd>BufferLineCycleNext<cr>')
  n('<c-h>', '<c-^>')
  n('<c-w>', u.bufdelete)
  n('H', '<cmd>BufferLineMovePrev<cr>')
  n('L', '<cmd>BufferLineMoveNext<cr>')
  n('<leader>bi', '<cmd>buffers<cr>')
  n('<leader>bI', '<cmd>buffers!<cr>')
  n('<leader>bl', '<cmd>BufferLineCloseLeft<cr>')
  n('<leader>bo', '<cmd>BufferLineCloseOthers<cr>')
  n('<leader>br', '<cmd>BufferLineCloseRight<cr>')
end

do -- win
  n('<c-j>', '<cmd>wincmd w<cr>')
  n('<c-k>', '<cmd>wincmd W<cr>')
  n('<c-s>+', '<cmd>resize +5<cr>')
  n('<c-s>-', '<cmd>resize -5<cr>')
  n('<c-s>=', '<cmd>wincmd =<cr>')
  n('<c-s>_', '<cmd>wincmd _<cr>')
  n('<c-s>|', '<cmd>wincmd |<cr>')
  n('<c-s><c-s>', '<cmd>wincmd q<cr>')
  n('<c-s>H', '<cmd>wincmd H<cr>')
  n('<c-s>J', '<cmd>wincmd J<cr>')
  n('<c-s>s', '<cmd>wincmd s<cr>')
  n('<c-s>v', '<cmd>wincmd v<cr>')

  n('<leader>k', '<cmd>NvimTreeFindFileToggle<cr>')
  n('<leader>q', util.qf_toggle)
  n('+q', util.force_close_tabpage)
  n('q', util.smart_quit)

  n('<leader>wo', '<cmd>AerialToggle!<cr>')
  -- n('<leader>wo', '<cmd>Outline<cr>')
  n('<leader>wi', '<cmd>LspInfo<cr>')
  n('<leader>wl', '<cmd>Lazy<cr>')
  n('<leader>wm', '<cmd>Mason<cr>')
  n('<leader>wh', '<cmd>ConformInfo<cr>')

  n('<leader>Q', '<cmd>quitall!<cr>')
end

do
  n('<leader>oc', '<cmd>set cursorline! cursorcolumn!<cr>')
  n('<leader>or', '<cmd>retab<cr>')
  n('<leader>os', '<cmd>set spell!<cr>')
  n('<leader>ow', '<cmd>set wrap!<cr>')
  n('<leader>ol', '<cmd>set columns=80<cr>')
end

do -- misc
  n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
  n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
  -- you know the trick
  -- n('+L', '<cmd>lua u._lazy_patch()<cr><cmd>lua u.lazy_cache_docs()<cr>')
  n('<leader>I', '<cmd>lua vim.show_pos()<cr>')
  nx('<leader>E', ':EditCodeBlock<cr>')
  nx('<leader>L', ':Linediff<cr>')

  -- n('<leader>m;', 'g<')
  n('<leader>mk', '<cmd>messages clear<cr>')
  -- n('<leader>ml', '<cmd>1messages<cr>')
  n('<leader>ml', '<cmd>messages<cr>')
  -- TODO: message is chunked, and ... paged, terrible
  -- so we use a explicit "redir" wrapper now
  -- TODO: toggle it
  vim.api.nvim_create_user_command('R', function(opt) u.pipe_cmd(opt.args) end, {
    nargs = 1,
    complete = 'command',
  })
  n('<leader>me', '<cmd>R messages<cr>')
  -- command! -nargs=1 -complete=command Redir lua u.pipe_cmd(<q-args>)()
  -- command! -nargs=1 RedirT silent call <SID>redir('tabnew', <f-args>)
  n('<leader>ma', function() u.pipe_cmd('messages') end)

  n('-', '<cmd>TSJToggle<cr>')
  nx('_', 'K')
  nx('K', ':Translate<cr>')

  n('<leader>cd', util.smart_cd)
  n('<leader>cf', '<cmd>cd %:h<cr>')
  n('<leader>cy', util.yank_filename)
  -- https://github.com/search?q=cgn+lang:vim
  n('<leader>c*', [[<cmd>let @/='\<'.expand('<cword>').'\>'<cr>"_cgn]])
  x('<leader>c*', [[sy:let @/=@s<cr>cgn]])

  n('<leader>cx', '<cmd>!chmod +x %<cr>')
  n('<leader>cX', '<cmd>!chmod -x %<cr>')

  map('t', '<c- >', '<c-\\><c-n>')
  map({ 't', 'n' }, '<c-\\>', '<cmd>execute v:count . "ToggleTerm"<cr>')

  -- diagnostics
  n('<leader>di', '<cmd>lua vim.diagnostic.open_float()<cr>')
  n('<leader>do', '<cmd>lua vim.diagnostic.setqflist()<cr>')
  n('<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  n('<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  n('<leader>ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')

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

  for _, char in ipairs({ ' ', '-', '_', ':', '.', '/' }) do
    map('i', char, char .. '<c-g>u')
  end
end
