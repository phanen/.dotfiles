local wezterm = require "wezterm"
local act = wezterm.action
local ac = wezterm.action_callback
local am = act.Multiple

-- this will auto re-run when dbus notify it
local function get_scheme()
  local appearance = wezterm.gui.get_appearance()
  if appearance:find "Light" then return "dayfox" end
  return "kitty"
end

local M = {
  font = wezterm.font_with_fallback {
    "CaskaydiaCove Nerd Font",
    "Noto Sans CJK SC",
  },
  font_size = 16.5,
  color_scheme = get_scheme(),
  default_prog = { "fish" },

  scrollback_lines = 10000,
  use_ime = true,
  check_for_updates = false,
  automatically_reload_config = false,

  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  window_background_opacity = 0.90,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",

  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = false,
}

M.color_schemes = {
  ["kitty"] = {
    foreground = "#ffffff",
    background = "#000000",
    cursor_bg = "#e0e0e0",
    cursor_fg = "#1d1f21",
    cursor_border = "#e0e0e0",
    selection_fg = "none",
    selection_bg = "rgba(255, 255, 255, 0.3)",
    scrollbar_thumb = "#222222",
    split = "#444444",
    ansi = { "#000000", "#cc0403", "#19cb00", "#cecb00", "#5f87ff", "#ba55d3", "#0dcdcd", "#dddddd" },
    brights = { "#767676", "#f2201f", "#23fd00", "#fffd00", "#0066ff", "#875faf", "#14ffff", "#ffffff" },
  },
}

local Mux = function(cond, act1, act2)
  return ac(function(window, pane)
    if cond(window, pane) then
      window:perform_action(act1, pane)
    else
      window:perform_action(act2, pane)
    end
  end)
end

local function is_nvim(_, pane) return pane:get_foreground_process_name():find "n?vim" end
local function has_selection(window, pane) return window:get_selection_text_for_pane(pane) ~= "" end
local CopySelOrExitCopy = Mux(
  has_selection,
  am { act.CopyTo "ClipboardAndPrimarySelection", act.CopyMode "ClearSelectionMode" },
  act.SendKey { mods = "CTRL", key = "c" }
)
local ClearSelOrExitCopy =
  Mux(has_selection, act.CopyMode "ClearSelectionMode", am { act.CopyMode "ClearPattern", act.CopyMode "Close" })

M.key_tables = {
  -- TODO: make copy mode much more visible
  copy_mode = {
    -- TODO: open link under enter
    { mods = "NONE", key = "Enter", action = act.CopyMode "MoveToStartOfNextLine" },
    { mods = "NONE", key = "Escape", action = ClearSelOrExitCopy },
    { mods = "SHIFT", key = "Space", action = act.CopyMode "Close" },
    { mods = "CTRL", key = "c", action = CopySelOrExitCopy },
    { mods = "NONE", key = "i", action = act.CopyMode "Close" },
    { mods = "NONE", key = "w", action = act.CopyMode "MoveForwardWord" },
    { mods = "NONE", key = "e", action = act.CopyMode "MoveForwardWordEnd" },
    { mods = "NONE", key = "b", action = act.CopyMode "MoveBackwardWord" },
    { mods = "NONE", key = "h", action = act.CopyMode "MoveLeft" },
    { mods = "NONE", key = "j", action = act.CopyMode "MoveDown" },
    { mods = "NONE", key = "k", action = act.CopyMode "MoveUp" },
    { mods = "NONE", key = "l", action = act.CopyMode "MoveRight" },
    { mods = "NONE", key = "g", action = act.CopyMode "MoveToScrollbackTop" },
    { mods = "NONE", key = "G", action = act.CopyMode "MoveToScrollbackBottom" },
    { mods = "NONE", key = "$", action = act.CopyMode "MoveToEndOfLineContent" },
    { mods = "NONE", key = "0", action = act.CopyMode "MoveToStartOfLine" },
    { mods = "NONE", key = "+", action = act.CopyMode "MoveToStartOfNextLine" },
    { mods = "NONE", key = "^", action = act.CopyMode "MoveToStartOfLineContent" },
    { mods = "NONE", key = "o", action = act.CopyMode "MoveToSelectionOtherEnd" },
    { mods = "NONE", key = "O", action = act.CopyMode "MoveToSelectionOtherEndHoriz" },
    { mods = "NONE", key = "d", action = act.CopyMode { MoveByPage = 0.5 } },
    { mods = "CTRL", key = "d", action = act.CopyMode { MoveByPage = 0.5 } },
    { mods = "NONE", key = "u", action = act.CopyMode { MoveByPage = -0.5 } },
    { mods = "CTRL", key = "u", action = act.CopyMode { MoveByPage = -0.5 } },
    { mods = "NONE", key = "H", action = act.CopyMode "MoveToViewportTop" },
    { mods = "NONE", key = "L", action = act.CopyMode "MoveToViewportBottom" },
    { mods = "NONE", key = "M", action = act.CopyMode "MoveToViewportMiddle" },
    -- TODO: support uppercase char
    { mods = "NONE", key = "f", action = act.CopyMode { JumpForward = { prev_char = false } } },
    { mods = "NONE", key = "t", action = act.CopyMode { JumpForward = { prev_char = true } } },
    { mods = "NONE", key = "F", action = act.CopyMode { JumpBackward = { prev_char = false } } },
    { mods = "NONE", key = "T", action = act.CopyMode { JumpBackward = { prev_char = true } } },
    { mods = "NONE", key = ";", action = act.CopyMode "JumpAgain" },
    { mods = "NONE", key = ",", action = act.CopyMode "JumpReverse" },
    -- TODO: invert selected color, https://github.com/wez/wezterm/issues/4257
    { mods = "NONE", key = "v", action = act.CopyMode { SetSelectionMode = "Cell" } },
    { mods = "NONE", key = "V", action = act.CopyMode { SetSelectionMode = "Line" } },
    { mods = "CTRL", key = "q", action = act.CopyMode { SetSelectionMode = "Block" } },
    {
      mods = "NONE",
      key = "y",
      action = am { act.CopyTo "ClipboardAndPrimarySelection", act.CopyMode "ClearSelectionMode" },
    },
    { mods = "NONE", key = ";", action = act.CopyMode "EditPattern" },
    {
      mods = "NONE",
      key = "/",
      action = am { act.CopyMode "ClearPattern", act.Search { CaseInSensitiveString = "" } },
    },
    { mods = "NONE", key = "n", action = act.CopyMode "NextMatch" },
    { mods = "NONE", key = "N", action = act.CopyMode "PriorMatch" },
  },

  -- TODO: change cursor color
  -- TODO: search history
  search_mode = {
    { mods = "NONE", key = "Escape", action = am { act.CopyMode "ClearPattern", act.ActivateCopyMode } },
    { mods = "CTRL", key = "c", action = act.CopyMode "Close" },
    { mods = "CTRL", key = "r", action = act.CopyMode "CycleMatchType" },
    -- TODO: line editing
    { mods = "CTRL", key = "u", action = act.CopyMode "ClearPattern" },
    { mods = "CTRL", key = "w", action = act.CopyMode "ClearPattern" },
    { mods = "NONE", key = "Enter", action = act.CopyMode "AcceptPattern" },
  },
}

M.keys = {
  { mods = "CTRL", key = "R", action = act.ReloadConfiguration },
  { mods = "SHIFT", key = "Space", action = am { act.CopyMode "ClearPattern", act.ActivateCopyMode } },
  {
    mods = "CTRL",
    key = "Space",
    -- FIXME: need toggle ?
    action = Mux(
      is_nvim,
      act.SendKey { mods = "CTRL", key = "Space" },
      am { act.CopyMode "ClearPattern", act.ActivateCopyMode }
    ),
  },
  { mods = "CTRL", key = "P", action = act.ActivateCommandPalette },
  { mods = "CTRL", key = "F", action = act.Search "CurrentSelectionOrEmptyString" },
  -- TODO: dim other text, only hi target
  {
    mods = "CTRL",
    key = "J",
    action = act.QuickSelectArgs {
      patterns = {
        [[(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})]],
        [[<([^>]+\.[^>]+)>]],
      },
      -- https://github.com/wez/wezterm/issues/1362
      action = ac(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.log_info("opening: " .. url)
        wezterm.open_with(url, os.getenv "BROWSER")
      end),
    },
  },
  { mods = "CTRL", key = "H", action = act.QuickSelect },
  { mods = "CTRL", key = "K", action = act.Search { Regex = "[a-f0-9]{6,}" } },
  { mods = "CTRL", key = "C", action = act.CopyTo "ClipboardAndPrimarySelection" },
  { mods = "CTRL", key = "v", action = act.PasteFrom "Clipboard" },
  { mods = "CTRL", key = ";", action = act.SendKey { mods = "CTRL", key = "\\" } },
  { mods = "CTRL", key = "c", action = act.SendKey { mods = "CTRL", key = "c" } },
  -- TODO: tab motion
  { mods = "CTRL", key = "{", action = act.MoveTabRelative(-1) },
  { mods = "CTRL", key = "}", action = act.MoveTabRelative(1) },
}

return M
