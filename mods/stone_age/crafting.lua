
local S = stone_age.S

-- craft recipes

minetest.register_craft({
  output = "stone_age:chip_stone_hard",
  recipe = {
    {"default:stone_hard"},
  },
})
minetest.register_craft({
  output = "stone_age:chip_stone_soft",
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
  name = S("Break flint"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=20,level=1,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:flint_fragment 2","stone_age:flint_shard 6"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Flint scraper"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=15,level=1,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:scraper_flint","stone_age:flint_fragment 1","stone_age:flint_shard 5"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Flint hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=10,level=1,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:hand_axe_flint","stone_age:flint_fragment 1","stone_age:flint_shard 3"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Flint chisel"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=15,level=1,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:chisel_flint","stone_age:flint_fragment 2","stone_age:flint_shard 4"},
  input = {{"default:flint"}},
})
recipes.register_recipe({
  name = S("Break soft stone"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=40,level=2,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:stone_soft_fragment 8"},
  input = {{"default:stone_soft"}},
})
recipes.register_recipe({
  name = S("Soft stone scraper"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=30,level=2,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:scraper_soft_stone","stone_age:stone_soft_fragment 6"},
  input = {{"default:stone_soft"}},
})
recipes.register_recipe({
  name = S("Soft stone hand axe"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=40,level=2,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:hand_axe_soft_stone","stone_age:stone_soft_fragment 4"},
  input = {{"default:stone_soft"}},
})
recipes.register_recipe({
  name = S("Soft stone chisel"),
  category = "rough_stone_crafts",
  manual = {{rough_chip_tool = {points=30,level=2,wear=1}}},
  tool_in_order = false,
  output = {"stone_age:chisel_soft_stone","stone_age:stone_soft_fragment 6"},
  input = {{"default:stone_soft"}},
})

