-- 'sbulav/nredir.nvim'
-- 'suliveevil/vim-redir-output'

local Msg = {}

Msg.pipe_cmd = function(cmd)
  local ui = api.nvim_list_uis()[1]
  local width = ui.width - 20
  local height = ui.height - 10
  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    border = g.border,
    anchor = 'NW',
    style = 'minimal',
  })
  vim.wo[win].winhl = 'Normal:ErrorFloat'
  vim.wo[win].nu = true
  vim.wo[win].rnu = true

  -- ... why this is needed
  u.map[buf].n.q = 'ZZ'

  cmd = vim.trim(cmd)
  if not cmd or cmd == '' then return end

  local lines
  if cmd:sub(1, 1) == '!' then
    lines = vim
      .iter(fn.systemlist(cmd:sub(2)))
      :map(function(line) return (line:gsub('[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]', '')) end)
      :totable()
  else
    lines = vim.split(fn.execute(cmd), '\n')
  end
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

Msg.yank_last = function() fn.setreg('+', vim.trim(fn.execute('1message'))) end

return Msg
