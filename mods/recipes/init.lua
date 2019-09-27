-- Mods which include special recipes functions

-- Definitions made by this mod that other mods can use too
recipes = {}

-- localize support via initlib
recipes.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  recipes.S = intllib.Getter()
end

-- Load files
local default_path = minetest.get_modpath("recipes")

dofile(default_path.."/recipes.lua")


recipes.S = nil

