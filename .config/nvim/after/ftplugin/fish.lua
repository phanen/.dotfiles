-- fish_indent
vim.bo.et = true
vim.bo.sts = 4
vim.bo.sw = 4
vim.bo.ts = 4

local funcedit = function(name)
  ---@return string?
  local guess_path = function()
    if fn.executable('fish') == 0 then return end
    local conf_dir = vim.system { 'fish', '-c', 'string split0 $__fish_config_dir' }:wait().stdout
    local func_dirs = vim.system { 'fish', '-c', 'string split0 $fish_function_path' }:wait().stdout
    assert(conf_dir and func_dirs)
    local ret = vim
      .iter(vim.gsplit(func_dirs, '\n', { trimempty = true }))
      :find(function(v) return u.fs.is_parent(conf_dir, v) end)
    return ret and fs.joinpath(ret, name)
  end
  local target_path = guess_path() or fs.joinpath(env.XDG_CONFIG_HOME, 'fish', 'functions', name)
  vim.cmd.edit(target_path)
end

u.com.FuncEdit = {
  function(opts)
    funcedit(opts.fargs[1] and (opts.fargs[1]:gsub('%.fish$', '') .. '.fish') or fn.expand('%:t'))
  end,
  nargs = '*',
}
