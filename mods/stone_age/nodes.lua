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
      local settings = {
          input_list = "input",
          output_list = "output",
          recipe_categories = {"rough_stone_crafts"},
        };
      return recipes.work_on_push(pos, node, puncher, settings);
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
  
