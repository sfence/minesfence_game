-- nodes for stone age

local S = stone_age.S

-- fromspec definitions

function stone_age.get_flat_stone_desk_formspec(recipes, selected)
  local variants = "";
  local separator = "";
  for key, recipe in pairs(recipes) do
    variants = variants..separator..recipe.name;
    separator = ",";
  end
  return "size[8,9;]"..
		"list[context;input;2,1;1,1;]"..
		"list[context;output;5,1;2,2;]"..
		"list[current_player;main;0,4.85;8,1;]"..
		"list[current_player;main;0,6.08;8,3;8]"..
		"listring[context;input]"..
	  "listring[current_player;main]"..
		"listring[context;output]"..
		"listring[current_player;main]"..
    "textlist[4,3;4,1;output_select;"..variants..";"..tonumber(selected)..";no]"..
    "";
end

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
      inv:set_size("output", 4);
      inv:set_width("output", 2);
      meta:set_string("formspec", stone_age.get_flat_stone_desk_formspec({}, 1));
      meta:set_string("progress", "");
      meta:set_string("last_recipe", "");
      meta:set_int("fromspec_recipe_select", 1);
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
  on_receive_fields = function(pos, formname, fields, sender)
      local settings = {
          input_list = "input",
          output_list = "output",
          recipe_categories = {"rough_stone_crafts"},
          selection_field_name = "output_select",
          formspec_function = stone_age.get_flat_stone_desk_formspec,
        };
      minetest.log("warning", "on_receive_fields "..dump(fields)) 
      recipes.on_receive_fields(pos, fields, settings, 4)
    end,
  on_metadata_inventory_move = function(pos)
      local settings = {
          input_list = "input",
          output_list = "output",
          recipe_categories = {"rough_stone_crafts"},
          selection_field_name = "output_select",
          formspec_function = stone_age.get_flat_stone_desk_formspec,
        };
      minetest.log("warning", "on_receive_fields "..dump(fields)) 
      recipes.on_inventory_update(pos, settings, 4)
    end,
  on_metadata_inventory_put = function(pos)
      local settings = {
          input_list = "input",
          output_list = "output",
          recipe_categories = {"rough_stone_crafts"},
          selection_field_name = "output_select",
          formspec_function = stone_age.get_flat_stone_desk_formspec,
        };
      minetest.log("warning", "on_receive_fields "..dump(fields)) 
      recipes.on_inventory_update(pos, settings, 4)
    end,
  on_metadata_inventory_take = function(pos)
      local settings = {
          input_list = "input",
          output_list = "output",
          recipe_categories = {"rough_stone_crafts"},
          selection_field_name = "output_select",
          formspec_function = stone_age.get_flat_stone_desk_formspec,
        };
      minetest.log("warning", "on_receive_fields "..dump(fields)) 
      recipes.on_inventory_update(pos, settings, 4)
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
  
