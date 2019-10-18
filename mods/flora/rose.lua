
local S = flora.S;

--
-- roses
--

-- red rose


local function register_rose(name, desc, box, f_groups)
	-- Common flowers' groups
	f_groups.snappy = 3
	f_groups.flower = 1
	f_groups.flora_plant = 1
	f_groups.attached_node = 1

	minetest.register_node("flora:" .. name, {
		description = name,
		drawtype = "plantlike",
		waving = 1,
		tiles = {"flora_" .. name .. ".png"},
		inventory_image = "flora_" .. name .. ".png",
		wield_image = "flora_" .. name .. ".png",
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		groups = f_groups,
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = box
		}
	})
end
local box = {-2 / 16, -0.5, -2 / 16, 2 / 16, 5 / 16, 2 / 16};
register_rose("rose_seed_planted", "", box, {});
register_rose("rose_sprout", "", box, {});
register_rose("rose_stem_leaf1", "", box, {});
register_rose("rose_stem_leaf2", "", box, {});
register_rose("rose_stem_leaf3", "", box, {});
register_rose("rose_stem_leaf4", "", box, {});
register_rose("rose_stem_flower_bud", "", box, {});
register_rose("rose_stem_flower", "", box, {});
register_rose("rose_stem_flower_fertilize", "", box, {});
register_rose("rose_stem_seed", "", box, {});

minetest.log("warning", "Red rose registered.");

local rose_def = {
  changes_to = {
      ["grow"]={ target_node="flora:rose_sprout", 
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
vegetation.register_plant("flora:rose_seed_planted", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_leaf1";
vegetation.register_plant("flora:rose_sprout", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_leaf2";
vegetation.register_plant("flora:rose_stem_leaf1", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_leaf3";
vegetation.register_plant("flora:rose_stem_leaf2", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_leaf4";
vegetation.register_plant("flora:rose_stem_leaf3", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_flower_bud";
vegetation.register_plant("flora:rose_stem_leaf4", table.copy(rose_def))
rose_def.changes_to.grow.target_node = "flora:rose_stem_flower";
vegetation.register_plant("flora:rose_stem_flower_bud", table.copy(rose_def))

