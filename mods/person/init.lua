-- Mods which include functions for persons

-- Definitions made by this mod that other mods can use too
person = {}

-- localize support via initlib
person.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  person.S = intllib.Getter()
end

-- Load files
local person_path = minetest.get_modpath("person")

dofile(person_path.."/person.lua")


person.S = nil

