local Is = {}

Is.win_float = function(win) return win and assert(api.nvim_win_get_config(win)).relative ~= '' end
Is.win_valid = function(win) return win and api.nvim_win_is_valid(win) end
Is.buf_valid = function(buf) return buf and api.nvim_buf_is_loaded(buf) end

Is.has_ts = function(buf) return (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft)) end
Is.has_lsp = function(buf) return #vim.lsp.get_clients { bufnr = buf } ~= 0 end

Is.nvim_local_build = function()
  return fn.isdirectory(g.nvim_root) == 1 and g.nvim_root == fs.root(vim.v.progpath, '.git')
end

return Is
