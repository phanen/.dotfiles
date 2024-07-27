return {
  {
    -- TODO: re-blame on file switch
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
          gs.nav_hunk('next', { target = 'all' })
        end)
        -- note: should not buf map, unknown
        -- end, { expr = true, buffer = bufnr })

        nx('gk', function()
          if vim.wo.diff then vim.cmd.normal { ']c', bang = true } end
          gs.nav_hunk('prev', { target = 'all' })
        end)

        -- TODO: currying
        -- TODO: icmd mode, ncmd mode
        local CmdMap = {
          new = function(self, main_cmd)
            local o = { main_cmd = main_cmd, __index = self }
            return setmetatable(o, o)
          end,
          reset = function(self, cmd) self.main_cmd = cmd end,
          map = function(self, group)
            for _, obj in pairs(group) do
              local lhs, cmds = obj[1], obj[2]
              local rhs
              if type(cmds) == 'string' then
                rhs = ('<cmd>%s %s<cr>'):format(self.main_cmd, cmds)
              elseif type(cmds) == 'table' then
                cmds = vim
                  .iter(cmds)
                  :map(function(_, cmd) return ('<cmd>%s %s<cr>'):format(self.main_cmd, cmd) end)
                  :totable()
                rhs = table.concat(cmds)
              end
              map.n(lhs, rhs)
            end
          end,
        }

        CmdMap:new('Gitsigns'):map({
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
      end,
    },
  },
  {
    'phanen/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = { { ' gl', '<cmd>lua require("gitlinker").get_permalink()<cr>', mode = { 'n', 'x' } } },
    opts = { remote = u.git.smart_remote_url },
  },
  -- TODO: this produce many [no name] buf...
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
