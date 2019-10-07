
local S = vegetation.S;

-- help functions for work with trees

-- 1. state -> seeds
-- 2. state -> sapling
-- 3. state -> 1/8 tree trunk with leaves/needles
-- 4. state -> random grow started....

-- tree trunk on ground is special node, abm actions is targeted to it
-- parent calculate chance to tree grow and process it through tree
-- parent calculate chance to deatch...

-- parent tree trunk 1/8, 1/4, 1/1
-- live tree trunk 1/8, 1/4, 1/1
-- bud tree trunk 1/8 with leaves/needles(can change to live, or grow)
-- deatch tree trunk 1/8, 1/4, 1/1
-- dry tree trunk 1/8, 1/4, 1/1
-- wet moudler tree trunk
-- dry moudler tree trunk (can be used to make fire?, have to be done by drying)
-- fertilizer (by same chance)
-- nothing

-- live leaves/needles
-- leaves/needles with fruit/cone
-- dry leaves/needles
-- brushwood
-- nothing

-- fruit/cone can change back to live leaves/neadles with chance to seeds itself to some distance...

-- tree definition
--
-- name -> name of tree
--
-- 
-- 


function vegetation.register_tree(tree_def)
end

