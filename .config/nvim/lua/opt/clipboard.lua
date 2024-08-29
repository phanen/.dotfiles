local o = vim.o

-- (not sure) for gui, maybe we need fallback to xsel/xclip/wl-copy
o.clipboard = 'unnamedplus'

-- TODO: paste from external
-- FIXME: osc paste error on this function
if env.SSH_TTY then
  vim.g.clipboard = {
    copy = {
      ['+'] = function(lines)
        local content = table.concat(lines, '\n')
        local encoded = vim.base64.encode(content)
        api.nvim_chan_send(2, string.format('\027]52;c;%s\027\\', encoded))
      end,
    },
    paste = {
      ['+'] = function() require('vim.ui.clipboard.osc52').paste('+')() end,
    },
  }
end
