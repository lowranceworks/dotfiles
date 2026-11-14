-- Run from the repository root: lua tests/hammerspoon_hotkeys.lua
-- The bindings are intentionally disabled; loading the config must register none.
hs = {
  hotkey = {
    bind = function()
      error("disabled Ctrl+H/J/K/L bindings must not register")
    end,
  },
  eventtap = {
    keyStroke = function()
      error("disabled Ctrl+H/J/K/L bindings must not emit arrows")
    end,
  },
}

dofile("dot_config/hammerspoon/init.lua")
print("Hammerspoon arrow bindings: disabled")
