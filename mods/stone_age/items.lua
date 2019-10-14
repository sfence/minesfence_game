-- items for stone age

local S = stone_age.S

--
-- work with stones
--

minetest.register_craftitem("stone_age:flint_fragment", {
	description = S("Flint fragment"),
	inventory_image = "stone_age_flint_fragment.png",
	groups = {},
})

minetest.register_craftitem("stone_age:flint_shard", {
	description = S("Flint shard (sharp)"),
	inventory_image = "stone_age_flint_shard.png",
	groups = {},
})

minetest.register_craftitem("stone_age:stone_soft_fragment", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_stone_soft_fragment.png",
	groups = {},
})

minetest.register_craftitem("stone_age:axe_head_soft_stone", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_axe_head_soft_stone.png",
	groups = {},
})

minetest.register_craftitem("stone_age:axe_head_soft_stone_sharpen", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_axe_head_soft_stone.png",
	groups = {},
})

minetest.register_craftitem("stone_age:axe_head_soft_stone_with_aperture", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_axe_head_soft_stone.png",
	groups = {},
})

minetest.register_craftitem("stone_age:axe_head_soft_stone_sharpen_with_aperture", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_axe_head_soft_stone.png",
	groups = {},
})

minetest.register_craftitem("stone_age:stone_soft_hammer_head_soft_stone", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_hammer_head_soft_stone.png",
	groups = {},
})

minetest.register_craftitem("stone_age:hammer_head_soft_stone_with_aperture", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_hammer_head_soft_stone_with_aperture.png",
	groups = {},
})

minetest.register_craftitem("stone_age:chisel_flint", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_chisel_flint.png",
	groups = {},
})

minetest.register_craftitem("stone_age:chisel_soft_stone", {
	description = S("Soft stone fragment"),
	inventory_image = "stone_age_chisel_soft_stone.png",
	groups = {},
})

--
-- work with wood
--

minetest.register_craftitem("stone_age:handle_wood", {
	description = S("Wood handle"),
	inventory_image = "stone_age_handle_wood.png",
	groups = {},
})

minetest.register_craftitem("stone_age:handle_wood_thick", {
	description = S("Wood handle"),
	inventory_image = "stone_age_handle_wood_thick.png",
	groups = {},
})

minetest.register_craftitem("stone_age:handle_wood_thick_with_aperture", {
	description = S("Wood handle with aperture"),
	inventory_image = "stone_age_handle_wood_thick_with_aperture.png",
	groups = {},
})

--
-- for fire
--

minetest.register_craftitem("stone_age:tinder_spark", {
	description = S("High flammable tinder"),
	inventory_image = "stone_age_tinder_spark.png",
	groups = {tinder = 1, flammable = 5},
})

--
--
--
