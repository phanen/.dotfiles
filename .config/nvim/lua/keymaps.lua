local kmp = require('utils.keymaps')

local map = kmp.map
local nmap = kmp.nmap
local imap = kmp.imap
local cmap = kmp.cmap
local vmap = kmp.vmap
local xmap = kmp.xmap
local omap = kmp.omap
local tmap = kmp.tmap
local lmap = kmp.lmap

-- disable some default behaviors
-- TODO: disbale p in select mode
-- TODO: disable clipboard in x or d
map({ 'n', 'v', 'i' }, '<left>', '<nop>')
map({ 'n', 'v', 'i' }, '<right>', '<nop>')
map({ 'n', 'v', 'i' }, '<up>', '<nop>')
map({ 'n', 'v', 'i' }, '<down>', '<nop>')
map({ 'n', 'v' }, '<space>', '<nop>')

nmap('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
nmap('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

nmap('<c-u>', '<c-u>zz')
nmap('<c-d>', '<c-d>zz')

vmap('<', '<gv')
vmap('>', '>gv')
vmap(',', '<gv')
vmap('.', '>gv')

vmap('p', '"_dp')

nmap('<a-j>', ':m .+1<cr>')
nmap('<a-k>', ':m .-2<cr>')

-- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cmap('w!!', 'w !sudo tee > /dev/null')

vmap('d', '"_d')
vmap('c', '"_c')
nmap('c', '"_c')
nmap('d', '"_d')
nmap('C', '"_C')
nmap('D', '"_D')
nmap('X', 'D')

nmap('<leader>z', '<Plug>(comment_toggle_linewise_count)')
-- nnoremap('<leader>C', '<cmd>edit $XDG_CONFIG_HOME/nvim<cr>')

-- navigation
nmap('<c-f>', '<cmd>BufferLineCycleNext<cr>')
nmap('<c-b>', '<cmd>BufferLineCyclePrev<cr>')

nmap('<c-j>', '<cmd>wincmd w<cr>')
nmap('<c-k>', '<cmd>wincmd W<cr>')

nmap('<c-h>', 'g^')
nmap('<c-l>', 'g$')
vmap('<c-h>', 'g^')
vmap('<c-l>', 'g$')

nmap('<leader>tn', '<cmd>tabnew<cr>')

-- layout
nmap('<c-up>', '<cmd>resize -2<cr>')
nmap('<c-down>', '<cmd>resize +2<cr>')
nmap('<c-left>', '<cmd>vertical resize -2<cr>')
nmap('<c-right>', '<cmd>vertical resize +2<cr>')

-- get img
nmap('<leader>gi', '<cmd>UploadClipboard<cr>')

-- symbol rename
nmap('<leader>rn', ':IncRename ')

-- subtitution
-- TODO refactor in lua
nmap('<leader>rp', require('utils').get_full2half_vimcmd())
nmap('<leader>rs', '<cmd>%s/\\s*$//g<cr>\'\'', { desc = 'clean tail space'})
nmap('<leader>rl', '<cmd>g/^$/d<cr>\'\'', { desc = 'clean the blank line'})
-- TODO (complete comment char)
nmap('<leader>rc', '<cmd>g/^#/d<cr>\'\'', { desc = 'clean the comment line'})
vmap('<leader>rk', [[<cmd>'<,'>s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
vmap('<leader>r,', [[<cmd>'<,'>s/,\([^ ]\)/, \1/g<cr>]])

-- how to quit in vim
nmap('<leader>q', '<cmd>Bdelete!<cr>')
nmap('<localleader>w', '<cmd>write<cr>')
imap('<c-q>', '<cmd>bdelete!<cr>')
imap('<c-s>', '<cmd>write<cr>')

-- toggle windows
nmap('<leader>wn', '<cmd>NvimTreeFindFileToggle<cr>')
nmap('<leader>h', '<cmd>NvimTreeFindFileToggle<cr>')
nmap('<leader>wo', '<cmd>AerialToggle<cr>')
nmap('<leader>l', '<cmd>AerialToggle<cr>')
nmap('<leader>wm', '<cmd>MarkdownPreview<cr>')
nmap('<leader>wl', '<cmd>Lazy<cr>')
nmap('<leader>wf', '<cmd>Navbuddy<cr>')

-- toggle options
nmap('<leader>of', '<cmd>set foldenable!<cr>')
nmap('<leader>os', '<cmd>set spell!<cr>')
nmap('<leader>on', function()
    if string.match(vim.o.nrformats, 'alpha') then
        vim.cmd [[set nrformats-=alpha]]
    else
        vim.cmd [[set nrformats+=alpha]]
    end
end, { desc = 'toggle nrformats'})

nmap('<leader>oj', '<cmd>wincmd _<cr>')
nmap('<leader>ok', '<cmd>wincmd =<cr>')
nmap('<leader>ob', require('utils.themes').toggle_bg, { desc = 'toggle background'} )
nmap('<leader><tab>', require('utils').next_colorscheme, { desc = 'switch colorscheme'})
nmap('<leader>ls', '<cmd>ls!<cr>')

-- term
nmap('<m-t>', ':split term://bash<cr>i')
tmap('<c-q>', '<c-\\><c-n>')
tmap('<m-t>', '<c-\\><c-n>:bdelete! %<cr>')
-- tnoremap('<c-;>', '<cmd>ToggleTerm<cr>') -- unusable in vim

-- diagnostic
nmap('[d', vim.diagnostic.goto_prev)
nmap(']d', vim.diagnostic.goto_next)
nmap('<leader>df', vim.diagnostic.open_float)
nmap('<leader>ds', vim.diagnostic.setloclist)


-- search
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text
-- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
vmap('//', [[y/\V<C-R>=escape(@",'/\')<CR><CR>]])
