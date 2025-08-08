--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local cs = require("utils/color_scheme")
local f = require("utils/font")
local h = require("utils/helpers")
local k = require("utils/keys")
local w = require("utils/wallpaper")
local b = require("utils/background")

local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	window_background_opacity = 0.9,

	adjust_window_size_when_changing_font_size = false,
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 333,
	animation_fps = 1, -- reduce the number of frames per second for the cursor blink animation
	cursor_blink_ease_in = "Constant",
	cursor_blink_ease_out = "Constant",

	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("CommitMono"),
	font_size = 16,

	window_padding = {
		left = 30,
		right = 30,
		top = 20,
		bottom = 10,
	},

	set_environment_variables = {
		-- THEME_FLAVOUR = "mocha",
	},

	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",

	-- keys
	keys = {
		-- enable natural text editing
		{ mods = "OPT", key = "LeftArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "b" }) },
		{ mods = "OPT", key = "RightArrow", action = wezterm.action.SendKey({ mods = "ALT", key = "f" }) },
		-- { mods  "CMD", key = "LeftArrow", action = wezterm.action.SendKey({ mods = "CTRL", key = "a" }) }, -- this is disabled because it shares the same hexcode as C-a (which is my tmux prefix)
		{ mods = "CMD", key = "RightArrow", action = wezterm.action.SendKey({ mods = "CTRL", key = "e" }) },
		{ mods = "CMD", key = "Backspace", action = wezterm.action.SendKey({ mods = "CTRL", key = "u" }) },

		k.cmd_key("q", k.multiple_actions(":qa!")),
	},
}

wezterm.on("user-var-changed", function(window, pane, name, value)
	-- local appearance = window:get_appearance()
	-- local is_dark = appearance:find("Dark")
	local overrides = window:get_config_overrides() or {}
	wezterm.log_info("name", name)
	wezterm.log_info("value", value)

	if name == "T_SESSION" then
		local session = value
		wezterm.log_info("is session", session)
		overrides.background = {
			w.set_tmux_session_wallpaper(value),
			{
				source = {
					Gradient = {
						colors = { "#000000" },
					},
				},
				width = "100%",
				height = "100%",
				opacity = 0.95,
			},
		}
	end

	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
		else
			overrides.font_size = number_value
		end
	end
	if name == "DIFF_VIEW" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.DecreaseFontSize, pane)
				number_value = number_value - 1
			end
			-- overrides.background = {
			-- 	w.set_nvim_wallpaper("Diffview.jpeg"),
			--
			-- 	{
			-- 		source = {
			-- 			Gradient = {
			-- 				colors = { "#000000" },
			-- 			},
			-- 		},
			-- 		width = "100%",
			-- 		height = "100%",
			-- 		opacity = 0.95,
			-- 	},
			-- }
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.background = nil
			overrides.font_size = nil
		else
			overrides.font_size = number_value
		end
	end
	window:set_config_overrides(overrides)
end)

return config
