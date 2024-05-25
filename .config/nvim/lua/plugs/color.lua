return {
  { 'rktjmp/lush.nvim', cond = true }, -- creator...
  -- FIXME(upstream): error now, vim.highlight.range use getregionpos as backend
  { 'HiPhish/rainbow-delimiters.nvim', cond = false, event = { 'BufReadPre', 'BufNewFile' } },
  { 'itchyny/vim-highlighturl', cond = true, event = 'ColorScheme' },
  {
    '4e554c4c/darkman.nvim',
    cond = false,
    -- lazy = false,
    build = 'go build -o bin/darkman.nvim',
    opts = { colorscheme = { dark = vim.g.colors_name, light = 'github_light' } },
  },
  {
    'xiyaowong/transparent.nvim',
    cond = false,
    cmd = 'TransparentToggle',
    opts = {},
  },
  { 'flobilosaurus/theme_reloader.nvim', cond = false },
  {
    'NvChad/nvim-colorizer.lua',
    cond = false,
    cmd = 'ColorizerToggle',
    opts = { filetypes = { '*' }, buftypes = {} },
  },
  -- debug ex (:
  {
    'nacro90/numb.nvim',
    cond = false,
    event = 'CmdlineEnter',
    config = true,
  },
  {
    'winston0410/range-highlight.nvim',
    cond = false,
    dependencies = { 'winston0410/cmd-parser.nvim' },
    event = 'CmdLineEnter',
    config = true,
  },
}
