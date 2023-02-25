
require 'plugins'
require 'settings'
require 'autocmds'
require 'keymaps'

-- toggle checked / create checkbox if it doesn't exist
-- vim.keymap.set('n', '<leader>nn', require('markdown-togglecheck').toggle)
-- -- toggle checkbox (it doesn't remember toggle state and always creates [ ])
-- vim.keymap.set('n', '<leader>nN', require('markdown-togglecheck').toggle_box)

-- vim.cmd [[
-- nnoremap <leader>ev :vsplit $MYVIMRC<cr>
-- nnoremap <leader>sv :source $MYVIMRC<cr>
-- ]]
--



-- require('neoscroll').setup {
--     mappings = {'<C-u>', '<C-d>', -- '<C-y>', '<C-e>',
--     -- 'zt', 'zz', 'zb'
--   },
-- }
--
--
-- local t = {}
-- -- Syntax: t[keys] = {function, {function arguments}}
--
-- local speed = '100'
-- t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', speed}}
-- t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', speed}}
--
-- require('neoscroll.config').set_mappings(t)
