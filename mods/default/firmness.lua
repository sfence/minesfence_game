
--
-- Firmness nodes
--

-- functions for manipulate with nodes which have defined firmness and resilience.
--
-- firmness mean number of steps under where should be any type of prop to prvent falling
-- resilience mean number of step after prop is out of use, where increase probability of start falling

function default.is_should_fall(pos, node, only_firmness)
  --minetest.log("warning", "default.is_should_fall called.");
  
  local node_def = minetest.registered_nodes[node.name];
  
  local firmness = node_def.groups["firmness"];
  local resilience = node_def.groups["resilience"];
  
  local is_should_fall = true;
  
  if (not(firmness)) then firmness = 0; end
  if (not(resilience)) then resilience = 0; end
  
  if ((firmness==0) and (resilience==0)) then
    --minetest.log("warning", "Fall of "..node.name.."?");
    -- if node is falling group, fall will be caused by game engine
    return false;
  end
  
  --minetest.log("warning", "Is_should_fall node "..node.name.." firmness: "..tostring(firmness).." resiliance: "..tostring(resilience));
  
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
            local falling_node = node_def.groups["falling_node"];
            if (not(falling_node)) then falling_node = 0; end
            if ((node_walkable==true) and (falling_node==0)) then
              --minetest.log("warning", "Walkable on "..dump(pos_find).." for "..dump(pos))
              is_should_fall = false;
              node.name = default.firmness_node_to_stable[node.name]; 
              if (node.name) then
                --minetest.log("warning", "To stable "..dump(pos))
                minetest.swap_node(pos, node);
              end
              return false;
            end
          end
        end
      end
      if (is_should_fall==false) then break; end
    end
  end
  
  if ((is_should_fall==true) and (resilience>0) and (only_firmness==false)) then
    local fall_chance = 1.0;
    local max_distance = firmness + resilience;
    
    -- calculate begining fail_chance
    pos_find.y = pos.y + 1;
    local check_node = minetest.get_node(pos_find);
    if (check_node.name~="ignore") then
      local node_def = minetest.registered_nodes[check_node.name];
      local node_walkable = node_def.walkable;
      if (node_walkable==true) then
        fall_chance = fall_chance - 0.02;
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
          local falling_node = node_def.groups["falling_node"];
          if (not(falling_node)) then falling_node = 0; end
          if ((node_walkable==true) and (falling_node==0)) then
            fall_chance = fall_chance - 0.07;
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
              local falling_node = node_def.groups["falling_node"];
              if (not(falling_node)) then falling_node = 0; end
              if ((node_walkable==true) and (falling_node==0)) then
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

function default.check_neighbour_for_fall(pos)
  --minetest.log("warning", "Check neighbour on: "..dump(pos));
  local check_pos = table.copy(pos);
  
  for y_diff = 0,1,1 do
    check_pos.y = pos.y + y_diff;
    for x_diff = -1,1,1 do
      check_pos.x = pos.x + x_diff;
      for z_diff = -1,1,1 do
        check_pos.z = pos.z + z_diff;
        --minetest.log("warning", "After destruct x_diff: "..tostring(x_diff).." z_diff: "..tostring(z_diff).." y_diff: "..tostring(y_diff));
        local check_node = minetest.get_node(check_pos);
        if (check_node.name~="ignore") then
          local fall_it = default.is_should_fall(check_pos, check_node, true);
          if (fall_it==true) then
            local new_node_name = default.firmness_node_to_falling[check_node.name];
            if (new_node_name~=nil) then
              --minetest.log("warning", "Falling 170 node "..check_node.name..": "..dump(check_pos));
              minetest.swap_node(check_pos,{name=new_node_name});
            else
              minetest.spawn_falling_node(check_pos);
            end
            minetest.check_for_falling(check_pos);
            if (y_diff>0) then
              --minetest.log("warning", "Near refall check of "..check_node.name);
              minetest.after(1, default.check_neighbour_for_fall, table.copy(check_pos));
            end
          end
        end
      end
    end
  end
end

-- should be done for neightbour of stable or normal destroyed node
-- default neightbour is 8 ( expect sum of firmness and resilience is not bigger then 8)
function default.neighbour_stable_to_normal(pos)
  local pos1 = {x = pos.x-8, y = pos.y-8, z = pos.z-8};
  local pos2 = {x = pos.x+8, y = pos.y+8, z = pos.z+8};
  
  local positions = minetest.find_nodes_in_area(pos1, pos2, default.firmness_node_stable_names);
  --minetest.log("warning", "Area "..dump(pos1).." to "..dump(pos2).." found  "..tostring(#positions));
  
  if (positions) then
    for i, find_pos in ipairs(positions) do
      local find_node = minetest.get_node(find_pos);
      find_node.name = default.firmness_node_from_stable[find_node.name];
      if (find_node.name) then
        minetest.swap_node(find_pos, find_node);
      end
    end
  end
end

default.firmness_node_to_falling = {};
default.firmness_node_falling_names = {};
default.firmness_node_to_stable = {};
default.firmness_node_from_stable = {};
default.firmness_node_stable_names = {};

function default.register_firmness_node_change(node_name, falling_node_name, stable_node_name)
  default.firmness_node_to_falling[node_name] = falling_node_name;
  table.insert(default.firmness_node_falling_names, falling_node_name);
  default.firmness_node_to_stable[node_name] = stable_node_name;
  default.firmness_node_from_stable[stable_node_name] = node_name;
  table.insert(default.firmness_node_stable_names, stable_node_name);
end

function default.firmness_abm_action(pos, node)
  local fall_it = default.is_should_fall(pos, node, false);
  --minetest.log("warning", "Node on pos "..dump(pos).." fall it is "..tostring(fall_it));
  if (fall_it==true) then
    local new_node_name = default.firmness_node_to_falling[node.name];
    if (new_node_name~=nil) then
      --minetest.log("warning", "Falling 227: "..dump(pos));
      minetest.swap_node(pos,{name=new_node_name});
    else
      minetest.spawn_falling_node(pos);
    end
    minetest.check_for_falling(pos);
    --default.firmness_after_destruct(pos, node);
    --minetest.after(1, default.check_neighbour_for_fall, pos);
  end
end

function default.firmness_after_destruct(pos, oldnode)
  default.neighbour_stable_to_normal(pos);
  --default.check_neighbour_for_fall(pos);
  minetest.after(1, default.check_neighbour_for_fall, pos);
end

function default.firmness_preserve_metadata(pos, oldnode, oldmeta, drops)
  default.neighbour_stable_to_normal(pos);
  --default.check_neighbour_for_fall(pos);
  minetest.after(1, default.check_neighbour_for_fall, pos);
end

