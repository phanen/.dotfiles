local M = {}

M.set_fzf_lua_default_hlgroups = function()
  local hl = require('lib').hl
  local hl_norm = hl.get(0, { name = 'Normal', link = false })
  local hl_speical = hl.get(0, { name = 'Special', link = false })
  hl.set(0, 'FzfLuaBufFlagAlt', {})
  hl.set(0, 'FzfLuaBufFlagCur', {})
  hl.set(0, 'FzfLuaBufName', {})
  hl.set(0, 'FzfLuaBufNr', {})
  hl.set(0, 'FzfLuaBufLineNr', { link = 'LineNr' })
  hl.set(0, 'FzfLuaCursor', { link = 'None' })
  hl.set(0, 'FzfLuaHeaderBind', { link = 'Special' })
  hl.set(0, 'FzfLuaHeaderText', { link = 'Special' })
  hl.set(0, 'FzfLuaTabMarker', { link = 'Keyword' })
  hl.set(0, 'FzfLuaTabTitle', { link = 'Title' })
  hl.set_default(0, 'TelescopeSelection', { link = 'Visual' })
  hl.set_default(0, 'TelescopePrefix', { link = 'Operator' })
  hl.set_default(0, 'TelescopeCounter', { link = 'LineNr' })
  hl.set_default(0, 'TelescopeTitle', {
    fg = hl_norm.bg,
    bg = hl_speical.fg,
    bold = true,
  })
end

return M
