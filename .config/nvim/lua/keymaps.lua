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
vnoremap('p', '"_dp')
nnoremap('<a-j>', ':m .+1<cr>')
nnoremap('<a-k>', ':m .-2<cr>')

-- nnoremap('<c-p>', '<c-y>')
-- nnoremap('<c-n>', '<c-e>')

vnoremap('d', '"_d')
vnoremap('c', '"_c')

nnoremap('<leader>C', '<cmd>edit $XDG_CONFIG_HOME/nvim<cr>')

-- navigation
nnoremap('<c-f>', '<cmd>BufferLineCycleNext<cr>')
nnoremap('<c-b>', '<cmd>BufferLineCyclePrev<cr>')

nnoremap('<c-h>', '<cmd>wincmd h<cr>')
nnoremap('<c-j>', '<cmd>wincmd j<cr>')
nnoremap('<c-k>', '<cmd>wincmd k<cr>')
nnoremap('<c-l>', '<cmd>wincmd l<cr>')

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
nnoremap('<leader>rs', '<cmd>%s/\\s*$//g<cr>', { desc = 'clean tail space'})
nnoremap('<leader>rl', '<cmd>g/^$/d<cr>', { desc = 'clean the blank line'})
-- TODO (complete comment char)
nnoremap('<leader>rc', '<cmd>g/^#/d<cr>', { desc = 'clean the comment line'})
vnoremap('<leader>rk', [[<cmd>'<,'>s/\/\* \(.*\) \*\//\/\/ \1/g<cr>]])
vnoremap('<leader>r,', [[<cmd>'<,'>s/,\([^ ]\)/, \1/g<cr>]])

-- how to quit in vim
nnoremap('<leader>q', '<cmd>bdelete!<cr>')
nnoremap('<localleader>q', '<cmd>quit!<cr>')
nnoremap('<localleader>w', '<cmd>write<cr>')
nnoremap('<localleader>w', '<cmd>write<cr>')
nnoremap('X', '<cmd>bdelete!<cr>')
inoremap('<c-q>', '<cmd>bdelete!<cr>')
inoremap('<c-s>', '<cmd>write<cr>')

-- toggle windows
nnoremap('<leader>wn', '<cmd>NvimTreeFindFileToggle<cr>')
nnoremap('<leader>wo', '<cmd>AerialToggle<cr>')
nnoremap('<leader>wm', '<cmd>MarkdownPreview<cr>')
nnoremap('<leader>wl', '<cmd>Lazy<cr>')

-- toggle options
nnoremap('<leader>of', '<cmd>set foldenable!<cr>')
nnoremap('<leader>os', '<cmd>set spell!<cr>')
nnoremap('<leader>on', function()
  if string.match(vim.o.nrformats, 'alpha') then
      vim.cmd [[set nrformats-=alpha]]
  else
      vim.cmd [[set nrformats+=alpha]]
  end
end)
nnoremap('<leader>ob', require('utils.themes').toggle_bg, { desc = 'toggle background'} )
nnoremap('<leader><tab>', require('utils').next_colorscheme, { desc = 'switch colorscheme'})
nnoremap('<leader>ls', '<cmd>ls!<cr>')

-- toy term
nnoremap('<m-t>', ':split term://bash<CR>i')
tnoremap('<c-q>', '<c-\\><c-n>')
tnoremap('<m-t>', '<c-\\><c-n>:bdelete! %<CR>')

-- diagnostic
nnoremap('[d', vim.diagnostic.goto_prev)
nnoremap(']d', vim.diagnostic.goto_next)
nnoremap('<leader>df', vim.diagnostic.open_float)
nnoremap('<leader>ds', vim.diagnostic.setloclist)
