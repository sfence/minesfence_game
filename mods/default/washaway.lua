
local S = default.S;


--
-- Wash Away by flowing water
--

local function flowing_water_washaways_risk(pos, node)
  if (node==nil) then
    node = minetest.get_node(pos)
  end
  
  local positions = default.shared_positions_in_sphere(pos, 1, 1, false);
  
  local washaways = {};
  
  local stable_neighbours = 0;
  
  local check_node;
  local check_def;
  
  local water_flowing;
  
  local flow_level;
  local flow_max_level;
  local flow_power;
  
  local upper_pos;
  local upper_node;
  
  for check_index, check_pos in pairs(positions) do
    check_node = minetest.get_node(check_pos);
    water_flowing = minetest.get_item_group(check_node.name, "water_flowing");
    if (water_flowing>0) then
      flow_level = minetest.get_node_level(check_pos);
      flow_max_level = minetest.get_node_max_level(check_pos);
      minetest.log("warning", "Level: "..tostring(flow_level).." Max level: "..tostring(flow_max_level).." param2: "..tostring(check_node.param2))
      
      flow_power = flow_level/flow_max_level;
      
      if (check_pos.y<pos.y) then
        -- if falling water form top  should be analyzed
        upper_pos = table.copy(check_pos);
        
        flow_power = 0;
        
        for i = 1,10 do
          upper_pos.y = check_pos.y + i;
          upper_node = minetest.get_node(upper_pos);
          water_flowing = minetest.get_item_group(upper_node.name, "water_flowing");
          if (water_flowing==0) then
            break;
          end
          
          flow_level = minetest.get_node_level(upper_pos);
          flow_max_level = minetest.get_node_max_level(upper_pos);
          
          flow_power = flow_power + flow_level/flow_max_level;
          
          if (flow_level<flow_max_level) then
            break;
          end
        end
      elseif (check_pos.y==pos.y) then
        -- if water is start to fall
        check_pos.y = check_pos.y - 1;
        
        upper_node = minetest.get_node(check_pos);
        water_flowing = minetest.get_item_group(upper_node.name, "water");
        
        if (water_flowing>0) then
          flow_power = 10*flow_power;
        end
        
        check_pos.y = check_pos.y + 1;
      end
      
      if (flow_power>0) then
        table.insert(washaways, {pos=check_pos,power=flow_power});
      end
    else
      -- if this function is called for node, flowing water have to be in the sphere with diameter 2
      -- so, if there is not flowing water source in node neightbour, flowing water can be beside it.
      water_flowing = minetest.get_item_group(check_node.name, "water");
      
      if (water_flowing>0) then
        table.insert(washaways, {pos=check_pos,power=0.01});
      elseif (check_pos.y==pos.y) then
        check_def = minetest.registered_nodes[check_node.name];
        
        if ((check_def==nil) or (check_def.buildable_to==false)) then
          stable_neighbours = stable_neighbours + 1;
        end
      end
    end
  end
  
  if (stable_neighbours>=4) then
    return {};
  end
  
  return washaways;
end

local function flowing_water_washaway_sediment(pos, node)
  if (node==nil) then
    node = minetest.get_node(pos)
  end
      
  local flow_level = 0;
  local flow_max_level = 0;
  local from_flow = 0;
  
  while (1) do
    local water_flowing = minetest.get_item_group(node.name, "water_flowing");
    if (water_flowing>0) then
      flow_level = minetest.get_node_level(pos);
      flow_max_level = minetest.get_node_max_level(pos);
      from_flow = flow_level/flow_max_level;
    else
      -- water source
      from_flow = 1.1;
    end
    local to_flow = 0;
    
    local flow_chances = {};
    local flow_power = 0;
    
    local positions = default.shared_positions_in_sphere(pos, 1, 1, false);
    for check_index,check_pos in pairs(positions) do
      local check_node = minetest.get_node(check_pos);
      
      water_flowing = minetest.get_item_group(check_node.name, "water_flowing")
      if (check_pos.y>=pos.y) then
        if (water_flowing>0) then
          flow_level = minetest.get_node_level(check_pos);
          flow_max_level = minetest.get_node_max_level(check_pos);
          to_flow = flow_level/flow_max_level;
          
          if (to_flow<from_flow) then
            flow_power = from_flow-to_flow;
            -- check for water falling in location
            check_pos.y = check_pos.y - 1;
            check_node = minetest.get_node(check_pos);
            
            water_flowing = minetest.get_item_group(check_node.name, "water_flowing");
            if (water_flowing>0) then
              flow_power = flow_power*10.0;
            end
            
            -- add to table
            check_pos.y = check_pos.y + 1;
            
            minetest.log("warning","Flow_target node: "..check_node.name.." pos: "..dump(check_pos))
            table.insert(flow_chances, {pos=table.copy(check_pos),power=flow_power,sediment=false});
          end
        end
      else
        -- can sediment on actual location?
        local check_def = minetest.registered_nodes[check_node.name];
        if ((check_def~=nil) and (check_def.buildable_to==true)) then
          flow_power = 10.0;
          if (water_flowing>0) then
            flow_level = minetest.get_node_level(check_pos);
            flow_max_level = minetest.get_node_max_level(check_pos);
            to_flow = flow_level/flow_max_level;
            
            flow_power = flow_power + 10*to_flow;
          end
          
          table.insert(flow_chances, {pos=table.copy(check_pos),power=flow_power,sediment=true});
        end
      end
    end
    -- look to table
    minetest.log("warning","Flow_chances: "..dump(flow_chances))
    
    if (#flow_chances==0) then
      return nil;
    end
    
    local flow_select = default.shared_random_from_table(flow_chances, "power");
    if (flow_select.sediment==true) then
      return flow_select.pos;
    end
    pos = flow_select.pos;
    node = minetest.get_node(pos);
  end
end

function default.washaway_node(pos, node)
  
  local washaway_chance = 0.0;
  
  local washaway_risk = minetest.get_item_group(node.name, "washaway")/100.0;
  --minetest.log("warning",dump(minetest.registered_items[node.name]))
  
  local washaways = flowing_water_washaways_risk(pos, node);
  local washaway_power = default.shared_sum_from_table(washaways, "power");
  
  --minetest.log("warning","Washaway_power: "..tostring(washaway_power).." risk: "..tostring(washaway_risk).." list: "..dump(washaways));
  washaway_chance = default.shared_add_chance_power_no_happen(washaway_risk, washaway_power);
  
  minetest.log("warning", "Wash away node "..node.name.." pos X:"..tostring(pos.x).." Y:"..tostring(pos.y).." Z:"..tostring(pos.z).." chance: "..tostring(washaway_chance).." washaways: "..tostring(#washaways));
  
  local chance = default.random_generator:next(0, 16777215)/16777215.0;
  
  if (chance<=washaway_chance) then
    -- select wash away from table
    local washaway_data = default.shared_random_from_table(washaways, "power");
    minetest.log("warning","Washaway: "..dump(washaway_data));
    
    local sediment_pos = flowing_water_washaway_sediment(washaway_data.pos);
    
    minetest.log("warning","Sediment: "..dump(sediment_pos));
    
    if (sediment_pos~=nil) then
      minetest.set_node(sediment_pos, node);
      minetest.remove_node(pos);
      minetest.check_for_falling(pos);
    end
    
  end
end

if (false) then
  minetest.register_abm({
    label = "Wash away by water",
    nodenames = {"group:washaway"},
    neighbors = {"group:water_flowing"},
    interval = 12,
    chance = 5,
    catch_up = false,
    action = default.washaway_node,
  })
end

