-- Use Vim-style arrows globally, including while holding the keys.
local arrows = { h = "left", j = "down", k = "up", l = "right" }

for key, arrow in pairs(arrows) do
  local function sendArrow()
    hs.eventtap.keyStroke({}, arrow, 0)
  end

  hs.hotkey.bind({ "ctrl" }, key, sendArrow, nil, sendArrow)
end
