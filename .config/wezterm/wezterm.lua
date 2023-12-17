local wezterm = require("wezterm")
local act = wezterm.action

-- this will auto re-run when dbus notify it
local function get_scheme()
	local appearance = wezterm.gui.get_appearance()
	if appearance:find("Light") then
		-- return "dayfox"
		return "catppuccin-latte"
	end
	return "Dracula (Official)"
end

-- note: may need restart to make some changes bind work correctly
local M = {
	font = wezterm.font_with_fallback({
		"CaskaydiaCove Nerd Font",
		"Noto Sans CJK SC",
	}),
	font_size = 13.5,
	color_scheme = get_scheme(),
	default_prog = { "fish" },

	use_ime = true,
	check_for_updates = false,
	-- FIXME: not work
	automatically_reload_config = false,

	window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
	window_background_opacity = 1,
	window_decorations = "RESIZE",
	window_close_confirmation = "NeverPrompt",

	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,
}

-- wezterm show-keys --lua  &| less
M.key_tables = {
	-- PERF: need confirm-mode
	-- search_mode = {
	-- },
	-- no copy mode?
}

M.keys = {
	{ mods = "SHIFT|CTRL", key = "R",          action = act.ReloadConfiguration },

	-- modes
	{ mods = "SHIFT",      key = "Space",      action = act.ActivateCopyMode },
	{ mods = "SHIFT|CTRL", key = "phys:Space", action = act.QuickSelect },
	{ mods = "SHIFT|CTRL", key = "p",          action = act.ActivateCommandPalette },
	{ mods = "SHIFT|CTRL", key = "f",          action = act.Search("CurrentSelectionOrEmptyString") },
	-- TODO: wtf
	{ mods = "SHIFT|CTRL", key = "z",          action = act.TogglePaneZoomState },
	{ mods = "SHIFT|CTRL", key = "k",          action = act.ClearScrollback("ScrollbackOnly") },
	{ mods = "SUPER",      key = "l",          action = act.ActivateTabRelative(1) },
	{ mods = "SUPER",      key = "h",          action = act.ActivateTabRelative(-1) },
	{ mods = "SUPER",      key = "u",          action = act.SpawnTab("CurrentPaneDomain") },
	{ mods = "SHIFT|CTRL", key = "w",          action = act.CloseCurrentTab({ confirm = false }) },
	-- clipboard
	-- PERF: copy-or-interrupt
	-- { mods = "CTRL",       key = "c",          action = act.CopyTo("Clipboard") },
	{ mods = "SHIFT|CTRL", key = "c",          action = act.CopyTo("Clipboard") },
	{ mods = "CTRL",       key = "v",          action = act.PasteFrom("Clipboard") },
}

return M
