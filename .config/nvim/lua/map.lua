local kmp = {}

kmp.edit = function()
  nx('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
  nx('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

  n('<leader>j', '<cmd>t .<cr>')
  x('<leader>j', '"gy\'>"gp')
  nx('$', 'g_')
  x('.', ':normal .<cr>')

  x('p', 'P')
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
  n('<leader>p', '<cmd>%d _ | norm P<cr>')
  n('<leader>y', '<cmd>%y<cr>')

  ic('<c-f>', '<right>')
  ic('<c-b>', '<left>')
  ic('<c-p>', '<up>')
  ic('<c-n>', '<down>')
  ic('<c-a>', '<home>')
  ic('<c-e>', '<end>')
  ic('<c-j>', function()
    require('readline').forward_word()
  end)
  ic('<c-o>', function()
    require('readline').backward_word()
  end)
  ic('<c-l>', function()
    require('readline').kill_word()
  end)
  ic('<c-k>', function()
    require('readline').kill_line()
  end)

  n('<leader>J', '<cmd>TSJToggle<cr>')
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
  n('<leader>oj', '<cmd>wincmd _<cr>')
  n('<leader>ok', '<cmd>wincmd =<cr>')
  n('<c-s>j', '<cmd>wincmd _<cr>')
  n('<c-s>k', '<cmd>wincmd =<cr>')
  n('<c-s>v', '<cmd>wincmd v<cr>')
  n('<c-s>s', '<cmd>wincmd s<cr>')
  n('<c-s>H', '<cmd>wincmd H<cr>')
  n('<c-s>J', '<cmd>wincmd J<cr>')
  n('<c-j>', '<cmd>wincmd w<cr>')
  n('<c-k>', '<cmd>wincmd W<cr>')

  n('<leader>q', function()
    local qf_win = vim
      .iter(vim.fn.getwininfo())
      :filter(function(win)
        return win.quickfix == 1
      end)
      :totable()
    if #qf_win == 0 then
      vim.cmd.copen()
    else
      vim.cmd.cclose()
    end
  end)
  n('<leader>k', '<cmd>NvimTreeFindFileToggle<cr>')
  n('<leader>wo', '<cmd>AerialToggle<cr>')
  n('<leader>wl', '<cmd>Lazy<cr>')
  n('<localleader>r', ':Lazy reload ')
  n('<leader>wj', '<cmd>Navbuddy<cr>')
  n('<leader>wi', '<cmd>LspInfo<cr>')
  n('<leader>wu', '<cmd>NullLsInfo<cr>')
  n('<leader>wy', '<cmd>Mason<cr>')
  n('<localleader>q', '<cmd>tabclose<cr>')
end

kmp.fmt = function()
  -- n("gw", "gg=G``")
  n('<leader>rp', '<cmd>%FullwidthPunctConvert<cr>')
  x('<leader>rp', ':FullwidthPunctConvert<cr>')
  n('<leader>rs', ":%s/\\s*$//g<cr>''")
  nx('<leader>rl', ":g/^$/d<cr>''")
  -- n("<leader>rc", [[<cmd>%s/ *\/\/.*//g<cr>'']])
  -- x("<leader>rc", [[:s/ *\/\/.*//g<cr>'']])
  x('<leader>r*', [[:s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  n('<leader>r*', [[:%s/^\([  ]*\)- \(.*\)/\1* \2/g]])
  x('<leader>r ', [[:s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  n('<leader>r ', [[:%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
  x('<leader>ro', ':!sort<cr>')

  nx('gw', function()
    require('conform').format { lsp_fallback = true }
  end)
end

kmp.option = function()
  n('<leader>oc', '<cmd>set cursorline! cursorcolumn!<cr>')
  n('<leader>of', '<cmd>set foldenable!<cr>')
  n('<leader>os', '<cmd>set spell!<cr>')
  n('<leader>ow', '<cmd>set wrap!<cr>')
end

kmp.misc = function()
  n('<leader>I', '<cmd>lua vim.show_pos()<cr>')
  n('<localleader>I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
  n('<localleader>E', '<cmd>lua vim.treesitter.query.edit()<cr>')
  n('<leader>M', '<cmd>messages<cr>')
  n('<leader>H', '<cmd>Fidget history<cr>')
  nx('<leader>i', 'K')
  n('K', ':Translate<cr>')

  n('<leader>cd', '<cmd>cd %:h<cr>')
  n('<leader>cg', function()
    local root = vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout
    if root == nil then
      return
    end
    root = vim.trim(root)
    vim.fn.chdir(root)
  end)
  n('<leader>cn', function()
    vim.fn.system(fmt('echo -n %s | xsel -ib', vim.fn.expand '%'))
  end)
  n('<leader>cx', '<cmd>!chmod +x %<cr>')

  map('t', '<c- >', '<c-\\><c-n>')

  -- diagnostics
  n('<leader>dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  n('<leader>dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  n('<leader>df', '<cmd>lua vim.diagnostic.open_float()<cr>')
  n('<leader>ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')

  -- notes
  n('<leader>e', '<cmd>e ~/notes/todo.md<cr>')
  nx('<leader>fn', '<cmd>SimpleNoteList<cr>')
end

kmp.tobj = function()
  ox('iq', 'i"')
  ox('aq', 'a"')
  ox('in', 'iB')
  ox('an', 'aB')
  ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
  ox('ah', ':<c-u>Gitsigns select_hunk<cr>')
  vim.cmd [[
" line object, https://vi.stackexchange.com/questions/24861/selector-for-line-of-text
function! Textobj_line(count) abort
    normal! gv
    if visualmode() !=# 'v'
    normal! v
    endif
    let startpos = getpos("'<")
    let endpos = getpos("'>")
    if startpos == endpos
    execute "normal! ^o".a:count."g_"
    return
    endif
    let curpos = getpos('.')
    if curpos == endpos
    normal! g_
    let curpos = getpos('.')
    if curpos == endpos
        execute "normal!" (a:count+1)."g_"
    elseif a:count > 1
        execute "normal!" a:count."g_"
    endif
    else
    normal! ^
    let curpos = getpos('.')
    if curpos == startpos
        execute "normal!" a:count."-"
    elseif a:count > 1
        execute "normal!" (a:count-1)."-"
    endif
    endif
endfunction
xnoremap <silent> il :<c-u>call Textobj_line(v:count1)<cr>
onoremap <silent> il :<c-u>execute "normal! ^v".v:count1."g_"<cr>
]]
end

nx('<leader>so', '<cmd>so<cr>')
vim.tbl_map(function(fn)
  fn()
end, kmp)
