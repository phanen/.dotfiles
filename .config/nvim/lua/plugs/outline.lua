return {
  {
    'stevearc/aerial.nvim',
    cond = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
      -- 'hrsh7th/nvim-cmp', Hack to ensure that lspkind-nvim is loaded
    },
    cmd = { 'AerialToggle' },
    opts = {
      -- backends = { 'lsp', 'treesitter', 'markdown' },
      backends = { 'treesitter', 'lsp', 'markdown' },
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

  {
    'Bekaboo/dropbar.nvim',
    cond = false,
    -- cond = fn.has('nvim-0.10') == 1,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { -- fzf support
      -- 'nvim-telescope/telescope-fzf-native.nvim',
    },
    opts = {
      general = {
        enable = function(buf, win)
          return vim.bo[buf].ft == 'fugitiveblame'
            or fn.win_gettype(win) == ''
              and vim.wo[win].winbar == ''
              and (vim.bo[buf].bt == '')
              and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
        end,
      },
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
      { '<leader>tc', '<Cmd>TSContextToggle<CR>', desc = 'Treesitter Context' },
    },
  },
}
