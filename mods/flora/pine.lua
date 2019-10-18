
local S = flora.S;

--
-- pine tree
--


minetest.register_node("flora:tree_pine_trunk_1_1", {
	description = S("Pine Tree trunk 1/1"),
	tiles = {"flora_tree_pine_trunk_top_1_1.png", "flora_tree_pine_trunk_top_1_1.png",
		"flora_tree_pine_trunk_1_1.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, flora = 1, flora_tree = 1, choppy = 3, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})

minetest.register_node("flora:tree_pine_trunk_1_4", {
	description = S("Pine Tree trunk 1/4"),
	tiles = {"flora_tree_pine_trunk_top_1_4.png", "flora_tree_pine_trunk_top_1_4.png",
		"flora_tree_pine_trunk_1_4.png"},
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

minetest.register_node("flora:tree_pine_trunk_1_8", {
	description = S("Pine Tree trunk 1/8"),
	tiles = {"flora_tree_pine_trunk_top_1_8.png", "flora_tree_pine_trunk_top_1_8.png",
		"flora_tree_pine_trunk_1_8.png"},
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

minetest.register_node("flora:tree_pine_needles",{
	description = S("Pine Needles"),
	drawtype = "allfaces_optional",
	tiles = {"flora_tree_pine_needles.png"},
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

minetest.register_node("flora:tree_pine_trunk_1_4_with_needles",{
	description = S("Pine trunk with Needles"),
	drawtype = "nodebox",
	tiles = {"flora_tree_pine_needles.png^flora_tree_pine_trunk_top_1_4.png", "flora_tree_pine_needles.png^flora_tree_pine_trunk_top_1_4.png",
		"flora_tree_pine_needles.png"},
	waving = 1,
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
minetest.register_node("flora:tree_pine_trunk_1_8_with_needles",{
	description = S("Pine trunk with Needles"),
	drawtype = "nodebox",
	tiles = {"flora_tree_pine_needles.png^flora_tree_pine_trunk_top_1_8.png", "flora_tree_pine_needles.png^flora_tree_pine_trunk_top_1_8.png",
		"flora_tree_pine_needles.png"},
	waving = 1,
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

minetest.register_node("flora:tree_pine_log", {
	description = S("Pine tree log"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"flora_tree_pine_log.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("flora:tree_pine_wood", {
	description = S("Pine Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"default_pine_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("flora:pine_sapling", {
	description = S("Pine Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"default_pine_sapling.png"},
	inventory_image = "default_pine_sapling.png",
	wield_image = "default_pine_sapling.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	on_timer = grow_sapling,
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
