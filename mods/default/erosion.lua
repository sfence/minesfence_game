
local S = default.S;

function default.erosion_air(pos, node)
    minetest.log("warning", "Air erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "erosion");
end

function default.erosion_water(pos, node)
    minetest.log("warning", "Water erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "erosion");
end

function default.erosion_heat(pos, node)
    minetest.log("warning", "Heat erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "erosion");
end

function default.erosion_dry(pos, node)
    minetest.log("warning", "Dry erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "erosion");
end

function default.erosion_wet(pos, node)
    minetest.log("warning", "Wet erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
    default.apply_node_change(pos, node, "erosion");
end

minetest.register_abm({
  label = "Air erosion",
  nodenames = {"group:erosion_air"},
  neighbors = {"group:air","air"},
  interval = 60,
  chance = 2,
  catch_up = false,
  action = default.erosion_air,
})

