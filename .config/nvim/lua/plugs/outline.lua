return {
  {
    'folke/trouble.nvim',
    cond = false,
    cmd = { 'Trouble' },
    keys = {
      { ' xx', '<cmd>Trouble diagnostics toggle<cr>' },
      { ' xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>' },
      { ' cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      { ' cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>' },
      { ' xL', '<cmd>Trouble loclist toggle<cr>' },
      { ' xQ', '<cmd>Trouble qflist toggle<cr>' },
    },
    opts = {},
  },
  {
    'stevearc/aerial.nvim',
    cond = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      -- 'hrsh7th/nvim-cmp', Hack to ensure that lspkind-nvim is loaded
    },
    cmd = { 'AerialToggle' },
    opts = {
      -- backends = { 'lsp', 'treesitter', 'markdown' },
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      keymaps = { ['<C-k>'] = false, ['<C-j>'] = false, ['l'] = 'actions.tree_toggle' },
      attach_mode = 'global',
      icons = { -- fix indent
        Collapsed = '',
        markdown = { Interface = '󰪥' },
      },
      nav = { preview = true },
      on_attach = function(_) package.loaded.aerial.tree_close_all() end,
    },
  },
  -- lsp only..
  {
    'hedyhli/outline.nvim',
    cond = false,
    cmd = 'Outline',
    opts = {
      preview_window = { live = true },
      symbols = { icon_source = 'lspkind' },
      keymaps = {
        show_help = '?',
        close = { '<esc>', 'q' },
        goto_location = '<cr>',
        -- peek_location = 'o',
        goto_and_close = '<s-cr>',
        restore_location = '<c-g>',
        hover_symbol = '_',
        toggle_preview = 'i',
        rename_symbol = 'r',
        code_actions = 'a',
        -- fold = 'o',
        -- unfold = 'o',
        -- find parent then toggle
        fold_toggle = 'o',
        fold_toggle_all = '<s-tab>',
        fold_all = 'zm',
        unfold_all = 'zr',
        fold_reset = 'r',
        down_and_jump = '<nul>',
        up_and_jump = '<nul>',
      },
    },
  },
  {
    'RRethy/vim-illuminate', -- show cursorword
    cond = false,
    event = { 'VeryLazy', 'LspAttach' },
    config = function()
      require('illuminate').configure({
        delay = 200,
        modes_allowlist = { 'n' },
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = { 'lsp' },
        },
      })
    end,
    keys = {
      { ']]', function() require('illuminate').goto_next_reference() end, desc = 'Next Reference' },
      { '[[', function() require('illuminate').goto_prev_reference() end },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    cond = false,
    opts = {
      mode = 'topline',
    },
    keys = {
      { ' tc', '<Cmd>TSContextToggle<CR>', desc = 'Treesitter Context' },
    },
  },
}
