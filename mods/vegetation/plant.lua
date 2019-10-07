
local S = vegetation.S;

-- help functions for work with plants

-- flowers atc.

-- 1. state -> plant seeds
-- 2. state -> plant sprout
-- 3. state -> young plant (can be safety replanted)
-- 4. state -> next grow states
-- 5. state -> stem with flower in one node

-- stem with leaf
-- stem with flower-bud
-- stem with flower
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
-- grow_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- pollen_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- dry_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- pest_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- rot_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- mould_to -> table with target_node and present definitions {target_node="targer_node", *_present = {}, ...}
-- pollen_spreading -> table with spreading definition
-- seed_spreading -> table with spreading definition
-- pest_spreading -> table with spreading definition
-- rot_spreading -> table with spreading definition
-- mouldy_spreading -> table with spreading definition

vegetation.plants = {};

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
  
  vegetation.plants[node_name] = plant_def;
end