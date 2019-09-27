
local S = recipes.S;

-- Recipe
-- name -> name of recipe
-- categoty -> category name string, used by machines to select only aviable recepts
-- manual -> key-value list of operations which have to be done and how are they exhausting/laborous, key name is used to check instument group, higger group mean quicker work
-- input -> recipe inputs, list of list
-- output -> recipe outouts list

recipes.recipes = {};

function recipes.register_recipe(recipe_data)
  if (recipe_data.name == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without name.")
    return
  end
  if (recipe_data.category == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without category.")
    return
  end
  if (recipe_data.manual == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without manual.")
    return
  end
  if (recipe_data.output == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without output.")
    return
  end
  if (recipe_data.input == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without inputs.")
    return
  end
  
  if (recipes.recipes[recipe_data.category] == nil) then
    recipes.recipes[recipe_data.category] = {}
  end
  
  table.insert(recipes.recipes[recipe_data.category], table.copy(recipe_data))
end

local function optimalize_inventory_input(inventory_input)
  local row_min = nil;
  local row_max = nil;
  
  local column_min = nil;
  local column_max = nil;
  
  for row_index, row_value in pairs(inventory_input) do
    for column_index, column_value in pairs(row_value) do
      if ((column_value ~= nil) and (column_value ~= "")) then
        if ((row_min==nil) or (row_min>row_index)) then row_min = row_index; end
        if ((row_max==nil) or (row_max<row_index)) then row_max = row_index; end
        if ((column_min==nil) or (column_min>column_index)) then column_min = column_index; end
        if ((column_max==nil) or (column_nax<column_index)) then column_max = column_index; end
      end
    end
  end 
  
  local optimalized_input = {};
  
  if (row_min==nil) then row_min = 1; end
  if (row_max==nil) then row_max = 1; end
  if (column_min==nil) then column_min = 1; end
  if (column_max==nil) then column_max = 1; end
  
  for row_index = row_min, row_max, 1 do
    local row_data = {};
    for column_index = column_min, column_max, 1 do
      local item = inventory_input[row_index][column_index];
      if (item ~= nil) then
        table.insert(row_data, item);
      end
    end
    table.insert(optimalized_input, row_data);
  end
  
  return optimalized_input;
end

local function compare_recipe_item(inventory_item, recipe_item)
  local group_begin = "group:"
  local item_name = ItemStack(inventory_item):get_name();
  if (recipe_item:sub(1,#group_begin) == group_begin) then
    if (minetest.get_item_group(item_name, recipe_item:sub(#group_begin))~=0) then
      return true;
    end
  else
    if (item_name == recipe_item) then
      return true;
    end
  end
  
  return false;
end

local function compare_recipe_row(inventory_row, recipe_row)
  if (#inventory_row == #recipe_row) then
    for index, inventory_item in pairs(inventory_row) do
      local recipe_item = recipe_row[index];
      if (compare_recipe_item(inventory_item, recipe_item)==false) then
        return false;
      end
    end
    return true;
  end
  return false;
end

local function compare_recipe_input(inventory_input, recipe_input)
  if ((inventory_input==nil) or (recipe_input==nil)) then
    return false;
  end
  if (#inventory_input == #recipe_input) then
    for index, inventory_row in pairs(inventory_input) do
      local recipe_row = recipe_input[index];
      if (compare_recipe_row(inventory_row, recipe_row)==false) then
        return false;
      end
    end
    return true;
  end
  return false;
end

local function compare_recipe_table(inventory_input, recipe_input)
end

function recipes.find_recipe(search_data, outputs_limit) 
  local found_recipes = {};
  
  if (search_data.category == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe without category.")
    return found_recipes;
  end
  if (search_data.input == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe without inputs.")
    return found_recipes;
  end
  
  local search_inputs = optimalize_inventory_input(search_data.input);  
  
  for keyA, category in pairs(search_data.category) do
    local category_recipes = recipes.recipes[category];
    for keyB, recipe in pairs(category_recipes) do
      if ((outputs_limit==0) or (#recipe.output <= outputs_limit)) then
        minetest.log("warning", "Compare with recipe: "..recipe.category)
        if (compare_recipe_input(search_inputs, recipe.input)==true) then
          table.insert(found_recipes, recipe)
        end
      end
    end
  end
  
  return found_recipes;
end

function recipes.inventory_to_table(inventory, list_name)
  local inventory_table = {};
  
  local inventory_size = inventory:get_size(list_name);
  local inventory_width = inventory:get_width(list_name);
  
  local column_index = 0;
  
  local row_data = {};
  
  for item_index = 1, inventory_size, 1 do
    local item = inventory:get_stack(list_name, item_index);
    table.insert(row_data, item);
    column_index = column_index + 1;
    if (column_index>=inventory_width) then
      table.insert(inventory_table, row_data);
      column_index = 0;
      row_data = {};
    end
  end
  
  if (#row_data > 0) then
    minetest.log("error", "Inventory size "..inventory_size.." is not integer multiple of inventory width "..inventory_width.." for listname "..list_name..".")
  end
  
  return inventory_table;
end

function recipes.inventory_from_table(inventory, list_name, inventory_table)
  local inventory_size = inventory:get_size(list_name);
  local inventory_width = inventory:get_width(list_name);
  
  local row_index = 1;
  local column_index = 1;
  
  for item_index = 1, inventory_size, 1 do
    local item = inventory_table[row_index][column_index];
    
    inventory:set_stack(list_name, item_index, item);
    
    column_index = column_index + 1;
    if (column_index>inventory_width) then
      column_index = 0;
      row_index = row_index + 1;
    end
  end
end

function recipes.inventory_from_list(inventory, list_name, inventory_list)
  local inventory_size = inventory:get_size(list_name);
  
  local item_index = 1;
  
  for item_index = 1, inventory_size, 1 do
    local item = inventory_list[item_index];
    
    if (item ~= nil) then
      inventory:set_stack(list_name, item_index, item);
    end
  end
end

function recipes.create_inventory_from_output(output)
  local inventory_list = {};
  
  local items = #output;
  
  for item_index=1,items,1 do
    local output_count = 0;
    local output_text = output[item_index];
    local found = string.find(output_text, " ");
    if (found~=nil) then
      output_count = tonumber(string.sub(output_text, found+1));
      output_text = string.sub(output_text, 1, found-1);
    else
      output_count = 1;
    end
    
    local stack = ItemStack(output_text);
    stack:set_count(output_count);
    table.insert(inventory_list, stack);
  end
  
  return inventory_list;
end

