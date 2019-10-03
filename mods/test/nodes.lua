
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

minetest.register_abm({
	label = "Test firmness",
	nodenames = {"test:firmness"},
	neighbors = {
		"air",
	},
	--interval = 61,
	interval = 11,
	chance = 6,
	catch_up = false,
  action = default.firmness_abm_action,
});

