return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G' },
    keys = {
      { '<leader>ga', '<cmd>G<cr>' },
      { '<leader>gl', '<cmd>G commit<cr>' },
      { '<leader>gb', '<cmd>G blame<cr>' },
      -- { '+gd', '<cmd>Gvdiffsplit<cr>' },
      { '+gr', '<cmd>Gr<cr>' },
      { '+gs', '<cmd>Gwrite<cr>' },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '+gd', ':DiffviewOpen<CR>', mode = { 'n', 'x' } },
      { '+gh', ':DiffviewFileHistory %<cr>', mode = { 'n', 'x' } },
    },
    opts = {
      enhanced_diff_hl = true,
      -- default_args = { DiffviewFileHistory = { '%' } },
      hooks = { diff_buf_win_enter = function(_, winid) vim.wo[winid].wrap = false end },
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
    keys = { { '<leader>gs', '<cmd>Gitsigns<cr>' } },
    dependencies = 'stevearc/dressing.nvim',
    opts = {
      -- used in diffview
      attach_to_untracked = true,
      preview_config = { border = vim.g.border },
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        nx('gj', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(gs.next_hunk)
          return '<ignore>'
        end, { expr = true })
        -- should not buf map, unkown
        -- end, { expr = true, buffer = bufnr })

        nx('gk', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(gs.prev_hunk)
          return '<ignore>'
        end, { expr = true })

        local n = function(lhs, rhs) map('n', lhs, ('<cmd>Gitsigns %s<cr>'):format(rhs)) end
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
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "n"<cr>', mode = 'n' },
      { '+gl', '<cmd>lua require("gitlinker").get_buf_range_url "v"<cr>', mode = 'x' },
    },
    -- TODO: smart remote
    opts = { mappings = nil },
  },
}
