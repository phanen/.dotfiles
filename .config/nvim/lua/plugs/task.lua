return {
  'stevearc/overseer.nvim',
  opts = function()
    return {
      dap = false,
      form = { border = g.border },
      confirm = { border = g.border },
      task_win = { border = g.border },
      component_aliases = {
        default = {
          { 'display_duration', detail_level = 2 },
          'on_output_summarize',
          'on_exit_set_status',
          'on_complete_notify',
          'on_complete_dispose',
          'unique',
        },
      },
    }
  end,
  config = function(_, opts)
    local overseer = require 'overseer'

    overseer.setup(opts)

    do -- For lazy loading lualine component
      local success, lualine = pcall(require, 'lualine')
      if not success then return end
      local lualine_cfg = lualine.get_config()
      for i, item in ipairs(lualine_cfg.sections.lualine_x) do
        if type(item) == 'table' and item.name == 'overseer-placeholder' then
          lualine_cfg.sections.lualine_x[i] = 'overseer'
        end
      end
      lualine.setup(lualine_cfg)
    end

    local templates = {
      {
        name = 'C++ build single file',
        builder = function()
          return {
            cmd = { 'c++' },
            args = { '-g', vim.fn.expand '%:p', '-o', vim.fn.expand '%:p:t:r' },
          }
        end,
        condition = { filetype = { 'cpp' } },
      },
    }
    for _, template in ipairs(templates) do
      overseer.register_template(template)
    end
  end,
  keys = {
    { '<leader>or', '<cmd>OverseerRun<CR>', desc = 'Run' },
    { '<leader>ol', '<cmd>OverseerToggle<CR>', desc = 'List' },
    { '<leader>on', '<cmd>OverseerBuild<CR>', desc = 'New' },
    { '<leader>oa', '<cmd>OverseerTaskAction<CR>', desc = 'Action' },
    { '<leader>oi', '<cmd>OverseerInfo<CR>', desc = 'Info' },
    { '<leader>oc', '<cmd>OverseerClearCache<CR>', desc = 'Clear cache' },
  },
}
