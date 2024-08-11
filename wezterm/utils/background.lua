local M = {}
local os = require("os")

M.get_background = function()
	return {
		source = "wezterm.background_image.File",
		file = os.getenv("HOME") .. "./.config/wezterm/wallpapers/sessions/dotfiles/_config/fish.jpeg",
		-- Other optional settings for the background image
	}
end

return M
