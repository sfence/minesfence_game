
local S = default.S;

function default.erosion_air(pos, node)
  --minetest.log("warning", "Air erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local erosion_chance = 0.0;
  
  local erosion_air = minetest.get_item_group(node.name, "erosion_air")/100.0;
  
  for check_index,check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    if ((check_node.name=="air") or (minetest.get_item_group(check_node.name, "air")>0)) then
      erosion_chance = default.shared_add_chance_happen(erosion_chance, erosion_air);
    end
  end
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  minetest.log("warning", "Air erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(erosion_chance))
  
  if (chance<=erosion_chance) then
    default.apply_node_change(pos, node, "erosion");
  end
end

function default.erosion_wind(pos, node)
  --minetest.log("warning", "Wind erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local erosion_chance = 0.0;
  
  local erosion_wind = minetest.get_item_group(node.name, "erosion_wind")/100.0;
  
  for check_index,check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    if ((check_node.name=="air") or (minetest.get_item_group(check_node.name, "air")>0)) then
      erosion_chance = default.shared_add_chance_happen(erosion_chance, erosion_air);
    end
  end
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  minetest.log("warning", "Wind erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(erosion_chance))
  
  if (chance<=erosion_chance) then
    default.apply_node_change(pos, node, "erosion");
  end
end

function default.erosion_water(pos, node)
  minetest.log("warning", "Water erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local erosion_chance = 0.0;
  
  local erosion_water = minetest.get_item_group(node.name, "erosion_water")/100.0;
  
  for check_index,check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    if (minetest.get_item_group(check_node.name, "water")>0) then
      check_def = minetest.registered_nodes[check_node.name];
      local erosion_part = 0.2;
      if (check_def.liquidtype=="flowing") then
        erosion_part = erosion_part + 0.8 * minetest.get_node_level(check_pos)/minetest.get_node_max_level(check_pos);
      end
      erosion_chance = default.shared_add_chance_happen(erosion_chance, erosion_part*erosion_water);
    end
  end
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=erosion_chance) then
    default.apply_node_change(pos, node, "erosion");
  end
end

function default.erosion_heat(pos, node)
  minetest.log("warning", "Heat erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  default.apply_node_change(pos, node, "erosion");
end

function default.erosion_dry(pos, node)
  minetest.log("warning", "Dry erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local erosion_chance = 0.0;
  
  local erosion_dry = minetest.get_item_group(node.name, "erosion_dry")/100.0;
  
  if (minetest.get_item_group(node.name, "dry")>0) then
    erosion_chance = default.shared_add_chance_happen(erosion_chance, erosion_dry);
  end
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=erosion_chance) then
    default.apply_node_change(pos, node, "erosion");
  end
end

function default.erosion_wet(pos, node)
  minetest.log("warning", "Wet erosion of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local erosion_chance = 0.0;
  
  local erosion_wet = minetest.get_item_group(node.name, "erosion_wet")/100.0;
  
  local erosion_part = 0.0;
  if (minetest.get_item_group(node.name, "damp")>0) then
    erosion_part = 0.33;
  end
  if (minetest.get_item_group(node.name, "wet")>0) then
    erosion_part = 0.97;
  end
  if (minetest.get_item_group(node.name, "soggy")>0) then
    erosion_part = 1.0;
  end
    
  if (erosion_part>0.0) then
    erosion_chance = default.shared_add_chance_happen(erosion_chance, erosion_part*erosion_wet);
  end
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=erosion_chance) then
    default.apply_node_change(pos, node, "erosion");
  end
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

minetest.register_abm({
  label = "Water erosion",
  nodenames = {"group:erosion_water"},
  neighbors = {"group:water"},
  interval = 60,
  chance = 2,
  catch_up = false,
  action = default.erosion_water,
})

minetest.register_abm({
  label = "Heat erosion",
  nodenames = {"group:erosion_heat"},
  interval = 60,
  chance = 2,
  catch_up = false,
  action = default.erosion_heat,
})

minetest.register_abm({
  label = "Dry erosion",
  nodenames = {"group:erosion_dry"},
  interval = 60,
  chance = 2,
  catch_up = false,
  action = default.erosion_dry,
})

minetest.register_abm({
  label = "Wet erosion",
  nodenames = {"group:erosion_wet"},
  interval = 60,
  chance = 2,
  catch_up = false,
  action = default.erosion_wet,
})
