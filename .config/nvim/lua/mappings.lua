-- `:h map-table`
local nmap = function(...) map("n", ...) end
local xmap = function(...) map("x", ...) end
local tmap = function(...) map("t", ...) end
local vmap = function(...) map("v", ...) end

local f = require "utils.keymap"

-- basics {{{
map({ "n", "x" }, "<space>", "<nop>")

nmap("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nmap("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

nmap("gj", "yyp")
nmap("gk", "yyP")
map({ "n", "x", "o" }, "ga", "G")
-- nmap("<leader>j", "yyp")

nmap("<c-u>", "<c-u>zz")
nmap("<c-d>", "<c-d>zz")

xmap("p", '"_dp')
nmap("d", '"_d')
xmap("d", '"_d')
nmap("D", '"_D')
nmap("c", '"_c')
xmap("c", '"_c')
nmap("C", '"_C')
nmap("X", "D")

nmap("<leader>V", "ggVG")
nmap("<leader>P", 'ggVG"_dp')
nmap("<leader>Y", "ggVGy")

nmap("<a-j>", "<cmd>move+<cr>")
nmap("<a-k>", "<cmd>move-2<cr>")
xmap("<a-j>", ":move '>+1<cr>gv=gv")
xmap("<a-k>", ":move '<-2<cr>gv=gv")

nmap("<a-h>", "<<")
nmap("<a-l>", ">>")
xmap("<a-h>", "<gv")
xmap("<a-l>", ">gv")

map({ "n", "x" }, "_", "5j")
map({ "n", "x" }, "-", "5k")

-- map({ "n", "v", "o" }, "^", "g^")
-- map({ "n", "v", "o" }, "$", "g$")

nmap("vv", "viw")
nmap("cc", "ciw")

-- nmap("<c-q>", "<c-u>")
-- nmap("<a-s>", "<c-o>")
-- nmap("<a-d>", "<c-i>")
-- TODO: since kmonad cannot handle mouse event now...
-- nmap("<a-w>", "gd")
-- }}}

-- buffer {{{
map({ "n", "v", "o" }, "<c-f>", "<cmd>BufferLineCycleNext<cr>")
map({ "n", "v", "o" }, "<c-e>", "<cmd>BufferLineCyclePrev<cr>")
nmap("<c-w>", "<cmd>Bdelete!<cr>")
-- }}}

-- window {{{
nmap("<c-s><c-s>", "<cmd>wincmd q<cr>")

nmap("<leader>oj", "<cmd>wincmd _<cr>")
nmap("<leader>ok", "<cmd>wincmd =<cr>")

nmap("<c-s>v", "<cmd>wincmd v<cr>")
nmap("<c-s>s", "<cmd>wincmd s<cr>")

nmap("<c-j>", "<cmd>wincmd w<cr>")
nmap("<c-k>", "<cmd>wincmd W<cr>")
-- nmap("<d-s-k>", "<cmd>resize -2<cr>")
-- nmap("<d-s-j>", "<cmd>resize +2<cr>")
-- nmap("<d-s-h>", "<cmd>vertical resize -2<cr>")
-- nmap("<d-s-l>", "<cmd>vertical resize +2<cr>")
-- }}}

-- subtitution {{{
nmap(
  "<leader>rp",
  [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：　]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"', '　':'  '}[submatch(0)]/g<cr>
    ]],
  { desc = "half to full" }
)
nmap("<leader>rs", "<cmd>%s/\\s*$//g<cr>''", { desc = "clean tail space" })
nmap("<leader>rl", "<cmd>g/^$/d<cr>''", { desc = "clean the blank line" })
xmap("<leader>rl", ":g/^$/d<cr>''", { desc = "clean the blank line" })

-- TODO: genearlize comment string
-- TODO: detect comment text area
-- nmap("<leader>rc", "<cmd>g/^#/d<cr>''", { desc = "clean the comment line" })
nmap("<leader>rc", [[<cmd>%s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })
xmap("<leader>rc", [[:s/ *\/\/.*//g<cr>'']], { desc = "clean the comment line" })

xmap("<leader>rk", [[:s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
xmap("<leader>r,", [[:s/,\([^ ]\)/, \1/g<cr>]])

-- no.-> no.space
xmap("<leader>rn", [[:s/^\([0-9]\.\)\([^ ]\)/\1 \2/g<cr>]])
-- TODO: smart remove in-text whitespace
-- :%s/\([^ ]\+ \) \+/\1/g

-- remove all comment string/line?
-- "%s/ *\/\/.*//g"

-- hex to dec
xmap("<leader>ro", [[:'<,'>s/0x[0-9a-fA-F]\+/\=str2nr(submatch(0), 16)<cr>]])
-- dec to hex
xmap("<leader>rh", [[:'<,'>s/\d\+/\=printf("0x%04x", submatch(0))<cr>]])

xmap("<leader>rm", [[:s/\s\{1,}//g<cr>]])

nmap("<leader>rU", [[:s/\v<(.)(\w*)/\u\1\L\2/g<cr>]])
xmap("<leader>rU", [[:s/\v<(.)(\w*)/\u\1\L\2/g<cr>]])
-- }}}

-- toggle windows {{{
nmap("<leader>k", "<cmd>NvimTreeFindFileToggle<cr>")
nmap("<leader>wo", "<cmd>AerialToggle<cr>")
nmap("<leader>wl", "<cmd>Lazy<cr>")
nmap("<leader>wj", "<cmd>Navbuddy<cr>")
nmap("<leader>wi", "<cmd>LspInfo<cr>")
nmap("<leader>wu", "<cmd>NullLsInfo<cr>")
nmap("<leader>wy", "<cmd>Mason<cr>")
-- }}}

-- toggle options {{{
nmap("<leader>oc", "<cmd>set cursorline! cursorcolumn!<cr>")
nmap("<leader>of", "<cmd>set foldenable!<cr>")
nmap("<leader>os", "<cmd>set spell!<cr>")
nmap("<leader>on", function()
  if string.match(vim.o.nrformats, "alpha") then
    vim.cmd [[set nrformats-=alpha]]
  else
    vim.cmd [[set nrformats+=alpha]]
  end
end, { desc = "toggle nrformats" })
nmap("<leader>ob", f.toggle_bg, { desc = "toggle background" })
-- nmap("<leader><tab>", f.next_colorscheme, { desc = "switch colorscheme" })
-- TODO: make it a real toggle
nmap("<leader>oJ", function() vim.cmd [[noremap J gJ]] end, { desc = "toggle join mode" })
nmap("<leader>ow", function() vim.cmd [[set wrap!]] end)
-- }}}

-- term {{{
-- nmap("<a-t>", ":split term://zsh<cr>i")
tmap("<c-space>", "<c-\\><c-n>")
-- tmap("<a-t>", "<c-\\><c-n>:bdelete! %<cr>")
-- }}}

-- diagnostic {{{
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)
nmap("<leader>df", vim.diagnostic.open_float, { desc = "diagnostic: open floating window" })
nmap("<leader>ds", vim.diagnostic.setloclist, { desc = "diagnostic: open quickfix list" })
-- }}}

-- miscs {{{
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
xmap("//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

nmap("<leader>t,", f.toggle_last_char ",", { desc = "add ',' to end of line" })
nmap("<leader>t;", f.toggle_last_char ";", { desc = "add ';' to end of line" })

nmap("<leader>E", "<Cmd>Inspect<CR>", { desc = "Inspect the cursor position" })

-- FIXME: pos
nmap("<leader>bo", [[<cmd>w <bar> %bd <bar> e#<cr>]], { desc = "close all other buffers" })
-- nmap("<localleader><tab>", [[:b <tab>]], { silent = false, desc = "open buffer list" })

nmap("<leader>U", "gUiw", { desc = "capitalize word" })
nmap("<c-w>f", "<c-w>vgf", { desc = "open file in vertical split" })

-- FIXME: cross line ^M -> \n
nmap("<leader>cw", [[:%s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (file)",
})
nmap("<leader>cl", [[:s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (line)",
})
xmap("<leader>cw", [["zy:%s/<c-r><c-o>"//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (visual)",
})

nmap("<c-p>", "I- <esc>")
xmap("<c-p>", "I- <esc>")

-- HACK: wordaround for batch comment toggle
nmap("<leader><c-_>", function()
  -- if in_commet
  vim.cmd "norm vic"
end)

-- https://stackoverflow.com/questions/1680194/reverse-a-word-in-vim
vim.cmd [[
vnoremap <silent> <Leader>is :<C-U>let old_reg_a=@a<CR>
 \:let old_reg=@"<CR>
 \gv"ay
 \:let @a=substitute(@a, '.\(.*\)\@=',
 \ '\=@a[strlen(submatch(1))]', 'g')<CR>
 \gvc<C-R>a<Esc>
 \:let @a=old_reg_a<CR>
 \:let @"=old_reg<CR>
]]

nmap("<leader>cd", "<cmd>cd %:h<cr>")
nmap("<leader>cb", "<cmd>cd %:h/..<cr>")

-- neovide: resize gui font
-- BUG: firenvim window size auto change
-- https://github.com/glacambre/firenvim/issues/800
-- https://github.com/glacambre/firenvim/issues/1006
local fsize = require("options").gui_font_size
nmap("<c-->", function()
  fsize = fsize - 1
  vim.o.guifont = "CaskaydiaCove Nerd Font:h" .. tostring(fsize)
end)
nmap("<c-=>", function()
  fsize = fsize + 1
  vim.o.guifont = "CaskaydiaCove Nerd Font:h" .. tostring(fsize)
end)
-- }}}

-- readline {{{
-- Insert mode
-- imap('<c-a>', '<c-o>^')
-- imap('<c-e>', '<c-o>$')
-- imap('<c-b>', '<esc>i')
-- imap('<c-k>', '<c-o>c')
-- cmap('<c-a>', '<home>')
-- cmap('<c-e>', '<end>')
-- }}}

-- vim:foldmethod=marker
