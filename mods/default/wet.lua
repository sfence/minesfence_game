
local S = default.S;

minetest.register_abm({
  label = "Wet of dry",
  nodenames = {"group:absorbing_power"},
  neighbors = {"group:water","group:damp","group:wet","group:soggy"},
  interval = 11,
  chance = 2,
  catch_up = false,
  action = function(pos, node)
    --minetest.log("warning", "Wet of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "wet");
  end,
})

minetest.register_abm({
  label = "Dry of wet",
  nodenames = {"group:damp","group:wet","group:soggy"},
  neighbors = {"group:dry","group:air","air"},
  interval = 11,
  chance = 3,
  catch_up = false,
  action = function(pos, node)
    --minetest.log("warning", "Dry of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "dry");
  end,
})

