return {
  'stevearc/aerial.nvim',
  cond = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cmd = { 'AerialToggle', 'AerialNavToggle' },
  opts = {
    -- backends = { 'lsp', 'treesitter', 'markdown' },
    backends = {
      ['_'] = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      markdown = { 'markdown' },
      man = { 'man' },
    },
    keymaps = { ['<C-k>'] = false, ['<C-j>'] = false, ['l'] = 'actions.tree_toggle' },
    attach_mode = 'global',
    icons = { -- fix indent
      Collapsed = '',
      markdown = { Interface = '󰪥' },
    },
    filter_kind = false,
    link_tree_to_folds = false,
    nav = { -- bad ratio...
      preview = true,
      border = g.border,
      win_opts = { cursorline = true, winblend = 20 },
    },
    on_attach = function(_) package.loaded.aerial.tree_close_all() end,
  },
}
