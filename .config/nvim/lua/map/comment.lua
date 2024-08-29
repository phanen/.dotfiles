map('', '<c-_>', '<c-/>', { remap = true })
map.x('<c-/>', 'gc', { remap = true })
-- TODO: comment empty line?
map.i('<c-/>', '<cmd>norm <c-/><cr>')
map.n(
  '<c-/>',
  function() return vim.v.count == 0 and 'gcl' or 'gcj' end,
  { expr = true, remap = true }
)
map.n(' <c-/>', '<cmd>norm vic<c-/><cr>')
map.n('gco', u.comment.comment_below)
map.n('gcO', u.comment.comment_above)
