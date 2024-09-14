return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cond = true,
    opts = {
      -- FIXME: not work
      library = {
        -- { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { 'luvit-meta/library' },
      },
      enabled = function(root_dir)
        -- NOTE: in this way we also don't lazy load .dotfile now (since we've used global notations in `set.lua`)
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
  { 'folke/neodev.nvim', cond = false, ft = 'lua', opts = {} }, -- buggy
}
