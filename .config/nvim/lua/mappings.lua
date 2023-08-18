-- `:h map-table`
local nmap = function(...) map("n", ...) end
local cmap = function(...) map("c", ...) end
local xmap = function(...) map("x", ...) end
local tmap = function(...) map("t", ...) end

local f = require "utils.keymap"

-- basics {{{
map({ "n", "x", "o" }, "<space>", "<nop>")

-- map({ "n", "x" }, ";", ":")
-- map({ "n", "x" }, ":", ";")

nmap("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nmap("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

nmap("<c-u>", "<c-u>zz")
nmap("<c-d>", "<c-d>zz")

xmap("<", "<gv")
xmap(">", ">gv")

-- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap("w!!", "w !sudo tee > /dev/null")

xmap("p", '"_dp')
nmap("d", '"_d')
xmap("d", '"_d')
nmap("D", '"_D')
nmap("c", '"_c')
xmap("c", '"_c')
nmap("C", '"_C')
nmap("X", "D")

-- buffer switch
map({ "n", "v", "o" }, "<c-f>", "<cmd>BufferLineCycleNext<cr>")
map({ "n", "v", "o" }, "<c-h>", "<cmd>BufferLineCyclePrev<cr>")

nmap("<c-s>", "<c-u>")

nmap("<leader>V", "ggVG")
nmap("<leader>P", 'ggVG"_dp')
nmap("<leader>Y", "ggVGy")
nmap("<leader>D", "ggVDy")
nmap("<leader>T", ":Translate ")

nmap("<leader>j", "yyp")

-- how to quit in vim
nmap("<c-e>", "<cmd>Bdelete!<cr>")
nmap("<leader>q", "<cmd>wincmd q<cr>")

nmap("<a-j>", "<cmd>move+<cr>")
nmap("<a-k>", "<cmd>move-2<cr>")
xmap("<a-j>", "<cmd>move'>+<cr>='[gv", { silent = true })
xmap("<a-k>", "<cmd>move-2<cr>='[gv", { silent = true })

nmap("<a-h>", "<<")
nmap("<a-l>", ">>")
xmap("<a-h>", "<gv")
xmap("<a-l>", ">gv")
nmap("_", "5j")
xmap("_", "5j")
nmap("-", "5k")
xmap("-", "5k")

nmap("<c-j>", "<cmd>wincmd w<cr>")
nmap("<c-k>", "<cmd>wincmd W<cr>")

map({ "n", "v", "o" }, "H", "g^")
map({ "n", "v", "o" }, "L", "g$")

nmap("<c-s-k>", "<cmd>resize -2<cr>")
nmap("<c-s-j>", "<cmd>resize +2<cr>")
nmap("<c-s-h>", "<cmd>vertical resize -2<cr>")
nmap("<c-s-l>", "<cmd>vertical resize +2<cr>")
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
-- TODO (complete comment char)
nmap("<leader>rc", "<cmd>g/^#/d<cr>''", { desc = "clean the comment line" })

xmap("<leader>rk", [[:s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
xmap("<leader>r,", [[:s/,\([^ ]\)/, \1/g<cr>]])
-- no.-> no.space
xmap("<leader>rn", [[:s/^\([0-9]\.\)\([^ ]\)/\1 \2/g<cr>]])
-- TODO: smart remove in-text whitespace
-- :%s/\([^ ]\+ \) \+/\1/g

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
nmap("<leader>wm", "<cmd>MarkdownPreview<cr>")
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
nmap("<leader>oj", "<cmd>wincmd _<cr>")
nmap("<leader>ok", "<cmd>wincmd =<cr>")
nmap("<leader>ob", f.toggle_bg, { desc = "toggle background" })
nmap("<leader><tab>", f.next_colorscheme, { desc = "switch colorscheme" })
-- TODO: make it a real toggle
nmap("<leader>oJ", function() vim.cmd [[noremap J gJ]] end, { desc = "toggle join mode" })
nmap("<leader>ow", function() vim.cmd [[set wrap!]] end)
-- }}}

-- term {{{
-- nmap("<a-t>", ":split term://zsh<cr>i")
tmap("<c-s>", "<c-\\><c-n>")
tmap("<a-t>", "<c-\\><c-n>:bdelete! %<cr>")
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
nmap("<localleader><tab>", [[:b <tab>]], { silent = false, desc = "open buffer list" })

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

-- }}}

-- resize gui font
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

-- vim:foldmethod=marker
