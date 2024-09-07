---@diagnostic disable: duplicate-set-field

-- vim.g.has_11 = vim.fn.has('nvim-0.11') == 1
-- vim.g.has_10 = vim.fn.has('nvim-0.10') == 1

-- no vim.iter, just drop it, use flake
local get_parser = vim.treesitter.get_parser
vim.treesitter.get_parser = function(bufnr, lang, opts)
  if bufnr == nil or bufnr == 0 then bufnr = api.nvim_get_current_buf() end
  -- TODO: better way to disable treesitter
  -- if vim.bo[bufnr].ft == 'tex' or api.nvim_buf_line_count(bufnr) > 10000 then
  --   error('skip treesitter for large buf')
  -- end
  return get_parser(bufnr, lang, opts)
end

-- FIXME(upstream): https://github.com/LuaLS/lua-language-server/issues/2451
-- note: this patch not work for fzf-lua
--   since it rewrite its own `localtion_handler`
--   and use `vim.lsp.utils.locations_to_items` item by item
local locations_to_items = vim.lsp.util.locations_to_items
vim.lsp.util.locations_to_items = function(locations, offset_encoding)
  local lines = {}
  local new_locations = {}
  for _, loc in ipairs(locations) do
    local uri = loc.uri or loc.targetUri
    local range = loc.range or loc.targetSelectionRange
    if not lines[uri .. range.start.line] then
      new_locations[#new_locations + 1] = loc
      lines[uri .. range.start.line] = true
    end
  end
  return locations_to_items(new_locations, offset_encoding)
end

-- TODO: (^I -> \t) for error message
-- use https://github.com/neovim/neovim/issues/26466
-- vim.notify = function(msg, level, opts) -- luacheck: no unused args
--   if level == vim.log.levels.ERROR then
--     vim.api.nvim_err_writeln(msg)
--     -- vim.api.nvim_echo({ { msg, 'Error' } }, true, {})
--   elseif level == vim.log.levels.WARN then
--     vim.api.nvim_echo({ { msg, 'WarningMsg' } }, true, {})
--   else
--     vim.api.nvim_echo({ { msg } }, true, {})
--   end
-- end

-- print(rawget(vim, 'ui'))
vim.ui.select = u.lazy_req('fzf-lua.providers.ui_select').ui_select
vim.ui.input = u.lazy_req('mod.x.ui_input').input

-- vim.text = u.lazy_req('mod.x.text')

-- handle error when use bufferline.nvim with `swapfile=true`
-- local nvim_set_current_buf = api.nvim_set_current_buf
-- api.nvim_set_current_buf = function(id)
--   xpcall(
--     function() nvim_set_current_buf(id) end,
--     vim.schedule_wrap(function(err)
--       if err:match('Vim:E325: ATTENTION') then vim.cmd.edit(vim.api.nvim_buf_get_name(id)) end
--     end)
--   )
-- end

vim.tbl_add_reverse_lookup = function(o)
  for _, k in ipairs(vim.tbl_keys(o)) do
    local v = o[k]
    if o[v] then
      error(
        string.format(
          'The reverse lookup found an existing value for %q while processing key %q',
          tostring(v),
          tostring(k)
        )
      )
    end
    o[v] = k
  end
  return o
end

if false then
  vim.validate = function(...) end
  vim.deprecate = function() end
end
