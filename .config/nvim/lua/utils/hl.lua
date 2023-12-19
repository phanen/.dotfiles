local api = vim.api

---@alias HLAttrs {from: string, attr: "fg" | "bg", alter: integer}

---@class HLData
---@field fg string
---@field bg string
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdotted boolean
---@field underdashed boolean
---@field underdouble boolean
---@field strikethrough boolean
---@field reverse boolean
---@field nocombine boolean
---@field link string
---@field default boolean

---@class HLArgs
---@field blend integer
---@field fg string | HLAttrs
---@field bg string | HLAttrs
---@field sp string | HLAttrs
---@field bold boolean
---@field italic boolean
---@field undercurl boolean
---@field underline boolean
---@field underdotted boolean
---@field underdashed boolean
---@field underdouble boolean
---@field strikethrough boolean
---@field reverse boolean
---@field nocombine boolean
---@field link string
---@field default boolean
---@field clear boolean
---@field inherit string

local attrs = {
  fg = true,
  bg = true,
  sp = true,
  blend = true,
  bold = true,
  italic = true,
  standout = true,
  underline = true,
  undercurl = true,
  underdouble = true,
  underdotted = true,
  underdashed = true,
  strikethrough = true,
  reverse = true,
  nocombine = true,
  link = true,
  default = true,
}

---@private
---@param opts {name: string?, link: boolean?}?
---@param ns integer?
---@return HLData
local function get_hl_as_hex(opts, ns)
  ns, opts = ns or 0, opts or {}
  opts.link = opts.link ~= nil and opts.link or false
  local hl = api.nvim_get_hl(ns, opts)
  hl.fg = hl.fg and ("#%06x"):format(hl.fg)
  hl.bg = hl.bg and ("#%06x"):format(hl.bg)
  return hl
end

local err_warn = vim.schedule_wrap(function(group, attribute)
  vim.notify(string.format("failed to get highlight %s for attribute %s\n%s", group, attribute, debug.traceback()), "ERROR", {
    title = string.format("Highlight - get(%s)", group),
  }) -- stylua: ignore
end)

local function get(group, attribute, fallback)
  assert(group, "cannot get a highlight without specifying a group name")
  local data = get_hl_as_hex { name = group }
  if not attribute then return data end

  assert(attrs[attribute], ("the attribute passed in is invalid: %s"):format(attribute))
  local color = data[attribute] or fallback
  if not color then
    if vim.v.vim_did_enter == 0 then
      api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function() err_warn(group, attribute) end,
      })
    else
      vim.schedule(function() err_warn(group, attribute) end)
    end
    return "NONE"
  end
  return color
end

return {
  get = get,
}
