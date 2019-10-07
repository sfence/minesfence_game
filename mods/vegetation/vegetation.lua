
local S = vegetation.S;

-- Vegetation
-- name -> vegetation node_name
-- type -> plant, bush, tree

-- presence of vegetation based on different environment characteristic is configured by setting structure
-- see vegetation.probability_function for more details
-- altitude_presence -> presence by altitude
-- heat_presence -> presence by heat
-- humidity_presence -> presence by humidity
-- midnight_light_presence -> presence by light intenzity on midnight
-- morning_light_presence -> presence by light intenzity on morning
-- midday_light_presence -> presence by light intenzity on midday
-- evening_light_presence -> presence by light intenzity on evening
-- biome_presence -> presence by biome parameter/group, table of presence where keys to table represent biome parameter/group name
--                -> if biome not have a parameter/group, vegetable cannot grow in that biome.

vegetation.vegetation = {};

function vegetation.register_vegetation(vegetation_data)
  if (vegetation_data.name == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without name.")
    return
  end
  if (vegetation_data.category == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without category.")
    return
  end
  if (vegetation_data.manual == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without manual.")
    return
  end
  if (vegetation_data.tool_in_order == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without tool_in_order specification.")
    return
  end
  if (vegetation_data.output == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without output.")
    return
  end
  if (vegetation_data.input == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without inputs.")
    return
  end
  
  if (vegetation.vegetation[recipe_data.category] == nil) then
    vegetation.vegetation[recipe_data.category] = {}
  end
  
  table.insert(recipes.recipes[recipe_data.category], table.copy(recipe_data))
end

vegetation.biome_parameters = {};

function vegetation.register_biome_parameters(biome_name, parameters)
  vegetation.biome_parameters[biome_name] = parameters;
end

-- 
-- vegetation probability function
--
-- max_probability*abs(1/(1+lower_steepness^(-x+lower_border))    + 1/(1+upper_steepness^(x-upper_border)) - 1)
-- 
-- probabality in lower_border and upper_border is 0.5, 
-- between lower_border and upper_border probability increase to 1, 
-- outside borders probability is decrease to 0,
-- steepnees of decrease and increase is done by lower_steepness and upper_steepness.
-- when lower_steepness < upper_steepness, function select area where vegetation can be found
-- when lower_steepness > upper_steepness, function select area where vegetation cannot be found
-- lower_steepness and upper_steepness have to be bigger then 1, values near to 1 means more gradually steepness.
-- use some program to show function graph to see probability changes
-- x is value of parameter in location
-- max_probability have to be from 0 to 1, 1 if not used, lower when you want to limit max probability.
-- setting lower_steepness and upper_steepness and max_probability to 1, disable probability sensitivity to x
-- all function parameters are stored 
-- in settings table (max_probability, lower_steepness, lower_border, upper_steepness, upper_border)
-- x is stored in actual_value fucntion parameter

function vegetation.probability_function(presence, actual_value)
  local first_part = 1/(1+presence.lower_steepness^(-actual_value+presence.lower_border));
  local second_part = 1/(1+presence.upper_steepness^(actual_value-presence.upper_border));
  local probability = presence.max_probability * math.abs(first_part + second_part - 1);
  return probability;
end

function vegetation.presence_chance(pos, presence_def)
  local grow_chance = 1.0;
  
  grow_chance = grow_chance * vegetation.probability_function(presence_def.altitude_presence, pos.y);
  
  biome_data = minetest.get_biome_data(pos);
  
  grow_chance = grow_chance * vegetation.probability_function(presence_def.heat_presence, biome_data.heat);
  grow_chance = grow_chance * vegetation.probability_function(presence_def.humidity_presence, biome_data.humidity);
  if not(presence_def.midnight_light_presence) then
    grow_chance = grow_chance * vegetation.probability_function(presence_def.midnight_light_presence, minetest.get_node_light(pos, 0.0));
  end
  if not(presence_def.morning_light_presence) then
    grow_chance = grow_chance * vegetation.probability_function(presence_def.morning_light_presence, minetest.get_node_light(pos, 0.25));
  end
  if not(presence_def.midday_light_presence) then
    grow_chance = grow_chance * vegetation.probability_function(presence_def.midday_light_presence, minetest.get_node_light(pos, 0.5));
  end
  if not(presence_def.evening_light_presence) then
    grow_chance = grow_chance * vegetation.probability_function(presence_def.evening_light_presence, minetest.get_node_light(pos, 0.75));
  end
  
  if (#presence_def.biome_presence>0) then
    biome_parameters = vegetation.biome_parameters[biome_name];
    if (biome_parameters==nil) then
      --minetest.log("warning", "Biome "..biome_name.." don't have registered any parameters.");
      return 0.0;
    end
    for parameter_key, parameter_presence in pairs(presence_def.biome_presence) do
      parameter_value = vegetation.biome_parameters[parameter_key];
      if (parameter_value==nil) then
        --minetest.log("warning", "Biome "..biome_name.." don't have registered parameter "..parameter_key);
        return 0.0;
      end
      grow_chance = grow_chance * vegetation.probability_function(parameter_presence, parameter_value);
    end
  end
  
  return grow_chance;
end

-- spreading_def
-- 
-- distance of spreading is calculated by find a solution for distance of function chance = 1/(parameter^distance)
-- parameter have to be number bigger then 1, recomended values are between 1.05 and 1.5.
-- 
-- distance_parameter -> means parameter in function
-- area_min, area_max -> area limits to look for good spreading location around random location
-- target_nodes -> list of names of nodes which can be affected, group names are supported
-- max_nodes -> affected nodes limit

function vegetation.spreading_locations(pos, spreading_def)
  local locations = {};
  
  -- chance = 1/(parameter^distance)
  -- 1/chance = parameter^distance
  -- log(parameter,1/chance) = distance
  -- ln(1/chance)/ln(parameter) = distance
  
  local chance = default.random_generator:next(16777215)/16777215.0;
  local distance = math.log(1/chance)/math.log(spreading_def.distance_parameter);
  local chance = default.random_generator:next(16777215)/16777215.0;
  local direction = 2*math.pi*chance;
  local location = {x=math.sin(direction)*distance, y=pos.y, z=math.cos(direction)*distance};
  location.x = math.floor(location.x+0.5);
  location.z = math.floor(location.z+0.5);
  
  local area_min = vector.add(location, spreading_def.area_min);
  local area_max = vector.add(location, spreading_def.area_max);
  
  local found = minetest.find_nodes_in_area(area_min, area_max, spreading_def.target_nodes);
  local distances = {};
  
  if (#found<=spreading_def.max_nodes) then
    for found_index, found_pos in pairs(found) do
      table.insert(locations, found_pos);
    end
  else
    for num=1,spreading_def.max_nodes do
      local found_index = default.random_generator:next(1, #found);
      table.insert(locations, found[found_index]);
      table.remove(found, found_index);
    end
  end
  
  return locations;
end
