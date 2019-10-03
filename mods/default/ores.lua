
local S = default.get_translator

function default.register_ore_desert_and_gravel(ore_name, ore_def)
  minetest.register_node("default:stone_with_iron", {
    description = S("Iron Ore"),
    tiles = {"default_stone.png^default_mineral_iron.png"},
    groups = {cracky = 2},
    drop = "default:iron_lump",
    sounds = default.node_sound_stone_defaults(),
  })
  minetest.register_node("default:gravel_with_iron", {
    description = S("Iron Ore"),
    tiles = {"default_gravel.png^default_mineral_iron.png"},
    groups = {crumbly = 2, falling_node = 1},
    drop = "default:iron_lump",
    sounds = default.node_sound_gravel_defaults(),
  })
end
