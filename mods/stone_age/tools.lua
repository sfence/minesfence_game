
local S = stone_age.S

-- stone age tools

--
-- ship tool
-- 

minetest.register_tool("stone_age:ship_stone_hard", {
	description = S("Hard ship stone"),
	inventory_image = "default_stone_hard.png",
	tool_capabilities = {
		full_punch_interval = 1.7,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=15.2, [3]=2.60}, uses=12, maxlevel=1},
		},
		damage_groups = {fleshy=1},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {ship_stone = 1, disable_repair = 1, 
            rough_chip_tool = 2, rough_chip_tool_uses = 50,
            rough_chip_tool_maxlevel = 2}
})

minetest.register_tool("stone_age:ship_stone_soft", {
	description = S("Soft ship stone"),
	inventory_image = "default_stone_soft.png",
	tool_capabilities = {
		full_punch_interval = 1.7,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=15.2, [3]=2.60}, uses=12, maxlevel=1},
		},
		damage_groups = {fleshy=1},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {ship_stone = 1, disable_repair = 1,
            rough_chip_tool = 1, rough_chip_tool_uses = 30,
            rough_chip_tool_maxlevel = 1}
})

--
-- Axe
--

minetest.register_tool("stone_age:hand_axe_soft_stone", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1, disable_repair = 1}
})

minetest.register_tool("stone_age:hand_axe_flint", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=12.4, [3]=2.30}, uses=10, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1, disable_repair = 1}
})

-- 
-- Spike
-- 

minetest.register_tool("stone_age:spike_soft_stone_medium", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {spike = 1, disable_repair = 1}
})

minetest.register_tool("stone_age:spike_flint_medium", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {spike = 1, disable_repair = 1}
})

minetest.register_tool("stone_age:spike_flint_precise", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {spike = 1, disable_repair = 1}
})

--
-- saw
--

minetest.register_tool("stone_age:saw_small_flint", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {saw = 1, disable_repair = 1}
})

-- 
-- sickle
--

minetest.register_tool("stone_age:sickle_flint", {
	description = S("Hand axe"),
	inventory_image = "stone_age_hand_axe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {axe = 1, disable_repair = 1}
})

-- 
-- make fire tools
--


--
-- weapons normal
--

minetest.register_tool("stone_age:lance_wood", {
	description = S("Wooden lance"),
	inventory_image = "stone_age_lance_wood.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=18.2, [3]=3.60}, uses=20, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	sound = {breaks = "default_tool_breaks"},
	groups = {lance = 1, disable_repair = 1}
})

--
-- weapons fire
--
