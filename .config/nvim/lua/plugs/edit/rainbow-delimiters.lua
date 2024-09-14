-- FIXME: block visual mode not work well
-- FIXME: very slow on large file
return {
  'HiPhish/rainbow-delimiters.nvim',
  cond = false,
  event = { 'BufReadPre', 'BufNewFile' },
}
