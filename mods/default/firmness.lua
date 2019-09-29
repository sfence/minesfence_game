
--
-- Firmness nodes
--

-- functions for manipulate with nodes which have defined firmness and resilience.
--
-- firmness mean number of steps under where should be any type of prop to prvent falling
-- resilience mean number of step after prop is out of use, where increase probability of start falling

function default.is_should_fall(pos, node)
  --minetest.log("warning", "default.is_should_fall called.");
  
  local node_def = minetest.registered_nodes[node.name];
  
  local firmness = node_def.groups["firmness"];
  local resilience = node_def.groups["resilience"];
  
  local is_should_fall = true;
  
  if (not(firmness)) then firmness = 0; end
  if (not(resilience)) then resilience = 0; end
  
  --minetest.log("warning", "Is_should_fall firmness: "..tostring(firmness).." resiliance: "..tostring(resilience));
  
  local pos_find = table.copy(pos);
  pos_find.y = pos.y - 1;
  local pos_distance = table.copy(pos_find);
  
  if (firmness>0) then
    for x_diff = -firmness,firmness,1 do
      for z_diff = -firmness,firmness,1 do
        pos_find.x = pos.x + x_diff;
        pos_find.z = pos.z + z_diff;
        
        --minetest.log("warning", "x_diff: "..tostring(x_diff).." z_diff: "..tostring(z_diff))
        
        --minetest.log("warning", "pos: "..dump(pos).."  pos_find: "..dump(pos_find).."pos_distance: "..dump(pos_distance))
        local distance = vector.distance(pos_distance, pos_find);
        --minetest.log("warning", "pos: "..dump(pos).."  pos_find: "..dump(pos_find).."pos_distance: "..dump(pos_distance))
        
        if (distance<=firmness) then
          local check_node = minetest.get_node(pos_find);
          
          if (check_node.name~="ignore") then
              --minetest.log("warning", "Node  "..check_node.name.." on y: "..tostring(pos_find.y).." x: "..tostring(pos_find.x).." z:"..tostring(pos_find.z).." distance: "..tostring(distance).." x_diff: "..tostring(x_diff).." z_diff: "..tostring(z_diff))
            
            local node_def = minetest.registered_nodes[check_node.name];
            local node_walkable = node_def.walkable;
            if (node_walkable==true) then
              --minetest.log("warning", "Walkable on "..dump(pos_find).." for "..dump(pos))
              is_should_fall = false;
              break;
            end
          end
        end
      end
      if (is_should_fall==false) then break; end
    end
  end
  
  if ((is_should_fall==true) and (resilience>0)) then
    local fall_chance = 0.70;
    local max_distance = firmness + resilience;
    
    -- calculate begining fail_chance
    pos_find.y = pos.y + 1;
    local check_node = minetest.get_node(pos_find);
    if (check_node.name~="ignore") then
      local node_def = minetest.registered_nodes[check_node.name];
      local node_walkable = node_def.walkable;
      if (node_walkable==true) then
        fall_chance = fall_chance + 0.02;
      end
    end
    pos_find.y = pos.y;
    for x_diff = -1,1,2 do
      for z_diff = -1,1,2 do
        pos_find.x = pos.x + x_diff;
        pos_find.z = pos.z + z_diff;
        
        local check_node = minetest.get_node(pos_find);
        if (check_node.name~="ignore") then
          local node_def = minetest.registered_nodes[check_node.name];
          local node_walkable = node_def.walkable;
          if (node_walkable==true) then
            fall_chance = fall_chance + 0.07;
          end
        end
      end
    end
    
    pos_find.y = pos.y - 1;
    
    local chance = default.random_generator:next(0, 16777215)/16777215.0;
    
    if (chance<=fall_chance) then
      for x_diff = -max_distance,max_distance,1 do
        for z_diff = -max_distance,max_distance,1 do
          pos_find.x = pos.x + x_diff;
          pos_find.z = pos.z + z_diff;
          
          local distance = vector.distance(pos_distance, pos_find);
          
          if ((distance>firmness) and (distance<=max_distance)) then
            local check_node = minetest.get_node(pos_find);
            
            if (check_node.name~="ignore") then
                --minetest.log("warning", "Node  "..check_node.name.." on y: "..tostring(pos_find.y).." x: "..tostring(pos_find.x).." z:"..tostring(pos_find.z).." distance: "..tostring(distance).." x_diff: "..tostring(x_diff).." z_diff: "..tostring(z_diff))
              local node_def = minetest.registered_nodes[check_node.name];
              local node_walkable = node_def.walkable;
              if (node_walkable==true) then
                --minetest.log("warning", "Walkable on "..dump(pos_find).." for "..dump(pos))
                local risk_prevent_power = (distance-firmness)/resilience;
                fall_chance = fall_chance * risk_prevent_power;
                --minetest.log("warning", "Risk_prevent_power: "..tostring(risk_prevent_power))
              end
            end
          end
        end
      end
    end
    
    if (chance>fall_chance) then
      is_should_fall = false;
    end
    
    --minetest.log("warning", "random chance: "..tostring(chance).." fall chance:"..tostring(fall_chance))
  end
  
  --minetest.log("warning", "Returning value: "..tostring(is_should_fall))
  
  return is_should_fall;
end

