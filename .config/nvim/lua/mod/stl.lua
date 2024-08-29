local M = {}
local groupid = ag('StatusLine', { clear = true })

local diag_signs_default_text = { 'E', 'W', 'I', 'H' }

local diag_severity_map = {
  [1] = 'ERROR',
  [2] = 'WARN',
  [3] = 'INFO',
  [4] = 'HINT',
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  HINT = 4,
}

---@param severity integer|string
---@return string
local function get_diag_sign_text(severity)
  local diag_config = vim.diagnostic.config()
  local signs_text = diag_config
    and diag_config.signs
    and type(diag_config.signs) == 'table'
    and diag_config.signs.text
  return signs_text and (signs_text[severity] or signs_text[diag_severity_map[severity]])
    or (diag_signs_default_text[severity] or diag_signs_default_text[diag_severity_map[severity]])
end

-- stylua: ignore start
local modes = {
  ['n']      = 'NO',
  ['no']     = 'OP',
  ['nov']    = 'OC',
  ['noV']    = 'OL',
  ['no\x16'] = 'OB',
  ['\x16']   = 'VB',
  ['niI']    = 'IN',
  ['niR']    = 'RE',
  ['niV']    = 'RV',
  ['nt']     = 'NT',
  ['ntT']    = 'TM',
  ['v']      = 'VI',
  ['vs']     = 'VI',
  ['V']      = 'VL',
  ['Vs']     = 'VL',
  ['\x16s']  = 'VB',
  ['s']      = 'SE',
  ['S']      = 'SL',
  ['\x13']   = 'SB',
  ['i']      = 'IN',
  ['ic']     = 'IC',
  ['ix']     = 'IX',
  ['R']      = 'RE',
  ['Rc']     = 'RC',
  ['Rx']     = 'RX',
  ['Rv']     = 'RV',
  ['Rvc']    = 'RC',
  ['Rvx']    = 'RX',
  ['c']      = 'CO',
  ['cv']     = 'CV',
  ['r']      = 'PR',
  ['rm']     = 'PM',
  ['r?']     = 'P?',
  ['!']      = 'SH',
  ['t']      = 'TE',
}
-- stylua: ignore end

---Get string representation of the current mode
---@return string
M.mode = function()
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  local mode = fn.mode()
  local mode_str = (mode == 'n' and (vim.bo.ro or not vim.bo.ma)) and 'RO' or modes[mode]
  return u.stl.hl(string.format(' %s ', mode_str), hl) .. ' '
end

---Get diff stats for current buffer
---@return string
M.gitdiff = function()
  local diff = vim.b.gitsigns_status_dict or u.git.diffstat()
  local added = diff.added or 0
  local changed = diff.changed or 0
  local removed = diff.removed or 0
  if added == 0 and removed == 0 and changed == 0 then return '' end
  return string.format(
    '+%s~%s-%s',
    u.stl.hl(tostring(added), 'StatusLineGitAdded'),
    u.stl.hl(tostring(changed), 'StatusLineGitChanged'),
    u.stl.hl(tostring(removed), 'StatusLineGitRemoved')
  )
end

---Get string representation of current git branch
---@return string
M.branch = function()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head or u.git.branch()
  return branch == '' and '' or '#' .. branch
end

---Get current filetype
---@return string
M.ft = function() return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper) end

---@return string
M.wordcount = function()
  local words, wordcount = 0, nil
  if vim.b.wc_words and vim.b.wc_changedtick == vim.b.changedtick then
    words = vim.b.wc_words
  else
    wordcount = fn.wordcount()
    words = wordcount.words
    vim.b.wc_words = words
    vim.b.wc_changedtick = vim.b.changedtick
  end
  local vwords = fn.mode():find('^[vsVS\x16\x13]') and (wordcount or fn.wordcount()).visual_words
  return words == 0 and ''
    or (vwords and vwords > 0 and vwords .. '/' or '')
      .. words
      .. (words > 1 and ' words' or ' word')
end

---Text filetypes
---@type table<string, true>
local ft_text = {
  [''] = true,
  ['tex'] = true,
  ['markdown'] = true,
  ['text'] = true,
}

---Additional info for the current buffer enclosed in parentheses
---@return string
M.info = function()
  if vim.bo.bt ~= '' then return '' end
  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= '' then table.insert(info, section) end
  end
  add_section(M.ft())
  if ft_text[vim.bo.ft] and not vim.b.bigfile then add_section(M.wordcount()) end
  add_section(M.branch())
  add_section(M.gitdiff())
  local ret = vim.tbl_isempty(info) and '' or string.format('(%s) ', table.concat(info, ', '))
  -- vim.print(ret)
  return ret
end

autocmd('DiagnosticChanged', {
  group = groupid,
  desc = 'Update diagnostics cache for the status line.',
  callback = function(info)
    local b = vim.b[info.buf]
    local diag_cnt_cache = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(info.data.diagnostics) do
      diag_cnt_cache[diagnostic.severity] = diag_cnt_cache[diagnostic.severity] + 1
    end
    b.diag_str_cache = nil
    b.diag_cnt_cache = diag_cnt_cache
  end,
})

---Get string representation of diagnostics for current buffer
---@return string
M.diag = function()
  if vim.b.diag_str_cache then return vim.b.diag_str_cache end
  local str = ''
  local buf_cnt = vim.b.diag_cnt_cache or {}
  for serverity_nr, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local cnt = buf_cnt[serverity_nr] or 0
    if cnt > 0 then
      local icon_text = get_diag_sign_text(serverity_nr)
      local icon_hl = 'StatusLineDiagnostic' .. severity
      str = str .. (str == '' and '' or ' ') .. u.stl.hl(icon_text, icon_hl) .. cnt
    end
  end
  if str:find('%S') then str = str .. ' ' end
  vim.b.diag_str_cache = str
  return str
end

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms
local spinner_timer = uv.new_timer()

local spinner_icons ---@type string[]
local spinner_icon_done ---@type string

if vim.g.no_nf then
  spinner_icon_done = '[done]'
  spinner_icons = {
    '[    ]',
    '[=   ]',
    '[==  ]',
    '[=== ]',
    '[ ===]',
    '[  ==]',
    '[   =]',
  }
else
  spinner_icon_done = vim.trim(u.static.icons().Ok)
  spinner_icons = {
    '⠋',
    '⠙',
    '⠹',
    '⠸',
    '⠼',
    '⠴',
    '⠦',
    '⠧',
    '⠇',
    '⠏',
  }
end

---Id and additional info of language servers in progress
---@type table<integer, { name: string, timestamp: integer, type: 'begin'|'report'|'end' }>
local server_info_in_progress = {}

autocmd('LspProgress', {
  desc = 'Update LSP progress info for the status line.',
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(
        spinner_progress_keep,
        spinner_progress_keep,
        vim.schedule_wrap(vim.cmd.redrawstatus)
      )
    end

    local id = info.data.client_id
    local now = uv.now()
    server_info_in_progress[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data.result and info.data.result.value.kind,
    } -- Update LSP progress data
    -- Clear client message after a short time if no new message is received
    vim.defer_fn(function()
      -- No new report since the timer was set
      local last_timestamp = (server_info_in_progress[id] or {}).timestamp
      if not last_timestamp or last_timestamp == now then
        server_info_in_progress[id] = nil
        if vim.tbl_isempty(server_info_in_progress) and spinner_timer then spinner_timer:stop() end
        vim.cmd.redrawstatus()
      end
    end, spinner_end_keep)
  end,
})

---@return string
M.lsp_progress = function()
  if vim.tbl_isempty(server_info_in_progress) then return '' end

  local buf = api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info_in_progress) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then return '' end

  local now = uv.now()
  ---@return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed
      or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if #server_ids == 1 and server_info_in_progress[server_ids[1]].type == 'end' then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done
    end
  else
    local spinner_icon_progress =
      spinner_icons[math.ceil(now / spinner_progress_keep) % #spinner_icons + 1]
    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    '%s %s ',
    table.concat(
      vim.tbl_map(function(id) return server_info_in_progress[id].name end, server_ids),
      ', '
    ),
    vim.b.spinner_icon
  )
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = [[%=]],
  diag         = [[%{%v:lua.require'mod.stl'.diag()%}]],
  fname        = [[%{%&bt==#''?'%t':(&bt==#'terminal'?'[Terminal] '.bufname()->substitute('^term://.\{-}//\d\+:\s*','',''):'%F')%} ]],
  info         = [[%{%v:lua.require'mod.stl'.info()%}]],
  lsp_progress = [[%{%v:lua.require'mod.stl'.lsp_progress()%}]],
  mode         = [[%{%v:lua.require'mod.stl'.mode()%}]],
  padding      = [[ ]],
  pos          = [[%{%&ru?"%l:%c ":""%}]],
  truncate     = [[%<]],
}
-- stylua: ignore end

local stl = table.concat {
  components.mode,
  components.fname,
  components.info,
  components.align,
  components.truncate,
  components.lsp_progress,
  components.diag,
  components.pos,
}

local stl_nc = table.concat {
  components.padding,
  components.fname,
  components.align,
  components.truncate,
  components.pos,
}

---Get statusline string
---@return string
M.get = function() return vim.g.statusline_winid == api.nvim_get_current_win() and stl or stl_nc end

autocmd({ 'FileChangedShellPost', 'DiagnosticChanged', 'LspProgress' }, {
  group = groupid,
  command = 'redrawstatus',
  -- command = 'sil! redrawstatus',
})

---Set default highlight groups for statusline components
---@return  nil
local function set_default_hlgroups()
  local default_attr = u.hl.get(0, {
    name = 'StatusLine',
    link = false,
    winhl_link = false,
  })

  ---@param hlgroup_name string
  ---@param attr table
  ---@return nil
  local function sethl(hlgroup_name, attr)
    local merged_attr = vim.tbl_deep_extend('keep', attr, default_attr)
    u.hl.set_default(0, hlgroup_name, merged_attr)
  end
  sethl('StatusLineGitAdded', { fg = 'GitSignsAdd' })
  sethl('StatusLineGitChanged', { fg = 'GitSignsChange' })
  sethl('StatusLineGitRemoved', { fg = 'GitSignsDelete' })
  sethl('StatusLineDiagnosticHint', { fg = 'DiagnosticSignHint' })
  sethl('StatusLineDiagnosticInfo', { fg = 'DiagnosticSignInfo' })
  sethl('StatusLineDiagnosticWarn', { fg = 'DiagnosticSignWarn' })
  sethl('StatusLineDiagnosticError', { fg = 'DiagnosticSignError' })
  sethl('StatusLineHeader', { fg = 'TabLine', bg = 'fg', reverse = true })
  sethl('StatusLineHeaderModified', {
    fg = 'Special',
    bg = 'fg',
    reverse = true,
  })
end

set_default_hlgroups()

autocmd('ColorScheme', {
  group = groupid,
  callback = set_default_hlgroups,
})

return M
