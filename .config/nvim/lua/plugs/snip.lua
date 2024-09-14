return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  build = 'make install_jsregexp',
  dependencies = 'rafamadriz/friendly-snippets',
  config = function()
    require('luasnip.loaders.from_lua').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets' }
    require('luasnip').filetype_extend('all', { '_' })
  end,
}
