local tl = require 'telescope'
local tb = require 'telescope.builtin'

tl.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- enable fzf native
pcall(tl.load_extension, 'heading')
pcall(tl.load_extension, 'fzf')

-- buffer search
vim.keymap.set('n', '<leader><space>', tb.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/',
  function()
    tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' }
)
vim.keymap.set('n', '<leader>?', tb.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>sf', tb.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', tb.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sw', tb.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sh', tb.help_tags, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>ss', tb.lsp_document_symbols, { desc = '[S]earch [S]ymbol' })

vim.keymap.set('n', '<leader>fh', "<cmd>Telescope heading<cr>", { desc = '[F]ind [H]eading' })
vim.keymap.set('n', '<leader>sb', tb.builtin, { desc = '[S]earch [M]eta' })
