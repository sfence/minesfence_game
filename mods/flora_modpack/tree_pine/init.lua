-- Mods which include functions for tree pine

-- Definitions made by this mod that other mods can use too
tree_pine = {}

-- localize support via initlib
tree_pine.S = function(s) return s end
if minetest.get_modpath("intllib") and intllib then
  tree_pine.S = intllib.Getter()
end

-- Load files
local tree_pine_path = minetest.get_modpath("tree_pine")

dofile(tree_pine_path.."/tree.lua")

tree_pine.S = nil

