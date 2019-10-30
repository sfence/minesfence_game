
local S = default.S;

-- 
-- shared functions
--

function default.shared_positions_in_cube(pos, distance, include_pos)
  local positions = {};
  local check_pos = table.copy(pos);
  
  distance = math.floor(distance);
  
  for x_diff = -distance,distance,1 do
    check_pos.x = pos.x + x_diff;
    for y_diff = -distance,distance,1 do
      check_pos.y = pos.y + y_diff;
      for z_diff = -distance,distance,1 do
        check_pos.z = pos.z + z_diff;
        
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

function default.shared_positions_with_distance_in_cube(pos, distance, include_pos)
  local positions_and_distance = {};
  local check_pos = table.copy(pos);
  
  distance = math.floor(distance);
  
  for x_diff = -distance,distance,1 do
    check_pos.x = pos.x + x_diff;
    for y_diff = -distance,distance,1 do
      check_pos.y = pos.y + y_diff;
      for z_diff = -distance,distance,1 do
        check_pos.z = pos.z + z_diff;
        
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

function default.shared_positions_in_sphere(pos, distance, include_pos)
  local positions = {};
  local check_pos = table.copy(pos);
  
  local diff_limit = math.floor(distance);
  
  for x_diff = -diff_limit,diff_limit,1 do
    check_pos.x = pos.x + x_diff;
    for y_diff = -diff_limit,diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for z_diff = -diff_limit,diff_limit,1 do
        check_pos.z = pos.z + z_diff;
        
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
  
  local diff_limit = math.floor(distance);
  
  for x_diff = -diff_limit,diff_limit,1 do
    check_pos.x = pos.x + x_diff;
    for y_diff = -diff_limit,diff_limit,1 do
      check_pos.y = pos.y + y_diff;
      for z_diff = -diff_limit,diff_limit,1 do
        check_pos.z = pos.z + z_diff;
        
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
  return (1.0-((1.0-chance_happen)*(1.0-add_happen_chance));
end

function default.shared_add_chance_no_happen(chance_happen, add_no_happen_chance)
  return (1.0-((1.0-chance_happen)*add_no_happen_chance);
end

