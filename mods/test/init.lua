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

dofile(test_path.."/nodes.lua")


test.S = nil

