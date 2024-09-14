if g.specs_loaded then goto spec_start end
g.specs_loaded = true

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
  ui = { border = g.border, backdrop = 100 },
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
        'matchit',
        'matchparen',
        'netrwPlugin',
        'nvim',
        -- 'osc52',
        'rplugin',
        'shada',
        'spellfile',
        'tohtml',
        'tutor',
      },
    },
  },
}

::spec_start::
--- AUTO GENERATED
return {
  { import = 'plugs.aerial' },
  { import = 'plugs.cmdline-hl' },
  { import = 'plugs.cmp' },
  { import = 'plugs.conform' },
  { import = 'plugs.copilot' },
  { import = 'plugs.debugprint' },
  { import = 'plugs.deps' },
  { import = 'plugs.dropbar' },
  { import = 'plugs.edit.align' },
  { import = 'plugs.edit.autopair' },
  { import = 'plugs.edit.autosave' },
  { import = 'plugs.edit.autotag' },
  { import = 'plugs.edit.comment' },
  { import = 'plugs.edit.dial' },
  { import = 'plugs.edit.easymotion' },
  { import = 'plugs.edit.enunch' },
  { import = 'plugs.edit.highlighturl' },
  { import = 'plugs.edit.hlslen' },
  { import = 'plugs.edit.inc-rename' },
  { import = 'plugs.edit.linediff' },
  { import = 'plugs.edit.matchup' },
  { import = 'plugs.edit.modesearch' },
  { import = 'plugs.edit.multicursor' },
  { import = 'plugs.edit.rainbow-delimiters' },
  { import = 'plugs.edit.readline' },
  { import = 'plugs.edit.refactoring' },
  { import = 'plugs.edit.spell' },
  { import = 'plugs.edit.structure' },
  { import = 'plugs.edit.substitue' },
  { import = 'plugs.edit.surround' },
  { import = 'plugs.edit.textobj' },
  { import = 'plugs.edit.treesj' },
  { import = 'plugs.edit.tssorter' },
  { import = 'plugs.edit.undo' },
  { import = 'plugs.fidget' },
  { import = 'plugs.flatten' },
  { import = 'plugs.fzf' },
  { import = 'plugs.git' },
  { import = 'plugs.lang.java' },
  { import = 'plugs.lang.markup' },
  { import = 'plugs.lang.rust' },
  { import = 'plugs.lang.syntax' },
  { import = 'plugs.lang.tex' },
  { import = 'plugs.lazydev' },
  { import = 'plugs.leetcode' },
  { import = 'plugs.lint' },
  { import = 'plugs.lsp' },
  { import = 'plugs.neogen' },
  { import = 'plugs.noice' },
  { import = 'plugs.nvim-bqf' },
  { import = 'plugs.nvim-treesitter' },
  { import = 'plugs.octo' },
  { import = 'plugs.quicker' },
  { import = 'plugs.scope' },
  { import = 'plugs.task' },
  { import = 'plugs.translator' },
  { import = 'plugs.tree' },
  { import = 'plugs.which-key' },
}
