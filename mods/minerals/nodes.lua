
local S = minerals.S;

--
--
--

minetest.register_node("minerals:ore_iron", {
	description = S("Iron ore SF"),
	tiles = {"default_stone.png^minerals_iron.png"},
	groups = {cracky = 1, firmness = 2, resilience = 3, cavein = 5},
	drop = "default:iron",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("minerals:ore_iron_crack", {
	description = S("Cracky iron ore"),
	tiles = {"default_stone.png^minerals_iron.png^default_stone_crack.png"},
	groups = {cracky = 1, falling_node = 1},
	drop = "default:iron",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
