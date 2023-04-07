local kmp = require('utils.keymaps')

local map = kmp.map
local nnoremap = kmp.nnoremap
local inoremap = kmp.inoremap
local cnoremap = kmp.cnoremap
local vnoremap = kmp.vnoremap
local xnoremap = kmp.xnoremap
local onoremap = kmp.onoremap
local tnoremap = kmp.tnoremap
local lnoremap = kmp.lnoremap

-- disable some default behaviors
-- TODO: disbale p in select mode
-- TODO: disable clipboard in x or d
map({ 'n', 'v', 'i' }, '<left>', '<nop>')
map({ 'n', 'v', 'i' }, '<right>', '<nop>')
map({ 'n', 'v', 'i' }, '<up>', '<nop>')
map({ 'n', 'v', 'i' }, '<down>', '<nop>')
map({ 'n', 'v' }, '<space>', '<nop>')
map({ 'n', 'v' }, '<space>f', '<nop>')

nnoremap('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
nnoremap('j', 'v:count == 0 ? "gj" : "j"', { expr = true })
nnoremap('<c-u>', '<c-u>zz')
nnoremap('<c-d>', '<c-d>zz')
vnoremap('<', '<gv')
vnoremap('>', '>gv')
vnoremap('p', '"_dp')

-- word wrap

-- text motion
nnoremap('<a-j>', ':m .+1<cr>')
nnoremap('<a-k>', ':m .-2<cr>')

-- config
nnoremap('<leader>cc', '<cmd>tabnew $XDG_CONFIG_HOME/nvim<cr>')
nnoremap('<leader>cs', '<cmd>source $XDG_CONFIG_HOME/nvim/init.lua<cr>')


-- switch buffers
nnoremap('<c-f>', '<cmd>BufferLineCycleNext<cr>')
nnoremap('<c-b>', '<cmd>BufferLineCyclePrev<cr>')

-- switch windows
nnoremap('<c-h>', '<cmd>wincmd h<cr>')
nnoremap('<c-j>', '<cmd>wincmd j<cr>')
nnoremap('<c-k>', '<cmd>wincmd k<cr>')
nnoremap('<c-l>', '<cmd>wincmd l<cr>')

-- resize windows
nnoremap('<c-up>', '<cmd>resize -2<cr>')
nnoremap('<c-down>', '<cmd>resize +2<cr>')
nnoremap('<c-left>', '<cmd>vertical resize -2<cr>')
nnoremap('<c-right>', '<cmd>vertical resize +2<cr>')

-- tab new
nnoremap('<leader>tn', '<cmd>tabnew<cr>')

-- ls
nnoremap('<leader>ls', '<cmd>ls<cr>')

-- get img
nnoremap('<leader>gi', '<cmd>UploadClipboard<cr>')

-- symbol rename
vim.keymap.set('n', '<leader>rn', ':IncRename ')

-- style
-- 全角2半角
-- TODO refactor in lua
nnoremap('<leader>rp', require('utils').get_full2half_vimcmd())
nnoremap('<leader>rs', '<cmd>%s/\\s*$//g<cr>', { desc = 'clean head space'})
nnoremap('<leader>rh', '<cmd>g/^$/d<cr>', { desc = 'clean tail space'})
nnoremap('<leader>rs', '<cmd>%s/\\s*$//g<cr>', { desc = 'swap quote make'})

-- diagnostic
nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)
nnoremap('<leader>df', vim.diagnostic.open_float)
nnoremap('<leader>ds', vim.diagnostic.setloclist)

-- toggle windows
nnoremap('<leader>q', '<cmd>bdelete!<cr>')
nnoremap('<localleader>q', '<cmd>wincmd q<cr>')
nnoremap('<localleader>  ', '<cmd>w<cr>')

nnoremap('<leader>wr', '<cmd>NvimTreeToggle<cr>')
nnoremap('<leader>wn', '<cmd>NvimTreeToggle<cr>')
nnoremap('<leader>wa', '<cmd>AerialToggle<cr>')
nnoremap('<leader>wm', '<cmd>MarkdownPreview<cr>')

-- toggle options
nnoremap('<leader>of', '<cmd>set foldenable!<cr>')
nnoremap('<leader>ob', require('utils.themes').toggle_bg, { desc = 'toggle background'} )
nnoremap('<leader><tab>', require('utils').next_colorscheme, { desc = 'switch colorscheme'})

-- toy term
nnoremap('<m-t>', ':split term://bash<CR>i')
tnoremap('<esc>', '<c-\\><c-n>')
tnoremap('<m-t>', '<c-\\><c-n>:bdelete! %<CR>')
