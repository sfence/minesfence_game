
local S = tree_pine.S;

--
-- pine tree
--

minetest.register_node("tree_pine:stump_1_1", {
	description = S("Pine Tree stump 1/1"),
	tiles = {"tree_pine_trunk_top_1_1.png", "tree_pine_trunk_1_1.png",
		"tree_pine_trunk_1_1.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, flora = 1, flora_tree = 1, flora_stump = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:stump_1_4", {
	description = S("Pine Tree stump 1/4"),
	tiles = {"tree_pine_trunk_top_1_4.png", "tree_pine_trunk_1_4.png",
		"tree_pine_trunk_1_4.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-1/4, -0.5, -1/4, 1/4, 0.5, 1/4},
  },
	groups = {tree = 1, flora = 1, flora_tree = 1, flora_stump = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:stump_1_8", {
	description = S("Pine Tree stump 1/8"),
	tiles = {"tree_pine_trunk_top_1_8.png", "tree_pine_trunk_1_8.png",
		"tree_pine_trunk_1_8.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-1/8, -0.5, -1/8, 1/8, 0.5, 1/8},
  },
	groups = {tree = 1, flora = 1, flora_tree = 1, flora_stump = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:trunk_1_1", {
	description = S("Pine Tree trunk 1/1"),
	tiles = {"tree_pine_trunk_top_1_1.png", "tree_pine_trunk_top_1_1.png",
		"tree_pine_trunk_1_1.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, flora = 1, flora_tree = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:trunk_1_4", {
	description = S("Pine Tree trunk 1/4"),
	tiles = {"tree_pine_trunk_top_1_4.png", "tree_pine_trunk_top_1_4.png",
		"tree_pine_trunk_1_4.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-1/4, -0.5, -1/4, 1/4, 0.5, 1/4},
  },
	groups = {tree = 1, flora = 1, flora_tree = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:trunk_1_8", {
	description = S("Pine Tree trunk 1/8"),
	tiles = {"tree_pine_trunk_top_1_8.png", "tree_pine_trunk_top_1_8.png",
		"tree_pine_trunk_1_8.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {-1/8, -0.5, -1/8, 1/8, 0.5, 1/8},
  },
	groups = {tree = 1, flora = 1, flora_tree = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:needles",{
	description = S("Pine Needles"),
	drawtype = "allfaces_optional",
	tiles = {"tree_pine_needles.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("tree_pine:stump_1_4_with_needles",{
	description = S("Pine srunk with Needles"),
	drawtype = "nodebox",
	tiles = {"tree_pine_needles.png^tree_pine_trunk_top_1_4.png", "tree_pine_needles.png^tree_pine_trunk_top_1_4.png",
		"tree_pine_trunk_1_4.png^tree_pine_needles.png"},
	waving = 0,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, flora_stump = 1, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	
  on_place = minetest.rotate_node
})
minetest.register_node("tree_pine:stump_1_8_with_needles",{
	description = S("Pine srunk with Needles"),
	drawtype = "nodebox",
	tiles = {"tree_pine_needles.png^tree_pine_trunk_top_1_8.png", "tree_pine_needles.png^tree_pine_trunk_top_1_8.png",
		"tree_pine_trunk_1_8.png^tree_pine_needles.png"},
	waving = 0,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, flora_stump = 1, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	
  on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:trunk_1_4_with_needles",{
	description = S("Pine trunk with Needles"),
	drawtype = "nodebox",
	tiles = {"tree_pine_needles.png^tree_pine_trunk_top_1_4.png", "tree_pine_needles.png^tree_pine_trunk_top_1_4.png",
		"tree_pine_trunk_1_4.png^tree_pine_needles.png"},
	waving = 0,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	
  on_place = minetest.rotate_node
})
minetest.register_node("tree_pine:trunk_1_8_with_needles",{
	description = S("Pine trunk with Needles"),
	drawtype = "nodebox",
	tiles = {"tree_pine_needles.png^tree_pine_trunk_top_1_8.png", "tree_pine_needles.png^tree_pine_trunk_top_1_8.png",
		"tree_pine_trunk_1_8.png^tree_pine_needles.png"},
	waving = 0,
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),
	
  on_place = minetest.rotate_node
})

minetest.register_node("tree_pine:log", {
	description = S("Pine tree log"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"tree_pine_log.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("tree_pine:wood", {
	description = S("Pine Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("tree_pine:seed_planted", {
	description = S("Pine Tree planted seed"),
	drawtype = "plantlike",
	tiles = {"tree_pine_seed_planted.png"},
	inventory_image = "tree_pine_seed_planted.png",
	wield_image = "tree_pine_seed_planted.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, flora_tree_plant = 1, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

})

minetest.register_node("tree_pine:sapling", {
	description = S("Pine Tree planted seed"),
	drawtype = "plantlike",
	tiles = {"tree_pine_sapling.png"},
	inventory_image = "tree_pine_sapling.png",
	wield_image = "tree_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, flora_tree_plant = 1, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

})

minetest.register_node("tree_pine:pine_sapling", {
	description = S("Pine Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	wield_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	groups = {snappy = 2, dig_immediate = 3, flammable = 3,
		attached_node = 1, sapling = 1},
	sounds = default.node_sound_leaves_defaults(),

	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(300, 1500))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		itemstack = default.sapling_on_place(itemstack, placer, pointed_thing,
			"default:pine_sapling",
			-- minp, maxp to be checked, relative to sapling pos
			-- minp_relative.y = 1 because sapling pos has been checked
			{x = -2, y = 1, z = -2},
			{x = 2, y = 14, z = 2},
			-- maximum interval of interior volume check
			4)

		return itemstack
	end,
})

local tree_def = {
    limit = {x=4,y=10,z=4},
  }

vegetation.register_tree("Pine tree", tree_def);

local tree_part_def = {
    size = 10,
    size_diff = 1,
    grow_points = 0,
    supporter = true,
    check_supporters = 1,
    stump = true,
    
    grow_on = {},
    grow_from = nil,
    --changes_to = {},
    --spreadings = {},
  }

tree_part_def.grow_points = 0;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {
    grow_cost = 288,
    grow_chance = 1,
  };
tree_part_def.stump = true;
vegetation.register_tree_part("Pine tree", "tree_pine:stump_1_1", table.copy(tree_part_def))
tree_part_def.grow_points = 0;
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 192,
    grow_chance = 10,
  };
tree_part_def.stump = false;
vegetation.register_tree_part("Pine tree", "tree_pine:trunk_1_1", table.copy(tree_part_def))
tree_part_def.size = 9;
tree_part_def.grow_points = 0;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {
    grow_cost = 144,
    grow_chance = 2,
  };
tree_part_def.stump = true;
vegetation.register_tree_part("Pine tree", "tree_pine:stump_1_4", table.copy(tree_part_def))
tree_part_def.grow_points = 0;
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 96,
    grow_chance = 12,
  };
tree_part_def.stump = false;
vegetation.register_tree_part("Pine tree", "tree_pine:trunk_1_4", table.copy(tree_part_def))
tree_part_def.size = 8;
tree_part_def.grow_points = 0;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {
    grow_cost = 36,
    grow_chance = 3,
  };
tree_part_def.stump = true;
vegetation.register_tree_part("Pine tree", "tree_pine:stump_1_8", table.copy(tree_part_def))
tree_part_def.grow_points = 0;
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 24,
    grow_chance = 1,
  };
tree_part_def.stump = false;
vegetation.register_tree_part("Pine tree", "tree_pine:trunk_1_8", table.copy(tree_part_def))
tree_part_def.size = 8;
tree_part_def.grow_points = 12;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {
    grow_cost = 72,
    grow_chance = 4,
  };
tree_part_def.stump = true;
vegetation.register_tree_part("Pine tree", "tree_pine:stump_1_4_with_needles", table.copy(tree_part_def))
tree_part_def.grow_points = 2;
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 48,
    grow_chance = 20,
  };
tree_part_def.stump = false;
vegetation.register_tree_part("Pine tree", "tree_pine:trunk_1_4_with_needles", table.copy(tree_part_def))
tree_part_def.size = 7;
tree_part_def.grow_points = 13;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {
    grow_cost = 18,
    grow_chance = 1,
  };
tree_part_def.stump = true;
vegetation.register_tree_part("Pine tree", "tree_pine:stump_1_8_with_needles", table.copy(tree_part_def))
tree_part_def.grow_points = 3;
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 12,
    grow_chance = 25,
  };
tree_part_def.stump = false;
vegetation.register_tree_part("Pine tree", "tree_pine:trunk_1_8_with_needles", table.copy(tree_part_def))
tree_part_def.size = 6;
tree_part_def.size_diff = 3;
tree_part_def.grow_points = 2;
tree_part_def.supporter = false;
tree_part_def.check_supporters = 0;
tree_part_def.grow_on = {};
tree_part_def.grow_from = {};
local pos_hash = minetest.hash_node_position({x=0,y=1,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 1,
    grow_chance = 50,
  };
local pos_hash = minetest.hash_node_position({x=1,y=0,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 1,
    grow_chance = 25,
  };
local pos_hash = minetest.hash_node_position({x=-1,y=0,z=0});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 1,
    grow_chance = 25,
  };
--local pos_hash = minetest.hash_node_position({x=0,y=0,z=1});
--tree_part_def.grow_on[pos_hash] = {
--    grow_cost = 1,
--    grow_chance = 25,
--  };
local pos_hash = minetest.hash_node_position({x=0,y=0,z=-1});
tree_part_def.grow_on[pos_hash] = {
    grow_cost = 1,
    grow_chance = 25,
  };
vegetation.register_tree_part("Pine tree", "tree_pine:needles", table.copy(tree_part_def))



local sapling_def = {
  changes_to = {
      ["grow"]={ target_node="tree_pine:sapling", 
        basic_chance = 1.0,
        altitude_presence = {probability_multiplier = 1.0, probability_offset = 0.0, lower_steepness = 1.2, lower_border = 0, upper_steepness = 1.2, upper_border = 1000,},
        heat_presence = {probability_multiplier = 1.0, probability_offset = 0.0, lower_steepness = 1.2, lower_border = -10, upper_steepness = 1.2, upper_border = 100,},
        humidity_presence = {probability_multiplier = 1.0, probability_offset = 0.0, lower_steepness = 1.2, lower_border = -10, upper_steepness = 1.2, upper_border = 200,},
        near_presence = {},
        biome_presence = {},
      },
    },
  spreadings = {},
};
vegetation.register_plant("tree_pine:seed_planted", table.copy(sapling_def))
sapling_def.changes_to.grow.target_node = "tree_pine:stump_1_8_with_needles";
vegetation.register_plant("tree_pine:sapling", table.copy(sapling_def))
