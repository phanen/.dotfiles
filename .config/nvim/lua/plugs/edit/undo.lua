return {
  {
    'jiaoshijie/undotree',
    cond = false,
    main = 'undotree',
    name = 'undotree-nvim',
    opts = true,
  },
  {
    'mbbill/undotree',
    cond = true,
    cmd = 'UndotreeToggle',
    keys = { { '+u', '<Cmd>UndotreeToggle<CR>' } },
    config = function()
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_HelpLine = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      -- vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = math.min(math.floor(vim.go.columns), 25)
      vim.g.undotree_TreeNodeShape = '◦'
      vim.g.undotree_WindowLayout = 2
    end,
  },
  {
    'kevinhwang91/nvim-fundo',
    cond = true,
    event = { 'BufReadPre' },
    dependencies = 'kevinhwang91/promise-async',
    build = function() require('fundo').install() end,
    opts = {},
  },
}
