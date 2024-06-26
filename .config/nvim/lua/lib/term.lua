local M = {}

---Check if any of the processes in terminal buffer `buf` is a TUI app
---@param buf integer? buffer handler
---@return boolean?
M.running_tui = function(buf)
  local proc_cmds = M.proc_cmds(buf)
  for _, cmd in ipairs(proc_cmds) do
    if
      fn.match(
        cmd,
        '\\v^(sudo(\\s+--?(\\w|-)+((\\s+|\\=)\\S+)?)*\\s+)?(/usr/bin/)?(n?vim?|vimdiff|emacs(client)?|lem|nano|helix|kak|lazygit|fzf|nmtui|sudoedit|ssh)'
      ) >= 0
    then
      return true
    end
  end
end

---Get list of commands of the processes running in the terminal
---@param buf integer? terminal buffer handler, default to 0 (current)
---@return string[]: process names
M.proc_cmds = function(buf)
  buf = buf or 0
  if not api.nvim_buf_is_valid(buf) or vim.bo[buf].bt ~= 'terminal' then return {} end
  local channel = vim.bo[buf].channel
  local chan_valid, pid = pcall(fn.jobpid, channel)
  if not chan_valid then return {} end
  return vim.split(fn.system('ps h -o args -g ' .. pid), '\n', {
    trimempty = true,
  })
end

return M
