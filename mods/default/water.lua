
local S = default.S;

-- 
-- control water flooding and water evaporate
--

function default.water_flowing_to_source(pos, step)
  local node = minetest.get_node(pos);
  
  local water_flowing = minetest.get_item_group(node.name, "water_flowing");
  if (water_flowing>0) then
    local flow_max_level = minetest.get_node_max_level(pos);
    local flow_level = minetest.get_node_level(pos);
    
    if (flow_max_level==flow_level) then
      local positions = default.shared_positions_in_sphere(pos, 1, 1);
      local check_node;
      local check_def;
      
      for check_index, check_pos in pairs(positions) do
        check_node = minetest.get_node(check_pos);
        water_flowing = minetest.get_item_group(check_node.name, "water_flowing");
        if (water_flowing>0) then
          if (check_pos.y<pos.y) then
            -- cannot be flooded, water is falling down
            return;
          end
        else
          check_def = minetest.registered_nodes[check_node.name];
          if ((check_def~=nil) and (check_def.buildable_to==true)) then
            return;
          end
          step = step + 1;
        end
      end
      
      step = step + 1;
      
      if (step>12) then
        -- change to source
        default.apply_node_change(pos, node, "flowing_to_source")
      else
        local random_after = default.random_generator:next(300, 1200)/10;
        minetest.after(1, default.water_flowing_to_source, pos, step);
      end
    end
  end
end

function default.water_flowing_abm(pos, node)
  local random_after = default.random_generator:next(1, 1200)/10;
  minetest.after(random_after, default.water_flowing_to_source, pos, 0);
end

function default.water_evaporate(pos, node)
  -- depend on temp
  
  
end

function default.water_spring(pos, node)
  local positions = default.shared_positions_in_sphere(pos, 1, 1);
  
  local node_def = minetest.registered_nodes[node.name];
  
  for check_index, check_pos in pairs(positions) do
    if (check_pos.y <= pos.y) then
      local check_node = minetest.get_node(check_pos);
      local water_flowing = minetest.get_item_group(check_node.name, "water_flowing");
      
      if (water_flowing==0) then
        if (check_node.name=="air") then
          water_flowing = 1;
          minetest.set_node(check_pos, {name=node_def.liquid_alternative_flowing})
        end
      end
      
      if (water_flowing>0) then
        local max_level = minetest.get_node_max_level(check_pos);
        minetest.set_node_level(check_pos, max_level);
      end
    end
  end
end
  
default.register_changeable_node_change("default:water_flowing", "flowing_to_source", {new_node_name="default:water_source",check_stability=false});

if (true) then
  minetest.register_abm({
    label = "Water flowing to source",
    nodenames = {"group:water_flowing"},
    interval = 301,
    chance = 100,
    catch_up = false,
    action = default.water_flowing_abm,
  })

  minetest.register_abm({
    label = "Water evaporate",
    nodenames = {"group:water_flowing"},
    neighbors = {"air"},
    interval = 299,
    chance = 1024,
    catch_up = false,
    action = default.water_evaporate,
  })
  
  minetest.register_abm({
    label = "Water spring",
    nodenames = {"default:spring_water_source"},
    interval = 1,
    chance = 1,
    catch_up = false,
    action = default.water_spring,
  })
end

