return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  config = function()
    vim.g.undotree_DiffAutoOpen = 0
    vim.g.undotree_HelpLine = 0
    vim.g.undotree_SetFocusWhenToggle = 1
    -- vim.g.undotree_ShortIndicators = 1
    vim.g.undotree_SplitWidth = math.min(math.floor(vim.go.columns), 25)
    vim.g.undotree_TreeNodeShape = '◦'
    vim.g.undotree_WindowLayout = 2
  end,
}
