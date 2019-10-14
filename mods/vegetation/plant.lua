
local S = vegetation.S;

-- help functions for work with plants

vegetation.registered_plants = {};

-- flowers atc.

-- 1. state -> plant seeds
-- 2. state -> plant sprout
-- 3. state -> young plant (can be safety replanted)
-- 4. state -> next grow states
-- 5. state -> stem with flower in one node

-- stem with leaf
-- stem with flower-bud
-- stem with flower
-- stem with fertilize flower
-- stem with seed (seeds can be dig from it)
-- dry stem
-- pest stem
-- rotting stem
-- mouldy stem

-- every flower state shoul be registered separetly, 
-- can have different grow chance and can have more then one posible grow variants

-- plant definition
--
-- name -> name of plant
-- 
-- changes_to -> table with tables with target_node and present definitions {target_node="targer_node", *_presence = {}, ...} 
--            -> table keys is used like description (grow_to, pollen_to, fertilize_to, dry_to, pest_to, rot_to, mould_to etc)

-- spreadings -> table with tables {change_to="change_key", spreading = {spreading definition}}
--            -> table key is used like description (poilen, seed, pest, rot, mouldy)
--            -> change_to menas change which will be inicialized (by probability function) with rewritten basic_chance

function vegetation.register_plant(node_name, plant_def)
  if (type(node_name)~="string") then
    minetest.log("warning", "Cannot register plant without node name.");
  end
  if (type(plant_def)~="table") then
    minetest.log("warning", "Cannot register plant for node "..node_name.." without plant definition.");
  end
  
  if (type(plant_def.name)~="string") then
    minetest.log("warning", "Cannot register plant for node "..node_name.." without plant name.");
  end
  
  if (type(plant_def.grow_to)~="table") then
    minetest.log("warning", "Cannot register plant for node "..node_name.." without plant grow_to table.");
  end
  
  vegetation.registered_plants[node_name] = plant_def;
end

function vegetation.plant_grow(pos, node)
  -- find plant definition
  local plant_def = vegetation.registered_plants[node.name];
  if (plant_def == nil) then
    minetest.log("error", "Node "..node.name.." is not the plant.");
    return;
  end
  -- look for possible changes of node
  for key, change_to in pairs(plant_def.changes_to) do
    local change_chance = vegetation.presence_chance(pos, change_to, 0.0);
    if (change_chance>0) then
      local chance = default.random_generator:next(16777215)/16777215.0;
      if (chance<=change_chance) then
        minetest.swap_node(pos, {name=change_to.target_node});
        return;
      end
    end
  end
  
  -- look for spreading of node
  for key, spreading in pairs(plant_def.spreadings) do
    local change_chance = vegetation.presence_chance(pos, spreading.presence, 0.0);
    if (change_chance>0) then
      local chance = default.random_generator:next(16777215)/16777215.0;
      if (chance<=change_chance) then
        -- presence happen
        local locations = vegetation.spreading_locations(pos, spreading);
        
        for i=1,spreading.max_nodes do
          if (#locations==0) then break; end
          
          local location_index = default.random_generator:next(#locations);
          local location = locations[location_index];
          
          table.remove(locations, location_index);
          
          vegetation.plant_spreading_change(location, spreading.target_change, spreading.change_basic_chance);
        end
      end
    end
  end
end

function vegetation.plant_spreading_change(pos, change_name, change_basic_chance)
  -- get node
  local node = minetest.get_node(pos);
  -- find plant definition
  local plant_def = vegetation.registered_plants[node.name];
  if (plant_def == nil) then
    minetest.log("error", "Node "..node.name.." is not the plant.");
    return;
  end
  -- get change definition
  local change_to = plant_def.changes_to[change_name];
  if (change_to~=nil) then
    local change_chance = vegetation.presence_chance(pos, change_to, change_basic_chance);
    if (change_chance>0) then
      local chance = default.random_generator:next(16777215)/16777215.0;
      if (chance<=change_chance) then
        minetest.swap_node(pos, {name=change_to.target_node});
        return;
      end
    end
  end
end