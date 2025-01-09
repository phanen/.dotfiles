return {
  'kevinhwang91/nvim-fundo',
  main = 'fundo',
  event = 'BufReadPre',
  build = function() require('fundo').install() end,
  opts = {},
}
