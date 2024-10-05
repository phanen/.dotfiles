-- FIXME(upstream): block visual mode not work well when edit(ts hl); very slow on large file
return {
  'HiPhish/rainbow-delimiters.nvim',
  cond = false,
  event = { 'BufReadPre', 'BufNewFile' },
}
