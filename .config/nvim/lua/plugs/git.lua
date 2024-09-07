return {
  { 'tpope/vim-fugitive', cmd = { 'G', 'Gwrite', 'Gr' } },
  { 'rbong/vim-flog', cmd = { 'Flog', 'Flogsplit' }, dependencies = { 'tpope/vim-fugitive' } },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    opts = {
      enhanced_diff_hl = true,
      -- default_args = { DiffviewFileHistory = { '%' } },
      hooks = { diff_buf_win_enter = function(_, winid) vim.wo[winid].wrap = false end },
      keymaps = {
        view = { q = '<cmd>DiffviewClose<cr>' },
        file_panel = { q = '<cmd>DiffviewClose<cr>' },
        file_history_panel = { q = '<cmd>DiffviewClose<CR>' },
      },
    },
  },
  {
    -- FIXME(upstream): hunk reset in last line not work
    -- ~/.local/share/nvim/lazy/nvim-snips/lua/snips/lua/init.lua
    -- also space is auto trim by what
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Gitsigns',
    opts = {
      -- signcolumn = false,
      -- used in diffview
      max_file_length = 20000,
      attach_to_untracked = true,
      preview_config = { border = vim.g.border },
      signs = {
        -- add = { text = '+' },
        -- TODO: better icons, fixed color
        -- FIXME: collide with warning
        -- https://github.com/search?q=%27%EF%81%95%27+lang%3Alua&type=code
        add = { text = '' },
        -- change = { text = '󰤌' },
        -- change = { text = '' },
        -- change = { text = '' },
        change = { text = '' },
        delete = { text = '' },
        topdelete = { text = '‾' },
        -- changedelete = { text = '' },
        -- changedelete = { text = '' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '+' },
        -- add = { text = '' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      on_attach = function(buf)
        local n = map.n[buf]
        local nx = map.nx[buf]
        local ox = map.ox[buf]
        -- TODO: maybe we should use api to do thing without buf map
        n(' hs', '<cmd>Gitsigns stage_hunk<cr>')
        n(' hu', '<cmd>Gitsigns undo_stage_hunk<cr>')
        n(' hr', '<cmd>Gitsigns reset_hunk<cr>')
        nx(' i', '<cmd>Gitsigns preview_hunk<cr>')
        n(' gu', '<cmd>Gitsigns reset_buffer_index<cr>')
        n(' hd', '<cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>')
        n('+gb', '<cmd>Gitsigns blame<cr>')

        -- PERF: find then select_hunk
        ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
        ox('ah', ':<c-u>Gitsigns select_hunk<cr>')
      end,
    },
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    opts = {
      disable_hint = true,
      disable_insert_on_commit = false,
      signs = { section = { '', '' }, item = { '▸', '▾' }, hunk = { '󰐕', '󰍴' } },
      integrations = {
        fzf_lua = true,
      },
    },
  },
  {
    'SuperBo/fugit2.nvim',
    cond = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      { 'chrisgrieser/nvim-tinygit', dependencies = { 'stevearc/dressing.nvim' } },
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = { { ' F', '<cmd>Fugit2<cr>' } },
    opts = {
      width = 100,
      external_diffview = true,
    },
  },
}
