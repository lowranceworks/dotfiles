return {
	black = 0xff181825, -- Mantle
	white = 0xffcdd6f4, -- Text
	red = 0xfff38ba8, -- Red
	green = 0xffa6e3a1, -- Green
	blue = 0xff89b4fa, -- Blue
	yellow = 0xfff9e2af, -- Yellow
	orange = 0xfffab387, -- Peach
	magenta = 0xffcba6f7, -- Mauve
	grey = 0xff6c7086, -- Overlay0
	transparent = 0x00000000,
	bar = {
		bg = 0xf01e1e2e, -- Base with alpha
		border = 0xff1e1e2e, -- Base
	},
	popup = {
		bg = 0xc0313244, -- Surface0 with alpha
		border = 0xff6c7086, -- Overlay0
	},
	bg1 = 0xff313244, -- Surface0
	bg2 = 0xff45475a, -- Surface1
	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
