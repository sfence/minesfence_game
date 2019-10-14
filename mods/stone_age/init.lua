-- Mods which include stone age items

-- Definitions made by this mod that other mods can use too
stone_age = {}

-- localize support via initlib
stone_age.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  stone_age.S = intllib.Getter()
end

-- Load files
local default_path = minetest.get_modpath("stone_age")

dofile(default_path.."/nodes.lua")
dofile(default_path.."/tools.lua")
-- dofile(default_path.."/craftitems.lua")
dofile(default_path.."/items.lua")
dofile(default_path.."/crafting.lua")
-- dofile(default_path.."/mapgen.lua")


stone_age.S = nil

