return {
  'akinsho/toggleterm.nvim',
  cmd = 'ToggleTerm',
  keys = {
    {
      '<leader><c-\\>',
      -- not work
      -- '<leader><esc>'
      function()
        local Terminal = require('toggleterm.terminal').Terminal
        local bufname = vim.api.nvim_buf_get_name(0)
        bufname = vim.fn.resolve(bufname)
        local root = require('lib.util').gitroot(bufname)
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
              -- since forgettable (no 'q' binding for lazygit)
              map('t', 'q', '<c-\\>', { remap = true, buffer = true })
            end,
          }
          _TERM_LIST[root] = term
        end
        term:toggle()
      end,
    },
  },
  opts = {
    open_mapping = false,
    direction = 'float',
    shell = '/bin/fish',
    float_opts = {
      height = function() return math.floor(vim.o.lines * 0.90) end,
      width = function() return math.floor(vim.o.columns * 0.95) end,
      border = vim.g.border,
    },
    -- autochdir = false,
  },
}
