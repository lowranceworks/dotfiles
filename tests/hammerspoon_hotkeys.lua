-- Run from the repository root: lua tests/hammerspoon_hotkeys.lua
local bindings = {}
local sent = {}

hs = {
  hotkey = {
    bind = function(modifiers, key, pressed, released, repeated)
      assert(#modifiers == 1 and modifiers[1] == "ctrl", "expected a Ctrl-only binding")
      assert(not bindings[key], "duplicate binding: " .. key)
      assert(released == nil, "release should not send an arrow")
      bindings[key] = { pressed = pressed, repeated = repeated }
    end,
  },
  eventtap = {
    keyStroke = function(modifiers, key)
      assert(#modifiers == 0, "arrow must have no modifiers")
      sent[#sent + 1] = key
    end,
  },
}

dofile("dot_config/hammerspoon/init.lua")

local expected = { h = "left", j = "down", k = "up", l = "right" }
local count = 0
for source, arrow in pairs(expected) do
  local binding = assert(bindings[source], "missing Ctrl+" .. source)
  binding.pressed()
  assert(sent[#sent] == arrow, "incorrect arrow for Ctrl+" .. source)
  assert(type(binding.repeated) == "function", "missing repeat for Ctrl+" .. source)
  binding.repeated()
  assert(sent[#sent] == arrow, "incorrect repeat for Ctrl+" .. source)
  count = count + 1
end
assert(count == 4)
for source in pairs(bindings) do
  assert(expected[source], "unexpected binding: Ctrl+" .. source)
end
print("Hammerspoon arrow bindings: 4 passed (press and repeat)")
