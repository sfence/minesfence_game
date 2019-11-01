
local S = default.S;

--
-- rock
--

local function update_tiles(rock_def, add_picture)
  for index, tile in pairs(rock_def.tiles) do
    rock_def.tiles[index] = tile.."^"..add_picture;
  end
  return rock_def;
end

local function update_firmness_node_def(node_def)
  if (node_def.after_destruct==nil) then
    node_def.after_destruct = default.firmness_after_destruct;
  end
  
  return node_def;
end
local function update_falling_node_def(node_def)
  if (node_def.on_construct==nil) then
    node_def.on_construct = function (pos)
        minetest.log("warning", "wtf falling call")
        minetest.after(0.1, default.check_for_landslide, pos);
      end
  end
  
  return node_def;
end
local function update_node_def(node_def)
  if (node_def.groups.firmness~=nil) then
    node_def = update_firmness_node_def(node_def);
  end
  if (node_def.groups.falling_node~=nil) then
    node_def = update_falling_node_def(node_def);
  end
  return node_def;
end

-- function for register solid rock with crack rock versions and wet rocks version
--
-- rock_def -> bssic node definition
function default.register_solid_rock(rock_name, rock_def, changes_def)
  local big_stones_name = rock_name.."_stones_big";
  local medium_stones_name = rock_name.."_stones_medium";
  
  -- solid stone
  local copy_def = table.copy(rock_def);
  
  default.register_wet_rock(rock_name, copy_def, changes_def.groups_solid_stone);
  
  -- big stones
  copy_def = table.copy(rock_def);
  copy_def = update_tiles(copy_def, "default_stones_big.png");
  copy_def.groups.falling_node = 1;
  
  default.register_wet_rock(big_stones_name, copy_def, changes_def.groups_big_stones);
  
  -- medium stones
  copy_def = table.copy(rock_def);
  copy_def = update_tiles(copy_def, "default_stones_medium.png");
  copy_def.groups.falling_node = 1;
  
  default.register_wet_rock(medium_stones_name, copy_def, changes_def.groups_medium_stones);
  
  -- gravel/small stones
  
  -- erosion
  
  for index, value in pairs({"","_damp","_wet","_soggy"}) do
    for change_index, change_name in pairs({"smash","erosion"}) do
      default.register_changeable_node_change((rock_name..value), change_name, {new_node_name=big_stones_name..value,check_stability=true});
      default.register_changeable_node_change((big_stones_name..value), change_name, {new_node_name=medium_stones_name..value,check_stability=true});
    end
  end
end

function default.register_wet_rock(rock_name, rock_def, groups)
  local function groups_to_def(rock_def, groups)
    for name, value in pairs(groups) do
      rock_def.groups[name] = value;
    end
    return rock_def;
  end
  local copy_def = nil;
  
  local dry_name = rock_name;
  local damp_name = rock_name.."_damp";
  local wet_name = rock_name.."_wet";
  local soggy_name = rock_name.."_soggy";
  
  -- dry
  copy_def = table.copy(rock_def);
  copy_def = groups_to_def(copy_def, groups.dry);
  copy_def = update_node_def(copy_def);
  copy_def.groups.dry = 1;
  minetest.register_node(dry_name, copy_def);
   
  -- damp
  copy_def = table.copy(rock_def);
  copy_def = update_tiles(copy_def, "default_damp.png");
  copy_def = groups_to_def(copy_def, groups.damp);
  --copy_def.groups.not_in_creative_inventory = 1;
  copy_def.groups.damp = 1;
  copy_def = update_node_def(copy_def);
  minetest.register_node(damp_name, copy_def);
  
  -- wet
  copy_def = table.copy(rock_def);
  copy_def = update_tiles(copy_def, "default_wet.png");
  copy_def = groups_to_def(copy_def, groups.wet);
  --copy_def.groups.not_in_creative_inventory = 1;
  copy_def.groups.wet = 1;
  copy_def = update_node_def(copy_def);
  minetest.register_node(wet_name, copy_def);
   
  -- soggy
  copy_def = table.copy(rock_def);
  copy_def = update_tiles(copy_def, "default_soggy.png");
  copy_def = groups_to_def(copy_def, groups.soggy);
  --copy_def.groups.not_in_creative_inventory = 1;
  copy_def.groups.soggy = 1;
  copy_def = update_node_def(copy_def);
  minetest.register_node(soggy_name, copy_def);
  
  -- changeable register
  default.register_changeable_node_change(dry_name, "wet", {new_node_name=damp_name,check_stability=false});
  
  default.register_changeable_node_change(damp_name, "wet", {new_node_name=wet_name,check_stability=false});
  default.register_changeable_node_change(damp_name, "dry", {new_node_name=dry_name,check_stability=false});
  
  default.register_changeable_node_change(wet_name, "wet", {new_node_name=soggy_name,check_stability=false});
  default.register_changeable_node_change(wet_name, "dry", {new_node_name=damp_name,check_stability=false});
  default.register_changeable_node_change(soggy_name, "dry", {new_node_name=wet_name,check_stability=false});
end

