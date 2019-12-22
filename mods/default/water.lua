
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
      
      for check_idnex, check_pos in pairs(positions) do
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
      
      -- 360 steps will be reduced to 60 when 1x1 area into solid block is going to be flooded
      if (step>360) then
        -- change to source
        default.apply_node_change(pos, node, "flowing_to_source")
      else
        minetest.after(1, default.water_flowing_to_source, pos, step);
      end
    end
  end
end

function default.water_flowing_abm(pos, node)
  local random_after = default.random_generator:next(1, 19)/10;
  --minetest.after(random_after, default.water_flowing_to_source, pos, 0);
end

function default.water_evaporate(pos, node)
  -- depend on temp
  
  
end
  
default.register_changeable_node_change("default:water_flowing", "flowing_to_source", {new_node_name="default:water_source",check_stability=false});

if (false) then
  minetest.register_abm({
    label = "Water flowing to source",
    nodenames = {"group:water_flowing"},
    interval = 15,
    chance = 15,
    catch_up = false,
    action = default.water_flowing_abm,
  })

  minetest.register_abm({
    label = "Water evaporate",
    nodenames = {"group:water_flowing"},
    neighbors = {"air"},
    interval = 15,
    chance = 1024,
    catch_up = false,
    action = default.water_evaporate,
  })
end

