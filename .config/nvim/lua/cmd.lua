cmd('EditFtplugin', function(opts)
  local ft
  if #opts.fargs == 1 then
    ft = opts.fargs[1]
  else
    ft = vim.bo.ft
  end
  if ft == '' then return end

  local path = string.format('%s/after/ftplugin/%s.lua', g.config_path, ft)
  vim.cmd.vsplit({ args = { path } })
end, {
  nargs = '?',
  desc = 'Edit after ftplugin',
  complete = function() return fn.getcompletion('', 'filetype') end,
})

cmd('DiffOrig', function()
  -- Get start buffer
  local start = api.nvim_get_current_buf()

  -- `vnew` - Create empty vertical split window
  -- `set buftype=nofile` - Buffer is not related to a file, will not be written
  -- `0d_` - Remove an extra empty start row
  -- `diffthis` - Set diff mode to a new vertical split
  vim.cmd('vnew | set buftype=nofile | read ++edit # | 0d_ | diffthis')

  -- TODO: attach winbar (or hide it)

  -- Get scratch buffer
  local scratch = api.nvim_get_current_buf()

  -- some filetype
  vim.bo[scratch].ft = vim.bo[start].ft

  -- `wincmd p` - Go to the start window
  -- `diffthis` - Set diff mode to a start window
  vim.cmd('wincmd p | diffthis')
end, {})

cmd('AppendModeline', function(opts)
  local modeline = string.format(
    'vim: ts=%d sw=%d tw=%d %set :',
    vim.o.tabstop,
    vim.o.shiftwidth,
    vim.o.textwidth,
    vim.o.expandtab and '' or 'no'
  )
  modeline = string.format(vim.bo.commentstring, modeline)
  api.nvim_buf_set_lines(0, -1, -1, false, { modeline })
  api.nvim_exec2('doautocmd BufRead', {})
end, {})
