return {
  {
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
  },
  {
    'glepnir/template.nvim',
    cond = false,
    cmd = { 'Template', 'TemProject' },
    config = function()
      require('template').setup({
        temp_dir = '~/t',
        author = 'xxx',
        email = 'xxxxxxxxx@xx.mail',
      })
      require('telescope').load_extension('find_template')
    end,
  },
  -- buggy for display
  {
    'Rawnly/gist.nvim',
    cond = false, --
    cmd = { 'GistCreate', 'GistCreateFromFile', 'GistsList' },
    config = true,
  },
  -- need v3 token?
  {
    'mattn/vim-gist',
    cond = false,
    cmd = { 'Gist' },
    dependencies = {
      'mattn/webapi-vim',
    },
  },
}
