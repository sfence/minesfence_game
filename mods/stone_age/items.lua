-- items for stone age

local S = stone_age.S

--
-- for crafting
--

--
-- for fire
--

minetest.register_tool("stone_age:tinder_spark", {
	description = S("High flammable tinder"),
	inventory_image = "stone_age_tinder_spark.png",
	groups = {tinder = 1, flammable = 5},
})

--
--
--
