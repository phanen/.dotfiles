local M = {}

M.pipe_cmd = function(cmd)
  local ui = api.nvim_list_uis()[1]
  local width = ui.width - 20
  local height = ui.height - 10
  local bufnr = api.nvim_create_buf(false, false)
  local win = api.nvim_open_win(bufnr, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    border = vim.g.border,
    anchor = 'NW',
    style = 'minimal',
  })
  vim.wo[win].winhl = 'Normal:ErrorFloat'
  vim.wo[win].nu = true
  vim.wo[win].rnu = true

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
  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
end

M.yank_last_message = function() fn.setreg('+', vim.trim(fn.execute('1message'))) end

return M
