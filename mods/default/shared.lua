
local S = default.S;

-- 
-- shared functions
--

function default.shared_positions_in_cube(pos, diff_limits, include_pos)
  local positions = {};
  local check_pos = table.copy(pos);
  
  local x_diff_limit = 0;
  local y_diff_limit = 0;
  local z_diff_limit = 0;
  if (type(diff_limits)=="number") then
    diff_limits = math.floor(diff_limits);
    x_diff_limit = diff_limits;
    y_diff_limit = diff_limits;
    z_diff_limit = diff_limits;
  else
    x_diff_limit = math.floor(diff_limits.x);
    y_diff_limit = math.floor(diff_limits.y);
    z_diff_limit = math.floor(diff_limits.z);
  end
  
  for z_diff = -z_diff_limit,z_diff_limit,1 do
    check_pos.z = pos.z + z_diff;
    for y_diff = -y_diff_limit,y_diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for x_diff = -x_diff_limit,x_diff_limit,1 do
        check_pos.x = pos.x + x_diff;
        
        if (include_pos==true) then
          table.insert(positions, table.copy(check_pos));
        else
          if ((check_pos.x~=pos.x)or(check_pos.y~=pos.y)or(check_pos.z~=pos.z)) then
            table.insert(positions, table.copy(check_pos));
          end
        end
      end
    end
  end
  
  return positions;
end

function default.shared_positions_with_distance_in_cube(pos, diff_limits, include_pos)
  local positions_and_distance = {};
  local check_pos = table.copy(pos);
  
  local x_diff_limit = 0;
  local y_diff_limit = 0;
  local z_diff_limit = 0;
  if (type(diff_limits)=="number") then
    diff_limits = math.floor(diff_limits);
    x_diff_limit = diff_limits;
    y_diff_limit = diff_limits;
    z_diff_limit = diff_limits;
  else
    x_diff_limit = math.floor(diff_limits.x);
    y_diff_limit = math.floor(diff_limits.y);
    z_diff_limit = math.floor(diff_limits.z);
  end
  
  for z_diff = -z_diff_limit,z_diff_limit,1 do
    check_pos.z = pos.z + z_diff;
    for y_diff = -y_diff_limit,y_diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for x_diff = -x_diff_limit,x_diff_limit,1 do
        check_pos.x = pos.x + x_diff;
        
        local check_distance = vector.distance(check_pos, pos);
        
        if (include_pos==true) then
          table.insert(positions_and_distance, {pos=table.copy(check_pos),distance=check_distance});
        else
          if ((check_pos.x~=pos.x)or(check_pos.y~=pos.y)or(check_pos.z~=pos.z)) then
            table.insert(positions_and_distance, {pos=table.copy(check_pos),distance=check_distance});
          end
        end
      end
    end
  end
  
  return positions_and_distance;
end

function default.shared_positions_in_sphere(pos, distance, diff_limits, include_pos)
  local positions = {};
  local check_pos = table.copy(pos);
  
  local x_diff_limit = 0;
  local y_diff_limit = 0;
  local z_diff_limit = 0;
  if (type(diff_limits)=="number") then
    diff_limits = math.floor(diff_limits);
    x_diff_limit = diff_limits;
    y_diff_limit = diff_limits;
    z_diff_limit = diff_limits;
  else
    x_diff_limit = math.floor(diff_limits.x);
    y_diff_limit = math.floor(diff_limits.y);
    z_diff_limit = math.floor(diff_limits.z);
  end
  
  for z_diff = -z_diff_limit,z_diff_limit,1 do
    check_pos.z = pos.z + z_diff;
    for y_diff = -y_diff_limit,y_diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for x_diff = -x_diff_limit,x_diff_limit,1 do
        check_pos.x = pos.x + x_diff;
        
        local check_distance = vector.distance(check_pos, pos);
        
        if (check_distance<=distance) then
          if (include_pos==true) then
            table.insert(positions, table.copy(check_pos));
          else
            if ((check_pos.x~=pos.x)or(check_pos.y~=pos.y)or(check_pos.z~=pos.z)) then
              table.insert(positions, table.copy(check_pos));
            end
          end
        end
      end
    end
  end
  
  return positions;
end

function default.shared_positions_with_distance_in_sphere(pos, distance, include_pos)
  local positions_and_distance = {};
  local check_pos = table.copy(pos);
  
  local x_diff_limit = 0;
  local y_diff_limit = 0;
  local z_diff_limit = 0;
  if (type(diff_limits)=="number") then
    diff_limits = math.floor(diff_limits);
    x_diff_limit = diff_limits;
    y_diff_limit = diff_limits;
    z_diff_limit = diff_limits;
  else
    x_diff_limit = math.floor(diff_limits.x);
    y_diff_limit = math.floor(diff_limits.y);
    z_diff_limit = math.floor(diff_limits.z);
  end
  
  for z_diff = -z_diff_limit,z_diff_limit,1 do
    check_pos.z = pos.z + z_diff;
    for y_diff = -y_diff_limit,y_diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for x_diff = -x_diff_limit,x_diff_limit,1 do
        check_pos.x = pos.x + x_diff;
        
        local check_distance = vector.distance(check_pos, pos);
        
        if (check_distance<=distance) then
          if (include_pos==true) then
            table.insert(positions_and_distance, {pos=table.copy(check_pos),distance=check_distance});
          else
            if ((check_pos.x~=pos.x)or(check_pos.y~=pos.y)or(check_pos.z~=pos.z)) then
              table.insert(positions_and_distance, {pos=table.copy(check_pos),distance=check_distance});
            end
          end
        end
      end
    end
  end
  
  return positions_and_distance;
end

function default.shared_add_chance_happen(chance_happen, add_happen_chance)
  return (1.0-((1.0-chance_happen)*(1.0-add_happen_chance)));
end

function default.shared_add_chance_no_happen(chance_happen, add_no_happen_chance)
  return (1.0-((1.0-chance_happen)*add_no_happen_chance));
end

function default.shared_add_chance_power_no_happen(chance_happen, power_no_happen_chance)
  return (1.0-math.pow((1.0-chance_happen), power_no_happen_chance));
end

function default.shared_sum_from_table(table_data, points_field_name)
  -- sum of points
  local sum_points = 0;
  for index,value in pairs(table_data) do
    sum_points = sum_points + value[points_field_name];
  end
  
  return sum_points;
end

function default.shared_random_from_table(table_data, points_field_name)
  -- sum of points
  local sum_points = 0;
  for index,value in pairs(table_data) do
    sum_points = sum_points + value[points_field_name];
  end
  
  -- select field
  local rand_points = default.random_generator:next(0, sum_points);
  local rand = default.random_generator:next(0, 16777215)/16777215.0;
  local rand_points = rand*sum_points;
  for index,value in pairs(table_data) do
    rand_points = rand_points - value[points_field_name];
    if (rand_points<=0) then
      return value;
    end
  end
  
  -- no select
  return nil;
end

function default.shared_is_buildable_to(pos)
  --minetest.log("warning", "is buildable: "..dump(pos))
  local node = minetest.get_node(pos);
  if (node==nil) then
    return false;
  end
  if ((node.name=="air") or (node.name=="ignore")) then
    return true;
  end
  local node_def = minetest.registered_nodes[node.name];
  if (node_def==nil) then
    return false;
  end
  --minetest.log("warning", "is buildable: "..dump(node_def.buildable_to))
  
  return node_def.buildable_to;
end

function default.shared_log_position(pos)
  return "[ X: "..pos.x.."; Z: "..pos.z.."; Y: "..pos.y..";]";
end

