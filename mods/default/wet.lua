
local S = default.S;

function default.wet_more_wet(pos, node)
  --minetest.log("warning", "Wet of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local wet_chance = 0.0;
  
  local absorbing_power = minetest.get_item_group(node.name, "absorbing_power")/100.0;
  
  local near_water_pos = minetest.find_node_near(pos, 50, {"group:water"});
  local wet_power = 0.2;
  if (near_water_pos~=nil) then
    local water_distance = vector.distance(pos, near_water_pos);
    wet_power = wet_power + 0.8*(50/water_distance);
  end
  
  for check_index,check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    local absorbing_part = 0.0;
    if (minetest.get_item_group(check_node.name, "water")>0) then
      check_def = minetest.registered_nodes[check_node.name];
      if (check_def.liquidtype=="flowing") then
        absorbing_part = 0.33 + 0.67 * minetest.get_node_level(check_pos)/minetest.get_node_max_level(check_pos);
      else
        absorbing_part = 1.0;
      end
    elseif (minetest.get_item_group(node.name, "damp")>0) then
      absorbing_part = wet_power * 0.083; --0.25 * 0.33;
    elseif (minetest.get_item_group(node.name, "wet")>0) then
      absorbing_part = wet_power * 0.167; -- 0.50 * 0.33;
    elseif (minetest.get_item_group(node.name, "soggy")>0) then
      absorbing_part = wet_power * 0.25; -- 0.75 * 0.33;
    end
    
    if (absorbing_part>0.0) then
      wet_chance = default.shared_add_chance_happen(wet_chance, absorbing_part*absorbing_power);
    end
  end
  
  minetest.log("warning", "Wet of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(wet_chance));
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=wet_chance) then
    default.apply_node_change(pos, node, "wet");
  end
end

function default.wet_more_dry(pos, node)
  --minetest.log("warning", "Dry of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local dry_chance = 0.0;
  
  local desiccation = minetest.get_item_group(node.name, "desiccation")/100.0;
  
  for check_index,check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    local desiccation_part = 1.0;
    if (minetest.get_item_group(check_node.name, "water")>0) then
      check_def = minetest.registered_nodes[check_node.name];
      if (check_def.liquidtype=="flowing") then
        desiccation_part = desiccation_part - 0.1 * (minetest.get_node_level(check_pos)/minetest.get_node_max_level(check_pos));
      else
        desiccation_part = 0.0;
      end
    elseif (minetest.get_item_group(node.name, "damp")>0) then
      desiccation_part = desiccation_part - 0.225; --0.25 * 0.9;
    elseif (minetest.get_item_group(node.name, "wet")>0) then
      desiccation_part = desiccation_part - 0.45; -- 0.50 * 0.9;
    elseif (minetest.get_item_group(node.name, "soggy")>0) then
      desiccation_part = desiccation_part - 0.675; -- 0.75 * 0.9;
    end
    
    if (desiccation_part>0.0) then
      dry_chance = default.shared_add_chance_happen(dry_chance, desiccation_part*desiccation);
    end
  end
  
  minetest.log("warning", "Dry of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(dry_chance));
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=dry_chance) then
    default.apply_node_change(pos, node, "dry");
  end
end

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

