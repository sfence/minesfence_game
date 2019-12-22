
local S = animal.S;

-- 
-- animal efect function
--
-- max_efect*abs(1/(1+lower_steepness^(-x+lower_border))    + 1/(1+upper_steepness^(x-upper_border)) - 1)
-- 
-- efect in lower_border and upper_border is 0.5, 
-- between lower_border and upper_border probability increase to 1, 
-- outside borders probability is decrease to 0,
-- steepnees of decrease and increase is done by lower_steepness and upper_steepness.
-- when lower_steepness < upper_steepness, function select area where vegetation can be found
-- when lower_steepness > upper_steepness, function select area where vegetation cannot be found
-- lower_steepness and upper_steepness have to be bigger then 1, values near to 1 means more gradually steepness.
-- use some program to show function graph to see probability changes
-- x is value of parameter in location
-- max_efect have to be 1 if not used, lower when you want to limit max efect, higger when you want make efect stronger.
-- setting lower_steepness and upper_steepness and max_probability to 1, disable probability sensitivity to x
-- all function parameters are stored 
-- in settings table (max_probability, lower_steepness, lower_border, upper_steepness, upper_border)
-- x is stored in actual_value fucntion parameter

function animal.efect_function(presence, actual_value)
  local first_part = 1/(1+presence.lower_steepness^(-actual_value+presence.lower_border));
  local second_part = 1/(1+presence.upper_steepness^(actual_value-presence.upper_border));
  local efect = max_efect*math.abs(first_part + second_part - 1);
  return efect;
end

