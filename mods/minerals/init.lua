-- Mods which include special recipes functions

-- Definitions made by this mod that other mods can use too
minerals = {}

-- localize support via initlib
minerals.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  minerals.S = intllib.Getter()
end

-- Load files
local minerals_path = minetest.get_modpath("minerals")

dofile(minerals_path.."/nodes.lua")


minerals.S = nil
