
local S = default.S;

--
-- Changeable nodes
--

-- used for register named node changes to central control of action, like stone degradation by fall, flora etc.
-- this changes are not happening automaticly, they have to be caused
-- benefit is that causer don't have to know what he have to do with every node, he can only cause named change, 
-- and change efect can be configuret in other place

default.registered_changeable_nodes = {};
default.register_changeable_nodes_by_change_names = {};

-- change definition
--
-- new_node_name -> new name of node
-- check_stability -> true, when stability should be rechecked after node change
-- allow_change -> callback, can be nil, return true when change should happen
--              -> parameters pos, node

function default.register_changeable_node_change(node_name, change_name, change_def)
  
  if (type(change_def)~="table") then
    minetest.log("warning", "Cannot register changeable node "..node_name.." change "..change_name.." without change definition.");
    return
  end
  
  if (type(change_def.new_node_name)~="string") then
    minetest.log("warning", "Cannot register changeable node "..node_name.." change "..change_name.." with missing new_node_name string in change definition.");
    return
  end
  
  if (type(change_def.check_stability)~="boolean") then
    minetest.log("warning", "Cannot register changeable node "..node_name.." change "..change_name.." with missing check_stability boolean in change definition.");
    return
  end
  
  if ((type(change_def.allow_change)~="nil") and (type(change_def.allow_change)~="function")) then
    minetest.log("warning", "Cannot register changeable node "..node_name.." change "..change_name.." with missing allow_change function in change definition.");
    return
  end
  
  local changeable_node = default.registered_changeable_nodes[node_name];
  if (changeable_node==nil) then
    default.registered_changeable_nodes[node_name] = {changes = {}};
    changeable_node = default.registered_changeable_nodes[node_name];
  end
  
  changeable_node.changes[change_name] = change_def;
  default.registered_changeable_nodes[node_name] = changeable_node;
  
  if (default.register_changeable_nodes_by_change_names[change_name]==nil) then
    default.register_changeable_nodes_by_change_names[change_name] = {};
  end
  table.insert(default.register_changeable_nodes_by_change_names[change_name], node_name);
  
  if (minetest.registered_nodes[node_name]==nil) then
    minetest.log("error", "Changeable source node name "..node_name.." is not valid registered node name. ( for change \""..change_name.."\")")
  end
  if (minetest.registered_nodes[change_def.new_node_name]==nil) then
    minetest.log("error", "Changeable target node name "..change_def.new_node_name.." is not valid registered node name. ( for change \""..change_name.."\")")
  end
end

-- do node change with change_name
function default.apply_node_change(pos, node, change_name)
  if (node==nil) then
    node = minetest.get_node(pos);
  end
  
  local changeable_node = default.registered_changeable_nodes[node.name];
  
  --minetest.log("warning", "Node "..node.name.." change "..change_name.." with data: "..dump(changeable_node))
  --minetest.log("warning", dump(default.registered_changeable_nodes))
  
  if (changeable_node~=nil) then
    local change_def = changeable_node.changes[change_name];
    --minetest.log("warning","change_def: "..dump(change_def))
    if (change_def~=nil) then
      if ((change_def.allow_change==nil) or (change_def.allow_change(pos, node)==true)) then
        --minetest.log("warning", "Change "..node.name.." to "..change_def.new_node_name..".")
        minetest.swap_node(pos, {name=change_def.new_node_name});
        if (change_def.check_stability==true) then
          minetest.check_for_falling(pos);
          default.neighbour_stable_to_normal(pos);
          minetest.after(1, default.check_neighbour_for_fall, pos);
          minetest.after(0.5, default.check_for_landslide, pos);
        end
        return true;
      end
    else
      --minetest.log("warning","Node "..node.name.." have not registered change "..change_name..".")
      --minetest.log("warning", dump(changeable_node));
    end
  else
    --minetest.log("warning","Apply to no changeable node "..node.name)
  end
  
  return false;
end

-- test if node can be changed with change_name
function default.is_node_changeable(pos, node, change_name)
  if (node==nil) then
    node = minetest.get_node(pos);
  end
  
  changeable_node = default.registered_changeable_nodes[node.name];
  
  if (changeable_node~=nil) then
    change_def = changeable_node.changes[change_name];
    if (change_def~=nil) then
      return true;
    end
  end
  
  return false;
end
