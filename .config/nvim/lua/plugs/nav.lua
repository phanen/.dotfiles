return {
  {
    -- https://github.com/akinsho/bufferline.nvim/issues/196
    'akinsho/bufferline.nvim',
    -- version = '*',
    cond = true,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    cmd = { 'BufferLineMovePrev', 'BufferLineMoveNext' },
    opts = {
      options = {
        tab_size = 10,
        enforce_regular_tabs = false,
        show_buffer_close_icons = false,
        hover = { enabled = false },
        offsets = {
          { filetype = 'NvimTree', text = 'NvimTree', text_align = 'center' },
          { filetype = 'undotree', text = 'UNDOTREE', text_align = 'center' },
        },
      },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    cond = false,
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
    dependencies = { { 'parsifa1/nvim-web-devicons' } },
  },
  {
    'phanen/dirstack.nvim',
    event = 'DirchangedPre',
    keys = {
      { ' <c-p>', "<cmd>lua require('dirstack').prev()<cr>" },
      { ' <c-n>', "<cmd>lua require('dirstack').next()<cr>" },
      { ' <c-l>', "<cmd>lua require('dirstack').hist()<cr>" },
    },
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        should_preview_cb = function(bufnr, _)
          local bufname = api.nvim_buf_get_name(bufnr)
          local fsize = fn.getfsize(bufname)
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
      { 'n',  [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]] },
      { 'N',  [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]] },
      { '*',  [[*<cmd>lua require('hlslens').start()<cr>]],                                        { remap = true } },
      { '#',  [[#<cmd>lua require('hlslens').start()<cr>]] },
      { 'g*', [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { 'g#', [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        '<esc>',
        function()
          vim.cmd.noh()
          require('hlslens').stop()
          api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
}
