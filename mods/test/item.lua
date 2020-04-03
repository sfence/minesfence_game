
local S = test.S;

--
--
--

minetest.register_craftitem("test:test_lua_call", {
	description = S("Test lua call"),
	inventory_image = "test_lua_call.png",
	groups = {oddly_breakable_by_hand = 1},
  
  on_use = function(itemstack, user, pointed_thing)
      local node_pos = pointed_thing.under;
      local node = minetest.get_node(node_pos);
      
      minetest.log("warning", "Test lua call for node: "..dump(node));
      
      -- test call
      --vegetation.tree_stump_grow(node_pos, node);
      minetest.log("warning", "Light under: "..minetest.get_node_light(pointed_thing.under));
      minetest.log("warning", "Light above: "..minetest.get_node_light(pointed_thing.above));
      
    end,
})

