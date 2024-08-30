local nvim_root = vim.fs.joinpath(env.HOME, 'b/neovim')

local function setup_neovim_local_formatter()
  -- arch upstream may ood (not support new features in cfg), so we perfer bundled
  local uncrustify_bin = vim.fs.joinpath(nvim_root, 'build/usr/bin/uncrustify')
  if fn.executable(uncrustify_bin) == 0 then
    uncrustify_bin = 'uncrustify' -- PATH as fallback
    if fn.executable(uncrustify_bin) == 0 then return end
  end

  -- unset lsp preset to make `formatprg` work
  vim.bo.formatexpr = ''
  vim.bo.formatprg = ('%s -q -l C -c %s'):format(uncrustify_bin, nvim_root .. '/src/uncrustify.cfg')
  require('fidget').notify('uncrustify attached')
end

-- TODO: g[did_my_ft .. vim.bo.ft]/ftdetect/autocmd once(work at first time)
if u.git.root() == nvim_root then setup_neovim_local_formatter() end
