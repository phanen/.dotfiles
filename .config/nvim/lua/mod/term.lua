local M = {}

local term_set_local_keymaps_and_opts = function(bufnr)
  if not api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].bt ~= 'terminal' then return end

  -- local o = vim.bo[bufnr]
  local o = vim.opt_local
  o.nu = false
  o.rnu = false
  o.spell = false
  o.statuscolumn = ''
  o.signcolumn = 'no'

  if fn.win_gettype() == 'popup' then
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
  end

  vim.cmd.startinsert()
end

M.setup = function(bufnr)
  term_set_local_keymaps_and_opts(bufnr)

  local gid = ag('Term', {})
  au('TermOpen', {
    group = gid,
    desc = 'Set terminal keymaps and options, open term in split.',
    callback = function(ev) term_set_local_keymaps_and_opts(ev.buf) end,
  })

  au('TermEnter', {
    group = gid,
    desc = 'Disable mousemoveevent in terminal mode.',
    callback = function()
      vim.g.mousemev = vim.go.mousemev
      vim.go.mousemev = false
    end,
  })

  au('TermLeave', {
    group = gid,
    desc = 'Restore mousemoveevent after leaving terminal mode.',
    callback = function()
      if vim.g.mousemev ~= nil then
        vim.go.mousemev = vim.g.mousemev
        vim.g.mousemev = nil
      end
    end,
  })

  -- FIXME: still not persistant, since `startinsert` delay
  au('ModeChanged', {
    group = gid,
    desc = 'Record mode in terminal buffer.',
    callback = function(ev)
      if vim.bo[ev.buf].bt == 'terminal' then vim.b[ev.buf].termode = api.nvim_get_mode().mode end
    end,
  })

  au({ 'BufWinEnter', 'WinEnter' }, {
    group = gid,
    desc = 'Recover inseart mode when entering terminal buffer.',
    callback = function(ev)
      if vim.bo[ev.buf].bt == 'terminal' and vim.b[ev.buf].termode == 't' then
        vim.cmd.startinsert()
      end
    end,
  })
end

return M
