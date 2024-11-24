if g.pm_loaded then goto spec_start end
g.pm_loaded = true

if not uv.fs_stat(g.lazy_path) then
  fn.system { 'git', 'clone', '--branch=stable', 'https://github.com/folke/lazy.nvim', g.lazy_path }
end
vim.opt.rtp:prepend(g.lazy_path)
vim.opt.rtp:append(g.docs_path) -- cache docs (must before lazy.nvim setup)

u.aug['u/lazy_patch'] = {
  'User',
  {
    pattern = { 'LazyInstall*', 'LazyUpdate*', 'LazySync*', 'LazyRestore*' },
    callback = function(ev) return u.misc.lazy_patch_autocmd(ev) end,
  },
}

require('lazy').setup {
  -- lazy.nvim will cleanup state before load plugins, no worry about the recursion
  spec = { import = 'pm' },
  lockfile = g.lock_path,
  defaults = { lazy = true },
  ui = { size = { height = 0.8, width = 0.95 }, border = g.border, backdrop = 100 },
  change_detection = { enabled = false, notify = false },
  git = { filter = false }, -- git blame
  install = { colorscheme = { 'tokyonight' } },
  dev = {
    path = g.dev_path,
    patterns = { 'phanen' },
    fallback = true,
  },
  performance = {
    rtp = {
      reset = false, -- override rtp or not
      disabled_plugins = {
        -- 'fzf', -- problem: this is disable by name (not by path...)
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'nightfox',
        'osc52',
        'rplugin',
        'shada',
        'spellfile',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

::spec_start::
--- AUTO GENERATED
return {
  { import = 'plugs.aerial' },
  { import = 'plugs.cmp' },
  { import = 'plugs.conform' },
  { import = 'plugs.context' },
  { import = 'plugs.copilot' },
  { import = 'plugs.deps' },
  { import = 'plugs.edit.autopair' },
  { import = 'plugs.edit.autotag' },
  { import = 'plugs.edit.dial' },
  { import = 'plugs.edit.hlslen' },
  { import = 'plugs.edit.matchup' },
  { import = 'plugs.edit.multicursor' },
  { import = 'plugs.edit.surround' },
  { import = 'plugs.edit.treesj' },
  { import = 'plugs.edit.ts-textobj' },
  { import = 'plugs.edit.undo' },
  { import = 'plugs.fidget' },
  { import = 'plugs.flatten' },
  { import = 'plugs.flog' },
  { import = 'plugs.fugitive' },
  { import = 'plugs.fundo' },
  { import = 'plugs.fzf' },
  { import = 'plugs.gitsigns' },
  { import = 'plugs.lang' },
  { import = 'plugs.lint' },
  { import = 'plugs.neogen' },
  { import = 'plugs.nvim-bqf' },
  { import = 'plugs.snip' },
  { import = 'plugs.tree' },
  { import = 'plugs.which-key' },
}
