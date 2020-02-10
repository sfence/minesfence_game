
--
-- Firmness nodes
--

-- functions for manipulate with nodes which have defined firmness and resilience.
--
-- firmness mean number of steps under where should be any type of prop to prvent falling
-- resilience mean number of step after prop is out of use, where increase probability of start falling

function default.is_should_fall(pos, node, only_firmness, to_stable)
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
    
  local check_node = minetest.get_node(pos_find);
  if (check_node.name=="ignore") then
    return false;
  end
  local node_def = minetest.registered_nodes[check_node.name];
  if (node_def.walkable==true) then
    return false;
  end
  
  local pos_distance = table.copy(pos_find);
  local no_in_air = false;
  
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
              if (distance<2.0) then
                no_in_air = true;
              end
              if (to_stable==true) then
                default.apply_node_change(pos, node, "stabilization");
              end
              return false;
            end
          end
        end
      end
      if (is_should_fall==false) then break; end
    end
  end
  
  if (no_in_air==false) then
    return true;
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
  --minetest.log("warning", "Check neighbour.");
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
          local fall_it = default.is_should_fall(check_pos, check_node, true, false);
          if (fall_it==true) then
            minetest.log("warning", "Fall node x: "..tostring(check_pos.x).." y: "..tostring(check_pos.y).." z: "..tostring(check_pos.z));
            default.fall_stable_node(check_pos, check_node, true); 
            if (y_diff>0) then
              --minetest.log("warning", "Near refall check of "..check_node.name);
              minetest.after(0.5+default.random_generator:next(0,10)/10.0, default.check_neighbour_for_fall, table.copy(check_pos));
            end
          end
        end
      end
    end
  end
end

-- when some node starts to fall, it can create cave-in effect.
-- use group cavein with values 1-100 to set probability of canein effect
function default.check_for_cavein(pos)
  local node = minetest.get_node(pos);
  local node_def = minetest.registered_nodes[node.name];
  
  local cavein = node_def.groups["cavein"];
  
  minetest.log("warning", "Node: "..node.name.." Cavein: "..tostring(cavein))
  
  if ((cavein) and (cavein>0)) then
    local check_pos = table.copy(pos);
    check_pos.y = pos.y -1;
    
    local check_node = minetest.get_node(check_pos);
    if (check_node.name=="ignore") then
      return;
    end
    local node_def = minetest.registered_nodes[check_node.name];
    local node_walkable = node_def.walkable;
    if (node_walkable==true) then
      return;
    end
    minetest.log("warning", "Walkable under: "..dump(node_walkable).." node: "..check_node.name.." pos: "..dump(check_pos))
    
    local no_cavein_points = 0;
    local cavein_points = 0;
    local recall_pos = {};
    
    for y_diff = -1,1,1 do
      check_pos.y = pos.y + y_diff;
      local y_factor = (y_diff/2.0)+1.0; -- 0.5 to 1.5
      for x_diff = -1,1,1 do
        check_pos.x = pos.x + x_diff;
        for z_diff = -1,1,1 do
          check_pos.z = pos.z + z_diff;
          
          if ((y_diff~=0) or (x_diff~=0) or (z_diff~=0)) then
            local check_node = minetest.get_node(check_pos);
            if (check_node.name~="ignore") then
              local node_def = minetest.registered_nodes[check_node.name];
              local node_walkable = node_def.walkable;
              
              local distance = vector.distance(pos, check_pos);
               
              if (node_walkable==false) then
                -- remove stability
                cavein_points = cavein_points + (cavein/(y_factor*distance));
              else
                -- add stability
                no_cavein_points = no_cavein_points + (100/(y_factor*distance));
                
                table.insert(recall_pos, table.copy(check_pos));
              end
              
              minetest.log("warning", "CaveIn points: "..tostring(cavein_points).." No cavin points:"..tostring(no_cavein_points).." cavein: "..tostring(cavein).." y_factor: "..tostring(y_factor).." distance:"..tostring(distance).." node_walkable: "..tostring(node_walkable));
            end
          end
        end
      end
    end
    
    local chance = (default.random_generator:next(0, 65535)/65535.0);
    local no_cavein_chance = no_cavein_points/(no_cavein_points+cavein_points);
    
    minetest.log("warning", "Chance: "..tostring(chance).." No_cavein_chance: "..tostring(no_cavein_chance));
    
    if (chance>no_cavein_chance) then
      minetest.log("warning", "Fall pos: "..dump(pos))
      local check_pos = table.copy(pos);
      check_pos.y = pos.y -1;
      local node_def = minetest.registered_nodes[check_node.name];
      minetest.log("warning", "Walkable under: "..dump(node_walkable).." node: "..check_node.name.." pos: "..dump(check_pos))
      --default.apply_node_change(pos, node, "crack");
      default.fall_stable_node(pos, node, false);
      
      for key, recall_pos in pairs(recall_pos) do
        minetest.after(0.2+default.random_generator:next(0,4)/10.0, default.check_for_cavein, recall_pos);
      end
    end
  end 
  
end

-- if falling done fall to another node, and there is free space in another node level, it can happen to fall into that area
-- use group landslide with values 1-100 to set probability of landslide happen
function default.check_for_landslide(pos)
  local node = minetest.get_node(pos);
  local node_def = minetest.registered_nodes[node.name];
  
  local landslide = node_def.groups["landslide"];
  
  --minetest.log("warning", "Landslide: "..tostring(landslide));
  
  if ((landslide) and (landslide>0)) then
    local check_pos = table.copy(pos);
    check_pos.y = pos.y -1;
    
    local check_node = minetest.get_node(check_pos);
    if (check_node.name=="ignore") then
      return;
    end
    local node_def = minetest.registered_nodes[check_node.name];
    local node_falling = node_def.groups["falling_node"];
    if (not(node_falling) or (node_falling<=0)) then
      return;
    end
    
    --minetest.log("warning", "Find positions of posible landslide,");
    
    local landslide_pos = {};
    
    for x_diff = -1,1,1 do
      check_pos.x = pos.x + x_diff;
      for z_diff = -1,1,1 do
        check_pos.z = pos.z + z_diff;
        if ((x_diff~=0)~=(z_diff~=0)) then -- xor
          check_pos.y = pos.y;
          
          local check_node = minetest.get_node(check_pos);
          if (check_node.name~="ignore") then
            local node_def = minetest.registered_nodes[check_node.name];
            
            if (node_def.buildable_to==true) then
              check_pos.y = pos.y - 1;
              
              if (landslide<=100) then
                local check_node = minetest.get_node(check_pos);
                if (check_node.name~="ignore") then
                  local node_def = minetest.registered_nodes[check_node.name];
                  
                  if (node_def.buildable_to==true) then
                    table.insert(landslide_pos, table.copy(check_pos))
                  end
                end
              else
                table.insert(landslide_pos, table.copy(check_pos))
              end
            end
          end
        end
      end    
    end
    
    --minetest.log("warning", dump(landslide_pos));
    local positions = #landslide_pos;
    if (positions>0) then
      local chance = (default.random_generator:next(0, 65535)/65535.0)*100;      
      if (landslide>100) then landslide = landslide - 100; end
      --minetest.log("warning", "Chance: "..tostring(chance).." Landslide: "..tostring(landslide));
      
      if (chance<=landslide) then
        local move_pos = {};
        if (positions>1) then
          local index = default.random_generator:next(1,#landslide_pos)
          
          move_pos = landslide_pos[index];
        else
          move_pos = landslide_pos[1];
        end
        
        minetest.set_node(move_pos, node);
        minetest.remove_node(pos);
        minetest.check_single_for_falling(move_pos);
        minetest.check_for_falling(pos);
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
 -- minetest.log("warning", "Area "..dump(pos1).." to "..dump(pos2).." found  "..tostring(#positions));
  
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

function default.fall_stable_node(pos, node, check_cavein)
  --minetest.log("warning", "fall_stable_node.");
  default.apply_node_change(pos, node, "smash");
  local new_node_name = default.firmness_node_to_falling[node.name];
  if (new_node_name~=nil) then
    --minetest.log("warning", "Falling 296: "..dump(pos));
    minetest.swap_node(pos,{name=new_node_name});
  else
    minetest.spawn_falling_node(pos);
  end
  minetest.check_for_falling(pos);
  default.neighbour_stable_to_normal(pos);
  
  if (check_cavein==true) then
    local check_pos = table.copy(pos);
    
    for x_diff = -1,1,1 do
      check_pos.x = pos.x + x_diff;
      for z_diff = -1,1,1 do
        check_pos.z = pos.z + z_diff;
        for y_diff = -1,1,1 do
          check_pos.y = pos.y + y_diff;
          
          if ((x_diff~=0) or (y_diff~=0) or (z_diff~=0)) then
            --minetest.log("warning", "X: "..tostring(check_pos.x).." Y:"..tostring(check_pos.y).." Z: "..tostring(check_pos.z));
            minetest.log("warning", "CaveIn check from fall stable node.")
            --minetest.log("warning", debug.traceback())
            default.check_for_cavein(check_pos);
          end
        end
      end
    end
  end
end

function default.register_firmness_node_change(node_name, falling_node_name, stable_node_name)
  if (falling_node_name) then
    default.firmness_node_to_falling[node_name] = falling_node_name;
    table.insert(default.firmness_node_falling_names, falling_node_name);
  end
  if (stable_node_name) then
    default.firmness_node_to_stable[node_name] = stable_node_name;
    default.firmness_node_from_stable[stable_node_name] = node_name;
    table.insert(default.firmness_node_stable_names, stable_node_name);
  end
end

function default.firmness_construct(pos)
  minetest.after(0.1, default.check_for_landslide, pos);
end

function default.firmness_abm_action(pos, node)
  local fall_it = default.is_should_fall(pos, node, false, true);
  --minetest.log("warning", "Node on pos "..dump(pos).." fall it is "..tostring(fall_it));
  if (fall_it==true) then
    default.fall_stable_node(pos, node, true); 
    --default.firmness_after_destruct(pos, node);
    --minetest.after(0.5+default.random_generator:next(0,10)/10.0, default.check_neighbour_for_fall, pos);
  end
end

function default.firmness_after_destruct(pos, oldnode)
  minetest.log("warning", "after_destruct X: "..tostring(pos.x).." Y: "..tostring(pos.y).." Z:"..tostring(pos.z));
  default.neighbour_stable_to_normal(pos);
  --default.check_neighbour_for_fall(pos);
  minetest.after(0.5+default.random_generator:next(0,10)/10.0, default.check_neighbour_for_fall, pos);
end

function default.firmness_preserve_metadata(pos, oldnode, oldmeta, drops)
  minetest.log("warning", "preverse_metadata");
  default.neighbour_stable_to_normal(pos);
  --default.check_neighbour_for_fall(pos);
  minetest.after(0.5+default.random_generator:next(0,10)/10.0, default.check_neighbour_for_fall, pos);
end

-- settings should include firmness, resilience, names
function default.register_node_with_firmness(node_def, settings)
  if (setting.normal_node) then
    normal_def = table.copy(node_def);
    
    normal_def.groups.firmness = setting.firmness;
    normal_def.groups.resilience = setting.resilience;
    
    normal_def.after_destruct = default.firmness_after_destruct;
    normal_def.preserve_metadata = default.firmness_preserve_metadata;
    
    minetest.register_node(setting.normal_node, normal_def);
  end
  
  if (setting.stable_node) then
    stable_def = table.copy(node_def);
    
    if not(stable_def.drops) then
      stable_def.drops = setting.normal_node;
    end
    
    stable_def.groups.not_in_creative_inventory = 1;
    
    stable_def.after_destruct = default.firmness_after_destruct;
    
    minetest.register_node(setting.stable_node, stable_def);
    
    default.register_firmness_node_change(setting.normal_node, nil, setting.stable_node);
  end
  
  if (setting.falling_node) then
    falling_def = table.copy(node_def);
    
    if not(falling_def.drops) then
      falling_def.drops = setting.normal_node;
    end
    
    falling_def.groups.falling_node = 1;
    falling_def.groups.not_in_creative_inventory = 1;
    
    falling_def.after_destruct = default.firmness_after_destruct,
    
    minetest.register_node(setting.falling_node, stable_def);
    
    default.register_firmness_node_change(setting.normal_node, setting.falling_node, nil);
  end
end

if (true) then
  minetest.register_abm({
    label = "Check Firmness",
    nodenames = {"group:firmness"},
    neighbors = {"group:air","group:water","air"},
    interval = 559,
    chance = 6,
    catch_up = false,
    action = default.firmness_abm_action,
  })
end

