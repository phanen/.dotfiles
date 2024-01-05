local n = function(...) map("n", ...) end
local x = function(...) map("x", ...) end
local t = function(...) map("t", ...) end
local o = function(...) map("o", ...) end

-- basics {{{
n("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
n("j", 'v:count == 0 ? "gj" : "j"', { expr = true })
x("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
x("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

n("gj", '"gyy"gp')
x("gj", '"gy\'>"gp')
n("$", "g_")
x("$", "g_")
n("gw", "gg=G``")

n("<c-u>", "<c-u>zz")
n("<c-d>", "<c-d>zz")

n("<c-d>", "<c-d>zz")

x("p", "P")
n("d", '"_d')
x("d", '"_d')
n("D", '"_D')
n("c", '"_c')
x("c", '"_c')
n("C", '"_C')

n("<leader>P", "<cmd>%d _<cr><cmd>norm P<cr>")
n("<leader>y", "<cmd>%y<cr>")

n("<a-j>", "<cmd>move+<cr>")
n("<a-k>", "<cmd>move-2<cr>")
x("<a-j>", ":move '>+1<cr>gv=gv")
x("<a-k>", ":move '<-2<cr>gv=gv")

n("<", "<<")
n(">", ">>")
n("<a-h>", "<<")
n("<a-l>", ">>")
x("<a-h>", "<gv")
x("<a-l>", ">gv")

t("<c-space>", "<c-\\><c-n>")

local toggle_qf = function()
  local wins = vim.fn.getwininfo()
  local qf_win = vim.iter(wins):filter(function(win) return win.quickfix == 1 end):totable()
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
n("<leader>cb", "<cmd>Popd<cr>")
-- }}}
-- buffer {{{
n("<c-f>", "<cmd>BufferLineCycleNext<cr>")
n("<c-e>", "<cmd>BufferLineCyclePrev<cr>")
n("<c-w>", "<cmd>Bdelete!<cr>")
n("<leader>bo", [[<cmd>w <bar> %bd <bar> e#<cr>]], { desc = "close all other buffers" })
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
n("<leader>rs", "<cmd>%s/\\s*$//g<cr>''", { desc = "clean tail space" })
n("<leader>rl", ":g/^$/d<cr>''", { desc = "clean the blank line" })
x("<leader>rl", ":g/^$/d<cr>''", { desc = "clean the blank line" })

-- TODO: genearlize comment string
-- TODO: detect comment text area
-- nmap("<leader>rc", "<cmd>g/^#/d<cr>''", { desc = "clean the comment line" })
n("<leader>rc", [[<cmd>%s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
x("<leader>rc", [[:s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })

x("<leader>rk", [[:s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
x("<leader>r,", [[:s/,\([^ ]\)/, \1/g<cr>]])
x("<leader>rn", [[:s/^\([0-9]\.\)\([^ ]\)/\1 \2/g<cr>]])
x("<leader>rd", [[:'<,'>s/0x[0-9a-fA-F]\+/\=str2nr(submatch(0), 16)<cr>]])
x("<leader>rh", [[:'<,'>s/\d\+/\=printf("0x%04x", submatch(0))<cr>]])
x("<leader>rm", [[:s/\s\{1,}//g<cr>]])
-- }}}
-- toggle {{{
-- windows
n("<leader>k", "<cmd>NvimTreeFindFileToggle<cr>")
n("<leader>wo", "<cmd>AerialToggle<cr>")
n("<leader>a", "<cmd>AerialToggle<cr>")
n("<leader>wl", "<cmd>Lazy<cr>")
n("<leader>wj", "<cmd>Navbuddy<cr>")
n("<leader>wi", "<cmd>LspInfo<cr>")
n("<leader>wu", "<cmd>NullLsInfo<cr>")
n("<leader>wy", "<cmd>Mason<cr>")
-- options
n("<leader>oc", "<cmd>set cursorline! cursorcolumn!<cr>")
n("<leader>of", "<cmd>set foldenable!<cr>")
n("<leader>os", "<cmd>set spell!<cr>")
n("<leader>on", function()
  if string.match(vim.o.nrformats, "alpha") then
    vim.cmd [[set nrformats-=alpha]]
  else
    vim.cmd [[set nrformats+=alpha]]
  end
end, { desc = "toggle nrformats" })
-- TODO: make it a real toggle
n("<leader>ow", function() vim.cmd [[set wrap!]] end)
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

-- vim:foldmethod=marker
