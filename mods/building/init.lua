-- Mods which include functions for buildings

-- Definitions made by this mod that other mods can use too
building = {}

-- localize support via initlib
building.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  building.S = intllib.Getter()
end

-- Load files
local building_path = minetest.get_modpath("building")

dofile(building_path.."/plan.lua")

building.S = nil

