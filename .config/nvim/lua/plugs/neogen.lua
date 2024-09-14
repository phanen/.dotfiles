return {
  'danymat/neogen',
  cmd = 'Neogen',
  keys = { { '<leader>.', '<cmd>Neogen<cr>' } },
  opts = {
    snippet_engine = 'luasnip',
    languages = {
      lua = {
        template = { annotation_convention = 'emmylua' },
      },
    },
  },
}
