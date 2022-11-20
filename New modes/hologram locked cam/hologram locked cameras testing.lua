-- ### GOALS
--  -  top down map
--  -  AI pathfinding script
--  -  players can attack somehow?? maybe make it auto locak on??
--  -  build defenses
--  -  wave system
--  -  store UI?
--  -  AI spawners
--  -  scaled offset for the camera height, so it can dynamically alter 



-- TRANSLATE HOLOGRAM MOVEMENTS TO MOVEMENT OF A GOOFY BIPED (EVERY 4 TICKS)+ JUMPING
-- we can just let he biped be controlled?? why translate movemnets too


-- PLAYER SHOOT SCRIPT (SYNTEHIC SHOOTING?)

-- 



-- ###########################
-- ### TEMPORARY VARIABLES ### 
-- ###########################
alias temp_num0 = global.number[0]
declare temp_num0 with network priority local

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
declare temp_obj0 with network priority local
declare temp_obj1 with network priority local

-- ########################
-- ### PLAYER VARIABLES ###
-- ########################
alias character = player.object[1] -- the player's real biped, the host will control this, to show where the player is. POV attached
--alias pov_marker = player.object[2] -- the object that marks where the POV should be attached to the characters
--alias pov_base = player.object[3] -- the base of the POV, important because we need to move this to the player location, not actually attaching to it
declare player.character with network priority high
--declare player.pov_marker with network priority local
--declare player.pov_base with network priority local

-- ########################
-- ### OBJECT VARIABLES ###
-- ########################
alias h_local_marker = object.object[0]
alias h_local_weapon = object.object[1]
alias h_local_stand = object.object[2]
alias h_local_pov = object.object[3]
declare object.h_local_marker with network priority local
declare object.h_local_weapon with network priority local
declare object.h_local_stand with network priority local
declare object.h_local_pov with network priority local

alias h_is_hologram = object.number[0]
declare object.h_is_hologram with network priority high

-- ########################
-- ### GLOBAL VARIABLES ###
-- ########################
alias global_tick_counter = global.number[1]
declare global_tick_counter with network priority local -- used to measure ticks between player movement inputs

alias default_orientation = global.object[2]
declare default_orientation with network priority high



-- ######################
-- ### SCRIPT WIDGETS ###
-- ######################
alias holo_to_begin = script_widget[0]

-- #####################
-- ### PLAYER TRAITS ###
-- #####################
alias hologram_traits = script_traits[0]
alias pre_holo_traits = script_traits[1]


-- -- leaving this here because it has some of the important info
-- function conf_hologram_oldstuff()
--    -- here we configure the hologram
--    --temp_obj0.object[1] = temp_obj0.place_at_me(unsc_data_core, none, none, 0, 0, 0, none)
--    temp_obj0.add_weapon(unsc_data_core, force)
--    temp_obj0.object[1] = current_player.get_weapon(primary) -- remember which weapon we were holding


--    -- configure the visual boundary on the power core
--    --global.object[2] = temp_obj0.object[0].place_between_me_and(temp_obj0.object[0], hill_marker, 0) -- visual agent
--    temp_obj0.object[2] = temp_obj0.object[0].place_between_me_and(temp_obj0.object[0], hill_marker, 0) -- pitch agent
--    --global.object[2] = basis.place_between_me_and(basis, hill_marker, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
--    global.object[1] = temp_obj0.object[0].place_at_me(hill_marker, none, none, 0,0,0, none)
--    -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
--    global.object[1].attach_to(temp_obj0.object[0], 0,0,0, relative)
--    global.object[1].detach()
--    -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
--    --global.object[2].attach_to(global.object[1], 0,0,0,relative)
--    global.object[1].face_toward(global.object[1],0,-1,0)
--    temp_obj0.object[2].attach_to(global.object[1], 0,0,0,relative)
--    -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
--    --global.object[2].attach_to(global.object[1], 0,0,0, relative)
--    --global.object[1].copy_rotation_from(temp_obj0.object[1], true)
--    --global.object[2].detach()
--    global.object[1].copy_rotation_from(temp_obj0, true)
--    temp_obj0.object[2].detach()
--    global.object[1].delete()
--    -- setup visual effect for the object
--    --global.object[2].set_shape(cylinder, 1,100,1)
--    --global.object[2].set_shape_visibility(everyone)
--    --global.object[2].attach_to(temp_obj0.object[1], 0,0,0,relative)
--    --global.object[1] = current_player.get_weapon(primary)
--    --current_player.add_weapon(temp_obj0.object[1])

--    --temp_obj0.object[2] = temp_obj0.place_between_me_and(temp_obj0, flag_stand, 0)
--    temp_obj0.attach_to(temp_obj0.object[2], 0,10,0,relative)
--    temp_obj0.object[2].face_toward(temp_obj0.object[2], 0, 1, 0)
-- end


---------------------------------
-- BASIC CONFIGURATIONS SCRIPT --
---------------------------------
do
   holo_to_begin.set_value_text("Use Hologram To Begin")
   global_tick_counter = 1
end

------------------------------------------------
-- SETUP DEFAULT OREINTATION OBJECT REFERENCE --
------------------------------------------------
if default_orientation == no_object then
   for each object do
      if default_orientation == no_object then
         temp_obj0 = current_object.place_between_me_and(current_object, flag_stand, 0)
         default_orientation = temp_obj0.place_at_me(flag_stand, none, none, 0,0,0,none)
         default_orientation.face_toward(default_orientation, 0,1,0)
         temp_obj0.delete()
      end
   end
end

-------------------------------
-- HOLOGRAM DETECTION SCRIPT --
-------------------------------
alias our_biped = temp_obj0
for each player do
   current_player.set_loadout_palette(spartan_tier_1)
   our_biped = current_player.biped
   if our_biped != no_object then 
      -- player is currently a hologram
      if our_biped.h_is_hologram != 0 then 
         current_player.apply_traits(hologram_traits)
         holo_to_begin.set_visibility(current_player, false) 
      end
      -- player has not entered hologram state yet
      if our_biped.h_is_hologram == 0 then 
         current_player.apply_traits(pre_holo_traits)
         holo_to_begin.set_visibility(current_player, true) 
         for each object do
            our_biped = current_player.biped
            if our_biped.h_is_hologram == 0 then 
               temp_num0 = current_object.get_distance_to(our_biped)
               if temp_num0 == 1 then -- this is probably our hologram
                  temp_num0 = current_object.health
                  if temp_num0 > 1 then -- has health, aand was a single unit away, very likely that this object is our hologram
                     current_player.set_biped(current_object)
                     current_player.character = our_biped
                     -- makr the new biped sa a hologram
                     current_object.h_is_hologram = 1
                     -- put at random spawn point
                     temp_obj0 = get_random_object("H_spawn", no_object)
                     current_object.attach_to(temp_obj0, 0,0,0,relative)
                     current_object.detach()

                  end
               end
            end
         end
      end
   end
end

--------------------------------------------------
-- FIXUP DIRECTION OF EACH PLAYER'S "CHARACTER" --
--------------------------------------------------
for each player do
   our_biped = current_player.biped
   if our_biped.h_is_hologram == 1 then
      our_biped.copy_rotation_from(default_orientation, true)
      temp_num0 = our_biped.get_distance_to(current_player.character)
      if temp_num0 >= 1 then
         current_player.character.face_toward(our_biped, 0,0,0)
         current_player.character.attach_to(our_biped, 0,0,0,relative)
         current_player.character.detach()
      end
   end
end

------------------------------------------------------------
-- LOCAL DESYNC SCRIPT TO MAKE PLAYERS HAVE TOP DOWN VIEW --
------------------------------------------------------------
-- important note: 
alias yaw_agent = temp_obj1
on local: do

   if global_tick_counter == 0 then -- is not the host

      for each player do
         our_biped = current_player.biped
         if our_biped != no_object then 
            if our_biped.h_is_hologram == 1 then 
               -- update position of each of the POV pedestals
               if our_biped.h_local_stand != no_object then
                  our_biped.h_local_stand.attach_to(current_player.character, 0,0,0,relative)
                  our_biped.h_local_stand.detach()
               end
               -- check if weapon was misconfigured -> reset
               if our_biped.h_local_weapon == no_object then 
                  -- throw some quick checks out first, to make sure everything has sync'd
                  if current_player.character != no_object then

                     -- setup pedestal objects if required
                     if our_biped.h_local_pov == no_object 
                     or our_biped.h_local_stand == no_object then
                        -- setup the node object, this is so it isnt affected by the movement of the biped
                        our_biped.h_local_stand = current_player.character.place_at_me(flag_stand, none,none, 0,0,0,none)
                        our_biped.h_local_stand.attach_to(current_player.character, 0,0,0,relative)
                        our_biped.h_local_stand.detach()
                        our_biped.h_local_stand.copy_rotation_from(default_orientation, true)
                        -- setup the actual pov marker 
                        our_biped.h_local_pov = our_biped.h_local_stand.place_at_me(flag_stand, none,none, 0,0,0,none)
                        our_biped.h_local_pov.copy_rotation_from(default_orientation, true)
                        our_biped.h_local_pov.attach_to(our_biped.h_local_stand, 0,0,60,relative)
                     end

                     -- clear previous attachment
                     our_biped.detach()
                     our_biped.h_local_marker.delete()
                     -- here we configure the hologram
                     --our_biped.add_weapon(unsc_data_core, force)
                     our_biped.add_weapon(unsc_data_core, force) -- POTENTIAL FOR FAILIRE; MIGHT NOT BEABLE TO HOLD WEAPON
                     our_biped.h_local_weapon = current_player.get_weapon(primary) -- remember which weapon we were holding

                     our_biped.h_local_marker = our_biped.h_local_pov.place_between_me_and(our_biped.h_local_pov, flag_stand, 0) -- pitch agent
                     yaw_agent = our_biped.h_local_marker.place_at_me(flag_stand, none, none, 0,0,0, none)
                     -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
                     yaw_agent.attach_to(our_biped.h_local_pov, 0,0,0, relative)
                     yaw_agent.detach()
                     -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
                     yaw_agent.face_toward(yaw_agent,0,-1,0)
                     our_biped.h_local_marker.attach_to(yaw_agent, 0,0,0,relative)
                     -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
                     yaw_agent.copy_rotation_from(default_orientation, true)
                     yaw_agent.face_toward(yaw_agent, 0,1,0)
                     --yaw_agent.face_toward(yaw_agent, 0,1,0)
                     our_biped.h_local_marker.detach()
                     
                     our_biped.copy_rotation_from(yaw_agent, true)
                     yaw_agent.delete()

                     our_biped.attach_to(our_biped.h_local_marker, 0,10,0,relative)
                     our_biped.h_local_marker.face_toward(our_biped.h_local_marker, 0, 1, 0)

                     our_biped.h_local_marker.attach_to(our_biped.h_local_pov, 0,0,0, relative)
                  end
               end
               -- placeholder script to shrink everything out of sight
               for each object do 
                  temp_num0 = our_biped.get_distance_to(current_object)
                  if temp_num0 == 0 
                  and not current_object.is_of_type(spartan) 
                  and not current_object.is_of_type(elite) 
                  and not current_object.is_of_type(hill_marker)
                  and not current_object.is_of_type(flag_stand) then 
                     current_object.set_scale(1)
                  end
               end
            end
         end
      end

   end
end