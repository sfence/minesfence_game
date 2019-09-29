-- Mods which include special recipes functions

-- Definitions made by this mod that other mods can use too
recipes = {}

-- localize support via initlib
recipes.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  recipes.S = intllib.Getter()
end

-- Load files
local recipes_path = minetest.get_modpath("recipes")

dofile(recipes_path.."/recipes.lua")
dofile(recipes_path.."/work.lua")


recipes.S = nil

