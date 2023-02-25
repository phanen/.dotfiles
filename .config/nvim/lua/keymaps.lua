
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set -- vim.api.nvim_set_keymap

-- disable default behavior of leader
keymap({ 'n', 'v' }, '<space>', '<nop>', { silent = true })
-- TODO: disbale p in select mode
-- keymap({'s'}, 'p', )

-- word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- fix the cursor the middle of screen
keymap('n', '<c-u>', '<c-u>zz')
keymap('n', '<c-d>', '<c-d>zz')

-- switch tab
keymap('n', '<c-f>', 'gt')
keymap('n', '<c-b>', 'gT')

-- stay in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- better paste
keymap("v", "p", '"_dp', opts)

-- swap <c-r> and <s-r>
-- keymap("n", "r", "<c-r>")
-- keymap("n", "<c-r>", "r")

-- add readline mode
local readline = require 'readline'

-- kill line
keymap('!', '<c-k>', readline.kill_line)
keymap('!', '<c-u>', readline.backward_kill_line)

-- kill word
keymap('!', '<m-d>', readline.kill_word)
keymap('!', '<c-q>', readline.backward_kill_word)
-- keymap('!', '<c-w>', readline.unix_word_rubout)

-- kill char
-- keymap('!', '<c-h>', '<bs>')
-- keymap('!', '<c-d>', '<delete>')

-- motion
keymap('!', '<c-a>', readline.beginning_of_line)
keymap('!', '<c-e>', readline.end_of_line)
keymap('!', '<m-f>', readline.forward_word)
keymap('!', '<m-b>', readline.backward_word)
keymap('!', '<c-f>', '<right>')
keymap('!', '<c-b>', '<left>')
keymap('!', '<c-n>', '<down>')
keymap('!', '<c-p>', '<up>')

-- windows navigation
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

-- windows resize
keymap("n", "<c-up>", ":resize -2<cr>", opts)
keymap("n", "<c-down>", ":resize +2<cr>", opts)
keymap("n", "<c-left>", ":vertical resize -2<cr>", opts)
keymap("n", "<c-right>", ":vertical resize +2<cr>", opts)

-- buffers nevigation
keymap("n", "<s-l>", ":bnext<cr>", opts)
keymap("n", "<s-h>", ":bprevious<cr>", opts)

-- text motion
keymap("n", "<a-j>", ":m .+1<cr>", opts)
keymap("n", "<a-k>", ":m .-2<cr>", opts)

keymap("n", "<a-j>", ":m .+1<cr>", opts)
keymap("n", "<a-k>", ":m .-2<cr>", opts)

keymap("n", "<f2>", "<cmd>NvimTreeToggle<cr>", opts)
keymap("n", "<f3>", "<cmd>AerialToggle<cr>", opts)
keymap("n", "<f4>", "<cmd>MarkdownPreview<cr>", opts)

-- -- toy term
-- keymap("n", "<m-t>", ":split term://bash<CR>i", opts)
-- keymap("t", "<m-t>", "<c-\\><c-n>:bdelete! %<CR>", opts)

-- advanced term
require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    start_in_insert = true,
    direction = 'horizontal'
})

local Term = require("toggleterm.terminal").Terminal
local pyterm = Term:new({
    cmd = 'python',
    directon = 'horizontal',
})

keymap("t", "<esc>", "<c-\\><c-n>", opts)
keymap("n", "<leader>tt",  "<c-\\>", { noremap = true, silent = true })
keymap("n", "<leader>tp", function() pyterm:toggle() end, opts)

-- diagnostic
keymap('n', '[d', vim.diagnostic.goto_prev, opts)
keymap('n', ']d', vim.diagnostic.goto_next, opts)
keymap('n', '<leader>df', vim.diagnostic.open_float, opts)
keymap('n', '<leader>ds', vim.diagnostic.setloclist, opts)


-------- shortcut --------------
-- tab new
keymap("n", "<leader>nt", "<cmd>tabnew<cr>", opts)

-- config
keymap("n", "<leader>cc", "<cmd>tabnew $XDG_CONFIG_HOME/nvim<cr>", opts)
keymap("n", "<leader>cs", "<cmd>source $XDG_CONFIG_HOME/nvim/init.lua<cr>", opts)

-- ls
keymap("n", "<leader>ls", "<cmd>ls<cr>", opts)

-- TODO
keymap('n', '<leader>q', '<cmd>q!<cr>', opts)
keymap('n', '<leader>w', '<cmd>w<cr>', opts)
keymap('n', '<leader>fo', '<cmd>set foldenable!<cr>', opts)

-- get img
keymap('n', '<leader>gi', '<cmd>UploadClipboard<cr>', opts)

-- symbol rename
vim.keymap.set("n", "<leader>rn", ":IncRename ")
-- 全角2半角
keymap('n', '<leader>rp', [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. '}[submatch(0)]/g<cr>]])
-- math mode bracket
keymap('v', '<leader>mb', [[
        <cmd>'<,'>s/[{}]/\={'{':'\{', '}':'\}'}[submatch(0)]/g<cr>]])

-- { silent = true }? ??
-- １２３４５６７ａｂｃｄｅｆｇ
--     -- :%s/[，、１２３４５６７ａｂｃｄｅｆｇ]/\={'，':', ','、':', ','１':'1','２':'2','３':'3','４':'4','５':'5','６':'6','７':'7','ａ':'a', 'ｂ':'b', 'ｃ':'c', 'ｄ':'d', 'ｅ':'e', 'ｆ':'f', 'ｇ':'g'}[submatch(0)]/g
