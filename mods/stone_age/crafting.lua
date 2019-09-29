
local S = stone_age.S

-- craft recipes

minetest.register_craft({
  output = "stone_age:flat_stone_desk",
  recipe = {
    {"default:stone_flat"},
  },
})

minetest.register_craft({
  output = "default:stone_flat",
  recipe = {
    {"stone_age:flat_stone_desk"},
  },
})

-- Roughly Chipping recipes
recipes.register_recipe({
  name = S("Hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = 10}},
  tool_in_order = false,
  output = {"stone_age:hand_axe"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = 40}},
  tool_in_order = false,
  output = {"stone_age:hand_axe"},
  input = {{"default:stone_soft"}},
})
