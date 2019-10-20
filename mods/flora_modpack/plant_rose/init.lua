-- Mods which include functions for plant rose

-- Definitions made by this mod that other mods can use too
plant_rose = {}

-- localize support via initlib
plant_rose.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  plant_rose.S = intllib.Getter()
end

-- Load files
local plant_rose_path = minetest.get_modpath("plant_rose")

dofile(plant_rose_path.."/plant.lua")

plant_rose.S = nil

