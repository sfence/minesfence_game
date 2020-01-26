
local S = test.S;

--
--
--

minetest.register_node("test:test_lua_call", {
	description = S("Test lua call"),
	tiles = {"default_stick.png"},
	groups = {oddly_breakable_by_hand = 1},
	drop = "test:test_lua_call",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
  
  on_use = function(itemstack, user, pointed_thing)
      local node_pos = pointed_thing.under;
      local node = minetest.get_node(node_pos);
      
      minetest.log("warning", "Test lua call for node: "..dump(node));
      
      -- test call
      vegetation.tree_stump_grow(node_pos, node);
      
    end,
})
