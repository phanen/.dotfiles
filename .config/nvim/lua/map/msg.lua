local n = map.n
local nx = map.nx

-- n(' m;', 'g<')
n(' mk', '<cmd>messages clear<cr>')
-- n(' ml', '<cmd>1messages<cr>')
n(' ml', '<cmd>messages<cr>')
-- TODO: message is chunked, and ... paged, terrible
-- so we use a explicit "redir" wrapper now
-- TODO: toggle it
cmd('R', function(opt) u.msg.pipe_cmd(opt.args) end, {
  nargs = 1,
  complete = 'command',
})
n(' me', '<cmd>R messages<cr>')
n(' ma', u.msg.pipe_messages)

n(' mi', ('<cmd>!tail %s<cr>'):format(lsp.get_log_path()))

n(' wo', '<cmd>AerialToggle!<cr>')
n(' wi', '<cmd>LspInfo<cr>')
n(' wl', '<cmd>Lazy<cr>')
n(' wm', '<cmd>Mason<cr>')
n(' wh', '<cmd>ConformInfo<cr>')

n(' bi', '<cmd>ls<cr>')
n(' bI', '<cmd>ls!<cr>')

-- misc
n('+E', '<cmd>lua vim.treesitter.query.edit()<cr>')
n('+I', '<cmd>lua vim.treesitter.inspect_tree()<cr>')
n('+L', u.lazy.lazy_chore_update)
n(' I', '<cmd>lua vim.show_pos()<cr>')
nx(' L', ':Linediff<cr>') -- TODO: quit it

n(" '", '<cmd>marks<cr>')
n(' "', '<cmd>reg<cr>')

nx('_', 'K')
nx('K', ':Translate<cr>')

-- n('ls', function() require('lazy.util').float_cmd('ls') end)
-- function blame_line(opts)
--   opts = vim.tbl_deep_extend('force', {
--     count = 3,
--     filetype = 'git',
--     size = { width = 0.6, height = 0.6 },
--     border = g.border,
--   }, opts or {})
--   local cursor = vim.api.nvim_win_get_cursor(0)
--   local line = cursor[1]
--   local file = vim.api.nvim_buf_get_name(0)
--   local cmd = u.git { 'log', '-n', opts.count, '-u', '-L', line .. ',+5:' .. file }
--   return require('lazy.util').float_cmd(cmd, opts)
-- end

_edit_fts = function()
  local fts = require('luasnip.util.util').get_snippet_filetypes()
  vim.ui.select(fts, {
    prompt = 'Select which filetype to edit:',
  }, function(item, idx)
    if idx then vim.cmd.edit(g.config_path .. '/lua/snippets/' .. item .. '.lua') end
  end)
end

-- api.nvim_set_hl(0, '@lsp.mod.global.lua', { link = '@variable.builtin' })

_ext_mark = function()
  local bufnr = api.nvim_get_current_buf()
  local cursor = api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]
  local p = api.nvim_buf_get_extmarks(
    bufnr,
    -1,
    { row, col },
    { row, col },
    { details = true, type = 'highlight', overlap = true }
  )

  do
    local highlighter = vim.treesitter.highlighter.active[bufnr]
    if not highlighter then goto done end
    local range = { row, col, row, col }
    local ltree = highlighter.tree:language_for_range(range)
    local lang = ltree:lang()
    local query = vim.treesitter.query.get(lang, 'highlights')

    ---- vim.print(query)
    if not query then goto done end
    local tree = assert(ltree:tree_for_range(range))
    for _, match, metadata in query:iter_matches(tree:root(), bufnr, row, row + 1) do
      for id, nodes in pairs(match) do
        for _, node in ipairs(nodes) do
          if vim.treesitter.node_contains(node, range) then
            local url = metadata[id] and metadata[id].url
            vim.print(metadata)
            if url and match[url] then
              for _, n in ipairs(match[url]) do
                -- urls[#urls + 1] =
                --   vim.treesitter.get_node_text(n, bufnr, { metadata = metadata[url] })
              end
            end
          end
        end
      end
    end

    ::done::
  end
  return p
end

nx(' E', _ext_mark)
