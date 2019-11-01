
local S = default.S;

function default.wet_more_wet(pos, node)
  --minetest.log("warning", "Wet of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local wet_chance = 0.0;
  
  local absorbing_power = minetest.get_item_group(node.name, "absorbing_power")/100.0;
  local capabilities = minetest.get_item_group(node.name, "capabilities")/100.0;
  
  local wet_from = {};
  local water_near = false;
  
  for check_index,check_pos in pairs(positions) do
    local check_node = minetest.get_node(check_pos);
    local absorbing_part = 0.0;
    
    local height_coeficient = 0.5;
    if (check_pos.y>pos.y) then
      height_coeficient = 1.0-capabilities;
    elseif (check_pos.y<pos.y) then
      height_coeficient = capabilities;
    end
    
    if (minetest.get_item_group(check_node.name, "water")>0) then
      water_near = true;
      local check_def = minetest.registered_nodes[check_node.name];
      if (check_def.liquidtype=="flowing") then
        absorbing_part = 0.33 + 0.67 * minetest.get_node_level(check_pos)/minetest.get_node_max_level(check_pos);
      else
        absorbing_part = 1.0;
      end
    elseif (minetest.get_item_group(check_node.name, "damp")>0) then
      absorbing_part = 0.083; --0.25 * 0.33;
      table.insert(wet_from, {pos=check_pos,points=math.ceil(83*height_coeficient)})
    elseif (minetest.get_item_group(check_node.name, "wet")>0) then
      absorbing_part = 0.167; -- 0.50 * 0.33;
      table.insert(wet_from, {pos=check_pos,points=math.ceil(167*height_coeficient)})
    elseif (minetest.get_item_group(check_node.name, "soggy")>0) then
      absorbing_part = 0.25; -- 0.75 * 0.33;
      table.insert(wet_from, {pos=check_pos,points=math.ceil(250*height_coeficient)})
    end
  
    --minetest.log("warning", "Near node "..check_node.name.." pos X:"..tostring(check_pos.x).." Y:"..tostring(check_pos.y).." Z:"..tostring(check_pos.z).." absorbing_part: "..tostring(absorbing_part).." absorbing_power: "..tostring(absorbing_power));
    
    if (absorbing_part>0.0) then
      wet_chance = default.shared_add_chance_happen(wet_chance, absorbing_part*absorbing_power*height_coeficient);
    end
  end
  
  minetest.log("warning", "Wet of node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(wet_chance));
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=wet_chance) then
    default.apply_node_change(pos, node, "wet");
    
    if (water_near==false) then
      from_data = default.shared_random_from_table(wet_from, "points");
      default.apply_node_change(from_data.pos, nil, "dry");
    end
  end
end

function default.wet_create_spring(pos, node)
  --minetest.log("warning", "Create spring on node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z))
  local positions = default.shared_positions_in_sphere(pos, 1, false);
  local desiccation_chance = 0.0;
  
  local desiccation = minetest.get_item_group(node.name, "desiccation")/100.0;
  local dry_positions = {};
  
  for check_index,check_pos in pairs(positions) do
    local check_node = minetest.get_node(check_pos);
    local desiccation = minetest.get_item_group(check_node.name, "desiccation")/100.0;
    if (desiccation>0) then
      table.insert(dry_positions, check_pos);
      
      desiccation_chance = default.shared_add_chance_happen(desiccation_chance, desiccation);
    end
  end
  
  minetest.log("warning", "Create spring on node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(desiccation_chance));
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=desiccation_chance) then
    local fresh_def = minetest.registered_nodes["default:fresh_water_flowing"];
    local leveled = fresh_def.leveled;
    local create_level = math.floor(chance/(desiccation_chance/(leveled+1)));
    if (create_level>0) then
      minetest.set_node(pos, {name="default:fresh_water_flowing"});
      if (create_level>leveled) then
        create_level = leveled;
      end
      minetest.set_node_level(pos, create_level);
    else
      minetest.set_node(pos, {name="default:spring_water_source"});
    end
    for dry_index,dry_pos in pairs(dry_positions) do 
      default.apply_node_change(dry_pos, nil, "dry");
    end
  end
end

minetest.register_abm({
  label = "Wet of dry",
  nodenames = {"group:absorbing_power"},
  neighbors = {"group:water","group:damp","group:wet","group:soggy"},
  interval = 11,
  chance = 2,
  catch_up = false,
  action = default.wet_more_wet,
})

minetest.register_abm({
  label = "Create spring",
  nodenames = {"group:air","air"},
  neighbors = {"group:desiccation"},
  interval = 110,
  chance = 110,
  catch_up = false,
  action = default.wet_more_dry,
})

