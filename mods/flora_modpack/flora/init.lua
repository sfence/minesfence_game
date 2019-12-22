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

if (false) then
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
  
  -- abm function
  minetest.register_abm({
    label = "Stump growing",
    nodenames = {"group:flora_stump"},
    interval = 39,
    chance = 1,
    catch_up = false,
    action = function (pos, node, active_object_count, active_object_coumt_wider)
        minetest.log("warning", "ABM stump grow node "..node.name.." x: "..tostring(pos.x).." y: "..tostring(pos.y).." z: "..tostring(pos.z));
        --minetest.log("warning", "ABM flora grow node "..dump(node).." on "..dump(pos));
        vegetation.tree_stump_grow(pos, node);
      end,
  });
  
  -- abm function
  minetest.register_abm({
    label = "Tree growing",
    nodenames = {"group:flora_tree_plant"},
    interval = 19,
    chance = 1,
    catch_up = false,
    action = function (pos, node, active_object_count, active_object_coumt_wider)
        minetest.log("warning", "ABM tree plant grow node "..node.name.." x: "..tostring(pos.x).." y: "..tostring(pos.y).." z: "..tostring(pos.z));
        --minetest.log("warning", "ABM flora grow node "..dump(node).." on "..dump(pos));
        vegetation.plant_grow(pos, node);
      end,
  });
end

flora.S = nil

