-- TODO: BufRead trigger man plugin (set buf)
-- make <c-s><c-d> work
vim.bo.bh = 'hide' -- unload -> hide
vim.bo.bt = '' -- nofile -> ''

-- TODO: also for helpdocs
map.n[0]('go', require 'man'.show_toc)

-- FIXME: `o` just delete qf/loc/list...
