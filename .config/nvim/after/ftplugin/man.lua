-- TODO: BufRead trigger man plugin (set buf)
vim.bo.bh = 'hide'
vim.bo.bt = ''

local n = map.n

-- TODO: not sure why this is needed (ft.lua)
n('u', '<c-u>', { buffer = 0 })
n('d', '<c-d>', { buffer = 0 })

-- we preset g:no_man_maps = 0
-- FIXME: `o` just delete qf/loc/list...
vim.cmd [[
  nnoremap <silent> <buffer> gO            :lua require'man'.show_toc()<CR>
  nnoremap <silent> <buffer> go            :lua require'man'.show_toc()<CR>
  nnoremap <silent> <buffer> <2-LeftMouse> :Man<CR>
  if get(g:, 'pager')
    nnoremap <silent> <buffer> <nowait> q :lclose<CR><C-W>q
  else
    nnoremap <silent> <buffer> <nowait> q :lclose<CR><C-W>c
  endif
]]
