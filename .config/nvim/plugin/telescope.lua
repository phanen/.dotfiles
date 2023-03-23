local tl = require 'telescope'
local tb = require 'telescope.builtin'

tl.setup {
  defaults = {
    mappings = {
      i = {
        ['<c-u>'] = false,
        ['<c-d>'] = false,
      },
    },
  },
}

-- enable fzf native
pcall(tl.load_extension, 'heading')
pcall(tl.load_extension, 'fzf')
pcall(tl.load_extension, 'file_browser')

vim.keymap.set('n', '<leader>/', function()
  tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  }) end,
  { desc = 'fuzzily [/]' }
)

vim.keymap.set('n', '<leader>fb', tb.buffers, { desc = '[f]ind [b]uffers' })
vim.keymap.set('n', '<leader>fr', tb.oldfiles, { desc = '[f]ind [r]ecents' })
vim.keymap.set('n', '<leader>ff', tb.find_files, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', '<leader><space>', tb.find_files, { desc = '[f]ind [f]iles' })
vim.keymap.set('n', '<leader>:', tb.command_history, { desc = 'command' })

vim.keymap.set('n', '<leader>fg', tb.live_grep, { desc = '[f]ind by [g]rep' })
vim.keymap.set('n', '<leader>fw', tb.grep_string, { desc = '[f]ind current [w]ord' })
vim.keymap.set('n', '<leader>fd', tb.diagnostics, { desc = '[f]ind [d]iagnostics' })

vim.keymap.set('n', '<leader>fh', "<cmd>Telescope heading<cr>", { desc = '[f]ind [h]eadings' })
vim.keymap.set('n', '<leader>fp', tb.help_tags, { desc = '[f]ind [h]elp' })
vim.keymap.set('n', '<leader>fs', tb.lsp_document_symbols, { desc = '[s]earch [s]ymbol' })

vim.keymap.set('n', '<leader>fm', tb.builtin, { desc = '[f]nd [m]eta' })

vim.keymap.set('n', '<leader>ft', "<cmd>Telescope file_browser<cr>", { desc = '[f]ind [h]eadings' })
