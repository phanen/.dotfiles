local Im = {}

local fcitx_cmd = fn.executable('fcitx5-remote') == 1 and 'fcitx5-remote'
  or fn.executable('fcitx-remote') == 1 and 'fcitx-remote'
if not fcitx_cmd then return end

-- This is how it works:
-- - vim.b[{buf}].__im_restore is set when the input method is temporarily
--   disabled for the buffer {buf} and should be restored when entering
--   'input modes' (*).
-- - g.__im_input_enter records the last buffer where we entered
--   'input modes'.
--
-- When we enter 'input modes', flag `g.__im_input_enter` is set to
-- `<abuf>`, and if `__im_restore` is set for `<abuf>`, we clear it and
-- restore/activate the input method.
--
-- When we leave 'input modes', we check if input method is activated, and if
-- so, we disable it and set `__im_restore` for buffer recorded in
-- `__im_input_enter`. Notice that `__im_input_enter` is not necessarily the
-- same as `<abuf>` or current buffer, e.g. when we enter an normal buffer in
-- a normal window from a terminal buffer in terminal window using a key
-- mapped to `<Cmd>wincmd h/j/k/l/...<CR>`, we switch to non-input mode
-- (normal mode) from input mode (terminal mode) AFTER entering the normal
-- buffer, however, we want to set `__im_restore` flag for the terminal
-- buffer instead of the current (normal) buffer. That's why we need to
-- keep track of the last buffer where we entered 'input modes' in
-- `__im_input_enter`.
--
-- (*) 'input modes' are modes where the input method should be activated,
-- including insert mode, replace mode, terminal mode, select mode, and
-- command mode when command type is '/', '?', '@', or '-'.
-- Notice that command mode when command type is ':', '>', or '=' is not
-- considered as input modes, because in these cases one will not want to
-- insert CJK, even if the input method is activated in the current buffer.

---Check if we are in 'input modes'.
---@return boolean
local function inside_input_mode()
  local mode = fn.mode()
  return (mode:find('^[itRss\x13]') or mode:find('^c') and fn.getcmdtype():find('[/?@-]')) and true
    or false
end

---Callback to invoke when (possibly) enter input mode
---@param buf integer buffer handler
---@return nil
local function input_mode_enter_callback(buf)
  if not inside_input_mode() then return end
  g.__im_input_enter = buf
  if vim.b[buf].__im_restore then
    vim.b[buf].__im_restore = nil
    vim.system { fcitx_cmd, '-o' }
  end
end

---Callback to invoke when (possibly) leave input mode
---@param buf integer handler
---@return nil
local function input_mode_leave_callback(buf)
  if inside_input_mode() then return end
  vim.system({ fcitx_cmd }, {}, function(obj)
    if obj.code ~= 0 or tonumber(obj.stdout) == 2 then
      vim.system { fcitx_cmd, '-c' }
      -- `g.__im_input_enter` may not be set, in which case it
      -- should just be the current buffer
      g.__im_input_enter = g.__im_input_enter or buf
      vim.schedule(function()
        if api.nvim_buf_is_valid(g.__im_input_enter) then
          vim.b[g.__im_input_enter].__im_restore = true
        end
      end)
    end
  end)
end

local buf = api.nvim_get_current_buf()
input_mode_leave_callback(buf)
input_mode_enter_callback(buf)

local i = map.i
local c = map.c

Im.setup = function()
  u.aug.im = {
    'ModeChanged',
    {
      pattern = '*:[ictRss\x13]*',
      callback = function(info) input_mode_enter_callback(info.buf) end,
    },
    'ModeChanged',
    {
      pattern = '[ictRss\x13]*:*',
      callback = function(info) input_mode_leave_callback(info.buf) end,
    },
  }

  i['<down>'] = '<cmd>norm! g<down><cr>'
  i['<up>'] = '<cmd>norm! g<up><cr>'

  i['<c-f>'] = '<right>'
  i['<c-b>'] = '<left>'
  i['<c-a>'] = u.rl.dwim_beginning_of_line
  i['<c-e>'] = '<end>'
  i['<c-j>'] = u.rl.forward_word
  i['<c-o>'] = u.rl.backward_word
  i['<c-l>'] = u.rl.kill_word
  i['<c-k>'] = u.rl.kill_line
  i['<c-u>'] = u.rl.dwim_backward_kill_line
  i['<c-bs>'] = '<c-w>'

  for _, char in ipairs { ' ', '-', '_', ':', '.', '/' } do
    i.expr[char] = function()
      if fn.reg_executing() ~= '' or fn.reg_recording() ~= '' then return char end
      return char .. '<c-g>u'
    end
  end

  i['<c-x>f'] = function() return u.pick.complete_file() end
  i['<c-x>l'] = function() return u.pick.complete_bline() end
  i['<c-x>p'] = function() return u.pick.complete_path() end

  c['<c-p>'] = '<up>'
  c['<c-n>'] = '<down>'
  c['<c-f>'] = '<right>'
  c['<c-b>'] = '<left>'
  c['<c-a>'] = u.rl.dwim_beginning_of_line
  c['<c-e>'] = '<end>'
  c['<c-d>'] = '<del>'
  c['<c-j>'] = u.rl.forward_word
  c['<c-o>'] = u.rl.backward_word
  c['<c-l>'] = u.rl.kill_word
  c['<c-k>'] = u.rl.kill_line
  c['<c-u>'] = u.rl.dwim_backward_kill_line
  c['<c-bs>'] = '<c-w>'
end

return Im
