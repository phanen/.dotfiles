-- 'liangxianzhe/floating-input.nvim'
local input = {}

function input.window_center(input_width)
  return {
    relative = 'win',
    row = api.nvim_win_get_height(0) / 2 - 1,
    col = api.nvim_win_get_width(0) / 2 - input_width / 2,
  }
end

function input.under_cursor(_)
  return {
    relative = 'cursor',
    row = -2,
    col = 0,
  }
end

function input.input(opts, on_confirm)
  local prompt = opts.prompt or 'Input: '
  local default = opts.default or ''

  -- calculate a minimal width with a bit buffer
  local default_width = vim.str_utfindex(default) + 10
  local prompt_width = vim.str_utfindex(prompt) + 10
  local input_width = default_width > prompt_width and default_width or prompt_width
  local default_win_config = {
    focusable = true,
    style = 'minimal',
    border = vim.g.border,
    width = input_width,
    height = 1,
    title = prompt,
  }

  local win_config = vim.tbl_deep_extend('force', default_win_config, opts.win_config or {})
  -- TODO: more smart, where to place
  win_config = vim.tbl_deep_extend('force', win_config, input.under_cursor(win_config.width))
  -- if prompt == 'New Name: ' then
  --   win_config = vim.tbl_deep_extend('force', win_config, input.under_cursor(win_config.width))
  -- else
  --   win_config = vim.tbl_deep_extend('force', win_config, input.window_center(win_config.width))
  -- end

  local bufnr = api.nvim_create_buf(false, true)

  -- TODO: fix fzf-lua
  -- TODO: autocompletion
  vim.schedule(function()
    local window = api.nvim_open_win(bufnr, true, win_config)
    api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, { default })
    -- insert then place cursor
    vim.cmd('startinsert')
    api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(default) + 1 })

    map.i('<cr>', function()
      local lines = api.nvim_buf_get_lines(bufnr, 0, 1, false)
      if lines[1] ~= default and on_confirm then on_confirm(lines[1]) end
      api.nvim_win_close(window, true)
      vim.cmd('stopinsert')
    end, { buffer = bufnr })

    map.i('<esc>', function()
      api.nvim_win_close(window, true)
      vim.cmd('stopinsert')
    end, { buffer = bufnr })
  end)
end
-- TODO: maybe restore mode
input.input = vim.schedule_wrap(input.input)

-- Deprecated. No need to call setup, will be removed soon.
function input.setup() end
return input
