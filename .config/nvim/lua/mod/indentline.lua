-- https://www.reddit.com/r/neovim/comments/18d6yb6/use_the_builtin_listchars_option_to_implement/
-- TODO: this still break on empty
-- TODO: try mini.indnetation

vim.o.list = true

-- Set the char for the indent line
vim.g.indentline_char = '|'

-- By default I am using space style indentation and 2 spaces for it
vim.o.listchars = 'trail:•,extends:#,nbsp:.,precedes:❮,extends:❯,tab:› ,leadmultispace:'
  .. vim.g.indentline_char
  .. '  '

-- I am using tab and leadmultispace in listchars to display the indent line. The chars for tab and
-- leadmultispace should be updated based on whether the indentation has been changed.
-- * If using space as indentation: set tab to a special character for denotation and leadmultispace
-- to the indent line character followed by multiple spaces whose amounts depends on the number of
-- spaces to use in each step of indent.
-- * If using tab as indentation: set leadmultispace to a special character for denotation and tab
-- to the indent line character.

local listchars_update = function(items)
  local listchars = vim.api.nvim_get_option_value('listchars', {})
  for item, val in pairs(items) do
    if listchars:match(item) then
      listchars = listchars:gsub('(' .. item .. ':)[^,]*', '%1' .. val)
    else
      listchars = listchars .. ',' .. item .. ':' .. val
    end
  end
  return listchars
end

local function update(is_local)
  local new_listchars = ''
  if vim.api.nvim_get_option_value('expandtab', {}) then
    local spaces = vim.api.nvim_get_option_value('shiftwidth', {})
    -- When shiftwidth is 0, vim will use tabstop value
    if spaces == 0 then spaces = vim.api.nvim_get_option_value('tabstop', {}) end
    new_listchars = listchars_update({
      tab = '› ',
      leadmultispace = vim.g.indentline_char .. string.rep(' ', spaces - 1),
    })
  else
    new_listchars = listchars_update({
      tab = vim.g.indentline_char .. ' ',
      leadmultispace = '␣',
    })
  end
  local opts = {}
  if is_local then opts.scope = 'local' end
  vim.api.nvim_set_option_value('listchars', new_listchars, opts)
end

ag('indent_line', { clear = true })
au({ 'OptionSet' }, {
  group = 'indent_line',
  pattern = { 'shiftwidth', 'expandtab', 'tabstop' },
  callback = function() update(vim.v.option_type == 'local') end,
})

-- OptionSet is not triggered on startup
-- This may be not needed. The listchars has been set properly in options.vim and it will be sourced
-- on startup.
au({ 'VimEnter' }, {
  group = 'indent_line',
  callback = function() update(false) end,
})
