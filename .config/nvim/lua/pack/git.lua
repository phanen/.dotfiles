return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G' },
    keys = {
      { '<leader>ga', '<cmd>G<cr>' },
      { '<leader>gb', '<cmd>G blame<cr>' },
      -- { '<localleader>gd', '<cmd>Gvdiffsplit<cr>' },
      { '<localleader>gr', '<cmd>Gr<cr>' },
      { '<localleader>gs', '<cmd>Gwrite<cr>' },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'DiffviewOpen',
    keys = {
      { '<localleader>gd', ':DiffviewOpen<CR>', mode = { 'n', 'x' } },
      { '<localleader>gh', ':DiffviewFileHistory<cr>', mode = { 'n', 'x' } },
    },
    opts = {
      enhanced_diff_hl = true,
      -- default_args = { DiffviewFileHistory = { '%' } },
      keymaps = {
        view = { q = '<Cmd>DiffviewClose<CR>' },
        file_panel = { q = '<Cmd>DiffviewClose<CR>' },
        file_history_panel = { q = '<Cmd>DiffviewClose<CR>' },
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = { { '<localleader>gs', '<cmd>Gitsigns<cr>' } },
    dependencies = 'stevearc/dressing.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(_)
        local n = function(lhs, rhs) map('n', lhs, ('<cmd>Gitsigns %s<cr>'):format(rhs)) end
        n('gj', 'next_hunk')
        n('gk', 'prev_hunk')
        n('<leader>hs', 'stage_hunk')
        n('<leader>hu', 'undo_stage_hunk')
        n('<leader>hr', 'reset_hunk')
        n('<leader>i', 'preview_hunk')
        n('<leader>gu', 'reset_buffer_index')
        n('<leader>hd', 'toggle_deleted<cr><cmd>Gitsigns toggle_word_diff')
      end,
    },
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "n"<cr>', mode = 'n' },
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "v"<cr>', mode = 'x' },
    },
    opts = { mappings = nil },
  },
}
