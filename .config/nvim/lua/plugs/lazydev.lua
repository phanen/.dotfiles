return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cond = true,
    opts = {
      library = {
        -- not work
        -- { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { 'luvit-meta/library' },
      },
      enabled = function(root_dir)
        -- hack: don't lazy load .dotfile (for some global annotations)
        return not uv.fs_stat(root_dir .. '/.luarc.jsonc')
          and not uv.fs_stat(root_dir .. '/.luarc.json')
      end,
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  -- { -- optional completion source for require statements and module annotations
  --   'hrsh7th/nvim-cmp',
  --   opts = function(_, opts)
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, {
  --       name = 'lazydev',
  --       group_index = 0, -- set group index to 0 to skip loading LuaLS completions
  --     })
  --   end,
  -- },
}
