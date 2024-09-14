-- 'liangxianzhe/floating-nvim'
-- 'stevearc/dressing.nvim'

local Ui = {}

local options = {
  --- @type vim.api.keyset.win_config
  win_config = {
    relative = 'cursor',
    anchor = 'SW',
    border = g.border or 'single',
    style = 'minimal',
    noautocmd = true,
    title_pos = 'left',
    row = 0,
    col = 0,
    height = 1,
  },
}

---@class (exact) ui.InputOptions
---@field prompt? string
---@field default? string
---@field win? table
---@field completion? string
---@field highlight? string|fun(text: string): any[][]

---@param opts ui.InputOptions|string|nil
---@param on_confirm fun(text?: string)
Ui.input = function(opts, on_confirm)
  assert(vim.is_callable(on_confirm))
  if type(opts) == 'string' then opts = { prompt = tostring(opts) } end
  opts = u.merge(options, opts or {})

  -- WIP: multiple line prompt/input
  local prompt = opts.prompt and (opts.prompt:gsub('\n', ' ')) or 'Input: '
  local default = opts.default and (opts.default:gsub('\n', ' ' or '')) or ''

  -- create win
  local win_config = opts.win_config
  win_config.width = math.max(api.nvim_strwidth(default) + 4, api.nvim_strwidth(prompt) + 2)
  win_config.title = prompt
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, true, { default })
  local win = api.nvim_open_win(buf, true, win_config)
  vim.wo[win].wrap = false
  vim.wo[win].list = true
  vim.wo[win].listchars = 'precedes:…,extends:…'
  vim.wo[win].sidescrolloff = 0

  local curr_width, prev_width = api.nvim_strwidth(default), nil
  local id = api.nvim_create_autocmd({ 'TextChangedI' }, {
    buffer = buf,
    callback = function()
      curr_width, prev_width = api.nvim_strwidth(api.nvim_get_current_line()), curr_width
      local _opts = api.nvim_win_get_config(win)
      _opts.width = _opts.width + curr_width - prev_width
      api.nvim_win_set_config(win, _opts)
    end,
  })

  local do_exit = function()
    api.nvim_del_autocmd(id)
    api.nvim_win_close(win, true)
    vim.cmd('stopinsert') -- FIXME: toggle number column...
  end
  -- aug.nu_toggle =
  --   { { 'InsertEnter', 'InsertLeave' }, function(_) vim.print(_) vim.wo.rnu = _.event == 'InsertLeave' end }
  -- vim.o.indentexpr = [[v.lua:require"nvim-treesitter".indentexpr()]]

  local do_confirm = function()
    local line = api.nvim_buf_get_lines(buf, 0, 1, false)[1]
    if line ~= default then on_confirm(line) end
    do_exit()
  end

  map[buf].i['<cr>'] = do_confirm
  map[buf].i['<esc>'] = do_exit

  vim.cmd('startinsert!')
end

Ui.select = u.lreq('fzf-lua.providers.ui_select').ui_select

return setmetatable(Ui, {
  __index = function(t, k)
    rawset(t, k, require('vim.ui')[k])
    return rawget(t, k)
  end,
})
