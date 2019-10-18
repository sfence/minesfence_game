-- Mods which include functions for floras

-- Definitions made by this mod that other mods can use too
flora = {}

-- localize support via initlib
flora.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  flora.S = intllib.Getter()
end

-- Load files
local flora_path = minetest.get_modpath("flora")

dofile(flora_path.."/rose.lua")

-- abm function
minetest.register_abm({
	label = "Flora growing",
	nodenames = {"group:flora_plant"},
	interval = 10,
  chance = 1,
	catch_up = false,
  action = function (pos, node, active_object_count, active_object_coumt_wider)
      minetest.log("warning", "ABM flora grow node "..node.name.." x: "..tostring(pos.x).." y: "..tostring(pos.y).." z: "..tostring(pos.z));
      --minetest.log("warning", "ABM flora grow node "..dump(node).." on "..dump(pos));
      vegetation.plant_grow(pos, node);
    end,
});

flora.S = nil

