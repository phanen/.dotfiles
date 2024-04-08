local path = vim.fs.joinpath(vim.g.data_path, 'lazy', 'lazy.nvim')
if not vim.uv.fs_stat(path) then
  vim.fn.system { 'git', 'clone', '--branch=stable', 'https://github.com/folke/lazy.nvim', path }
end

local stage_path = vim.fs.joinpath(vim.g.config_path, 'lua', 'pack', 'stage.lua')
local extra_sepc = {
  vim.uv.fs_stat(stage_path) and { import = 'pack.stage' } or nil,
}

vim.opt.rtp:prepend(path)

-- preserve a rtp for docs
local docs_path = vim.fs.joinpath(vim.g.state_path, 'lazy', 'docs')
vim.g.docs_path = docs_path
vim.opt.rtp:append(docs_path)

require('lazy').setup {
  spec = {
    { import = 'pack.cmp' },
    { import = 'pack.doc' },
    { import = 'pack.edit' },
    { import = 'pack.fzf' },
    { import = 'pack.git' },
    { import = 'pack.lsp' },
    { import = 'pack.misc' },
    { import = 'pack.nav' },
    { import = 'pack.ts' },
    extra_sepc,
  },
  lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
  defaults = { lazy = true },
  change_detection = { enabled = false, notify = false },
  git = { filter = false }, -- blame it
  dev = { path = '~/b', patterns = { 'phanen' }, fallback = true },
  performance = {
    rtp = {
      reset = false, -- override rtp or not
      disabled_plugins = {
        'matchit',
        'matchparen',
        'netrwPlugin',
        'nvim',
        'osc52',
        'rplugin',
        'shada',
        'spellfile',
        'tohtml',
        'tutor',
      },
    },
  },
}

-- manage color by fzf-lua
local color_path = vim.fs.joinpath(vim.g.cache_path, 'fzf-lua', 'pack', 'fzf-lua', 'opt')
vim.g.color_path = color_path
for dir, type in vim.fs.dir(color_path) do
  if type == 'directory' then vim.opt.rtp:append(vim.fs.joinpath(color_path, dir)) end
end
