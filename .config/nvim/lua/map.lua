local n = function(...) map("n", ...) end
local x = function(...) map("x", ...) end
local t = function(...) map("t", ...) end
local nx = function(...) map({ "n", "x" }, ...) end
local ox = function(...) map({ "o", "x" }, ...) end
local ic = function(...) map("!", ...) end

-- basics {{{
nx("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nx("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

n("gj", '"gyy"gp')
x("gj", '"gy\'>"gp')
nx("$", "g_")

n("gw", "gg=G``")

x("p", "P")
nx("d", '"_d')
nx("D", '"_D')
nx("c", '"_c')
nx("C", '"_C')

n("<a-j>", "<cmd>move+<cr>")
n("<a-k>", "<cmd>move-2<cr>")
x("<a-j>", ":move '>+<cr>gv")
x("<a-k>", ":move '<-2<cr>gv")
n("<a-h>", "<<")
n("<a-l>", ">>")
x("<a-h>", "<gv")
x("<a-l>", ">gv")

t("<c- >", "<c-\\><c-n>")
x(".", ":normal .<cr>")

local toggle_qf = function()
  local qf_win = vim.iter(vim.fn.getwininfo()):filter(function(win) return win.quickfix == 1 end):totable()
  if #qf_win == 0 then
    vim.cmd.copen()
  else
    vim.cmd.cclose()
  end
end
n("<leader>q", toggle_qf)

ox("iq", 'i"')
ox("aq", 'a"')
ox("in", "iB")
ox("an", "aB")

n("<leader>p", "<cmd>%d _ | norm P<cr>")
n("<leader>y", "<cmd>%y<cr>")
n("<leader>cd", "<cmd>cd %:h<cr>")
n("<leader>cy", function() vim.fn.system(string.format("echo -n %s | xsel -ib", vim.fn.expand "%")) end)
n("<leader>cg", function()
  local root = vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout
  if root == nil then return end
  root = vim.trim(root)
  vim.fn.chdir(root)
end)
-- }}}
-- readline {{{
ic("<c-f>", "<right>")
ic("<c-b>", "<left>")
ic("<c-p>", "<up>")
ic("<c-n>", "<down>")
ic("<c-a>", "<home>")
ic("<c-e>", "<end>")
ic("<c-j>", function() require("readline").forward_word() end)
ic("<c-o>", function() require("readline").backward_word() end)
ic("<c-l>", function() require("readline").kill_word() end)
ic("<c-k>", function() require("readline").kill_line() end)
-- }}}
-- layout {{{
n("<c-f>", "<cmd>BufferLineCycleNext<cr>")
n("<c-e>", "<cmd>BufferLineCyclePrev<cr>")
n("<c-w>", "<cmd>Bdelete!<cr>")
n("<leader>bo", "<cmd>BufferLineCloseOthers<cr>")
n("<leader>br", "<cmd>BufferLineCloseRight<cr>")
n("<leader>bl", "<cmd>BufferLineCloseLeft<cr>")
n("<c-b>", "<cmd>FzfLua buffers<cr>")
n("<c-s><c-s>", "<cmd>wincmd q<cr>")
-- TODO: restart with session
-- n("<c-s>r", "<cmd>wincmd q<cr>")
n("<leader>oj", "<cmd>wincmd _<cr>")
n("<leader>ok", "<cmd>wincmd =<cr>")
n("<c-s>v", "<cmd>wincmd v<cr>")
n("<c-s>s", "<cmd>wincmd s<cr>")
n("<c-s>H", "<cmd>wincmd H<cr>")
n("<c-s>J", "<cmd>wincmd J<cr>")
n("<c-j>", "<cmd>wincmd w<cr>")
n("<c-k>", "<cmd>wincmd W<cr>")

n("<localleader>q", "<cmd>tabclose<cr>")
-- }}}
-- subtitution {{{
n("<leader>rp", "<cmd>%FullwidthPunctConvert<cr>")
x("<leader>rp", ":FullwidthPunctConvert<cr>")
n("<leader>rs", ":%s/\\s*$//g<cr>''")
nx("<leader>rl", ":g/^$/d<cr>''")
n("<leader>rc", [[<cmd>%s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
x("<leader>rc", [[:s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
x("<leader>r*", [[:s/^\([  ]*\)- \(.*\)/\1* \2/g]])
n("<leader>r*", [[:%s/^\([  ]*\)- \(.*\)/\1* \2/g]])
x("<leader>r ", [[:s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<cr>]])
-- }}}
-- toggle {{{
-- windows
n("<leader>k", "<cmd>NvimTreeFindFileToggle<cr>")
n("<leader>wo", "<cmd>AerialToggle<cr>")
n("<leader>wl", "<cmd>Lazy<cr>")
n("<localleader>r", ":Lazy reload ")
n("<leader>wj", "<cmd>Navbuddy<cr>")
n("<leader>wi", "<cmd>LspInfo<cr>")
n("<leader>wu", "<cmd>NullLsInfo<cr>")
n("<leader>wy", "<cmd>Mason<cr>")
-- options
n("<leader>oc", "<cmd>set cursorline! cursorcolumn!<cr>")
n("<leader>of", "<cmd>set foldenable!<cr>")
n("<leader>os", "<cmd>set spell!<cr>")
n("<leader>ow", "<cmd>set wrap!<cr>")
-- }}}
-- diagnostic {{{
n("<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
n("<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<cr>")
n("<leader>df", "<cmd>lua vim.diagnostic.open_float()<cr>")
n("<leader>ds", "<cmd>lua vim.diagnostic.setloclist()<cr>")
-- }}}
-- misc {{{
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
x("//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

n("<leader>I", "<cmd>Inspect<cr>")
n("<leader>M", "<cmd>messages<cr>")
-- FIXME: cross line ^M -> \n
n("<leader>cw", [[:%s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]])
n("<leader>cl", [[:s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]])
x("<leader>cw", [["zy:%s/<c-r><c-o>"//g<left><left>]])

n("<leader>E", "<cmd>e ~/priv/todo.md<cr>")
n(
  "<leader>e",
  function() return string.format("<cmd>e ~/priv/%s.md<cr>", vim.trim(vim.fn.system "date +%m-%d")) end,
  { expr = true }
)
n("<leader>cx", "<cmd>!chmod +x %<cr>")
-- }}}
-- tobj {{{
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
-- }}}
-- vim:foldmethod=marker
