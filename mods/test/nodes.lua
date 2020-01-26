
local S = test.S;

--
--
--

minetest.register_node("test:firmness", {
	description = S("Firmness test"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1, firmness = 2, resilience = 3, cavein = 5},
	drop = "test:firmness",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  after_destruct = default.firmness_after_destruct,
  
  on_drop = function(itemstack, dropper, pos)
      minetest.log("warning", "Drop test:firmness.");
      minetest.set_node(pos, {name="test:firmness"});
      return itemstack:take_item(1);
    end,
})

minetest.register_node("test:firmness_stable", {
	description = S("Firmness test stable"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1, not_in_creative_inventory=1},
	drop = "test:firmness",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  after_destruct = default.firmness_after_destruct,
})

minetest.register_node("test:firmness_falling", {
	description = S("Firmness test falling"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1, falling_node=1, landslide=90, not_in_creative_inventory=1},
	drowning = 1,
	drop = "test:firmness",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  on_construct = function (pos)
      --minetest.log("warning", "on_construct")
      minetest.after(0.1, default.check_for_landslide, pos);
    end,
})

default.register_firmness_node_change("test:firmness", "test:firmness_falling", "test:firmness_stable");

--minetest.register_abm({
--	label = "Test firmness",
--	nodenames = {"test:firmness"},
--	neighbors = {
--		"air",
--	},
--	--interval = 61,
--	interval = 11,
--	chance = 6,
--	catch_up = false,
--  action = default.firmness_abm_action,
--});

local test_formspec1 = 
    "size[8,9;]"..
    "list[context;input;2,1;1,1]"..
    "list[current_player;main;0,4.85;8,1;]"..
    "list[current_player;main;0,6.08;8,3;8]"..
    "liststring[context;input]"..
    "liststring[current_player;main]"..
    "label[4,3;label]"..
    "";
local test_formspec2 = 
    "size[8,9;]"..
    "list[context;input;2,1;1,1]"..
    "list[current_player;main;0,4.85;8,1;]"..
    "list[current_player;main;0,6.08;8,3;8]"..
    "liststring[context;input]"..
    "liststring[current_player;main]"..
    "label[4,3;jiny label]"..
    "";

minetest.register_node("test:formspec", {
	description = S("Formspec test"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1},
	drop = "test:formspec",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", test_formspec1)
      local inv = meta:get_inventory();
      inv:set_size("input",1);
      inv:set_width("input",1);
		end,
  on_receive_fields = function(pos, formname, fields, sender)
      minetest.log("warning", "Sign on receive.");
    end,
  on_metadata_inventory_put = function(pos, listname, index, sack, player)
      minetest.log("warning", "on put inventory.");
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", test_formspec2)
    end,
});

