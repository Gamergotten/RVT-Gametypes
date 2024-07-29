-- ### GOALS
--  -  top down map
--  -  AI pathfinding script
--  -  build defenses
--  -  wave system
--  -  store UI?
--  -  AI spawners
--  -  scaled offset for the camera height, so it can dynamically alter 




-- lookat tracker

-- clamp up down direction via putting players into vehicles

-- have the hologram have fixed direction on host
-- and then provide direction sync object from host to the clients so they can fixup the direction?



-- ###########################
-- ### TEMPORARY VARIABLES ### 
-- ###########################
alias temp_num0 = global.number[0]
declare temp_num0 with network priority local

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[5]
alias temp_obj3 = global.object[6]
declare temp_obj0 with network priority local
declare temp_obj1 with network priority local
declare temp_obj2 with network priority local
declare temp_obj3 with network priority local

-- ########################
-- ### PLAYER VARIABLES ###
-- ########################
alias local_finder         = player.object[0] -- reusable on client after local player has been found + free slot for host
alias character            = player.object[1] -- the players real biped, only needed on host??
alias location             = player.object[2] -- replicate player location to clients
alias direction            = player.object[3] -- replicate player direction to clients
alias controlling_hologram = player.number[0] 
declare player.local_finder         with network priority local
declare player.character            with network priority high
declare player.location             with network priority high
declare player.direction            with network priority high
declare player.controlling_hologram with network priority high

alias ticks_since_activate = player.number[1]
alias recorded_latency     = player.number[2]
declare player.ticks_since_activate with network priority local = -1
declare player.recorded_latency     with network priority local = -1



-- ########################
-- ### OBJECT VARIABLES ###
-- ########################
alias obj_is_hologram = object.number[0]
declare object.obj_is_hologram with network priority local -- we dont care about hologram checks on clients

-- ########################
-- ### GLOBAL VARIABLES ###
-- ########################
alias is_host = global.number[1]
alias _local_player = global.player[0]
alias default_orientation = global.object[2]
declare is_host               with network priority local 
declare _local_player         with network priority local
declare default_orientation   with network priority high


alias holo_local_marker = global.object[3]
alias holo_local_weapon = global.object[4]
declare holo_local_marker  with network priority local
declare holo_local_weapon  with network priority local


-- ######################
-- ### SCRIPT WIDGETS ###
-- ######################
alias holo_to_begin = script_widget[0]

-- #####################
-- ### PLAYER TRAITS ###
-- #####################
alias hologram_traits = script_traits[0]
alias pre_holo_traits = script_traits[1]


---------------------------------
-- BASIC CONFIGURATIONS SCRIPT --
---------------------------------
do
   holo_to_begin.set_value_text("Use Hologram To Begin")
   holo_to_begin.set_text("latency: %nms, ticks: %n", hud_player.recorded_latency, hud_player.ticks_since_activate)
   is_host = 1
end

------------------------------------------------
-- SETUP DEFAULT OREINTATION OBJECT REFERENCE --
------------------------------------------------
for each player do
   if default_orientation == no_object and current_player.biped != no_object then
      temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, flag_stand, 0)
      default_orientation = temp_obj0.place_at_me(flag_stand, none, none, 0,0,0,none)
      default_orientation.face_toward(default_orientation, 0,1,0) -- rotate 90 degrees to the right?
      temp_obj0.delete()
   end
end

--------------------------------------
-- SETUP PLAYER ORIENTATION OBJECTS --
--------------------------------------
for each player do
   if current_player.location == no_object and current_player.biped != no_object then
      current_player.location = current_player.biped.place_at_me(capture_plate, none,none, 0,0,0,none)
      current_player.location.copy_rotation_from(default_orientation, true)
      current_player.direction = current_player.biped.place_between_me_and(current_player.biped, flag_stand, 0)
   end
end


-------------------------------
-- HOLOGRAM DETECTION SCRIPT --
-------------------------------
for each player do
   current_player.set_loadout_palette(spartan_tier_1)
   if current_player.biped != no_object and current_player.controlling_hologram == 0 then 
      for each object do
         if current_object.obj_is_hologram == 0 and current_player.controlling_hologram == 0 then 
            temp_num0 = current_object.get_distance_to(current_player.biped)
            if temp_num0 == 1 then -- this is probably our hologram
               temp_num0 = current_object.health
               if temp_num0 > 1 then -- has health, aand was a single unit away, very likely that this object is our hologram
                  temp_obj0 = current_player.biped
                  current_player.set_biped(current_object)
                  current_player.character = temp_obj0
                  -- mark the new biped as a hologram
                  current_object.obj_is_hologram = 1
                  current_player.controlling_hologram = 1
                  -- put player's hologram at a random spawn point
                  temp_obj0 = get_random_object("H_spawn", no_object)
                  current_object.attach_to(temp_obj0, 0,0,0,relative)
                  current_object.detach()
               end
            end
         end
      end
   end
end
----------------------------
-- DISPLAY HOLOGRAM STATE --
----------------------------
for each player do -- hologram active
   if current_player.controlling_hologram != 0 then 
      current_player.apply_traits(hologram_traits)
      holo_to_begin.set_visibility(current_player, true) 
   end
end
for each player do -- hologram not active
   if current_player.controlling_hologram == 0 then 
      current_player.apply_traits(pre_holo_traits)
      holo_to_begin.set_visibility(current_player, true) 
   end
end
-----------------------------------
-- CHECK TO RESET HOLOGRAM STATE --
-----------------------------------
-- potentially debug?? we need a dedicated player die and reset function!!
for each player do
   if current_player.biped == no_object then
      current_player.controlling_hologram = 0 -- this should only happen when we die, so when not controlling a biped anymore?
   end
end

--------------------------------------------------
-- FIXUP DIRECTION OF EACH PLAYER'S "CHARACTER" --
--------------------------------------------------
for each player do
   if current_player.controlling_hologram == 1 then
      -- update location object for clients
      current_player.location.attach_to(current_player.biped, 0,0,0,relative)
      current_player.location.detach()
      -- then update the silly thingo biped
      --current_player.biped.copy_rotation_from(default_orientation, true)


      --current_player.character.face_toward(current_player.biped, 0,0,0)
      --current_player.character.attach_to(current_player.biped, 0,0,0,relative)
      --current_player.character.detach()
   end
end

------------------------------------
-- GET LOOK DIRECTION FROM PLAYER --
------------------------------------
global.number[10] += 1
if global.number[10] >= 4 then
   global.number[10] = 0
for each player do
   if current_player.controlling_hologram == 1 then
      -- place object offset from current weapon location
      temp_obj0 = current_player.get_weapon(primary)
      temp_obj1 = current_player.location.place_at_me(flag_stand, none, none, 0,0,0,none)
      temp_obj1.attach_to(temp_obj0, 30, 0,0,relative)
      temp_obj1.detach()

      -- setup temp_obj2 to be parallel to the player, and facing towards the direction on the pitch axis
      temp_obj2 = current_player.direction.place_between_me_and(current_player.direction, hill_marker, 0)
      temp_obj3 = current_player.direction.place_between_me_and(current_player.direction, capture_plate, 0)
      temp_obj3.copy_rotation_from(default_orientation, true)
      temp_obj3.face_toward(temp_obj3, 0,-1,0)
      temp_obj2.attach_to(temp_obj3, 0,0,0,relative)
      temp_obj3.face_toward(current_player.location, 0,0,0)
      temp_obj2.detach()
      temp_obj2.face_toward(temp_obj1, 0,0,0)

      -- DEBUG: keep the object around for a tick for visual analysis --
      temp_obj3.delete()
      current_player.object[0].delete()
      current_player.object[0] = temp_obj2
      temp_obj2.set_hidden(false)
      ------------------------------------------------------------

      -- setup vehicle to reset player orientation with!!
      temp_obj2 = current_player.biped.place_at_me(ghost, none,none, 0,0,127, none)
      temp_obj2.attach_to(current_player.biped, 0,0,0,relative)
      temp_obj2.detach()
      temp_obj2.face_toward(temp_obj1, 0,0,0) -- apply ghost rotation towards where our player is looking?
      -- then apply the rotation reset via vehicle
      current_player.force_into_vehicle(temp_obj2)
      current_player.biped.detach()
      current_player.biped.copy_rotation_from(temp_obj2, true)
      temp_obj2.delete() -- get rid of ghost
      -- fixup player pos
      current_player.biped.attach_to(current_player.location, 0,0,0,relative)
      current_player.biped.detach()

      -- fixup direction object to be at our new direction?
      temp_obj1.delete() -- get rid of our thingo
      current_player.direction.attach_to(temp_obj0, 30, 0,0,relative)
      current_player.direction.detach()
   end
end
end




----------------
-- LOCAL CODE --
----------------
-- important note: 
alias yaw_agent = temp_obj1
on local: do
   if is_host != 1 then -- is not the host
      



      -------------------------
      -- LOCAL PLAYER FINDER --
      -------------------------
      for each player do
			if _local_player == no_player and current_player.biped != no_object then
				if current_player.local_finder == no_object then
					current_player.local_finder = current_player.biped.place_at_me(elite, none, suppress_effect, 5, 0, 2, none)
				end
				temp_obj0 = current_player.get_crosshair_target()
				if temp_obj0 != no_object then
					_local_player = current_player
					for each player do
						current_player.local_finder.delete()
					end
				end
			end
		end

      if _local_player != no_player then
         ---------------------------------
         -- DEBUG ABILITY USAGE TRACKER --
         ---------------------------------
         if _local_player.ticks_since_activate >= 0 and _local_player.controlling_hologram == 0 then
            _local_player.ticks_since_activate += 1
         end
         if _local_player.ticks_since_activate >= 0 and _local_player.controlling_hologram == 1 then
            _local_player.recorded_latency = _local_player.ticks_since_activate
            _local_player.recorded_latency *= 16666
            _local_player.recorded_latency /= 1000
            _local_player.ticks_since_activate = -1
         end
         temp_obj0 = _local_player.get_armor_ability()
         if temp_obj0.is_in_use() and _local_player.ticks_since_activate == -1 then
            _local_player.ticks_since_activate = 0
         end

         --------------------------------
         -- HIDE OTHER PLAYER'S BIPEDS --
         --------------------------------
         for each player do
            if current_player != _local_player and current_player.character != no_object then
               current_player.character.set_hidden(true)
            end
         end

         --------------------------------
         -- CONFIGURE LOCAL PLAYER POV --
         --------------------------------
         if _local_player.biped != no_object and _local_player.controlling_hologram == 1 and _local_player.biped != _local_player.character then 
            -- check if weapon was misconfigured -> reset (i think this fires when the player detaches??))
            if holo_local_weapon == no_object then 
               -- throw some quick checks out first, to make sure everything has sync'd
               if _local_player.location != no_object then
                  -- clear previous attachment
                  _local_player.biped.detach()
                  holo_local_marker.delete()
                  -- here we configure the hologram
                  _local_player.biped.add_weapon(unsc_data_core, force) -- POTENTIAL FOR FAILIRE; MIGHT NOT BEABLE TO HOLD WEAPON
                  holo_local_weapon = _local_player.get_weapon(primary) -- remember which weapon we were holding

                  holo_local_marker = _local_player.location.place_between_me_and(_local_player.location, flag_stand, 0) -- pitch agent
                  yaw_agent = holo_local_marker.place_at_me(flag_stand, none, none, 0,0,0, none)
                  -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
                  yaw_agent.face_toward(yaw_agent,0,-1,0)
                  holo_local_marker.attach_to(yaw_agent, 0,0,0,relative)
                  -- get position and then fix it up??
                  yaw_agent.copy_rotation_from(default_orientation, true)
                  yaw_agent.face_toward(yaw_agent, 0,-1,0)
                  --yaw_agent.face_toward(yaw_agent, 0,1,0)
                  holo_local_marker.detach()
                  
                  _local_player.biped.copy_rotation_from(yaw_agent, true)
                  yaw_agent.delete()

                  _local_player.biped.attach_to(holo_local_marker, 0,10,0,relative)
                  holo_local_marker.face_toward(holo_local_marker, 0, 1, 0)

                  holo_local_marker.attach_to(_local_player.location, 0,0,60, relative)
               end
            end
            -- placeholder script to shrink everything out of sight
            for each object do 
               temp_num0 = _local_player.biped.get_distance_to(current_object)
               if temp_num0 == 0 
               and not current_object.is_of_type(spartan) 
               and not current_object.is_of_type(elite) 
               and not current_object.is_of_type(hill_marker)
               and not current_object.is_of_type(flag_stand)
               and not current_object.is_of_type(capture_plate) then 
                  --current_object.set_scale(1)
                  current_object.set_hidden(true)
               end
            end
         end
      end

   end
end