
local S = recipes.S;

-- help functions for work on recipes with tools

-- puncher is player
-- doneWork in percents
local function work_hud(puncher, doneWork)
  local hud_allWork = nil;
  local hud_doneWork = nil;
  
  local player_name = puncher:get_player_name();
  
  hud_allWork = puncher:hud_add({
      hud_elem_type = "statbar",
      text = "default_cloud.png^[colorize:#ff0000:256]",
      number = 40, -- statbar size
      direction = 0, -- left to right
      position = {x=0.5, y=0.65},
      aligment = {x=0, y=0},
      offset = {x=-320, y=0},
      size = {x=32, y=32},
    })
  hud_doneWork = puncher:hud_add({
      hud_elem_type = "statbar",
      text = "default_cloud.png^[colorize:#00ff00:256]",
      number = math.floor(doneWork*0.4), -- doneWork
      direction = 0, -- left to right
      position = {x=0.5, y=0.65},
      aligment = {x=0, y=0},
      offset = {x=-320, y=0},
      size = {x=32, y=32},
    })
  minetest.after(2, function()
      local player = minetest.get_player_by_name(player_name);
      if (player) then
        player:hud_remove(hud_allWork);
        player:hud_remove(hud_doneWork);
      end
    end)
end

-- settings
-- input_list -> input list name in inventory
-- output_list -> utput list name in inventory
-- recipe_categories -> list of recipe categories to search in

function recipes.work_on_push(pos, node, puncher, settings)
  if ( not(pos) or not(node) or not(puncher)) then
    return true;
  end
  
  local wielded = puncher:get_wielded_item();
  if (not(wielded) or not(wielded:get_name()) ) then
    return true;
  end
  local wielded_name = wielded:get_name();
    
  -- minetest.log("warning", "Punched by "..wielded_name..".")
  
  local meta = minetest.get_meta(pos);
  local inventory = meta:get_inventory();
  local input_table = recipes.inventory_to_table(inventory, settings.input_list);
  
  local search_recipe = {categories = settings.recipe_categories, input = input_table};
  
  -- minetest.log("warning", "Look for recipe category: "..dump(search_recipe.categories))
  
  local found = recipes.find_recipe(search_recipe, 1);
  
  --minetest.log("warning", "Found:"..#found.." dump: "..dump(found))
  
  if (#found>1) then
    minetest.log("error", "Found more then one recipe.")
    meta:set_string("last_recipe", "");
    return true;
  end
  
  if (#found<1) then
    -- no recipe found
    meta:set_string("last_recipe", "");
    return true;
  end
  
  local recipe = found[1];
  
  local recipe_sha1 = minetest.sha1(dump(recipe));
  local last_recipe = meta:get_string("last_recipe");
  
  local progress_string = "1";
  local progress_list = {1};
  
  if (recipe_sha1 ~= last_recipe) then
    -- minetest.log("warning", "new_recipe");
    progress_list = recipes.create_progress_list(recipe);
    progress_string = table.concat(progress_list, ";");
    meta:set_string("progress", progress_string);
    meta:set_string("last_recipe", recipe_sha1);
  else
    progress_string = meta:get_string("progress");
    -- minetest.log("warning", "A: "..progress_string);
    -- minetest.log("warning", "B: "..tostring((progress_string~=nil)));
    -- minetest.log("warning", "C: "..tostring((progress_string~="")));
    if ((progress_string~=nil) and (progress_string~="")) then
      -- minetest.log("warning", "From meta data: "..progress_string);
      progress_list = string.split(progress_string, ";");
      for key, value in pairs(progress_list) do progress_list[key] = tonumber(value); end
    else
      -- minetest.log("warning", "From recipe");
      progress_list = recipes.create_progress_list(recipe);
    end
  end
  
  -- minetest.log("warning", "Progress: "..progress_string)
  -- minetest.log("warning", "Progress: "..dump(progress_list))
  local tool_use = recipes.get_tool_use(recipe, wielded_name, progress_list);
  -- minetest.log("warning", "Tool use: "..dump(tool_use))
  
  local progress_points = recipes.progress_sum(progress_list);
  
  local work_points_list = recipes.create_progress_list(recipe);
  local work_points = recipes.progress_sum(work_points_list);
  
  if ((tool_use.tool_power>0)or(progress_points<=0)) then
    -- minetest.log("warning", "Punched by usefull tool.")
    -- do something
    
    --minetest.log("warning", "Tool use: "..dump(tool_use))
    if (tool_use.tool_power>0) then
      progress_list[tool_use.progress_index] = progress_list[tool_use.progress_index] - tool_use.tool_power;
      progress_points = recipes.progress_sum(progress_list);
      
      --minetest.log("warning", "Tool wear: "..tostring(wielded:get_wear()))
      wielded:add_wear(tool_use.tool_add_wear);
      --minetest.log("warning", "Tool wear: "..tostring(wielded:get_wear()))
      puncher:set_wielded_item(wielded);
      
    end
    
    work_hud(puncher, math.floor(100-(100*progress_points)/work_points))
    
    progress_string = table.concat(progress_list, ";");
    meta:set_string("progress", tostring(progress_string));
    local progress_points = recipes.progress_sum(progress_list);
    
    --minetest.log("warning", "State "..progress_points.."/"..work_points)
    
    if (progress_points==0) then
      local output_list = recipes.create_inventory_from_output(recipe.output);
      --minetest.log("warning", "from_list")
      if (recipes.inventory_from_list(inventory, settings.output_list, output_list)==true) then
        
        --minetest.log("warning", "update_inventory "..dump(input_table))
        recipes.reduce_input_inventory(input_table, recipe.input);
        recipes.inventory_from_table(inventory, settings.input_list, input_table);
        
        --minetest.log("warning", "Done.")
        meta:set_string("progress", 0);
        meta:set_string("last_recipe", 0);
      end
    end
  else
    -- minetest.log("warning", "Punched by unusable tool.")
    work_hud(puncher, math.floor(100-(100*progress_points)/work_points))
    return true;
  end
  
  return false;
end

