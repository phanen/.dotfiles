-- Signs
---@param opts {highlight: string, icon: string}
local function sign(opts)
  vim.fn.sign_define(opts.highlight, {
    text = opts.icon,
    texthl = opts.highlight,
    linehl = opts.highlight .. "Line",
  })
end

local error = "" -- '✗'
local warn = "" -- 
local info = "󰋼" --  ℹ 󰙎 
local hint = "󰌶" --  ⚑

sign { highlight = "DiagnosticSignError", icon = error }
sign { highlight = "DiagnosticSignWarn", icon = warn }
sign { highlight = "DiagnosticSignInfo", icon = info }
sign { highlight = "DiagnosticSignHint", icon = hint }
