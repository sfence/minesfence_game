-- Mods which include special recipes functions

-- Definitions made by this mod that other mods can use too
vegetation = {}

-- localize support via initlib
vegetation.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  vegetation.S = intllib.Getter()
end

-- Load files
local vegetation_path = minetest.get_modpath("vegetation")

dofile(vegetation_path.."/vegetation.lua")
--dofile(vegetation_path.."/work.lua")

vegetation.S = nil

