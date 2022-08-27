---------------
-- TEMP VARS --
---------------
alias temp_obj0 = global.object[0]
alias temp_num0 = global.number[0]

-------------------
-- CONSTANT VARS --
-------------------
alias mvar_hash = global.number[1]

-- 
-- INPUTS: temp_num0
function rotate_bits_and_XOR()
   mvar_hash ^= temp_num0 -- XOR our temp_var into our hash, XOR provides a way to add bits without overflowing
   -- rotate the first bit to the last bit, so we can bitshift without losing data
   temp_num0 = mvar_hash
   -- covnert bit#0 to bit#16
   temp_num0 &= 0b1000000000000000 -- strip out the rest of the information, so we get a clean division
   temp_num0 /= 0b1000000000000000
   -- bitshift hash by 1 bit to the left
   mvar_hash &= 0b0111111111111111 -- remove the sign, we don't need this bit anyway, this is so we get a clean multiplication
   mvar_hash *= 0b0000000000000010 -- bitshift 1 to the left
   -- complete rotation by adding our lost bit#0 to bit#15, which is currently vacant
   mvar_hash += temp_num0
end
-- generate maps hash, exports this value to "mvar_hash" aka global.number[1] or whatever number you want
function generate_hash()
   mvar_hash = 0 -- this is our seed
   temp_obj0 = no_object -- we need to clear this first, else hashes may be inconsistant
   -- begin hashing
   for each object do
      -- you can remove any of these hash elements, to save code or whatever, main one is the distance
      -- hash distance to world origin
      temp_num0 = current_object.get_distance_to(temp_obj0)
      rotate_bits_and_XOR()
      -- hash spawn sequence (optional)
      temp_num0 = current_object.spawn_sequence
      rotate_bits_and_XOR()
      -- hash orientation (optional)
      temp_num0 = current_object.get_orientation()
      rotate_bits_and_XOR()
      -- you can add as many hash elements as you want here
      -- set our first object (typically the skybox) as the world origin, to get distances
      if temp_obj0 == no_object then -- do this at the end so we save an action & trigger
         temp_obj0 = current_object
      end
   end
end

-- call hash function once, im not sure if this will work as expected during a round restart however
on init: do
   generate_hash()
end

-- to display the map's hash, you can do whatever you want with it though
-- however, you will of course need to display the hash so you can hash all your maps!
script_widget[0].set_text("map hash %n", mvar_hash)

-- alert players of incorrect map
alias desired_map_hash = -24765 -- this is asylums hash, but you have to fill this one out yourself
if mvar_hash != desired_map_hash then
   game.show_message_to(all_players, none, "this is the incorrect map; please restart with the correct map")
   mvar_hash = desired_map_hash -- to prevent spamming this action, we will allow this to be the correct map
end

-- end game when incorrect map
alias desired_map_hash = -24765 -- this is asylums hash, but you have to fill this one out yourself
if mvar_hash != desired_map_hash then
   game.show_message_to(all_players, none, "this is the incorrect map; please restart with the correct map")
   game.end_round() -- end this session as it is the incorrect map
end

-- multiple allowed maps
alias asylum_map_hash = -24765 
alias boardwalk_map_hash = 14186
alias boneyard_map_hash = 11955
if mvar_hash != asylum_map_hash and mvar_hash != boardwalk_map_hash and mvar_hash != boneyard_map_hash then
   game.show_message_to(all_players, none, "this is the incorrect map; please restart with the correct map")
   game.end_round() -- end this session as it is the incorrect map
end