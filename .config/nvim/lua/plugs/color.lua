return {
  { 'rktjmp/lush.nvim', cond = true }, -- creator...
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
  {
    'NvChad/nvim-colorizer.lua',
    cond = false,
    cmd = 'ColorizerToggle',
    opts = { filetypes = { '*' }, buftypes = {} },
  },
  {
    'winston0410/range-highlight.nvim',
    cond = false,
    dependencies = { 'winston0410/cmd-parser.nvim' },
    event = 'CmdLineEnter',
    config = true,
  },
}
