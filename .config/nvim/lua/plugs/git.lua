return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G' },
    keys = {
      { ' ga', '<cmd>silent G commit --amend --no-edit<cr>' },
      { ' gr', '<cmd>Gr<cr>' },
      -- { '+gd', '<cmd>Gvdiffsplit<cr>' },

      { ' gb', '<cmd>G blame<cr>' },
      { ' gg', '<cmd>G<cr>' },
      { ' gP', '<cmd>G push<cr>' },
      { ' gs', '<cmd>Gwrite<cr>' },
      { ' gw', '<cmd>G commit<cr>' },
    },
  },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { ' gd', ':DiffviewOpen<CR>', mode = { 'n', 'x' } },
      { ' gh', ':DiffviewFileHistory %<cr>', mode = { 'n', 'x' } },
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
    cond = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Gitsigns',
    dependencies = 'stevearc/dressing.nvim',
    opts = {
      -- signcolumn = false,
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
          if vim.wo.diff then return vim.cmd.normal { '[c', bang = true } end
          gs.nav_hunk('prev', { target = 'all' })
        end)
        -- note: should not buf map, unknown
        -- end, { expr = true, buffer = bufnr })

        nx('gk', function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true } end
          gs.nav_hunk('next', { target = 'all' })
        end)

        local n = function(lhs, rhs) map('n', lhs, ('<cmd>Gitsigns %s<cr>'):format(rhs)) end
        n(' hs', 'stage_hunk')
        n(' hu', 'undo_stage_hunk')
        n(' hr', 'reset_hunk')
        n(' i', 'preview_hunk')
        n(' gu', 'reset_buffer_index')
        n(' hd', 'toggle_deleted<cr><cmd>Gitsigns toggle_word_diff')
        n('+gb', 'blame')
      end,
    },
  },
  { -- TODO: use self-host ssh remote...
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- FIXME: compat
    keys = {
      { ' gl', '<cmd>lua require("gitlinker").get_buf_range_url "n"<cr>', mode = 'n' },
      { ' gl', '<cmd>lua require("gitlinker").get_buf_range_url "v"<cr>', mode = 'x' },
    },
    -- TODO: smart remote
    -- PERF: or since we always rebase patch on the top (see upd-nvim), blame remote branch work fine
    -- this also apply to lazygit
    opts = { mappings = nil },
  },
  -- TODO: this produce many [no name] buf...
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    keys = {
      { ' gn', function() require('neogit').open({ cwd = require('lib.util').smart_root() }) end },
    },
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
    'rbong/vim-flog',
    cmd = { 'Flog', 'Flogsplit' },
    keys = { { ' gf', '<cmd>Flog<cr>' } },
    dependencies = { 'tpope/vim-fugitive' },
  },
  {
    'SuperBo/fugit2.nvim',
    cond = true,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      { 'chrisgrieser/nvim-tinygit', dependencies = { 'stevearc/dressing.nvim' } },
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = { { '<leader>F', '<cmd>Fugit2<cr>' } },
    opts = {},
  },
}
