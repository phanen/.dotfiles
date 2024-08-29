-- credit to https://www.reddit.com/r/neovim/comments/18d6yb6/use_the_builtin_listchars_option_to_implement
-- TODO: this still break on empty
-- TODO: try mini.indnetation

local o = vim.o

-- stylua: ignore start
o.expandtab   = true -- use space (`:retab!` to swap space and tabs)
o.shiftwidth  = 0    -- (auto)indent's width (follow `ts`)
o.softtabstop = 0    -- inserted tab's width (follow `sw`)
o.tabstop     = 2    -- tab's (shown) width, also for spaces count in `:retab`
-- stylua: ignore end

local idl = '|'
o.list = true
o.listchars = 'trail:•,extends:#,nbsp:.,precedes:❮,extends:❯,tab:› ,leadmultispace:'
  .. idl
  .. '  '

-- update vim options by lua table
local update_option = function(lcs, tbl)
  for k, v in pairs(tbl) do
    if lcs:match(k) then
      lcs = lcs:gsub('(' .. k .. ':)[^,]*', '%1' .. v)
    else
      lcs = lcs .. ',' .. k .. ':' .. v
    end
  end
  return lcs
end

local update_idl = function(is_local)
  local lcs = vim.o.listchars
  if vim.o.et then
    local sw = vim.o.sw == 0 and vim.o.ts or vim.o.sw
    lcs = update_option(lcs, { tab = '› ', leadmultispace = idl .. (' '):rep(sw - 1) })
  else
    lcs = update_option(lcs, { tab = idl .. ' ', leadmultispace = '␣' })
  end

  local opts = {}
  if is_local then opts.scope = 'local' end
  api.nvim_set_option_value('listchars', lcs, opts)
end

local group = ag('indent_line', { clear = true })

autocmd('OptionSet', {
  group = group,
  pattern = { 'shiftwidth', 'expandtab', 'tabstop' },
  callback = function() update_idl(vim.v.option_type == 'local') end,
})

autocmd('BufEnter', {
  group = group,
  callback = function() update_idl(true) end,
})
