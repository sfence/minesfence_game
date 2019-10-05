
local S = stone_age.S

-- craft recipes

minetest.register_craft({
  output = "stone_age:ship_stone_hard",
  recipe = {
    {"default:stone_hard"},
  },
})
minetest.register_craft({
  output = "stone_age:ship_stone_soft",
  recipe = {
    {"default:stone_soft"},
  },
})

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
  name = S("Flint hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=10,level=1,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:hand_axe_flint"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Soft stone hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=40,level=2,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:hand_axe_soft_stone"},
  input = {{"default:stone_soft"}},
})

