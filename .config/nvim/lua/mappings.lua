-- local map = vim.keymap.set

local recursive_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.remap = true
  map(mode, lhs, rhs, opts)
end

-- `:h map-table`
local nremap = function(...) recursive_map("n", ...) end
local iremap = function(...) recursive_map("i", ...) end
local nmap = function(...) map("n", ...) end
local imap = function(...) map("i", ...) end
local cmap = function(...) map("c", ...) end
local vmap = function(...) map("v", ...) end
local xmap = function(...) map("x", ...) end
local omap = function(...) map("o", ...) end
local tmap = function(...) map("t", ...) end
local lmap = function(...) map("l", ...) end

local ac = require "utils.actions"

map({ "n", "v", "o" }, "<space>", "<nop>")

nmap("k", 'v:count == 0 ? "gk" : "k"', { expr = true })
nmap("j", 'v:count == 0 ? "gj" : "j"', { expr = true })

nmap("<c-u>", "<c-u>zz")
nmap("<c-d>", "<c-d>zz")

xmap("<", "<gv")
xmap(">", ">gv")
xmap(",", "<gv")
xmap(".", ">gv")

xmap("p", '"_dp')

nmap("<s-tab>", "vil")
-- nmap("<a-k>", ":m .-2<cr>")
-- nmap("<a-j>", ":m .+1<cr>")
-- nmap('<a-k>', '<cmd>move-2<CR>==')
-- nmap('<a-j>', '<cmd>move+<CR>==')
-- xmap('<a-k>', ":move-2<CR>='[gv", { silent = true })
-- xmap('<a-j>', ":move'>+<CR>='[gv", { silent = true })

-- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap("w!!", "w !sudo tee > /dev/null")

xmap("d", '"_d')
xmap("c", '"_c')
nmap("c", '"_c')
nmap("d", '"_d')
nmap("C", '"_C')
nmap("D", '"_D')
nmap("X", "D")

nmap("<leader>z", "<Plug>(comment_toggle_linewise_count)")

-- navigation
map({ "n", "v", "o" }, "<c-f>", "<cmd>BufferLineCycleNext<cr>")
map({ "n", "v", "o" }, "<c-h>", "<cmd>BufferLineCyclePrev<cr>")
-- map({ "n", "v", "o" }, "<c-b>", "<cmd>BufferLineCyclePrev<cr>")

-- how to quit in vim
nmap("<c-e>", "<cmd>Bdelete!<cr>")
nmap("<leader>q", "<cmd>wincmd q<cr>")
nmap("<localleader>w", "<cmd>write<cr>")
imap("<c-q>", "<cmd>Bdelete!<cr>")
imap("<c-s>", "<cmd>write<cr>")

-- map({ "n", "v", "o" }, "<a-j>", "<cmd>BufferLineCycleNext<cr>")
-- map({ "n", "v", "o" }, "<a-k>", "<cmd>BufferLineCyclePrev<cr>")

nmap("<a-k>", "<cmd>move-2<CR>==")
nmap("<a-j>", "<cmd>move+<CR>==")
xmap("<a-k>", "<cmd>move-2<cr>='[gv", { silent = true })
xmap("<a-j>", "<cmd>move'>+<cr>='[gv", { silent = true })

nmap("<c-j>", "<cmd>wincmd w<cr>")
nmap("<c-k>", "<cmd>wincmd W<cr>")

nmap("<c-s>", [[<c-^>]])

map({ "n", "v", "o" }, "H", "g^")
map({ "n", "v", "o" }, "L", "g$")

nmap("<c-s-k>", "<cmd>resize -2<cr>")
nmap("<c-s-j>", "<cmd>resize +2<cr>")
nmap("<c-s-h>", "<cmd>vertical resize -2<cr>")
nmap("<c-s-l>", "<cmd>vertical resize +2<cr>")

-- symbol rename
nmap("<leader>rn", ":IncRename ")

-- subtitution
nmap(
  "<leader>rp",
  [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：　]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"', '　':'  '}[submatch(0)]/g<cr>
    ]],
  { desc = "half to full" }
)
nmap("<leader>rs", "<cmd>%s/\\s*$//g<cr>''", { desc = "clean tail space" })
nmap("<leader>rl", "<cmd>g/^$/d<cr>''", { desc = "clean the blank line" })
vmap("<leader>rl", ":g/^$/d<cr>''", { desc = "clean the blank line" })
-- TODO (complete comment char)
nmap("<leader>rc", "<cmd>g/^#/d<cr>''", { desc = "clean the comment line" })

vmap("<leader>rk", [[:s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
vmap("<leader>r,", [[:s/,\([^ ]\)/, \1/g<cr>]])
-- no.-> no.space
vmap("<leader>rn", [[:s/^\([0-9]\.\)\([^ ]\)/\1 \2/g<cr>]])
-- TODO: smart remove in-text whitespace
-- :%s/\([^ ]\+ \) \+/\1/g

-- hex to dec
vmap("<leader>ro", [[:'<,'>s/0x[0-9a-fA-F]\+/\=str2nr(submatch(0), 16)<cr>]])
-- dec to hex
vmap("<leader>rh", [[:'<,'>s/\d\+/\=printf("0x%04x", submatch(0))<cr>]])

vmap("<leader>rm", [[:s/\s\{1,}//g<cr>]])

nmap("<leader>rU", [[:s/\v<(.)(\w*)/\u\1\L\2/g<cr>]])
vmap("<leader>rU", [[:s/\v<(.)(\w*)/\u\1\L\2/g<cr>]])

-- toggle windows
nmap("<leader>wn", "<cmd>NvimTreeFindFileToggle<cr>")
nmap("<leader>k", "<cmd>NvimTreeFindFileToggle<cr>")
nmap("<leader>wo", "<cmd>AerialToggle<cr>")
nmap("<leader>wm", "<cmd>MarkdownPreview<cr>")
nmap("<leader>wl", "<cmd>Lazy<cr>")
nmap("<leader>wj", "<cmd>Navbuddy<cr>")
nmap("<leader>wi", "<cmd>LspInfo<cr>")
nmap("<leader>wu", "<cmd>NullLsInfo<cr>")
nmap("<leader>wy", "<cmd>Mason<cr>")

-- toggle options
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
nmap("<leader>ob", ac.toggle_bg, { desc = "toggle background" })
nmap("<leader><tab>", ac.next_colorscheme, { desc = "switch colorscheme" })
-- TODO: make it a real toggle
nmap("<leader>oJ", function() vim.cmd [[noremap J gJ]] end, { desc = "toggle join mode" })
nmap("<leader>ow", function() vim.cmd [[set wrap!]] end)

-- term
nmap("<a-t>", ":split term://zsh<cr>i")
tmap("<c-q>", "<c-\\><c-n>")
tmap("<a-t>", "<c-\\><c-n>:bdelete! %<cr>")
-- tnoremap('<c-;>', '<cmd>ToggleTerm<cr>') -- unusable in vim

-- diagnostic
nmap("[d", vim.diagnostic.goto_prev)
nmap("]d", vim.diagnostic.goto_next)
nmap("<leader>df", vim.diagnostic.open_float)
nmap("<leader>ds", vim.diagnostic.setloclist)

-- search
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
vmap("//", [[y/\V<c-r>=escape(@",'/\')<cr><cr>]])

-- get something
nmap("<leader>gi", "<cmd>UploadClipboard<cr>")

nmap("<leader>t,", ac.toggle_last_char ",", { desc = "add ',' to end of line" })
nmap("<leader>t;", ac.toggle_last_char ";", { desc = "add ';' to end of line" })

nmap("<leader>E", "<Cmd>Inspect<CR>", { desc = "Inspect the cursor position" })

-- FIXME: pos
nmap("<leader>bo", [[<cmd>w <bar> %bd <bar> e#<cr>]], { desc = "close all other buffers" })
nmap("<localleader><tab>", [[:b <tab>]], { silent = false, desc = "open buffer list" })

nmap("<leader>U", "gUiw`]", { desc = "capitalize word" })
nmap("<c-w>f", "<c-w>vgf", { desc = "open file in vertical split" })

-- TODO: text object?
-- FIXME: cross line ^M -> \n
nmap("<leader>cw", [[:%s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (file)",
})
nmap("<leader>cl", [[:s/\<<c-r>=expand("<cword>")<cr>\>//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (line)",
})
vmap("<leader>cw", [["zy:%s/<c-r><c-o>"//g<left><left>]], {
  silent = false,
  desc = "replace word under the cursor (visual)",
})

-- TODO: mark current char?
nmap("<c-p>", "I- <esc>")
vmap("<c-p>", "I- <esc>")

-- https://stackoverflow.com/questions/9458294/open-url-under-cursor-in-vim-with-browser
vim.cmd [[
  " nmap <silent> gx :!xdg-open <c-r><c-a>
  nnoremap <silent> gx :execute 'silent! !xdg-open ' . shellescape(expand('<cWORD>'), 1)<cr>
]]