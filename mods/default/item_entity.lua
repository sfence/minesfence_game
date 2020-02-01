-- mods/default/item_entity.lua

local builtin_item = minetest.registered_entities["__builtin:item"]

local item = {
	set_item = function(self, itemstring)
		builtin_item.set_item(self, itemstring)

		local stack = ItemStack(itemstring)
		local itemdef = minetest.registered_items[stack:get_name()]
		if itemdef and itemdef.groups.flammable ~= 0 then
			self.flammable = itemdef.groups.flammable
		end
    self.build_on_stop = false;
    if (minetest.registered_nodes[stack:get_name()]~=nil) then
      self.build_on_stop = true;
    end
	end,

	burn_up = function(self)
		-- disappear in a smoke puff
		self.object:remove()
		local p = self.object:get_pos()
		minetest.sound_play("default_item_smoke", {
			pos = p,
			max_hear_distance = 8,
		})
		minetest.add_particlespawner({
			amount = 3,
			time = 0.1,
			minpos = {x = p.x - 0.1, y = p.y + 0.1, z = p.z - 0.1 },
			maxpos = {x = p.x + 0.1, y = p.y + 0.2, z = p.z + 0.1 },
			minvel = {x = 0, y = 2.5, z = 0},
			maxvel = {x = 0, y = 2.5, z = 0},
			minacc = {x = -0.15, y = -0.02, z = -0.15},
			maxacc = {x = 0.15, y = -0.01, z = 0.15},
			minexptime = 4,
			maxexptime = 6,
			minsize = 5,
			maxsize = 5,
			collisiondetection = true,
			texture = "default_item_smoke.png"
		})
	end,
  
  build_itself = function(self)
		local pos = self.object:get_pos()
    
    local node = minetest.get_node(pos);
    if (node.name=="air") or (node.name=="ignore") or (minetest.registered_nodes[node.name].buildable_to==true) then
		  local stack = ItemStack(self.itemstring)
		  self.object:remove()
      --minetest.log("warning", "Pos: "..dump(pos).." stack: "..dump(stack:to_string()))
      minetest.set_node(pos, {name=stack:get_name()});
      stack:take_item(1);
      if (stack:get_count()>0) then
        minetest.add_item(pos, stack);
      end
    end
  end,

	on_step = function(self, dtime)
    -- minetest.log("warning", "Selt item step: "..dump(self))
		builtin_item.on_step(self, dtime)

		if self.flammable then
			-- flammable, check for igniters
			self.ignite_timer = (self.ignite_timer or 0) + dtime
			if self.ignite_timer > 10 then
				self.ignite_timer = 0

				local node = minetest.get_node_or_nil(self.object:get_pos())
				if not node then
					return
				end

				-- Immediately burn up flammable items in lava
				if minetest.get_item_group(node.name, "lava") > 0 then
					self:burn_up()
				else
					--  otherwise there'll be a chance based on its igniter value
					local burn_chance = self.flammable
						* minetest.get_item_group(node.name, "igniter")
					if burn_chance > 0 and math.random(0, burn_chance) ~= 0 then
						self:burn_up()
					end
				end
			end
		end
    if (self.build_on_stop==true) and (self.moving_state==false) then
      self:build_itself()
    end
	end,
}

-- set defined item as new __builtin:item, with the old one as fallback table
setmetatable(item, builtin_item)
minetest.register_entity(":__builtin:item", item)
