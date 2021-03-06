
local S = vegetation.S;

-- help functions for work with trees

vegetation.tree_name_from_node_name = {};
vegetation.registered_trees = {};

-- 1. state -> seeds
-- 2. state -> sapling
-- 3. state -> 1/8 tree trunk with leaves/needles
-- 4. state -> random grow started....

-- tree trunk on ground is special node, abm actions is targeted to it
-- parent calculate chance to tree grow and process it through tree
-- parent calculate chance to deatch...

-- parent tree stump 1/8, 1/4, 1/1
-- live tree trunk 1/8, 1/4, 1/1
-- bud tree trunk 1/8, 1/4 with leaves/needles(can change to live, or grow)
-- deatch tree trunk 1/8, 1/4, 1/1
-- dry tree trunk 1/8, 1/4, 1/1
-- wet moudler tree trunk
-- dry moudler tree trunk (can be used to make fire?, have to be done by drying)
-- fertilizer (by same chance)
-- nothing

-- live leaves/needles
-- leaves/needles with blossom
-- leaves/needles with fertilize blossom
-- leaves/needles with fruit/cone
-- dry leaves/needles
-- brushwood
-- nothing

-- combine with plant for blossom fertilize? or full leaves/needles life?

-- fruit/cone can change back to live leaves/neadles with chance to seeds itself to some distance...

-- tree function for treetop is defined by actual tree height
-- for each grow part some points is calculated, and from points is calculated chance for grow that part
-- number of grow is defined by maximum grow points and random function defined by biome and tree vitality

-- tree part size for define growing. 
-- Only bigger size can replace lower one.
-- only lower size can be supported to grow
-- can change_to only, if have near part with same/bigger size when condition.size_check is yes/no
-- can change_to only, if there will be only one supporter in grow location when condition.prevent_more_support_grow is yes

-- tree definition        
--
-- limit -> table x, z limits and y as height limit.
--       -> auto size calculation without limit can be a problem in forests
-- 
-- parts -> table created by tree_part register function.
-- supporters -> table created by tree_part register function.
-- grows_on -> table created by tree_part register function.

function vegetation.register_tree(tree_name, tree_def)
  tree_def.parts = {};
  tree_def.nodes = {};
  tree_def.supporters = {};
  tree_def.grow_on = {};
  vegetation.registered_trees[tree_name] = tree_def;
end

-- tree part definition
-- 
-- size -> size value, can grow only when is supported by bigger size part
--      -> parts with size-1 have bigger chance to grow with support
--      -> 0 is not allowed value
-- size_diff -> limit of size_diff to grow on
--           -> for trunk should be 1, for leaves can be bigger
--
-- grow_points -> number of grow points added by this tree part
--
-- supporter -> true/false - can support grow
-- check_supporters -> number, 0 do not check, or max distance of supporters, maximum efective distacnce is lower then 2.0
-- stump -> true/false - is tree stump
--
-- grow_on -> table with grow cost and grow chance based on location diff x, y, z as hash by minetest.hash_node_position function
--         -> [0, 0, 0] is supporter node
--         -> use only 0, -1 and 1 diffs
--         -> keep nil if part is accesable only by changes_to
-- grow_from -> table with grow cost and grow chance for supporter node
--
-- changes_to -> table with tables with target_node and present definitions {target_node="targer_node", condition={}, *_presence = {}, ...} 
--            -> table keys is used like description (grow_to, pollen_to, fertilize_to, dry_to, pest_to, rot_to, mould_to etc)
--            -> condition -> size_check = yes/no, prevent_more_support_grow = yes/no
--            -> should be used only for levase->blosom, changing to death, dry, mold etc.
--
-- spreadings -> table with tables {change_to="change_key", spreading = {spreading definition}}
--            -> table key is used like description (poilen, seed, pest, rot, mouldy)
--            -> change_to menas change which will be inicialized (by probability function) with rewritten basic_chance

function vegetation.register_tree_part(tree_name, tree_part_node_name, tree_part_def)
  vegetation.registered_trees[tree_name].parts[tree_part_node_name] = tree_part_def
  table.insert(vegetation.registered_trees[tree_name].nodes, tree_part_node_name);
  if (tree_part_def.supporter==true) then
    table.insert(vegetation.registered_trees[tree_name].supporters, tree_part_node_name);
  end
  if (tree_part_def.grow_on~=nil) then
    table.insert(vegetation.registered_trees[tree_name].grow_on, tree_part_node_name);
  end
  vegetation.tree_name_from_node_name[tree_part_node_name] = tree_name;
end

function vegetation.tree_part_grow(pos, node)
  -- find tree definition
  local tree_name = vegetation.tree_name_from_node_name[node.name];
  if (tree_name==nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree.");
    return;
  end
  -- find tree part definition
  local tree_def = vegetation.registered_trees[tree_name];
  local tree_part_def = tree_def.parts[node.name];
  if (tree_part_def == nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree "..tree_name..".");
    return;
  end
  -- look for possible changes of tree part
  for key, change_to in pairs(tree_part_def.changes_to) do
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
  for key, spreading in pairs(tree_part_def.spreadings) do
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
          
          vegetation.tree_part_spreading_change(location, spreading.target_change, spreading.change_basic_chance);
        end
      end
    end
  end
end

function vegetation.tree_part_spreading_change(pos, change_name, change_basic_chance)
  -- get node
  local node = minetest.get_node(pos);
  -- find tree definition
  local tree_name = vegetation.tree_name_from_node_name[node.name];
  if (tree_name==nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree.");
    return;
  end
  -- find tree part definition
  local tree_def = vegetation.registered_trees[tree_name];
  local tree_part_def = tree_def.parts[node.name];
  if (tree_part_def == nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree "..tree_name..".");
    return;
  end
  -- get change definition
  local change_to = tree_part_def.changes_to[change_name];
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

function vegetation.tree_stump_grow(pos, node, grow_points_multiplier)
  -- find tree definition
  local tree_name = vegetation.tree_name_from_node_name[node.name];
  if (tree_name==nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree.");
    return;
  end
  -- find tree part definition
  local tree_def = vegetation.registered_trees[tree_name];
  local supporter_def = tree_def.parts[node.name];
  if (supporter_def == nil) then
    minetest.log("error", "Node "..node.name.." is not the part of tree "..tree_name..".");
    return;
  end
  -- tree area by limit
  local tree_data = vegetation.tree_get_data(pos, tree_def);
  minetest.log("warning", "tree_data: "..dump(tree_data));
  
  -- measure tree height
  
  local tree_height = tree_data.max_y - pos.y + 1;
  
  local grow_variants = {};
  
  -- check all positions around supporter nodes for grow_on
  for index, supporter_pos in pairs(tree_data.supporters) do
    local supporter_node = minetest.get_node(supporter_pos);
    
    supporter_def = tree_def.parts[supporter_node.name];
    if ((supporter_def~=nil) and (supporter_def.supporter==true)) then
      minetest.log("warning", "Supporter: "..dump(supporter_node))
      local positions = default.shared_positions_in_cube(supporter_pos, 1, false)
      for check_index, check_pos in pairs(positions) do
        local check_node = minetest.get_node(check_pos);
        local check_node_def = minetest.registered_nodes[check_node.name];
        local check_grow_on = false;
        local check_pos_part_size = 0;
        -- is location free to check_grow_on?
        if ((check_node_def==nil) or (check_node_def.buildable_to==true)) then
          check_grow_on = true;
        else
          local tree_part_def = tree_def.parts[check_node.name];
          if (tree_part_def~=nil) then
            check_grow_on = true;
            check_pos_part_size = tree_part_def.size;
          end
        end
        
        if (check_grow_on==true) then
          grow_variants = vegetation.tree_part_check_grow_on(grow_variants, tree_def, supporter_pos, supporter_def, check_pos, check_pos_part_size, tree_data.grow_points)
        end
      end
      
      grow_variants = vegetation.tree_part_check_grow_from(grow_variants, tree_def, supporter_pos, supporter_def, tree_data.grow_points)
    end
  end
  
  -- grow if possible
  minetest.log("warning", "Grow_variants: "..dump(grow_variants))
  if (#grow_variants > 0) then
    local grow_points = tree_data.grow_points;
    -- calculate sum of grow points in all variants
    local grow_chance_sum = 0;
    for index, grow_variant in pairs(grow_variants) do
      grow_chance_sum = grow_chance_sum + grow_variant.chance_points;
    end
    -- until some of grow variant is accesable
    while (#grow_variants > 0) do
      -- use grow_points for random, bigger chance for bigger growing
      local grow_random = default.random_generator:next(1,grow_chance_sum);
      local grow_index = 0;
      
      for index, grow_variant in pairs(grow_variants) do
        if (grow_random>grow_variant.chance_points) then
          grow_random = grow_random - grow_variant.chance_points;
        else
          grow_index = index;
          break;
        end
      end
      
      --cheepest variant of grow variant random select
      --local grow_index = default.random_generator:next(1,#grow_variants);
      
      local grow_variant = grow_variants[grow_index];
      
      -- do grow
      minetest.log("warning", "Do grow: "..dump(grow_variant))
      minetest.set_node(grow_variant.pos, {name=grow_variant.target_node});
      
      -- reduce for next grow select
      grow_points = grow_points - grow_variant.cost_points;
      grow_chance_sum = grow_chance_sum - grow_variant.chance_points;
      
      table.remove(grow_variants, grow_index);
      
      -- create remove list, adding to end
      local remove_indexes = {};
      for index, grow_variant in pairs(grow_variants) do
        if (grow_variant.cost_points<grow_points) then
          table.insert(remove_indexes, index);
          grow_chance_sum = grow_chance_sum - grow_variant.chance_points;
        end
      end
      
      -- remove from end by list
      for index = #remove_indexes, 1, -1 do
        table.remove(grow_variants, remove_indexes[index])
      end
    end
  end
end

function vegetation.tree_get_data(pos, tree_def)
  -- tree area by limit
  local area_min = {x = pos.x - tree_def.limit.x,
                    y = pos.y,
                    z = pos.z - tree_def.limit.z};
  local area_max = {x = pos.x + tree_def.limit.x,
                    y = pos.y + tree_def.limit.y,
                    z = pos.z + tree_def.limit.z};
   
  -- find all locations supported by stump
  local checked_positions = {};
  local check_supporter_positions = {pos};
  local supporter_positions = {};
  local grow_points = 0;
  local max_y = pos.y;
  while (#check_supporter_positions>0) do
    minetest.log("warning", "Check supporter positons: "..tostring(#check_supporter_positions))
    local next_check_supporter_positions = {};
    local check_pos = {};
    for index, supporter_pos in pairs(check_supporter_positions) do
      for x_diff = -1,1,1 do
        check_pos.x = supporter_pos.x + x_diff;
        for y_diff = -1,1,1 do
          check_pos.y = supporter_pos.y + y_diff;
          for z_diff = -1,1,1 do
            check_pos.z = supporter_pos.z + z_diff;
            -- check if postion is in tree area
            if (    (check_pos.x>=area_min.x)and(check_pos.x<=area_max.x)
                 and(check_pos.y>=area_min.y)and(check_pos.x<=area_max.y)
                 and(check_pos.z>=area_min.z)and(check_pos.x<=area_max.z) ) then
              minetest.log("warning", "In tree area.")
              local hash_pos = minetest.hash_node_position(check_pos);
              if (checked_positions[hash_pos]==nil) then
                -- only if node has not been checked
                local check_node = minetest.get_node(check_pos);
                if (check_node~=nil) then
                  local tree_part_def = tree_def.parts[check_node.name];
                  
                  if (tree_part_def~=nil) then
                    if (tree_part_def.supporter==true) then
                      table.insert(next_check_supporter_positions, table.copy(check_pos));
                      table.insert(supporter_positions, table.copy(check_pos));
                      
                      if (max_y<check_pos.y) then
                        max_y = check_pos.y;
                      end
                    end
                    if (tree_part_def.grow_points>0) then
                      --table.insert(grow_matrix, check_pos);
                      grow_points = grow_points + tree_part_def.grow_points;
                    end
                  end
                end
                checked_positions[hash_pos] = true;
              end
            end
          end
        end
      end
    end
    check_supporter_positions = next_check_supporter_positions;
  end
  
  local tree_data = {};
  
  tree_data.supporters = supporter_positions; 
  tree_data.grow_points = grow_points;
  tree_data.max_y = max_y;
  
  return tree_data;
end

function vegetation.tree_part_check_grow_on(grow_variants, tree_def, supporter_pos, supporter_def, check_pos, check_pos_part_size, max_grow_cost)
  minetest.log("warning", "Check grow of node:"..default.shared_log_position(check_pos));
  minetest.log("warning", "Supporter def:"..dump(supporter_def));
  for tree_part_node_name, tree_part_def in pairs(tree_def.parts) do
    if (tree_part_def.grow_on~=nil) then
        minetest.log("warning", "Tree part "..tree_part_node_name.." def:"..dump(tree_part_def));
      if (    (supporter_def.size>=tree_part_def.size)
          and ((supporter_def.size-tree_part_def.size)<=tree_part_def.size_diff)
          and (check_pos_part_size<tree_part_def.size)) then
        minetest.log("warning", "Tree part "..tree_part_node_name.." def:"..dump(tree_part_def));
        for hash_pos,grow_data in pairs(tree_part_def.grow_on) do
          local grow_on_pos = minetest.get_position_from_hash(hash_pos);
          minetest.log("warning", "Decode hash: "..default.shared_log_position(grow_on_pos).." for supporter pos: "..default.shared_log_position(supporter_pos).." and check_pos: "..default.shared_log_position(check_pos))
          if (  (grow_on_pos.x~=0) or (grow_on_pos.y~=0) or (grow_on_pos.z~=0) ) then
            -- minetest.log("warning", "Decode hash: "..dump(grow_on_pos))
            -- condition is relevant only for relevant grow_on by the position of supporter and eheck_pos
            if (    ((supporter_pos.x+grow_on_pos.x)==check_pos.x)
                and ((supporter_pos.y+grow_on_pos.y)==check_pos.y)
                and ((supporter_pos.z+grow_on_pos.z)==check_pos.z)) then
              
              minetest.log("warning", "Get grow positon. Check for collisions.")
              local more_supporters = false;
              if (tree_part_def.check_supporters>0) then
                -- look for other more supporters prevention
                local area_min = {x=check_pos.x-1, y=check_pos.y-1, z=check_pos.z-1};
                local area_max = {x=check_pos.x+1, y=check_pos.y+1, z=check_pos.z+1};
                local founds = minetest.find_nodes_in_area(area_min, area_max, tree_def.supporters);
                minetest.log("warning", "Find "..tostring(#founds).." supporters.")
                if (#founds>1) then
                  -- supporters have to be checked
                  for index, found_pos in pairs(founds) do
                    -- no check itself
                    if (  (found_pos.x~=check_pos.x)
                        or(found_pos.y~=check_pos.y)
                        or(found_pos.z~=check_pos.z)) then
                      -- no check main supporter
                      if (  (found_pos.x~=supporter_pos.x)
                          or(found_pos.y~=supporter_pos.y)
                          or(found_pos.z~=supporter_pos.z)) then
                      -- distance limit check (1 for only check one axe diff)
                        local distance = (found_pos.x-supporter_pos.x)^2;
                        distance = distance + (found_pos.y-supporter_pos.y)^2;
                        distance = distance + (found_pos.z-supporter_pos.x)^2;
                        if (distance<=(tree_part_def.check_supporters^2)) then
                          found_node = minetest.get_node(found_pos);
                          found_tree_part_def = tree_def.parts[found_node.name];
                          
                          if (    (found_tree_part_def.supporter==true)
                              and (found_tree_part_def.size>tree_part_def.size)
                              and ((found_tree_part_def.size-tree_part_def.size)<=tree_part_def.size_diff)) then
                            -- more supporters
                            more_supporters = true;
                          end
                        end
                      end
                    end
                  end
                  if (more_supporters==true) then
                    minetest.log("warning", "more_supporters");
                  end
                end
              end
              
              if (more_supporters==false) then
                local grow_cost = grow_data.grow_cost * (tree_part_def.size-check_pos_part_size);
                
                minetest.log("warning", "Grow_cost: "..tostring(grow_cost))
                if (grow_cost<=max_grow_cost) then
                  local grow_variant = {cost_points = grow_cost, chance_points=grow_data.grow_chance, target_node = tree_part_node_name, pos = table.copy(check_pos)};
                  table.insert(grow_variants, grow_variant);
                  minetest.log("warning", "Add grow variant: "..dump(grow_variant));
                end
                -- break;
              end
            end
          end
        end
      end
    end
  end
  
  return grow_variants;
end

function vegetation.tree_part_check_grow_from(grow_variants, tree_def, supporter_pos, supporter_def, max_grow_cost)
  minetest.log("warning", "Check grow from of node:"..default.shared_log_position(supporter_pos));
  minetest.log("warning", "Supporter def:"..dump(supporter_def));
  for tree_part_node_name, tree_part_def in pairs(tree_def.parts) do
    if (tree_part_def.grow_from~=nil) then
      if (supporter_def.size<tree_part_def.size) then
        if (tree_part_def.stump==supporter_def.stump) then
          minetest.log("warning", "Tree part "..tree_part_node_name.." def:"..dump(tree_part_def));
          if (tree_part_def.supporter==true) then
            -- look for other more supporters prevention
            local area_min = {x=supporter_pos.x-1, y=supporter_pos.y-1, z=supporter_pos.z-1};
            local area_max = {x=supporter_pos.x+1, y=supporter_pos.y+1, z=supporter_pos.z+1};
            local founds = minetest.find_nodes_in_area(area_min, area_max, tree_def.supporters);
            minetest.log("warning", "Find "..tostring(#founds).." supporters.")
            if (#founds>1) then
              -- supporters have to be checked
              local more_supporters = false;
              for index, found_pos in pairs(founds) do
                -- no check itself/main supporter
                if (  (found_pos.x~=supporter_pos.x)
                    or(found_pos.y~=supporter_pos.y)
                    or(found_pos.z~=supporter_pos.z)) then
                  found_node = minetest.get_node(found_pos);
                  found_tree_part_def = tree_def.parts[found_node.name];
                  
                  if (    (found_tree_part_def.supporter==true)
                      and (found_tree_part_def.size>tree_part_def.size)
                      and ((found_tree_part_def.size-tree_part_def.size)<=tree_part_def.size_diff)) then
                    -- more supporters
                    more_supporters = true;
                    break;
                  end
                end
              end
              if (more_supporters==true) then
                minetest.log("warning", "more_supporters");
                -- break;
              end
            end
          end
              
          local grow_data = tree_part_def.grow_from;
          local grow_cost = grow_data.grow_cost * (tree_part_def.size-supporter_def.size);
          
          minetest.log("warning", "Grow_cost: "..tostring(grow_cost))
          if (grow_cost<=max_grow_cost) then
            local grow_variant = {cost_points = grow_cost, chance_points=grow_data.grow_chance, target_node = tree_part_node_name, pos = table.copy(supporter_pos)};
            table.insert(grow_variants, grow_variant);
            minetest.log("warning", "Add grow variant: "..dump(grow_variant));
          end
        end
      end
    end
  end
  
  return grow_variants;
end
