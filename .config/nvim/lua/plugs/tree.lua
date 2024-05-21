return {
  {
    'nvim-tree/nvim-tree.lua',
    cond = true,
    -- workaround for open dir
    lazy = not vim.fn.argv()[1],
    event = 'CmdlineEnter',
    cmd = { 'NvimTreeFindFileToggle' },
    keys = { 'gf', { '<leader>k', '<cmd>NvimTreeFindFileToggle<cr>' } },
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      {
        'stevearc/dressing.nvim',
        opts = {
          input = { mappings = { i = { ['<c-p>'] = 'HistoryPrev', ['<c-n>'] = 'HistoryNext' } } },
        },
      },
    },
    opts = {
      sync_root_with_cwd = true,
      actions = { change_dir = { enable = true, global = true } },
      view = {
        -- width = math.min(math.floor(vim.go.columns), 25),
        width = {
          min = function() return math.max(math.floor(vim.go.columns), 25) end,
          max = function() return math.min(math.floor(vim.go.columns), 35) end,
        },
        adaptive_size = true,
      },
      -- hijack_directories = { enable = false },
      on_attach = function(bufnr)
        local api = package.loaded['nvim-tree.api']
        api.config.mappings.default_on_attach(bufnr)
        local node_path_dir = function()
          local node = api.tree.get_node_under_cursor()
          if not node then return end
          if node.parent and node.type == 'file' then return node.parent.absolute_path end
          return node.absolute_path
        end
        local files = function() require('fzf-lua').files { cwd = node_path_dir() or vim.uv.cwd() } end
        local grep = function()
          require('fzf-lua').live_grep_native { cwd = node_path_dir() or vim.uv.cwd() }
        end
        local n = function(lhs, rhs) return map('n', lhs, rhs, { buffer = bufnr }) end
        n('h', api.node.navigate.parent)
        n('l', api.node.open.edit)
        n('o', api.tree.change_root_to_node)
        n('<c-f>', files)
        n('<c-e>', grep)
        n('gj', api.node.navigate.git.next)
        n('gk', api.node.navigate.git.prev)
      end,
    },
  },
}
