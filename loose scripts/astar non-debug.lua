-- NOTES
-- variable zombie speeds
-- when a zombie goes back on the path - they should reset their current node
-- when a zombie spawns in, it should consider if the destination is off the track
-- tell zombies to find the closest node to get back on the path with
-- recalculate target node if destination changes destination node


alias temp_num0 = global.number[0]
alias temp_num1 = global.number[1]
alias temp_num2 = global.number[2]

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias temp_obj3 = global.object[3]

alias mover_agent = global.object[4]


-- pathing node stuff 
alias linked1 = object.object[0]
alias linked2 = object.object[1]
alias linked3 = object.object[2]
alias linked4 = object.object[3]

alias initalized = object.number[0]
alias lowest_dist = object.number[1]
alias has_been_reached = object.number[2] 
alias best_parent = object.number[3]

-- agent vars
alias movement_interval = object.number[0]
alias destination = object.object[0]
alias destination_node = object.object[1] -- this could be replaced with a temporary object
alias current_node = object.object[2]
alias next_node = object.object[3]

declare object.timer[0] = 1 
declare object.timer[1] = 1
alias repath_timer = object.timer[0]
alias verify_timer = object.timer[1]

-- zombie vars
alias zombie_step_size = 6
alias zombie_step_interval = 13

-- bake connections into nodes, this will drastically save on perfromance, however it is slightly more expensive on the code (or maybe not actually, this turned out super cheap)
for each object with label "p_node" do
   if current_object.initalized == 0 then -- time to initialize
      current_object.initalized = 1
      temp_obj0 = current_object
      for each object with label "p_node" do
         if current_object != temp_obj0 then
            if temp_obj0.shape_contains(current_object) and current_object.shape_contains(temp_obj0) then -- they both overlap, hurray!
               -- else if block, its cheaper than it looks
               -- essentially, find a free slot and toss the linked node in
               temp_num0 = 0
               if temp_obj0.linked1 == no_object  then
                  temp_obj0.linked1 = current_object
                  temp_num0 = 1
               end
               if temp_num0 == 0 then
                  if temp_obj0.linked2 == no_object  then
                     temp_obj0.linked2 = current_object
                     temp_num0 = 1
                  end
                  if temp_num0 == 0 then
                     if temp_obj0.linked3 == no_object  then
                        temp_obj0.linked3 = current_object
                        temp_num0 = 1
                     end
                     if temp_num0 == 0 then
                        if temp_obj0.linked4 == no_object  then
                           temp_obj0.linked4 = current_object
                           temp_num0 = 1
                        end
                     end
                  end
               end
            end
         end
      end
   end
end



-- TODO: put your own spawner logic in here
for each object with label "spawner" do
   current_object.timer[1].set_rate(-10%)
   if current_object.timer[1].is_zero() then
      current_object.timer[1].reset()
      current_object.object[0] = current_object.place_at_me(spartan, "agent",none,0,0,0,none)
   end
end





-- inputs
-- temp_obj0 -- the owner to pull from
-- outputs
-- temp_obj1 -- the object from index
function return_parent()
   temp_obj1 = no_object
   -- condition tree, my beloved (SUPER efficient)
   if temp_obj0.best_parent >= 0 then 
      temp_obj1 = temp_obj0.linked1
      if temp_obj0.best_parent >= 1 then 
         temp_obj1 = temp_obj0.linked2
         if temp_obj0.best_parent >= 2 then 
            temp_obj1 = temp_obj0.linked3
            if temp_obj0.best_parent == 3 then 
               temp_obj1 = temp_obj0.linked4
            end
         end
      end
   end
end
-- inputs 
-- temp_obj0 -- object to store parent to
-- temp_obj1 -- best parent
function write_parent()
   temp_obj0.best_parent = -1
   if temp_obj0.linked1 == temp_obj1 then
      temp_obj0.best_parent = 0
   end
   if temp_obj0.linked2 == temp_obj1 then
      temp_obj0.best_parent = 1
   end
   if temp_obj0.linked3 == temp_obj1 then
      temp_obj0.best_parent = 2
   end
   if temp_obj0.linked4 == temp_obj1 then
      temp_obj0.best_parent = 3
   end
end


-- inputs
-- temp_obj0 -- the node to evaluate 
-- temp_obj1 -- the parent of this node
function evaluate_node()
   if temp_obj3 == no_object then
      -- if this node exists and has not already been evaluated
      if temp_obj0 != no_object and temp_obj0.has_been_reached != 2 then 
         temp_obj0.has_been_reached = 1
         -- if this node has already been reached, but not evaluated yet, then we have to check if the current path is more efficient than the one that reached it before this one
         if temp_obj0.best_parent != -1 then -- we have already evaluated this one, and must check to see if our current parent is more efficient
            temp_num0 = temp_obj0.get_distance_to(temp_obj1)
            temp_num0 += temp_obj1.lowest_dist
            if temp_num0 < temp_obj0.lowest_dist then
               temp_obj0.lowest_dist = temp_num0
               write_parent()
            end
         end
         -- otherwise, we can assume the current path is the most efficient way to reach this node 
         if temp_obj0.best_parent == -1 then -- no parent, and we're good to just slap our values in
            temp_obj0.lowest_dist = temp_obj0.get_distance_to(temp_obj1) -- find the distance between this and the parent object
            temp_obj0.lowest_dist += temp_obj1.lowest_dist -- 
            write_parent() -- store our parent as an index, that may be accessed later,
            -- this method allows errors to be discerned regarding to specific nodes exceeding 4 linked objects
            -- TODO: i swear we needed something else here
         end
         if temp_obj2 == temp_obj0 then
            temp_obj3 = temp_obj0
         end
      end
   end
end
-- inputs 
-- temp_obj2 -- destination
-- outputs
-- temp_obj3 -- destination, but only if we reached it
function recurs_path_scan()
   -- figure out which node would be the next best one to evaluate (when starting its obviously the first)
   temp_obj1 = no_object
   temp_num0 = 32000
   for each object with label "p_node" do
      if current_object.has_been_reached == 1 then
         -- calculate the "efficiency" of this node
         temp_num1 = current_object.get_distance_to(temp_obj2)
         temp_num1 += current_object.lowest_dist
         temp_num1 -= temp_num2
         -- if no other nodes have a lower efficiency, then this one is the way to go (probably)
         if temp_num1 < temp_num0 then
            temp_num0 = temp_num1
            temp_obj1 = current_object
         end
      end
   end
   if temp_obj1 != no_object then
      --  we now evaluate this node, and mark its child nodes for evalution when we do out next iteration of this code

      temp_obj1.has_been_reached = 2 -- mark this node as now figured out, no shorter paths can be found
      -- now its time to evalute this node (or rather, all its subnodes)
      temp_obj0 = temp_obj1.linked1
      evaluate_node()
      temp_obj0 = temp_obj1.linked2
      evaluate_node()
      temp_obj0 = temp_obj1.linked3
      evaluate_node()
      temp_obj0 = temp_obj1.linked4
      evaluate_node()
      -- running the recurison only when theres a next node should be perfect
      if temp_obj3 == no_object then
         recurs_path_scan()
      end
   end
end
-- input: temp_obj0 -- the object to scan back through
function recurse_back_through()
   return_parent() -- return the parent of this node that was deemed to have the shortest path
   if temp_obj1 != temp_obj2 then
      if temp_obj1 != no_object then -- then we've still got more to look through
         temp_obj0 = temp_obj1 -- set new object to look at
         recurse_back_through()
      end
   end
   if temp_obj1 == temp_obj2 then 
      -- then we return temp_obj0, as thats the next node forward from where we started
      temp_obj3 = temp_obj0
   end
end
-- inputs 
-- current_object -- the agent to move
-- temp_obj0 -- the object to move towards 
function ai_movement_towards()
   temp_num0 = current_object.get_speed()
   current_object.movement_interval += 1 -- have a minimum movement ticks
   -- if hasn't moved for 13 ticks, and isn't being affected by gravity
   if current_object.movement_interval >= zombie_step_interval and temp_num0 < 6 then
      current_object.movement_interval = 0 
      -- to get to the next node, we have to walk towards the center of the current node
      if mover_agent == no_object then
         mover_agent = current_object.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0, none)
      end
      current_object.face_toward(temp_obj0, 0,0,0)
      -- move agent to player
      -- TODO: convert this to non-velocity affecting attaching, so players could hit the zombies with a car, and they would more accurately move
      mover_agent.copy_rotation_from(current_object, true)
      mover_agent.attach_to(current_object, 0, 0, 0, relative)
      mover_agent.detach()
      -- scale down distance between agent & player
      current_object.attach_to(mover_agent, 28, 0, 1, relative)
      mover_agent.set_scale(zombie_step_size)
      mover_agent.copy_rotation_from(mover_agent, true)
      current_object.detach()
      -- reset move_agent's scale
      mover_agent.set_scale(100)
      mover_agent.copy_rotation_from(mover_agent, true)
   end
end
-- INPUTS
-- temp_obj0 -- the object to find the parent node of
-- OUTPUTS
-- temp_obj1 -- the resulting node, can be null
function find_parent_node()
   temp_obj1 = no_object
   temp_num0 = 32000 -- max destination node range
   for each object with label "p_node" do
      if current_object.shape_contains(temp_obj0) then
         temp_num1 = current_object.get_distance_to(temp_obj0)
         if temp_num1 < temp_num0 then
            temp_num0 = temp_num1
            temp_obj1 = current_object
         end
      end
   end
end

-- Agent status indicators
-- skull: no possible targets
-- cross: no valid path
-- arrow: pathfinding
-- target: is moving directly to the player 

-- Node status indicators
-- team[1] == has been evaluated; shortest path has been found
-- team[0] == to be evaluated
-- no icon == has been evaluated, but is not a node in the path
-- diamond == is a node in the path that we'll be taking
-- arrow == the destination node
-- crown == the current node
-- padlock == the next node 

-- Agent pathfinding code
for each object with label "agent" do
   ---TODO: ADD TARGETING SYSTEM HERE
   if current_object.destination == no_object then
      for each player do
         if current_player.biped != no_object then
            current_object.destination = current_player.biped
         end
      end
   end
   if current_object.destination != no_object then -- activate pathfinding protocol
      if current_object.next_node == no_object and current_object.repath_timer.is_zero() then
         -- get current node / nearest current node
         -- get destination node / nearest destination node

         -- find closest node (it has to contain our Agent)
         if current_object.current_node == no_object then
            temp_obj0 = current_object
            find_parent_node()
            current_object.current_node = temp_obj1
         end
         if current_object.current_node != no_object then -- then our guy is on the navmesh 
            -- find the destination node
            temp_obj0 = current_object.destination
            find_parent_node()
            current_object.destination_node = temp_obj1

            if current_object.destination_node != no_object then -- then we're both on the navmesh 
               if current_object.destination_node == current_object.current_node then -- this means that we're already on the same node as the destination, enable blind tracking
                  current_object.repath_timer.reset()
               end
               if current_object.destination_node != current_object.current_node then
                  -- now run the pathfinding algo, to get the next node
                  -- yes we calculate all this just to find the next node to go to, and then when we get there, we repeat the process
                  -- reset all nodes
                  for each object with label "p_node" do
                     -- make sure each node is nice and clean for the calculations we're about to perform
                     current_object.has_been_reached = 0
                     current_object.lowest_dist = 32000
                     current_object.best_parent = -1
                  end
                  -- configure our current node to be the first result in the recursive node search function
                  temp_obj0 = current_object.current_node
                  temp_obj0.has_been_reached = 1
                  temp_obj0.lowest_dist = 0
                  -- clear our output node
                  -- NOTE: this could be swapped with a number reference aswell, we're only using this variable to know when to early abort the recursive function (IE. we found the destination)
                  temp_obj3 = no_object 
                  -- record the destination object, so we can compare that with each node and deterime if that is the one we're looking for
                  temp_obj2 = current_object.destination_node
                  -- store the distance to a number, so we don't have to constantly recalucate it
                  temp_num2 = current_object.current_node.get_distance_to(current_object.destination_node)
                  -- now we map out the weighting of each node and hopefully find a path
                  recurs_path_scan()
                  -- we're using temp_obj3, but we can use temp_obj2 instead, if you plan on removing temp_obj3
                  if temp_obj3 != no_object then -- we successfully drew a line from start to finish
                     -- now run through it reverse to find our next node, hopefully these calculations are consistent, so we can just rerun to recursively get the next node
                     temp_obj3 = no_object
                     temp_obj0 = temp_obj2
                     temp_obj2 = current_object.current_node
                     recurse_back_through()

                     if temp_obj3 != no_object then
                        -- if we managed to get a retun from the recursive backtrack function, then that is our next node to go to
                        current_object.next_node = temp_obj3
                        current_object.verify_timer.reset() -- just so we dont instantly verify after refinding the path
                     end
                  end
               end
            end
         end
      end
      -- this condition ask whether the Agent is in the same node as the player, or if they are both not inside of nodes
      -- we use a timer, so the Agent doesn't bog down the script by constantly calculating the pathing when they're stuck/blind
      if not current_object.repath_timer.is_zero() or current_object.next_node == no_object then -- blind mode
         current_object.repath_timer.set_rate(-100%)
         -- if they failed to find a path, enable blind movement mode for a second and keep checking
         temp_obj0 = current_object.destination
         ai_movement_towards()
         current_object.next_node = no_object
         current_object.current_node = no_object 
         current_object.destination_node = no_object -- this one is unneeded, but good to clean it up anyway
      end
      -- at the moment, this is split from the above condition, so we can differentiate exactly why the AI is not following the path
      -- this condition asks if the AI failed to find a path to the player
      -- if current_object.next_node == no_object and current_object.repath_timer.is_zero() then
      --    -- if they failed to find a path, enable blind movement mode for a second and keep checking
      --    current_object.set_waypoint_icon(dead_teammate_marker)
      --    temp_obj0 = current_object.destination
      --    ai_movement_towards() -- commented out, so we can debug zombies that have fallen off their path
      -- end
      -- if the agent has a node that they're following, go towards it
      if current_object.next_node != no_object and current_object.repath_timer.is_zero() then 
         -- here we do a check every second to see if we or the player accidently changed 
         current_object.verify_timer.set_rate(-100%)
         if current_object.verify_timer.is_zero() then
            current_object.verify_timer.reset()
            temp_obj0 = current_object
            find_parent_node()
            temp_obj2 = temp_obj1
            temp_obj0 = current_object.destination
            find_parent_node()
            if temp_obj1 != current_object.destination_node or temp_obj2 != current_object.current_node then
               -- then the paths changed, so we better let the rest of the script know that we need to recalculate the path
               current_object.next_node = no_object
               current_object.current_node = temp_obj2 
               current_object.destination_node = temp_obj1
            end
         end
         -- set input of function
         temp_obj0 = current_object.current_node
         ai_movement_towards()
         -- if the Agent has made it to the next node then we can set it as the current, and enable the AI to find a new next node
         if current_object.next_node.shape_contains(current_object) then -- signal find next node and go that way
            current_object.current_node = current_object.next_node
            current_object.next_node = no_object
         end
      end
   end
end