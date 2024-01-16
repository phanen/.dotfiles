local n = function(...) map("n", ...) end
local x = function(...) map("x", ...) end
local t = function(...) map("t", ...) end
local o = function(...) map("o", ...) end
local e = function(...) map({ "n", "x" }, ...) end

-- basics {{{
e("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
e("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

n("gj", '"gyy"gp')
x("gj", '"gy\'>"gp')
e("$", "g_")

n("gw", "gg=G``")

x("p", "P")
e("d", '"_d')
e("D", '"_D')
e("c", '"_c')
e("C", '"_C')

n("<leader>p", "<cmd>%d _<cr><cmd>norm P<cr>")
n("<leader>y", "<cmd>%y<cr>")

n("<a-j>", "<cmd>move+<cr>")
n("<a-k>", "<cmd>move-2<cr>")
x("<a-j>", ":move '>+<cr>gv")
x("<a-k>", ":move '<-2<cr>gv")
n("<a-h>", "<<")
n("<a-l>", ">>")
x("<a-h>", "<gv")
x("<a-l>", ">gv")

t("<c- >", "<c-\\><c-n>")

local toggle_qf = function()
  local qf_win = vim.iter(vim.fn.getwininfo()):filter(function(win) return win.quickfix == 1 end):totable()
  if #qf_win == 0 then
    vim.cmd.copen()
  else
    vim.cmd.cclose()
  end
end
n("<leader>q", toggle_qf)

x("iq", 'i"')
o("iq", 'i"')

n("gl", "gx", { remap = true })

n("<leader>cd", "<cmd>cd %:h<cr>")
-- }}}
-- buffer {{{
n("<c-f>", "<cmd>BufferLineCycleNext<cr>")
n("<c-e>", "<cmd>BufferLineCyclePrev<cr>")
n("<c-w>", "<cmd>Bdelete!<cr>")
n("<leader>bo", [[<cmd>w | %bd | e#<cr>]])
-- }}}
-- readline {{{
map("!", "<c-f>", "<right>")
map("!", "<c-b>", "<left>")
map("!", "<c-p>", "<up>")
map("!", "<c-n>", "<down>")
map("!", "<c-a>", "<home>")
map("!", "<c-e>", "<end>")
map("!", "<c-j>", function() require("readline").forward_word() end)
map("!", "<c-o>", function() require("readline").backward_word() end)
map("!", "<c-l>", function() require("readline").kill_word() end)
map("!", "<c-k>", function() require("readline").kill_line() end)
-- }}}
-- window {{{
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
-- }}}
-- subtitution {{{
n(
  "<leader>rp",
  [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：　]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"', '　':'  '}[submatch(0)]/g<cr>
    ]],
  { desc = "half to full" }
)
n("<leader>rs", ":%s/\\s*$//g<cr>''", { desc = "clean tail space" })
e("<leader>rl", ":g/^$/d<cr>''")
n("<leader>rc", [[<cmd>%s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
x("<leader>rc", [[:s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
x("<leader>rn", [[:s/^\([0-9]\.\)\([^ ]\)/\1 \2/g<cr>]])
-- }}}
-- toggle {{{
-- windows
n("<leader>k", "<cmd>NvimTreeFindFileToggle<cr>")
n("<leader>wo", "<cmd>AerialToggle<cr>")
-- n("<leader>a", "<cmd>Outline<cr>")
n("<leader>wl", "<cmd>Lazy<cr>")
n("<leader>wj", "<cmd>Navbuddy<cr>")
n("<leader>wi", "<cmd>LspInfo<cr>")
n("<leader>wu", "<cmd>NullLsInfo<cr>")
n("<leader>wy", "<cmd>Mason<cr>")
-- options
n("<leader>oc", "<cmd>set cursorline! cursorcolumn!<cr>")
n("<leader>of", "<cmd>set foldenable!<cr>")
n("<leader>os", "<cmd>set spell!<cr>")
n("<leader>ow", "<cmd>set wrap!]]")
-- }}}
-- diagnostic {{{
n("[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
n("]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
n("<leader>df", "<cmd>lua vim.diagnostic.open_float()<cr>")
n("<leader>ds", "<cmd>lua vim.diagnostic.setloclist()<cr>")
-- }}}
-- gui {{{
local gui_font_size = 13
vim.o.guifont = "CaskaydiaCove Nerd Font:h" .. tostring(gui_font_size)
n("<c-->", function()
  gui_font_size = gui_font_size - 1
  vim.o.guifont = "CaskaydiaCove Nerd Font:h" .. tostring(gui_font_size)
end)
n("<c-=>", function()
  gui_font_size = gui_font_size + 1
  vim.o.guifont = "CaskaydiaCove Nerd Font:h" .. tostring(gui_font_size)
end)
--}}}
-- misc {{{
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
x("//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

n("<leader>I", "<Cmd>Inspect<CR>")
n("<leader>M", "<Cmd>messages<CR>")
-- FIXME: cross line ^M -> \n
n("<leader>cw", [[:%s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]])
n("<leader>cl", [[:s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]])
x("<leader>cw", [["zy:%s/<c-r><c-o>"//g<left><left>]])

n("<leader>E", "<cmd>e ~/priv/todo.md<cr>")
n("<leader>e", "<cmd>e ~/priv/" .. vim.trim(vim.fn.system "date +%m-%d", "\n") .. ".md<cr>")

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
xnoremap <silent> il :<C-U>call Textobj_line(v:count1)<CR>
onoremap <silent> il :<C-U>execute "normal! ^v".v:count1."g_"<CR>
]]
-- }}}
-- vim:foldmethod=marker
