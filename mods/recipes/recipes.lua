
local S = recipes.S;

-- Recipe
-- name -> name of recipe
-- category -> category name string, used by machines to select only aviable recepts
-- manual -> list of tables with one key and table of values, where key mean work_name and key value is table with work_points, level and wear. Work_name specify tool group which have to be used to work, higger group mean quicker work, work_points specify number of work which have to be done and level specify the minimal level of tool which have to be used, wear mean wear multiplication..
-- tool_in_order -> true if tool have to be used in order of manual definition, false when the usage in order is not required
-- input -> recipe inputs, list of list (default:stone, deault:tool +5) converted to tables
-- output -> recipe outouts list (default:stone, default:stone 5) converted to table
-- special -> special data for fuel, etc

recipes.recipes = {};


-- konvert recept item text to recept item table
-- 
-- group -> name of group
-- name -> name of item/tool
-- items_count -> count of item for use or product
-- tool_wear -> change of tool wear
local function text_item_to_table_item(recipe_item_text)
  local group_begin = "group:"
  
  local recipe_item_table = {};
  
  local found = string.find(recipe_item_text, " ");
  local item_number = found;
  if not(found) then
    found = #recipe_item_text;
  end
  
  if (recipe_item_text:sub(1,#group_begin-1) == group_begin) then
    recipe_item_table.group = recipe_item_text:sub(#group_begin, found);
  else
    recipe_item_table.name = recipe_item_text:sub(1, found);
  end
  
  if (item_number) then
    local number_begin = string.sub(recipe_item_text, item_number, item_number);
    if ((number_begin~="+") and (number_begin~="-")) then
      recipe_item_table.items_count = tonumber(string.sub(recipe_item_text, item_number));
    else
      recipe_item_table.tool_wear = tonumber(string.sub(recipe_item_text, item_number));
    end
  else
    recipe_item_table.items_count = 1;
  end
  
  return recipe_item_table;
end

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
  if (recipe_data.tool_in_order == nil) then
    minetest.log("error", "[Recipes] ignore to register recipe without tool_in_order specification.")
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
  local recipe_data_copy = table.copy(recipe_data);
  
  -- recipe reformat some data
  for row_index, row_data in pairs(recipe_data_copy.input) do
    for column_index, recipe_item in pairs(row_data) do
      row_data[column_index] = text_item_to_table_item(recipe_item);
    end
    recipe_data_copy.input[row_index] = row_data;
  end
  
  for output_index, output_item in pairs(recipe_data_copy.output) do
    recipe_data_copy.output[output_index] = text_item_to_table_item(output_item);
  end
  
  table.insert(recipes.recipes[recipe_data.category], recipe_data_copy)
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

-- group -> name of group
-- name -> name of item/tool
-- items_count -> count of item for use or product
-- tool_wear -> change of tool wear
local function compare_recipe_item(inventory_item, recipe_item)
  local item_name = ItemStack(inventory_item):get_name();
  
  if (recipe_item.group) then
    if (minetest.get_item_group(item_name, recipe_item.group)~=0) then
      return true;
    end
  else
    if (item_name == recipe_item.name) then
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

local function compare_recipe_output(inventory_output, recipe_output)
  minetest.log("warning", "inventory outputs: "..tostring(#inventory_output).." recipe outputs: "..tostring(#recipe_output))
  if (#inventory_output >= #recipe_output) then
    for index, inventory_item in pairs(inventory_output) do
      local found = false;
      minetest.log("warning", "inv item: "..dump(inventory_item))
      for recipe_index, recipe_item in pairs(recipe_output) do
        minetest.log("warning", "recipe item: "..dump(recipe_item))
        if (compare_recipe_item(inventory_item, recipe_item)==true) then
          found = true;
          break;
        end
      end
      if (found==false) then
        return false;
      end
    end
    return true;
  end
  return false;
end

local function compare_recipe_table(inventory_input, recipe_input)
end

function recipes.find_recipe_by_input(search_data, outputs_limit) 
  local found_recipes = {};
  
  if (search_data.categories == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe without categories.")
    return found_recipes;
  end
  if (search_data.input == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe without inputs.")
    return found_recipes;
  end
  
  local search_inputs = optimalize_inventory_input(search_data.input);  
  
  for keyA, category in pairs(search_data.categories) do
    local category_recipes = recipes.recipes[category];
    for keyB, recipe in pairs(category_recipes) do
      if ((outputs_limit==0) or (#recipe.output <= outputs_limit)) then
        -- minetest.log("warning", "Compare with recipe: "..recipe.category)
        if (compare_recipe_input(search_inputs, recipe.input)==true) then
          table.insert(found_recipes, recipe)
        end
      end
    end
  end
  
  return found_recipes;
end

function recipes.find_recipe_by_output(search_data) 
  local found_recipes = {};
  
  if (search_data.categories == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe by output without categories.")
    return found_recipes;
  end
  if (search_data.output == nil) then
    minetest.log("error", "[Recipes] ignore to search recipe by output without outputs.")
    return found_recipes;
  end
  
  local search_inputs = search_data.output;
  
  for keyA, category in pairs(search_data.categories) do
    local category_recipes = recipes.recipes[category] or {};
    for keyB, recipe in pairs(category_recipes) do
      -- minetest.log("warning", "Compare with recipe: "..recipe.category)
      if (compare_recipe_output(search_data.output, recipe.output)==true) then
        table.insert(found_recipes, recipe)
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

function recipes.reduce_input_inventory(inventory_table, recipe_table)
  for row_index, row_data in pairs(inventory_table) do
    local recipe_row = recipe_table[row_index];
    for column_index, item in pairs(row_data) do
      local recipe_item = recipe_row[column_index];
      
      --minetest.log("warning", "recipe_item: "..dump(recipe_item))
      
      if (recipe_item.items_count) then
        local item_count = item:get_count();
        item:set_count(item_count-recipe_item.items_count);
      end
      if (recipe_item.tool_wear) then
        item:add_wear(recipe_item.tool_weare);
      end
    end
  end
end
function recipes.inventory_from_table(inventory, list_name, inventory_table)
  local inventory_size = inventory:get_size(list_name);
  local inventory_width = inventory:get_width(list_name);
  
  --minetest.log("warning", "inv size: "..tostring(inventory_size).." inv width: "..tostring(inventory_width))
  --minetest.log("warning", "table width: "..tostring(#inventory_table).." table columns: "..tostring(#inventory_table[1]))
  
  --minetest.log("warning", dump(inventory_table))
  
  for row_index = 1,#inventory_table do
    local inventory_row = inventory_table[row_index];
    for column_index = 1,#inventory_row do
      local stack_index = ((row_index-1)*inventory_width)+column_index;
      --minetest.log("warning", "row: "..tostring(row_index).." column: "..tostring(column_index).." stack: "..tostring(stack_index))
      if (stack_index<=inventory_size) then
        local item = inventory_table[row_index][column_index];
        
        inventory:set_stack(list_name, stack_index, item);
      end
    end
  end
end

function recipes.inventory_from_list(inventory, list_name, inventory_list)
  local inventory_size = inventory:get_size(list_name);
  
  --minetest.log("warning", "Size "..tostring(inventory_size))
  
  for item_index = 1, inventory_size, 1 do
    local item = inventory_list[item_index];
    if (item ~= nil) then
      local can_be_added = inventory:room_for_item(list_name, item);
      if (can_be_added~=true) then
        return false;
      end
    end
  end
  
  for item_index = 1, inventory_size, 1 do
    local item = inventory_list[item_index];
    
    --minetest.log("warning", "for item "..dump(item))
    
    if (item ~= nil) then
      --minetest.log("warning", "Item "..item:get_name().." can be added: "..tostring(can_be_added).." to listname "..list_name)
      inventory:add_item(list_name, item);
    end
  end
  
  return true;
end

function recipes.create_inventory_from_output(output)
  local inventory_list = {};
  
  local items = #output;
  
  for item_index=1,items,1 do
    local output_data = output[item_index];
    
    --minetest.log("warning", "from_output: "..dump(output_data))
    
    if ((output_data.name) and (output_data.items_count)) then 
      local stack = ItemStack(output_data.name);
      stack:set_count(output_data.items_count);
      table.insert(inventory_list, stack);
    end
  end
  
  return inventory_list;
end

function recipes.get_tool_use(recipe, wielded_name, progress_list)
  local use_tool = {tool_power = 0, add_wear = 0, progress_index = 0};
  
  local function get_tool_work(wielded_name, work_name)
    local tool_work = {
        power = minetest.get_item_group(wielded_name, work_name),
        maxlevel = minetest.get_item_group(wielded_name, work_name.."_maxlevel"),
        uses  = minetest.get_item_group(wielded_name, work_name.."_uses"),
      };
    minetest.log("warning", "Tool work "..work_name..": "..dump(tool_work));
    return tool_work;
  end;
  
  local function create_use_tool(tool_work, work_data, index)
    local use_tool = {tool_power = 0, progress_index = 0};
    
    use_tool.progress_index = index;
    
    local leveldiff = tool_work.maxlevel - work_data.level;
    
    if (leveldiff>=0) then
      use_tool.tool_power  = tool_work.power;
      if (tool_work.uses>0) then
        use_tool.tool_add_wear = (65535/(tool_work.uses*(3^leveldiff)))*work_data.wear;
      else
        use_tool.tool_add_wear = 0;
      end
    else
      use_tool.tool_power = 0;
      use_tool.tool_add_wear = 0;
    end
    
    local leveldiff = use_tool
    
    return use_tool;
  end
  
  if (recipe.tool_in_order==true) then
    for index, work_table in pairs(recipe.manual) do
      if (progress_list[index]>0) then
        local work_name, work_data = next(work_table, nil);
        local tool_work = get_tool_work(wielded_name, work_name);
        return create_use_tool(tool_work, work_data, index);
      end
    end
  else
    for index, work_table in pairs(recipe.manual) do
      if (progress_list[index]>0) then
        local work_name, work_data = next(work_table, nil);
        local tool_work = get_tool_work(wielded_name, work_name);
        --minetest.log("warning", "Power: "..tostring(tool_power).." maxlevel: "..tostring(tool_maxlevel).." Work "..work_name..": "..dump(work_data))
        if ((tool_work.power>0) and (tool_work.maxlevel>=work_data.level)) then
          return create_use_tool(tool_work, work_data, index);
        end
      end
    end
  end
  
  return use_tool;
end

-- zero sum mean work is finished
function recipes.progress_sum(progress)
  local progress_sum = 0;
  
  for index, work_points in pairs(progress) do
    if (work_points>0) then
      progress_sum = progress_sum + work_points;
    end
  end
  
  return progress_sum;
end

function recipes.create_progress_list(recipe)
  local progress_list = {};
  
  for index, work_table in pairs(recipe.manual) do
    local work_name, work_data = next(work_table, nil);
    
    table.insert(progress_list, work_data.points);
  end
  
  return progress_list;
end

