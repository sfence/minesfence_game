
local S = stone_age.S

-- stone age tools

--
-- Axe
--

minetest.register_tool("stone_age:hand_axe", {
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

