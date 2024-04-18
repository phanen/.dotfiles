return {
  'akinsho/toggleterm.nvim',
  keys = { '<c-\\>', '<leader><c-\\>' },
  opts = {
    open_mapping = '<c-\\>',
    direction = 'float',
    shell = '/bin/fish',
    float_opts = {
      height = function() return math.floor(vim.o.lines * 0.90) end,
      width = function() return math.floor(vim.o.columns * 0.95) end,
      border = 'rounded',
    },
    -- autochdir = false,
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)
    local Terminal = require('toggleterm.terminal').Terminal
    -- not work
    -- map('n', '<leader><esc>', function()
    map('n', '<leader><c-\\>', function()
      local bufname = vim.api.nvim_buf_get_name(0)
      bufname = vim.fn.resolve(bufname)
      local root = u.gitroot(bufname)
      if not _TERM_LIST then _TERM_LIST = {} end
      local term = _TERM_LIST[root]
      if not term then
        -- get a shell after quit lazygit?
        term = Terminal:new {
          cmd = 'lazygit',
          dir = root,
          hidden = true,
          on_open = function()
            map('t', '<c-\\>', function() term:toggle() end, { buffer = true })
            -- since forgettable (luckily there's no binding for lazygit using 'q')
            map('t', 'q', '<c-\\>', { remap = true, buffer = true })
          end,
        }
        _TERM_LIST[root] = term
      end
      term:toggle()
    end)
  end,
}
