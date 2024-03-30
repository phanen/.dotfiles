local g, fs, fn = vim.g, vim.fs, vim.fn

-- vim.go.loadplugins = false

g.config_path = fn.stdpath('config')
g.data_path = fn.stdpath('data')
g.state_path = fn.stdpath('state')
g.cache_path = fn.stdpath('cache')

g.lazy_path = fs.joinpath(g.data_path, 'lazy')
g.docs_path = fs.joinpath(g.state_path, 'lazy', 'docs')
g.color_path = fs.joinpath(g.cache_path, 'fzf-lua', 'pack', 'fzf-lua', 'opt')
g.color_cache = vim.fs.joinpath(g.cache_path, 'colors_name')

local fd = assert(io.open(vim.g.color_cache, 'r'))
g.colors_name = fd:read('*a') or 'vim'
fd:close()

_G.r = setmetatable({}, {
  __index = function(_, k)
    return require(k)
  end,
})

if vim.fn.has('nvim-0.10') == 0 then
  return
end

---@diagnostic disable: duplicate-set-field
vim.uv = vim.uv or vim.loop
function vim.fs.joinpath(...)
  return (table.concat({ ... }, '/'):gsub('//+', '/'))
end
function vim.keycode(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
