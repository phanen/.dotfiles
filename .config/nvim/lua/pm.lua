if env.NVIM_NO3RD then return end

local path = vim.fs.joinpath(g.data_path, 'lazy', 'lazy.nvim')
if not uv.fs_stat(path) then
  fn.system { 'git', 'clone', '--branch=stable', 'https://github.com/folke/lazy.nvim', path }
end

vim.opt.rtp:prepend(path)

if not g.disable_cache_docs then
  -- preserve a rtp for docs (note: before setup of lazy.nvim)
  local docs_path = vim.fs.joinpath(g.state_path, 'lazy', 'docs')
  g.docs_path = docs_path
  vim.opt.rtp:append(docs_path)
end

require('lazy').setup {
  spec = {
    { import = 'plugs' },
    -- { import = 'plugs.ai' },
    -- { import = 'plugs.cmp' },
    -- { import = 'plugs.coding' },
    -- { import = 'plugs.color' },
    -- { import = 'plugs.comment' },
    -- { import = 'plugs.dap' },
    -- { import = 'plugs.doc' },
    -- { import = 'plugs.edit' },
    -- { import = 'plugs.fold' },
    -- { import = 'plugs.fzf' },
    -- { import = 'plugs.git' },
    -- { import = 'plugs.key' },
    -- { import = 'plugs.lang' },
    -- { import = 'plugs.lsp' },
    -- { import = 'plugs.nav' },
    -- { import = 'plugs.outline' },
    -- { import = 'plugs.perf' },
    -- { import = 'plugs.session' },
    -- { import = 'plugs.snippet' },
    -- { import = 'plugs.substitute' },
    -- { import = 'plugs.tabline' },
    -- { import = 'plugs.task' },
    -- { import = 'plugs.term' },
    -- { import = 'plugs.tool' },
    -- { import = 'plugs.tpope' },
    -- { import = 'plugs.tree' },
    -- { import = 'plugs.ts' },
    -- { import = 'plugs.ui' },
    -- { import = 'plugs.win' },
    {
      { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
      { 'folke/lazy.nvim' },
      -- buggy in wayalnd
      -- { 'lilydjwg/fcitx.vim', cond = not env.WAYLAND_DISPLAY, event = 'InsertEnter' },
      { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },
      { 'voldikss/vim-translator', cmd = 'Translate' },
      {
        'chrishrb/gx.nvim',
        cmd = 'Browse',
        keys = { { 'gl', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
        opts = {},
      },
      { 'rktjmp/hotpot.nvim', lazy = true },
      -- { 'Konfekt/vim-select-replace', lazy = false },
      -- todo
      { 'echasnovski/mini.nvim', cond = false, version = false },
      { 'monaqa/modesearch.vim', cond = false, keys = { { 'g/', '<Plug>(modesearch-slash)' } } },
      { 'chentoast/marks.nvim', cond = false, lazy = false, opts = {} },
      -- not work?
      {
        'kevinhwang91/nvim-fundo',
        cond = false,
        event = { 'BufReadPre' },
        dependencies = 'kevinhwang91/promise-async',
        build = function() require('fundo').install() end,
        opts = {},
      },
      { 'jghauser/kitty-runner.nvim', lazy = false, cond = false, opts = {} },
    },
  },
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
    colorscheme = {
      'macro',
      'nano',
      'cockatoo',
    },
  },
}

---Lazy-load runtime files
---@param runtime string
---@param flag string
---@param event string|string[]
local _load = function(event, runtime, flag)
  if not g[flag] then
    g[flag] = 0
    au(event, {
      once = true,
      callback = function()
        g[flag] = nil
        vim.cmd.runtime(runtime)
        return true
      end,
    })
  end
end

-- _load('FileType', 'plugin/rplugin.vim', 'loaded_remote_plugins')
-- seems ported to lua now
-- _load('FileType', 'provider/python3.vim', 'loaded_python3_provider')

-- manage color by fzf-lua
local color_path = vim.fs.joinpath(g.cache_path, 'fzf-lua', 'pack', 'fzf-lua', 'opt')
g.color_path = color_path
for dir, type in vim.fs.dir(color_path) do
  if type == 'directory' then vim.opt.rtp:append(vim.fs.joinpath(color_path, dir)) end
end
