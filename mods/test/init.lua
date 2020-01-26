-- Mods which include special recipes functions

-- Definitions made by this mod that other mods can use too
test = {}

-- localize support via initlib
test.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  test.S = intllib.Getter()
end

-- Load files
local test_path = minetest.get_modpath("test")

if (false) then
  dofile(test_path.."/nodes.lua")
end
if (true) then
  dofile(test_path.."/item.lua")
end

test.S = nil

