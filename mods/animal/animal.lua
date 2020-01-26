
local S = animal.S;

--
-- animal
--

animal.registered_animals = {};

-- 
-- animal definition
--
-- states -> table of conditions variables, see state definition, key is name of state
-- 
-- grow_chance -> chance to grow, like efect, should use some animal parameters like age, size, vitality etc.
-- grow_step -> grow step

function animal.register_animal(animal_name, animal_def)
  
end

--
-- state definition
--
-- name -> stored like key of table, where it is stored
--      -> there sould be used some predefined names, like:
--      ->  max_lives, 
-- 
-- function -> function(animal_state, parameters) will be called to calculate state value, 
--          -> animal_state -> animal instance state
--          -> parameters -> parameters for calculation function
-- parameters -> table with parameters for function
--

function animal.get_state_value(state_def, condition)
  
end

--
-- state value definition
--
-- value -> state actual value
-- last_time -> last time of recalculation
