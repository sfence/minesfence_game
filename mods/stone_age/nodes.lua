-- nodes for stone age

local S = stone_age.S

-- fromspec definitions

local formspec_flat_stone_desk = "size[8,9;]"..
		"list[context;input;2,1;1,1;]"..
		"list[context;output;5,1;2,2;]"..
		"list[current_player;main;0,4.85;8,1;]"..
		"list[current_player;main;0,6.08;8,3;8]"..
		"listring[context;input]"..
	  "listring[current_player;main]"..
		"listring[context;output]"..
		"listring[current_player;main]"..
    "";

-- node registration

minetest.register_node("stone_age:flat_stone_desk",{
  description = S("Stone desk"),
  groups = {oddly_breakable_by_hand = 1},
  drawtype = "nodebox",
  is_ground_content = false,
  tiles = {
    "stone_age_flat_stone_desk_top.png", "stone_age_flat_stone_desk_top.png",
    "stone_age_flat_stone_desk_side.png", "stone_age_flat_stone_desk_side.png",
    "stone_age_flat_stone_desk_side.png", "stone_age_flat_stone_desk_side.png",
  },
  node_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
  },
  selection_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
  },
  
  on_construct = function(pos)
      local meta = minetest.get_meta(pos);
        meta:set_string("infotext", S("Flat stone desk"))
        local inv = meta:get_inventory();
        inv:set_size("input", 1);
        inv:set_width("input", 1);
        inv:set_size("output", 1);
        inv:set_width("output", 1);
        meta:set_string("formspec", formspec_flat_stone_desk)
        meta:set_string("progress", 0)
        meta:set_string("last_recipe", 0)
    end,
 
  can_dig = function(pos, player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory();
        if  (   not(inv:is_empty("input")) 
            or  not(inv:is_empty("output"))
            ) then
          return false;
        end
        return true;
    end,
    
  on_punch = function(pos, node, puncher)
      minetest.log("warning", "Stone desk punched by something.")
      if ( not(pos) or not(node) or not(puncher)) then
        return true;
      end
      
      local wielded = puncher:get_wielded_item();
      if (not(wielded) or not(wielded:get_name()) ) then
        return true;
      end
      local wielded_name = wielded:get_name();
        
      minetest.log("warning", "Punched by "..wielded_name..".")
      
      local rough_chip_tool  = minetest.get_item_group(wielded_name, "rough_chip_tool");
      local precise_chip_tool  = minetest.get_item_group(wielded_name, "precise_chip_tool");
      
      if (rough_chip_tool > 0) then
        minetest.log("warning", "Punched by rough_chip_tool.")
        -- do something
        local meta = minetest.get_meta(pos);
        local inventory = meta:get_inventory();
        local input_table = recipes.inventory_to_table(inventory, "input");
        
        local search_recipe = {category = {"rough_stone_crafts"}, input = input_table};
        
        minetest.log("warning", "Look for recipe:"..search_recipe.category[1])
        
        local found = recipes.find_recipe(search_recipe, 1);
        
        minetest.log("warning", "Found:"..#found.." id: "..tostring(found[1]))
        
        if (#found>1) then
          minetest.log("error", "Found more then one recipe.")
        end
        
        local progress = meta:get_string("progress");
        progress = tonumber(progress) + rough_chip_tool;
        meta:set_string("progress", tostring(progress));
        
        minetest.log("warning", "State "..progress.."/"..found[1].manual["rough_chip_tool"])
        
        if (progress>=found[1].manual["rough_chip_tool"]) then
          local output_list = recipes.create_inventory_from_output(found[1].output);
          recipes.inventory_from_list(inventory, "output", output_list);
          
          minetest.log("warning", "Done.")
          meta:set_string("progress", 0);
          meta:set_string("last_recipe", 0);
        end
        
      elseif (precise_chip_tool > 0) then
        minetest.log("warning", "Punched by precise_chip_tool.")
        -- do something
      else
        minetest.log("warning", "Punched by other tool.")
        return true;
      end
      
      return false;
    end,
})

minetest.register_node("stone_age:flat_stone_table",{
  description = S("Stone table"),
  groups = {cracky=2},
  drawtype = "nodebox",
  is_ground_content = false,
  tiles = {
    "stone_age_flat_stone_table_top.png", "stone_age_flat_stone_table_bottom.png",
    "stone_age_flat_stone_table_side.png", "stone_age_flat_stone_table_side.png",
    "stone_age_flat_stone_table_side.png", "stone_age_flat_stone_table_side.png",
  },
  node_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
  },
  selection_box = {
    type = "fixed",
    fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
  },
})
  
