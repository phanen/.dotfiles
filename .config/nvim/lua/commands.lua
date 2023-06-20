local fn, api, cmd, fmt = vim.fn, vim.api, vim.cmd, string.format
local command = function(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

command('ToggleBackground', function() vim.o.background = vim.o.background == 'dark' and 'light' or 'dark' end)
------------------------------------------------------------------------------
command('Todo', [[noautocmd silent! grep! 'TODO\|FIXME\|BUG\|HACK' | copen]])
-- command('ReloadModule', function(tbl) require('plenary.reload').reload_module(tbl.args) end, {
--   nargs = 1,
-- })
-- source https://superuser.com/a/540519
-- write the visual selection to the filename passed in as a command argument then delete the
-- selection placing into the black hole register
command('MoveWrite', [[<line1>,<line2>write<bang> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})
command('MoveAppend', [[<line1>,<line2>write<bang> >> <args> | <line1>,<line2>delete _]], {
  nargs = 1,
  bang = true,
  range = true,
  complete = 'file',
})

command('Reverse', '<line1>,<line2>g/^/m<line1>-1', {
  range = '%',
  bar = true,
})

-- command('Exrc', function()
--   local cwd = fn.getcwd()
--   local p1, p2 = ('%s/.nvim.lua'):format(cwd), ('%s/.nvimrc'):format(cwd)
--   local path = uv.fs_stat(p1) and p1 or uv.fs_stat(p2) and p2
--   if not path then
--     local _, err = io.open(p1, 'w')
--     assert(err == nil, err)
--     path = p1
--   end
--   if not path then return end
--   local ok, err = pcall(vim.cmd.edit, path)
--   if not ok then vim.notify(err, 'error', { title = 'Exrc Opener' }) end
-- end)
--
--
