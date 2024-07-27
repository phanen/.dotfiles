local toggle_lazygit = function()
  local Terminal = require('toggleterm.terminal').Terminal
  local root = u.git.root { follow_symlinks = true }
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
        map('t', '<c-`>', function() term:toggle() end, { buffer = true })
        -- since forgettable (no 'q' binding for lazygit)
        map('t', 'q', '<c-\\>', { remap = true, buffer = true })
        map('t', 'q', '<c-`>', { remap = true, buffer = true })
      end,
    }
    _TERM_LIST[root] = term
  end
  term:toggle()
end

return {
  {
    'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    keys = {
      { '<leader><c-\\>', toggle_lazygit },
      { '<leader><c-`>', toggle_lazygit },
      -- not work '<leader><esc>'
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
  },
  { 'numToStr/FTerm.nvim', cond = false },
  {
    'voldikss/vim-floaterm', -- floating windows (no auto-resize)
    cond = false,
    keys = { { '<c-\\>', '<cmd>FloatermToggle<cr>', mode = { 'n', 't' } } },
    init = function()
      vim.g.floaterm_shell = 'fish'
      vim.g.floaterm_height = 0.9
      vim.g.floaterm_width = 0.9
    end,
    cmd = 'FloatermToggle',
    lazy = false,
  },
  {
    'willothy/flatten.nvim',
    ft = { 'toggleterm', 'terminal', 'neo-term' },
    cond = true,
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: undefined-doc-name
      ---@type Terminal?
      local saved_terminal
      require('flatten').setup {
        window = { open = 'alternate' },
        callbacks = {
          should_block = function(argv)
            vim.print(argv)
            return vim.tbl_contains(argv, '-b')
          end,
          pre_open = function()
            local term = require('toggleterm.terminal')
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              saved_terminal:close()
            else
              api.nvim_set_current_win(winnr)
            end
            if ft == 'gitcommit' or ft == 'gitrebase' then
              au('BufWritePost', {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function() api.nvim_buf_delete(bufnr, {}) end),
              })
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
  },
}
