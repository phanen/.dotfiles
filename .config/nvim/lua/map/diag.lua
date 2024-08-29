local n = map.n
n(' di', '<cmd>lua vim.diagnostic.open_float()<cr>')
n(' do', '<cmd>lua vim.diagnostic.setqflist()<cr>')
n(' dj', '<cmd>lua vim.diagnostic.goto_next()<cr>')
n(' dk', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
n(' ds', '<cmd>lua vim.diagnostic.setloclist()<cr>')
n(' dj', '<cmd>lua vim.diagnostic.jump{count = 1}<cr>')
n(' dk', '<cmd>lua vim.diagnostic.jump{count = -1}<cr>')
n(' dt', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)
