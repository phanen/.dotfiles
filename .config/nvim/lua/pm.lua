local pkg_root = g.data_path .. '/lazy'

local lazy_path = pkg_root .. '/lazy.nvim'
if not uv.fs_stat(lazy_path) then
  fn.system { 'git', 'clone', '--branch=stable', 'https://github.com/folke/lazy.nvim', lazy_path }
end
vim.opt.rtp:prepend(lazy_path)

-- a rtp for cache docs (before setup of lazy.nvim)
if not g.disable_cache_docs then
  local docs_path = fs.joinpath(g.state_path, 'lazy', 'docs')
  g.docs_path = docs_path
  vim.opt.rtp:append(docs_path)
end

-- local lz_path = pkg_root .. '/lz.n'
-- vim.opt.rtp:prepend(lz_path)
--
-- ---@type fun(name: string)
-- local pkg_load = function(basename)
--   vim.opt.rtp:prepend(pkg_root .. '/' .. basename)
--   local packname = fn.trim(basename, '.nvim')
-- end
--
-- g.lz_n = { load = pkg_load }
--
-- require('lz.n').load {
--   { 'plenary.nvim', lazy = false },
--   {
--     'telescope.nvim',
--     cmd = 'Telescope',
--     after = function() require('telescope').setup() end,
--   },
-- }

require('lazy').setup {
  spec = { import = 'plugs' },
  lockfile = g.data_path .. '/lazy-lock.json',
  defaults = {
    lazy = true,
    -- version = '*',
    cond = function(p)
      -- vscode plugins by list
      return not g.vscode
        or ({
          ['flash.nvim'] = true,
          ['readline.nvim'] = true,
        })[p.name]
    end,
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
  git = { filter = false }, -- blame it
  dev = {
    path = '~/b',
    patterns = { 'phanen' },
    fallback = true,
  },
  ui = {
    border = g.border,
    backdrop = 100,
    icons = {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
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
  install = {
    colorscheme = { 'tokyonight' },
  },
}
