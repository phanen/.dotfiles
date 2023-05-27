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

nnoremap('k', 'v:count == 0 ? "gk" : "k"', { expr = true })
nnoremap('j', 'v:count == 0 ? "gj" : "j"', { expr = true })

nnoremap('<c-u>', '<c-u>zz')
nnoremap('<c-d>', '<c-d>zz')

vnoremap('<', '<gv')
vnoremap('>', '>gv')
vnoremap(',', '<gv')
vnoremap('.', '>gv')

vnoremap('p', '"_dp')

nnoremap('<a-j>', ':m .+1<cr>')
nnoremap('<a-k>', ':m .-2<cr>')

-- https://stackoverflow.com/questions/2600783/how-does-the-vim-write-with-sudo-trick-work
cnoremap('w!!', 'w !sudo tee > /dev/null')

vnoremap('d', '"_d')
vnoremap('c', '"_c')
nnoremap('c', '"_c')
nnoremap('d', '"_d')
nnoremap('C', '"_C')
nnoremap('D', '"_D')
nnoremap('X', 'D')

nnoremap('<leader>z', '<Plug>(comment_toggle_linewise_count)')
-- nnoremap('<leader>C', '<cmd>edit $XDG_CONFIG_HOME/nvim<cr>')

-- navigation
nnoremap('<c-f>', '<cmd>BufferLineCycleNext<cr>')
nnoremap('<c-b>', '<cmd>BufferLineCyclePrev<cr>')

nnoremap('<c-j>', '<cmd>wincmd w<cr>')
nnoremap('<c-k>', '<cmd>wincmd W<cr>')

nnoremap('<c-h>', 'g^')
nnoremap('<c-l>', 'g$')
vnoremap('<c-h>', 'g^')
vnoremap('<c-l>', 'g$')

nnoremap('<leader>tn', '<cmd>tabnew<cr>')

-- layout
nnoremap('<c-up>', '<cmd>resize -2<cr>')
nnoremap('<c-down>', '<cmd>resize +2<cr>')
nnoremap('<c-left>', '<cmd>vertical resize -2<cr>')
nnoremap('<c-right>', '<cmd>vertical resize +2<cr>')

-- get img
nnoremap('<leader>gi', '<cmd>UploadClipboard<cr>')

-- symbol rename
nnoremap('<leader>rn', ':IncRename ')

-- subtitution
-- TODO refactor in lua
nnoremap('<leader>rp', require('utils').get_full2half_vimcmd())
nnoremap('<leader>rs', '<cmd>%s/\\s*$//g<cr>\'\'', { desc = 'clean tail space'})
nnoremap('<leader>rl', '<cmd>g/^$/d<cr>\'\'', { desc = 'clean the blank line'})
-- TODO (complete comment char)
nnoremap('<leader>rc', '<cmd>g/^#/d<cr>\'\'', { desc = 'clean the comment line'})
vnoremap('<leader>rk', [[<cmd>'<,'>s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
vnoremap('<leader>r,', [[<cmd>'<,'>s/,\([^ ]\)/, \1/g<cr>]])

-- how to quit in vim
nnoremap('<leader>q', '<cmd>Bdelete!<cr>')
nnoremap('<localleader>w', '<cmd>write<cr>')
inoremap('<c-q>', '<cmd>bdelete!<cr>')
inoremap('<c-s>', '<cmd>write<cr>')

-- toggle windows
nnoremap('<leader>wn', '<cmd>NvimTreeFindFileToggle<cr>')
nnoremap('<leader>h', '<cmd>NvimTreeFindFileToggle<cr>')
nnoremap('<leader>wo', '<cmd>AerialToggle<cr>')
nnoremap('<leader>l', '<cmd>AerialToggle<cr>')
nnoremap('<leader>wm', '<cmd>MarkdownPreview<cr>')
nnoremap('<leader>wl', '<cmd>Lazy<cr>')
nnoremap('<leader>wf', '<cmd>Navbuddy<cr>')

-- toggle options
nnoremap('<leader>of', '<cmd>set foldenable!<cr>')
nnoremap('<leader>os', '<cmd>set spell!<cr>')
nnoremap('<leader>on', function()
  if string.match(vim.o.nrformats, 'alpha') then
      vim.cmd [[set nrformats-=alpha]]
  else
      vim.cmd [[set nrformats+=alpha]]
  end
end, { desc = 'toggle nrformats'})

nnoremap('<leader>oj', '<cmd>wincmd _<cr>')
nnoremap('<leader>ok', '<cmd>wincmd =<cr>')
nnoremap('<leader>ob', require('utils.themes').toggle_bg, { desc = 'toggle background'} )
nnoremap('<leader><tab>', require('utils').next_colorscheme, { desc = 'switch colorscheme'})
nnoremap('<leader>ls', '<cmd>ls!<cr>')

-- term
nnoremap('<m-t>', ':split term://bash<cr>i')
tnoremap('<c-q>', '<c-\\><c-n>')
tnoremap('<m-t>', '<c-\\><c-n>:bdelete! %<cr>')
-- tnoremap('<c-;>', '<cmd>ToggleTerm<cr>') -- unusable in vim

-- diagnostic
nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)
nnoremap('<leader>df', vim.diagnostic.open_float)
nnoremap('<leader>ds', vim.diagnostic.setloclist)
