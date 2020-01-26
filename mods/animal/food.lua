local S = animal.S;

-- vitality

animal.food_types = {};

--
--
-- food_name -> food name
--
-- food_def ->
--   item_name -> item/node name for pair with specific item/node
--   nutriments -> table of nutriments 

function animal.register_food(food_name, food_def)
  if (type(food_def.definition_name)~="string") then
    minetest.log("warning", "Food "..food_name.." definition don't include item_name.");
    return;
  end
  if (#food_def.nutriments<1) then
    minetest.log("warning", "Food "..food_name.." definition don't include nutriments table.");
    return;
  end
  for nutriment in food.nutriments do
    if (type(nutriment.level)~="number") then
      minetest.log("warning", "Food "..food_name.." nutriment definition don't include level.");
      return;
    end
    if (type(nutriment.amount)~="number") then
      minetest.log("warning", "Food "..food_name.." nutriment definition don't include amount.");
      return;
    end
  end
  table.insert(animal.food_types, food_def);
end

-- basic nutriments
--   water
--   mineral (salt, calcium, iron for body)
--   vitamins
--   roughage
--   proteins
--   fat
--   saccharide
--   
-- nutriments definition:
--   name (name of filed in table)
--   level -> is used to calculate efect to eater
--   amount -> maximum addition to eater

