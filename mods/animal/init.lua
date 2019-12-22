-- Mods which include functions for animals

-- Definitions made by this mod that other mods can use too
animal = {}

-- localize support via initlib
animal.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  animal.S = intllib.Getter()
end

-- Load files
local animal_path = minetest.get_modpath("animal")

dofile(animal_path.."/vitality.lua")

animal.S = nil

