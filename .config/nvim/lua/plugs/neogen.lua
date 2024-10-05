return {
  'danymat/neogen',
  cmd = 'Neogen',
  dependencies = 'nvim-cmp', -- when enter selection mode, ensure cmp mappings setuped
  opts = {
    snippet_engine = 'luasnip',
    languages = {
      lua = {
        template = { annotation_convention = 'emmylua' },
      },
    },
  },
}
