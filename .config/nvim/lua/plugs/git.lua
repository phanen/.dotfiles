return {
  {
    -- TODO: re-blame on file switch
    'tpope/vim-fugitive',
    cmd = { 'G' },
    keys = {
      -- todo: if staged then amend (maybe use gitsigns)
      { ' ga', '<cmd>silent G commit --amend --no-edit<cr>' },
      { ' gr', '<cmd>Gr<cr>' },
      -- { ' gd', '<cmd>Gvdiffsplit<cr>' },
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
      { ' gd', ':DiffviewOpen<cr>', mode = { 'n', 'x' } },
      { ' gh', ':DiffviewFileHistory %<cr>', mode = { 'n', 'x' } },
    },
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
    cond = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Gitsigns',
    opts = {
      -- signcolumn = false,
      -- used in diffview
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

      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        map.nx('gj', function()
          if vim.wo.diff then vim.cmd.normal { '[c', bang = true } end
          gs.nav_hunk('next', { target = 'all' })
        end, { buffer = bufnr })

        map.nx('gk', function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true } end
          gs.nav_hunk('prev', { target = 'all' })
        end, { buffer = bufnr })

        -- TODO: currying
        -- TODO: icmd mode, ncmd mode
        local _ = ({
          new = function(self, main_cmd, bufnr)
            local o = {
              main_cmd = main_cmd,
              bufnr = bufnr,
              __index = self,
            }
            return setmetatable(o, o)
          end,
          map = function(self, group)
            if self.main_cmd then
              for _, obj in pairs(group) do
                local lhs, cmds = obj[1], obj[2]
                local rhs = '<cmd>%s %s<cr>'
                if type(cmds) == 'string' then
                  rhs = rhs:format(self.main_cmd, cmds)
                elseif type(cmds) == 'table' then
                  cmds = vim
                    .iter(cmds)
                    :map(function(subcmd) return rhs:format(self.main_cmd, subcmd) end)
                    :totable()
                  rhs = table.concat(cmds)
                end
                map.n(lhs, rhs, { buffer = bufnr })
              end
            end
          end,
        }):new('Gitsigns', bufnr):map({
          { ' hs', 'stage_hunk' },
          { ' hu', 'undo_stage_hunk' },
          { ' hr', 'reset_hunk' },
          { ' i', 'preview_hunk' },
          { ' gu', 'reset_buffer_index' },
          { ' hd', { 'toggle_deleted', 'toggle_word_diff' } },
          { '+gb', 'blame' },
        })

        -- PERF: find then select_hunk
        map.ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
        map.ox('ah', ':<c-u>Gitsigns select_hunk<cr>')
      end,
    },
  },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    keys = {
      { ' gn', function() require('neogit').open { cwd = u.smart.root() } end },
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
