return {
  -- tabline
  {
    'romgrk/barbar.nvim',
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
  },
  {
    'mg979/tabline.nvim',
    cond = false,
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.o.showtabline = 2 end,
    opts = {},
    config = function(_, opts)
      local tabline = require 'tabline.setup'
      tabline.setup(opts)
      tabline.mappings(true)
    end,
  },
  {
    'nanozuki/tabby.nvim',
    cond = false,
    -- init = function() vim.o.showtabline = 2 end,
    event = { 'BufReadPre', 'BufNewFile' },
    config = true,
  },
  {
    'ThePrimeagen/harpoon',
    cond = false,
    branch = 'harpoon2',
    opts = {},
    keys = {
      { '<leader>H', function() require('harpoon'):list():add() end },
      {
        '<leader><c-h>',
        function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon quick menu',
      },
      { '<leader>1', function() require('harpoon'):list():select(1) end },
      { '<leader>2', function() require('harpoon'):list():select(2) end },
      { '<leader>3', function() require('harpoon'):list():select(3) end },
      { '<leader>4', function() require('harpoon'):list():select(4) end },
      { '<leader>5', function() require('harpoon'):list():select(5) end },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    enabled = false,
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.opt.laststatus = 0 end,
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        always_divide_middle = true,
        component_separators = { left = '', right = '' },
        -- globalstatus = true,
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            function() return vim.bo.modified and ' ' or '󰄳 ' end,
            separator = { left = '' },
            padding = 0,
          },
          { 'location', padding = 0 },
        },
        lualine_b = {
          {
            'progress',
            padding = { left = 1, right = 0 },
          },
        },
        lualine_c = {
          { 'filename', file_status = true, path = 3 },
          -- function() return vim.bo.readonly and ' ' or '' end,
          {
            'diff',
            padding = { left = 1, right = 0.5 },
            source = function() return vim.b.gitsigns_status_dict end,
          },
        },
        lualine_x = {
          function()
            local bufnr = api.nvim_get_current_buf()
            local clients = vim
              .iter(vim.lsp.get_clients())
              :filter(function(client) return client.attached_buffers[bufnr] end)
              -- :filter(function(client) return client.name ~= 'copilot' end)
              :map(
                function(client) return ' ' .. client.name end
              )
              :totable()
            local info = table.concat(clients, ' ')
            if info == '' then
              return 'No LSP server'
            else
              return info
            end
          end,
        },
        lualine_y = {
          { 'encoding', padding = 0 },
          'fileformat',
          'diagnostics',
        },
        lualine_z = {
          {
            'branch',
            icon = '',
            padding = { left = 0, right = 0 },
            separator = { left = '', right = '' },
          },
        },
      },
      extensions = {
        'aerial',
        'fugitive',
        'lazy',
        'man',
        'mason',
        -- 'neo-tree',
        -- 'nvim-dap-ui',
        'nvim-tree',
        'quickfix',
        'toggleterm',
        'trouble',
      },
    },
    dependencies = {
      { 'parsifa1/nvim-web-devicons' },
    },
  },

  -- indent line
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = false,
    event = { 'BufRead', 'BufNewFile' },
    main = 'ibl',
    opts = { scope = { enabled = true } },
  },
  {
    'shellRaining/hlchunk.nvim',
    cond = false,
    event = { 'BufRead', 'BufNewFile' },
    opts = {
      chunk = { enable = true },
      indent = { enable = true, use_treesitter = false },
      line_num = { enable = false },
      blank = { enable = false, chars = { '․' } },
    },
  },
}
