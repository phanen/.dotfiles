vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opts = { noremap = true, silent = true }
local map = vim.keymap.set -- vim.api.nvim_set_keymap

-- disable default behavior
map({ 'n', 'v' }, '<space>', '<nop>', opts)
map({ 'n', 'v' }, '<space>f', '<nop>', opts)
-- TODO: disbale p in select mode
-- TODO: disable clipboard in x or d

-- word wrap
map('n', 'k', 'v:count == 0 ? "gk" : "k"', { expr = true, silent = true })
map('n', 'j', 'v:count == 0 ? "gj" : "j"', { expr = true, silent = true })

-- fix the cursor the middle of screen
map('n', '<c-u>', '<c-u>zz')
map('n', '<c-d>', '<c-d>zz')

-- switch tab
map('n', '<c-f>', 'gt')
map('n', '<c-b>', 'gT')

-- stay in visual mode
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)

-- better paste
map('v', 'p', '"_dp', opts)

-- windows navigation
map('n', '<c-h>', '<c-w>h', opts)
map('n', '<c-j>', '<c-w>j', opts)
map('n', '<c-k>', '<c-w>k', opts)
map('n', '<c-l>', '<c-w>l', opts)

-- windows resize
map('n', '<c-up>', ':resize -2<cr>', opts)
map('n', '<c-down>', ':resize +2<cr>', opts)
map('n', '<c-left>', ':vertical resize -2<cr>', opts)
map('n', '<c-right>', ':vertical resize +2<cr>', opts)

-- buffers nevigation
map('n', '<s-l>', ':bnext<cr>', opts)
map('n', '<s-h>', ':bprevious<cr>', opts)

-- text motion
map('n', '<a-j>', ':m .+1<cr>', opts)
map('n', '<a-k>', ':m .-2<cr>', opts)

-- toy term
map('n', '<m-t>', ':split term://bash<CR>i', opts)
map('t', '<m-t>', '<c-\\><c-n>:bdelete! %<CR>', opts)

-- diagnostic
map('n', '[d', vim.diagnostic.goto_prev, opts)
map('n', ']d', vim.diagnostic.goto_next, opts)
map('n', '<leader>df', vim.diagnostic.open_float, opts)
map('n', '<leader>ds', vim.diagnostic.setloclist, opts)


-------- shortcut --------------
-- tab new
map('n', '<leader>nt', '<cmd>tabnew<cr>', opts)

-- config
map('n', '<leader>cc', '<cmd>tabnew $XDG_CONFIG_HOME/nvim<cr>', opts)
map('n', '<leader>cs', '<cmd>source $XDG_CONFIG_HOME/nvim/init.lua<cr>', opts)

-- ls
map('n', '<leader>ls', '<cmd>ls<cr>', opts)

-- TODO
map('n', '<leader>q', '<cmd>q!<cr>', opts)
map('n', '<leader>w', '<cmd>w<cr>', opts)
map('n', '<leader>fo', '<cmd>set foldenable!<cr>', opts)

-- get img
map('n', '<leader>gi', '<cmd>UploadClipboard<cr>', opts)

-- symbol rename
vim.keymap.set('n', '<leader>rn', ':IncRename ')

-- style
-- 全角2半角
map('n', '<leader>rp', [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"'}[submatch(0)]/g<cr>]])
-- { silent = true }? ??
-- １２３４５６７ａｂｃｄｅｆｇ
--     -- :%s/[，、１２３４５６７ａｂｃｄｅｆｇ]/\={'，':', ','、':', ','１':'1','２':'2','３':'3','４':'4','５':'5','６':'6','７':'7','ａ':'a', 'ｂ':'b', 'ｃ':'c', 'ｄ':'d', 'ｅ':'e', 'ｆ':'f', 'ｇ':'g'}[submatch(0)]/g

-- math mode bracket
map('v', '<leader>mb', [[
        <cmd>'<,'>s/[{}]/\={'{':'\{', '}':'\}'}[submatch(0)]/g<cr>]])
-- 清除行尾空格
map('n', '<leader>rs', '<cmd>%s/\\s*$//g<cr>')
-- 清除行首空格
map('n', '<leader>rh', '<cmd>%s/\\s*$//g<cr>')
-- 清除空行
map('n', '<leader>rl', '<cmd>g/^$/d<cr>')

-- switch theme
map('n', '<leader>cl', ':colorscheme ')
