-- https://www.reddit.com/r/neovim/comments/18d6yb6/use_the_builtin_listchars_option_to_implement/
-- TODO: this still break on empty
-- TODO: try mini.indnetation

local o = vim.o

-- stylua: ignore start
o.expandtab      = true -- use space (`:retab!` to swap space and tabs)
o.shiftwidth     = 0    -- (auto)indent's width (follow `ts`)
o.softtabstop    = 0    -- inserted tab's width (follow `sw`)
o.tabstop        = 2    -- tab's (shown) width, also for spaces count in `:retab`
-- stylua: ignore end

local indentline = '|'
o.list = true
o.listchars = 'trail:•,extends:#,nbsp:.,precedes:❮,extends:❯,tab:› ,leadmultispace:'
  .. indentline
  .. '  '

local set_lsc = function(items)
  local lsc = vim.o.listchars
  for item, val in pairs(items) do
    if lsc:match(item) then
      lsc = lsc:gsub('(' .. item .. ':)[^,]*', '%1' .. val)
    else
      lsc = lsc .. ',' .. item .. ':' .. val
    end
  end
  return lsc
end

local update = function()
  local new_listchars = ''

  -- TODO: vim.o or vim.bo (vim.wo???)
  if vim.o.expandtab then
    local sw = vim.o.shiftwidth
    if sw == 0 then sw = vim.o.tabstop end
    new_listchars = set_lsc({ tab = '› ', leadmultispace = indentline .. (' '):rep(sw - 1) })
  else
    new_listchars = set_lsc({ tab = indentline .. ' ', leadmultispace = '␣' })
  end

  -- seems empty is also global

  -- UNKOWN: cannot use it here
  -- vim.bo.listchars = new_listchars
  -- list is local
  -- but listchar is global-local?
  local opts = {}
  if vim.v.option_type == 'local' then opts.scope = 'local' end
  vim.api.nvim_set_option_value('listchars', new_listchars, opts)
  -- vim.wo.listchars = new_listchars
end

local group = ag('indent_line', { clear = true })

au({ 'OptionSet' }, {
  group = group,
  pattern = { 'shiftwidth', 'expandtab', 'tabstop' },
  callback = function(ev) update(ev.buf) end,
})

au('BufEnter', {
  group = group,
  callback = function(ev) update(ev.buf) end,
})
