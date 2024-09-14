return {
  'kevinhwang91/nvim-fundo',
  event = 'BufReadPre',
  build = function() require('fundo').install() end,
  opts = {},
}
