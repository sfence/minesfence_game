
local S = building.S;

minetest.register_node("building:wall", {
	description = S("Cobble wall"),
	tiles = {"default_cobble.png"},
	groups = {cracky = 1},
	drop = "buiilding:wall",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  on_place = function(itemstack, placer, pointed_thing)
      if (placer~=nil) then
        minetest.log("warning", "on_place of building wall.");
        if (pointed_thing.type=="node") then
          local pointed_node = minetest.get_node(pointed_thing.under);
          local node_def = minetest.registered_nodes[pointed_node.name];
          local plan_pos = pointed_thing.above;
          if ((node_def) and (node_def.buildable_to==true)) then
            plan_pos = pointed_thing.under;
          end
          --minetest.set_node(plan_pos, {name="building:plan_3x3"});
          minetest.rotate_node(ItemStack("building:plan_3x3"), placer, pointed_thing)
        
          local search_recipe = {categories = {"building"}, output = {"building:wall"}};
          local founds = recipes.find_recipe_by_output(search_recipe);
          
          minetest.log("warning", "Recipes: "..tostring(#founds));
          
          if (#founds~=1) then
            minetest.log("error", "[Building] More then one building recipes is registered for build building:wall");
          end
          
          local recipe = founds[1];
          
          local meta = minetest.get_meta(plan_pos);
          
          local recipe_sha1 = minetest.sha1(dump(recipe));
          progress_list = recipes.create_progress_list(recipe);
          progress_string = table.concat(progress_list, ";");
          meta:set_string("output", "building:wall");
          meta:set_string("progress", progress_string);
          meta:set_string("last_recipe", recipe_sha1);
          
          local inventory = meta:get_inventory();
          
          inventory:set_list("target", {ItemStack("building:wall")});
          
          recipes.inventory_from_table(inventory, "missing", recipe.input);
          
        
        end
        return itemstack;
      end
      return minetest.on_place(itemstack, placer, pointed_thing);
    end,
})

minetest.register_node("building:plan_3x3", {
	description = S("Building plan 3x3"),
	tiles = {"building_plan_top.png", "building_plan_bottom.png",
            "building_plan_right.png", "building_plan_left.png",
            "building_plan_back.png", "building_plan_front.png"},
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {
              {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
              {0, 0, 0, 0.5, 0.5, 0.5},
            },
  },
  use_texture_alpha = true,
	paramtype2 = "facedir",
	is_ground_content = false,
  walkable = false,
	groups = {oddly_breakable_by_hand = 1},
	sounds = default.node_sound_wood_defaults(),
  
  on_place = minetest.rotate_node,
  
  on_construct = function(pos)
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory();
      inv:set_size("missing", 9);
      inv:set_width("missing", 3);
      inv:set_size("input", 9);
      inv:set_width("input", 3);
      inv:set_size("target", 1);
      inv:set_width("target", 1);
      meta:set_string("formspec", "size[12,9;]"..
                                  "label[1,0;Missing]"..
                                  "list[context;missing;1,0.5;3,3;]"..
                                  "label[5,0;Inputs]"..
                                  "list[context;input;5,0.5;3,3;]"..
                                  "label[9,0;Build result]"..
                                  "list[context;target;9,1.5;1,1;]"..
                                  "list[current_player;main;0,4.85;8,1;]"..
                                  "list[current_player;main;0,6.08;8,3;8]"..
                                  "liststring[context;missing]"..
                                  "liststring[context;target]"..
                                  "liststring[context;input]"..
                                  "liststring[current_player;main;]"..
                                  "liststring[current_player:main]")
    end,
  
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_lst, to_index, count, player)
      return 0;
    end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      minetest.log("warning", "put_allow")
      if (player~=nil) then
        if (listname~="input") then
          return 0;
        end
        
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory();
        
        local missing = inv:get_stack("missing", index);
        
        local allow = math.min(missing:get_count(),stack:get_count());
        
        return allow;
      else
        minetest.node_metadata_inventory_offer_allow(pos, listname, index, stack, player)
      end
    end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
      if (listname~="input") then
        return;
      end
      
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory();
      
      local missing = inv:get_stack("missing", index);
      
      local allow = math.min(missing:get_count(),stack:get_count());
      
      missing:take_item(allow);
      inv:set_stack("missing", index, missing);
    end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
      if (listname~="input") then
        return 0;
      end
      
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory();
      
      local input = inv:get_stack("input", index);
      
      local allow = math.min(input:get_count(),stack:get_free_space());
      
      return allow;
    end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
      if (listname~="input") then
        return;
      end
      
      local meta = minetest.get_meta(pos);
      local inv = meta:get_inventory();
      
      local input = inv:get_stack("input", index);
      local missing = inv:get_stack("missing", index);
      
      --minetest.log("warning", dump(stack:get_name()))
      local addItem = ItemStack(stack:get_name());
      --minetest.log("warning", dump(addItem:get_name()))
      --minetest.log("warning", dump(stack:get_count()+missing:get_count()))
      addItem:set_count(stack:get_count()+missing:get_count());
      --minetest.log("warning", dump(addItem:get_name()))
      inv:set_stack("missing", index, addItem);
    end,
  
  on_punch = function (pos, node, puncher)
      local settings = {
          input_list = "input",
          output_list = "target",
          missing_list = "missing",
          recipe_categories = {"building"},
        };
      return recipes.build_on_punch(pos, node, puncher, settings);
    end,
})

recipes.register_recipe({
  name = S("Build plan wall"),
  category = "building",
  manual = {{hand_work={points=30,level=1,wear=1}}},
  tool_in_order = false,
  output = {"building:wall"},
  input = {{"default:cobble","default:cobble"},
           {"default:cobble","default:cobble"},},
})
