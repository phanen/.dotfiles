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
        n('gj', '<cmd>Gitsigns next_hunk<cr>')
        n('gk', '<cmd>Gitsigns prev_hunk<cr>')
        n('<leader>hs', '<cmd>Gitsigns stage_hunk<cr>')
        n('<leader>hu', '<cmd>Gitsigns undo_stage_hunk<cr>')
        n('<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
        n('<leader>hi', '<cmd>Gitsigns preview_hunk<cr>')
        n('<leader>gu', '<cmd>Gitsigns reset_buffer_index<cr>')
        n('<leader>hd', '<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>')
      end,
    },
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { '<localleader>gn', '<cmd>Neogit<cr>' } },
    opts = {
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = {
        section = { '', '' },
        item = { '▸', '▾' },
        hunk = { '󰐕', '󰍴' },
      },
    },
  },
  {
    'ruifm/gitlinker.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    keys = {
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "n"<cr>', mode = 'n' },
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "x"<cr>', mode = 'v' },
    },
    opts = { mappings = nil },
  },
}
