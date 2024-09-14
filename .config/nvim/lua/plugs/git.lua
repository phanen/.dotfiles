g.gitsigns_signs = {
  add = { text = '' },
  change = { text = '' },
  delete = { text = '' },
  topdelete = { text = '‾' },
  changedelete = { text = '' }, -- hl-delete
  untracked = { text = '' }, -- hl-add
}

return {
  { 'tpope/vim-fugitive', cmd = { 'G', 'Gwrite', 'Gr' } },
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
      signcolumn = true,
      numhl = false,
      -- used in diffview
      max_file_length = 20000,
      attach_to_untracked = true,
      preview_config = { border = g.border },
      signs = g.gitsigns_signs,
      signs_staged = g.gitsigns_signs,
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
}
