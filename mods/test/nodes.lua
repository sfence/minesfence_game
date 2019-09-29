
local S = test.S;

--
--
--

minetest.register_node("test:firmness", {
	description = S("Firmness test"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1, firmness = 2, resilience = 3},
	drop = "test:firmness",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("test:firmness_falling", {
	description = S("Firmness test falling"),
	tiles = {"test_node.png"},
	groups = {cracky = 1, oddly_breakable_by_hand = 1, firmness = 2, resilience = 3, falling_node=1, not_in_creative_inventory=1},
	drowning = 1,
	drop = "test:firmness",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_abm({
	label = "Test firmness",
	nodenames = {"test:firmness"},
	neighbors = {
		"air",
	},
	--interval = 61,
	interval = 11,
	chance = 1,
	catch_up = false,
	action = function(pos, node)
      local fall_it = default.is_should_fall(pos, node);
      --minetest.log("warning", "Node on pos "..dump(pos).." fall it is "..tostring(fall_it));
      if (fall_it==true) then
        minetest.set_node(pos,{name=node.name.."_falling"} )
        --minetest.spawn_falling_node(pos);
        minetest.check_for_falling(pos);
      end
    end,
  });
