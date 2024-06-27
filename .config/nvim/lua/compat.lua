---@diagnostic disable: duplicate-set-field

g.has_11 = fn.has('nvim-0.11') == 1
g.has_10 = fn.has('nvim-0.10') == 1

if g.has_11 then
  vim.keymap.del('n', 'grn')
  vim.keymap.del('n', 'grr')
  vim.keymap.del({ 'n', 'x' }, 'gra')
end

if g.has_10 then
  vim.keymap.del('n', '<c-w>d')
  vim.keymap.del('n', '<c-w><c-d>')
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
end

if not g.has_10 then
  vim.fs.joinpath = function(...) return (table.concat({ ... }, '/'):gsub('//+', '/')) end
  vim.keycode = function(str) return api.nvim_replace_termcodes(str, true, true, true) end
  -- no vim.iter, just drop it, use flake
end
