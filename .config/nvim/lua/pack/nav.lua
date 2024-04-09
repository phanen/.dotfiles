return {
  {
    'nvim-tree/nvim-tree.lua',
    -- workaround for open dir
    lazy = not vim.fn.argv()[1],
    keys = 'gf',
    event = 'CmdlineEnter',
    cmd = { 'NvimTreeFindFileToggle' },
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
      view = { adaptive_size = true },
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
        local files = function()
          require('fzf-lua').files {
            ['--history'] = vim.fn.stdpath 'state' .. '/telescope_history',
            cwd = node_path_dir() or vim.uv.cwd(),
          }
        end
        local n = function(lhs, rhs) return map('n', lhs, rhs, { buffer = bufnr }) end
        n('h', api.tree.change_root_to_parent)
        n('l', api.node.open.edit)
        n('o', api.tree.change_root_to_node)
        n('<leader><c-p>', function() require('dirstack').prev() end)
        n('<leader><c-n>', function() require('dirstack').next() end)
        n('f', files)
        n('<c-e>', '')
      end,
    },
  },
  {
    'kwkarlwang/bufjump.nvim',
    keys = {
      { '<leader><c-o>', "<cmd>lua require('bufjump').backward()<cr>" },
      { '<leader><c-i>', "<cmd>lua require('bufjump').forward()<cr>" },
    },
  },
  {
    'phanen/dirstack.nvim',
    event = 'DirChangedPre',
    keys = {
      { '<leader><c-p>', function() require('dirstack').prev() end },
      { '<leader><c-n>', function() require('dirstack').next() end },
      { '<leader><c-x>', function() require('dirstack').info() end },
    },
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        should_preview_cb = function(bufnr, _)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if bufname:match '^fugitive://' then return false end
          if fsize > 100 * 1024 then return false end
          return true
        end,
      },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      { 'n', [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]] },
      { 'N', [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]] },
      { '*', [[*<cmd>lua require('hlslens').start()<cr>]], { remap = true } },
      { '#', [[#<cmd>lua require('hlslens').start()<cr>]] },
      { 'g*', [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { 'g#', [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        '<esc>',
        function()
          vim.cmd.noh()
          require('hlslens').stop()
          vim.api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
  {
    'akinsho/bufferline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'BufferLineMovePrev', 'BufferLineMoveNext' },
    opts = {
      options = {
        show_buffer_close_icons = false,
        hover = { enabled = false },
        offsets = {
          {
            filetype = 'NvimTree',
            text = function() return vim.fn.getcwd() end,
            text_align = 'left',
          },
          { filetype = 'undotree', text = 'UNDOTREE', text_align = 'left' },
        },
      },
    },
  },
}
