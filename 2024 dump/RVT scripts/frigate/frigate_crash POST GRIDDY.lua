

-- ALIAS SECTION ---------------------------------------------------------------------------------------

-- ####################
-- ### TEMP ALIASES ###
-- ####################
   alias temp_num0 = global.number[0]
   alias temp_num1 = global.number[1]
   alias temp_num2 = global.number[2]
   alias temp_num3 = global.number[3]
   alias temp_num4 = global.number[4]
   declare temp_num0 with network priority local
   declare temp_num1 with network priority local
   declare temp_num2 with network priority local
   declare temp_num3 with network priority local
   declare temp_num4 with network priority local

   alias temp_obj0 = global.object[0]
   alias temp_obj1 = global.object[1]
   alias temp_obj2 = global.object[2]
   alias temp_obj3 = global.object[3]
   alias temp_obj4 = global.object[4]
   alias temp_obj5 = global.object[5]
   alias temp_obj6 = global.object[6]
   declare temp_obj0 with network priority local
   declare temp_obj1 with network priority local
   declare temp_obj2 with network priority local
   declare temp_obj3 with network priority local
   declare temp_obj4 with network priority local
   declare temp_obj5 with network priority local
   declare temp_obj6 with network priority local

   alias temp_player0 = global.player[1]
   declare temp_player0 with network priority local
---
-- ########################
-- ### GLOBAL VARIABLES ###
-- ########################
   -- global ticker (also host indicator)
      alias global_ticker = global.number[5]
      declare global_ticker with network priority local
      global_ticker += 1
   ---
   -- teams
      alias SPARTANS = team[0]
      alias ELITES = team[1]
   ---
   -- local player finder
      alias local_player_ = global.player[0]
      declare local_player_ with network priority local
   ---
   -- ground checking 
      alias ground_checker = global.object[7]
      declare ground_checker with network priority local
   --- 
   -- debug variables
      --alias frigates_distance = global.number[6]
      --declare frigates_distance with network priority local
      alias object_count = global.number[7]
      declare object_count with network priority local
   ---
   -- HUD variables
      alias players_left = global.number[6]
      declare players_left with network priority low
   ---
   -- initial weapon gifts 
      alias splasers_given_out = global.number[8]
      declare splasers_given_out with network priority local
   ---
---     
-- ########################
-- ### OBJECT VARIABLES ###
-- ########################
   -- declarations
      declare object.object[0] with network priority high
      declare object.object[1] with network priority local
      declare object.object[2] with network priority local
      declare object.object[3] with network priority high
      declare object.number[0] with network priority local
      declare object.number[1] with network priority local
      --declare object.number[2] with network priority local
      --declare object.number[3] with network priority local
      --declare object.number[4] with network priority local
      --declare object.number[5] with network priority local
      --declare object.number[6] with network priority local
      --declare object.number[7] with network priority local
   ---
   -- frig attachments
      alias offset = object.object[0]
      alias parent_frig = object.object[3]
      alias gravity_obj = object.object[1]
      alias placeholder_obj = object.object[2]
   ---
   -- frig_damage (inherits frig_attachment)
      alias objective_health = object.timer[0]
      declare object.objective_health = 100
   ---
   -- frigate vars
      alias frig_init = object.number[0] -- also used to count up ticks until frigate crashes
      alias frig_mover = object.object[0] -- needs to sync to clients
      alias frig_gravity_obj = object.object[2]
      --alias frig_mover_step = object.object[1]
      alias frig_direction_obj = object.object[3]
   ---
   -- player biped vars
      alias has_init = object.number[0]
      alias last_vehicle = object.object[1]
      -- alias bpd_init = object.number[1] -- yeah this literally behaves the exact same as the one above, but separate just becauase they're in different code sections?????
      -- alias bpd_OS_socket = object.object[1]
      -- alias bpd_OS_visual = object.object[2]
   ---
---
-- ######################
-- ### PLAYER ALIASES ###
-- ######################
   -- cargo physics variables
      alias global_pos = player.object[0]
      alias relative_pos = player.object[1]
      alias last_frigate = player.object[2]
      alias local_finder = player.object[3] -- only used on off-hosts
      declare player.global_pos with network priority local
      declare player.relative_pos with network priority local
      declare player.last_frigate with network priority local
      declare player.local_finder with network priority local
   ---
   -- out of bounds variables
      alias monitor_biped = player.object[3] -- only on host
      --alias tickOffset = player.number[0]
      --alias synced = player.number[1]
      --declare player.tickOffset with network priority local = 0
      --declare player.synced with network priority local
      alias synced = player.number[1]
      alias host = player.number[5]
      alias invincibilityTick = player.number[0]
      declare player.synced with network priority local
      declare player.host with network priority local
      declare player.invincibilityTick with network priority local = 2

      alias out_of_bounds_timer = player.timer[0]
      declare player.out_of_bounds_timer = 15

      alias reset_monitor_fallback = player.timer[3] -- probably redundant
      declare player.reset_monitor_fallback = 1
   ---
   -- dont die from exiting banshees
      alias exit_vehicle_timer = player.timer[2]
      declare player.exit_vehicle_timer = 1
      --alias was_just_in_banshee = player.number[6]
      --declare player.was_just_in_banshee with network priority local
   ---
   -- armory variables
      alias armory_cycle_timer = player.timer[1]
      declare player.armory_cycle_timer = 5
   ---
   -- infection variables 
      alias is_infected = player.number[2]
      alias is_last_man_standing = player.number[3]
      alias init_ticks = player.number[4]
      declare player.is_infected with network priority local
      declare player.is_last_man_standing with network priority local
      declare player.init_ticks with network priority local
   ---
---



-- SCRIPT SECTION ---------------------------------------------------------------------------------------
----------------------------
-- SPECIAL HELPER SCRIPTS --
----------------------------
   -------------------
   -- OFFSET ATTACH --
   -------------------
      -- INPUTS
      alias lookat_obj = temp_obj2
      alias offs_target_object = temp_obj5
      alias basis = temp_obj3
      alias offset_scale = temp_num0
      alias pitch_obj = temp_obj1 -- this gets deleted
      -- OUTPUTS
      alias yaw_obj = temp_obj0 -- also input
      alias offset_obj = temp_obj4 -- optional input
      -- yaw_obj - create a new object at basis that looks at "lookat_obj" on both pitch and yaw
      -- then take a variable number offset_scale and create offset_obj at that distance forward from yaw_obj
      function basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
         -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
         yaw_obj.attach_to(basis, 0,0,0, relative)
         yaw_obj.detach()   
         -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
         yaw_obj.face_toward(yaw_obj,0,-1,0)
         -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
         pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
         yaw_obj.face_toward(lookat_obj,0,0,0)
         pitch_obj.detach()
         -- apply the relative pitch rotation to our yaw axis
         yaw_obj.attach_to(pitch_obj, 0,0,0, relative) 
         pitch_obj.face_toward(lookat_obj,0,0,0)
         pitch_obj.face_toward(pitch_obj,0,-1,0)
         yaw_obj.detach()
         -- setup offset object & attach-offset it in the forward direction
         pitch_obj.delete()
         offset_obj = yaw_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
         offset_obj.copy_rotation_from(offs_target_object, true)
         offset_obj.attach_to(yaw_obj, 100,0,0, relative)
         -- now we just do the attaching forward, set scale of yaw obj, thus scaling the attachment offset of offset_obj
         yaw_obj.set_scale(offset_scale)
         yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
      end
      function offset_attach() -- used just below and by the turret thing
         offs_target_object.parent_frig = basis
         -- place pitch and yaw objects
         pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
         yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
         -- place lookat object
         lookat_obj = offs_target_object.place_between_me_and(offs_target_object, sound_emitter_alarm_2, 0)
         offset_scale = lookat_obj.get_distance_to(pitch_obj)
         basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
         lookat_obj.delete()
         offs_target_object.offset = offset_obj

         offs_target_object.attach_to(offset_obj, 0,0,0,relative)
         yaw_obj.attach_to(basis, 0,0,0,relative)
      end
   ---
   --------------------
   -- CASCADE ATTACH --
   --------------------
      alias knee = object.object[0] -- used as 'tip' or 'point' in cascade operation, but when completed becomes the knee/joint of a connection
      alias foot = object.object[1] -- opposite end of the triangle object formation
      alias cascade_length = 100
      alias cascade_amount = 150

      alias counter = temp_num0 -- input
      alias src = temp_obj0 -- input
      alias dst = temp_obj1 -- input
      function cascade_loop()
         src.face_toward(dst.knee, 0,0,0)
         dst.face_toward(src.knee, 0,0,0)
         counter += 1
         if counter < cascade_amount then
            cascade_loop()
         end
      end
      --    src = temp_obj0 -- input/output
      --    dst = temp_obj1 -- input/output
      alias rotation_helper = temp_obj2 -- internal
      function cascade() 
         -- essentially create editable versions of the locations
         src = src.place_between_me_and(src, sound_emitter_alarm_2, 0)
         dst = dst.place_between_me_and(dst, sound_emitter_alarm_2, 0)
         
         -- do whatever this does
         temp_num1 = src.get_distance_to(dst)
         temp_num1 /= 2
         temp_num1 += 5 -- just some padding to make sure it all works fine??
         if temp_num1 < 100 then
            temp_num1 = 100
         end
         -- DEBUG: too far apart exception
         -- temp_num0 /= 2 -- we need to check if distance is greater than twice the cascade length, alternatively we check if half the distance is greater than a single cascade length
         -- if temp_num0 > cascade_length then
         --    game.show_message_to(all_players, none, "failure: range exceeded, increase the 'cascade_length'")
         -- end
         --

         -- create rotation helper to orient our locations towards another
         -- NOTE: we could replace this with a global helper object, so that it only needs to be spawned in once, however reseting coords might not be the easiest, which is probably why we always spawned it from scratch in the original pitch axis functions
         rotation_helper = src.place_at_me(sound_emitter_alarm_2, none,none, 0,0,0, none)
         rotation_helper.attach_to(src, 0,0,0, relative)
         rotation_helper.detach()
         -- then offset rotation, converting roll to pitch
         rotation_helper.face_toward(rotation_helper,0,-1,0)
         src.attach_to(rotation_helper, 0,0,0,relative)
         -- then correct our src's yaw to face towards dst
         rotation_helper.face_toward(dst, 0,0,0)
         src.detach()
         rotation_helper.delete() -- no longer needed
         -- we can simply copy the rotation over to dst as well, so they will now have the exact same pitch heading
         dst.copy_rotation_from(src, true)
         
         -- setup the edge things
         src.knee = src.place_between_me_and(src, sound_emitter_alarm_2, 0)
         dst.knee = dst.place_between_me_and(src, sound_emitter_alarm_2, 0)
         -- src knee needs to have the same orientation, so we can rotate it later
         src.knee.copy_rotation_from(src, true)

         src.knee.attach_to(src, cascade_length,0,0, relative)
         dst.knee.attach_to(dst, cascade_length,0,0, relative)
            -- then scale up the distance
            src.set_scale(temp_num1)
            dst.set_scale(temp_num1)
            src.copy_rotation_from(src, true)
            dst.copy_rotation_from(dst, true)
         
         -- call the cascade recursive function
         counter = 0
         cascade_loop()
         dst.knee.delete() -- no longer needed
         src.foot = dst
         
         -- fixup src.knee 
         src.knee.detach()
         src.knee.face_toward(dst, 0,0,0)
         -- bind foot to our thing
         dst.attach_to(src.knee, cascade_length,0,0, relative)
            -- then scale up the distance
            src.knee.set_scale(temp_num1)
            src.knee.copy_rotation_from(src.knee, true)
            -- reset src_scale so we can attach it correctly again
            src.set_scale(100)
            src.copy_rotation_from(src, true)
            -- attach and scale up distance
            src.knee.attach_to(src, cascade_length,0,0, relative)
            src.set_scale(temp_num1)
            src.copy_rotation_from(src, true)
      end
      -- function cascade_attach()
      --    src = no_object -- todo fix this
      --    dst = current_object
      --    cascade()
      --    src.attach_to(no_object, 0,0,0, relative)
      --    current_object.attach_to(dst, 0, 0, 0, relative)
      -- end
   ---
   ----------------------------
   -- GROUND DETECTION LOGIC --
   ----------------------------
      if ground_checker == no_object then
         ground_checker = get_random_object("ground", no_object)
         ground_checker.offset = ground_checker.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
         ground_checker.offset.attach_to(ground_checker, 100, 0,0,relative)
         ground_checker.offset.set_shape(cylinder, 10000, 10,100)
         -- debug
         --ground_checker.offset.set_shape_visibility(everyone)
         --ground_checker.offset.set_waypoint_visibility(everyone)
         --ground_checker.set_waypoint_visibility(everyone)
      end
      function check_for_ground()
         temp_num0 = current_object.get_distance_to(ground_checker)
         ground_checker.set_scale(temp_num0)
         --ground_checker.copy_rotation_from(ground_checker, true)
         ground_checker.face_toward(current_object, 0,0,0)
         -- and then use this condition after calling the function
         --if ground_checker.offset.shape_contains(current_object) then
      end
      function player_check_for_ground() -- theres really no point in functionizing this but whatever
         temp_num0 = current_player.biped.get_distance_to(ground_checker)
         ground_checker.set_scale(temp_num0)
         ground_checker.face_toward(current_player.biped, 0,0,0)
      end
   ---
   --------------------
   -- VELOCITY MOVER --
   --------------------
      function ApplyVelocity()
         if temp_num0 > 0 then
            temp_obj1.attach_to(temp_obj0, -1, 0, 0, relative)
            temp_obj1.detach()
            temp_obj0.attach_to(temp_obj1,  1, 0, 0, relative)
            temp_obj0.detach()
            temp_num0 -=1
            ApplyVelocity()
         end
      end
      function push_forward()
         temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0)
         temp_obj1.copy_rotation_from(temp_obj0, true)
         temp_num0 = 48
         ApplyVelocity()
      end
   ---
   -------------------------
   -- CLEANUP ATTACHMENTS --
   -------------------------
      alias cleanup_target = temp_obj1
      function cleanup_attachments()
         if cleanup_target != no_object then
            for each object do
               if cleanup_target != current_object then
                  temp_num0 = current_object.get_distance_to(cleanup_target)
                  if temp_num0 == 0 then
                     current_object.delete()
                  end
               end
            end
         end
      end
   ---
   ------------------------
   -- OUT OF BOUNDS PLAY --
   ------------------------
      --for each player do
      --   current_player.biped.set_invincibility(1)
      --end
      -- for each player do
      --    current_player.tickOffset += 1
      --    current_player.tickOffset %= 16
      --    current_player.biped.set_invincibility(0)
      --    if current_player.tickOffset == 0 then
      --       current_player.biped.set_invincibility(1)
      --    end
      -- end
      -- for each player do
      --    if current_player.synced == 0 then
      --       current_player.synced = 1
      --       for each object do
      --          if not current_player.biped.is_of_type(monitor) then
      --             --alias new = allocate temporary object
      --             temp_obj0 = current_object.place_between_me_and(current_object, monitor, 0)
      --             current_player.set_biped(temp_obj0)
      --          end
      --       end
      --    end
      -- end
      for each player do
         if current_player.synced == 0 then
            for each object do
               if not current_player.biped.is_of_type(monitor) then
                  current_player.monitor_biped = current_object.place_at_me(monitor, none, suppress_effect, 0, 0, 100, none)
                  current_player.set_biped(current_player.monitor_biped)
               end
            end
         end
      end
      -- this code should NOT BE NEEDED !!!! JUST IN CASE THIS WAS THE PROBLEM THOUGH!!!!
      for each player do
         if not current_player.biped.is_of_type(monitor) then
            current_player.reset_monitor_fallback.reset()
         end
         if current_player.biped.is_of_type(monitor) then
            current_player.reset_monitor_fallback.set_rate(-100%)
            if current_player.reset_monitor_fallback.is_zero() then
               temp_obj0 = current_player.biped.place_at_me(monitor, none, none, 0,0,25, none)
               current_player.biped.delete()
               current_player.set_biped(temp_obj0)
               game.show_message_to(all_players, none, "%p is stuck in monitor mode!!! GAMEMODE BROKEN", current_player)
            end
         end
      end

      for each player do
         if current_player.synced == 1 then
            current_player.invincibilityTick = 0
            current_player.synced = 2
         end
         temp_obj0 = current_player.get_vehicle()
         current_player.biped.set_invincibility(0)
         temp_obj0.set_invincibility(0)
         if current_player.invincibilityTick == 15 and not current_player.biped.is_of_type(monitor) then
            current_player.biped.set_invincibility(1)
            temp_obj0.set_invincibility(1)
         end
      end

      for each player do
         if current_player.biped == no_object and current_player.host == 0 then
            current_player.invincibilityTick = 9
         end
         if current_player.biped != no_object then
            current_player.host = 1
         end
         if current_player.host == 1 then
            current_player.invincibilityTick += 1
            if current_player.invincibilityTick > 15 then
               current_player.invincibilityTick = 0
            end
         end
      end
      -- stuck in monitor potential fix
   ---
   --------------------------------
   -- RANDOMIZE OBJECT DIRECTION --
   --------------------------------
      -- copied from halo moddy wars
      -- inputs: temp_num2 -- rotation count
      function recurse_interp_rotation_yaw()
         if temp_num2 > 0 then
            temp_num2 -= 1
            -- turn left
            temp_obj1.face_toward(temp_obj1, 127,-1,0) 
            if temp_num1 <= temp_num0 then  -- turn right (twice as much to account for the left turn)
               temp_obj1.face_toward(temp_obj1, 127, 2,0) 
            end
            recurse_interp_rotation_yaw()
         end
      end
      -- NOTE: you have to multiply the inputs by 2.216613958442163 to actually get the degrees you want (IE. to input 90 degrees you need to set the number variable to 199)
      -- ALSO NOTE: this rotates in either diretion, determined randomly (why would we only need to randomly rotate in a single direction??)
      --alias min_degrees = temp_num0
      --alias rand_degrees = temp_num2
      function rotate_random()
         --rand_degrees = rand(rand_degrees)
         --rand_degrees += min_degrees
         temp_num2 = rand(100)
         temp_num1 = rand(2) -- which direction to turn
         temp_num0 = 0
         --min_degrees = 0 -- because this is used with the thing
         recurse_interp_rotation_yaw()
      end
   ---
---


-------------------
-- FRIGATE LOGIC --
-------------------
   -------------------
   -- INIT FRIGATES --
   -------------------
      for each object with label "frig_origin" do
         if current_object.frig_init == 0 then
            current_object.frig_init = 1
            -- attach/setup all our attach pieces
            basis = current_object
            for each object with label "frig_attach" do
               if basis.shape_contains(current_object) then
                  offs_target_object = current_object
                  offset_attach()
               end
            end
            for each object with label "frig_armory" do
               if basis.shape_contains(current_object) then
                  offs_target_object = current_object
                  offset_attach()
               end
            end
            for each object with label "frig_damage" do
               if basis.shape_contains(current_object) then
                  --current_object.placeholder_obj = current_object.place_between_me_and(current_object, capture_plate, 0)
                  --current_object.placeholder_obj.copy_rotation_from(current_object, true)
                  --offs_target_object = current_object.placeholder_obj
                  offs_target_object = current_object
                  offset_attach()
                  --current_object.offset = offset_obj
                  --current_object.parent_frig = basis
                  current_object.set_waypoint_icon(ordnance)
                  current_object.set_waypoint_visibility(everyone)
                  current_object.set_waypoint_priority(high)
                  --current_object.set_waypoint_range(0, 35)
                  current_object.team = SPARTANS
                  current_object.set_waypoint_timer(object.objective_health)
                  current_object.attach_to(current_object.placeholder_obj, 0,0,0,relative)
               end
            end
            -- SPAWN IN SPECIAL FRIGATE OBJECTS!!!!
               -- for each object with label "frig_turret" do
               --    if basis.shape_contains(current_object) then
               --       if current_object.spawn_sequence != 0 then 
               --          --offs_target_object = no_object -- fallback
               --          temp_obj0 = no_object
               --          if current_object.spawn_sequence == 1 then
               --             temp_obj0 = current_object.place_at_me(machine_gun_turret, none, none, 0,0,0,none)
               --          end
               --          if current_object.spawn_sequence == 2 then
               --             temp_obj0 = current_object.place_at_me(warthog_turret_rocket, none, none, 0,0,0,none)
               --          end
               --          if current_object.spawn_sequence == 3 then
               --             temp_obj0 = current_object.place_at_me(warthog_turret_gauss, none, none, 0,0,0,none)
               --          end
               --          if temp_obj0 != no_object then
               --             offs_target_object = current_object.place_at_me(flag_stand, "frig_attach", none, 0,0,0,none)
               --             offs_target_object.attach_to(current_object, 0,0,0,relative)
               --             offs_target_object.detach()
               --             offs_target_object.copy_rotation_from(current_object, true)
               --             temp_obj0.set_invincibility(1)
               --             temp_obj0.set_waypoint_visibility(everyone)
               --             temp_obj0.copy_rotation_from(current_object, true)
               --             temp_obj0.attach_to(offs_target_object, 0,0,0,relative)
               --             --offs_target_object = temp_obj0
               --             offset_attach()
               --          end
               --          current_object.delete()
               --       end
               --    end
               -- end
            ---

            -- then we can relocate our frigate
            ground_checker.set_scale(10000)
            --ground_checker.copy_rotation_from(ground_checker, true)
            ground_checker.face_toward(ground_checker, 127,5,0) -- rotate the direction slightly so the next ship spawns in a different spot

            -- project the thingo upwards??
            temp_obj0 = ground_checker.offset.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
            temp_obj1 = ground_checker.offset.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
            temp_obj1.attach_to(temp_obj0, 0,0,100, relative)
            temp_obj0.set_scale(900)
            temp_obj0.copy_rotation_from(temp_obj0, true)
         
            current_object.attach_to(temp_obj1, 0,0,0,relative)
            current_object.detach()
            temp_obj0.delete()

            current_object.frig_direction_obj = current_object.place_at_me(flag_stand, none, none, 127,0,0, none)
            --current_object.frig_mover_step = current_object.place_at_me(flag_stand, none, none, 0,0,0, none)
            current_object.frig_mover = current_object.place_at_me(capture_plate, none, none, 0,0,0, none)
            current_object.frig_mover.set_invincibility(1)
            current_object.attach_to(current_object.frig_mover, 0,0,0,relative)
         end
      end
   ---
   -----------------------------
   -- UPDATE FRIGATE POSITION --
   -----------------------------
      for each object with label "frig_origin" do
         if current_object.frig_gravity_obj == no_object then
            -- chunk as code but it'll work
            
            -- make the frigate move 
            temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            temp_obj0.copy_rotation_from(current_object, true)

            current_object.frig_mover.attach_to(temp_obj0, 1,0,0,relative)
            temp_obj0.set_scale(25)
            temp_obj0.copy_rotation_from(temp_obj0, true)
            
            current_object.frig_mover.detach()
            temp_obj0.delete()
            -- push frigates away from each other if they get too close
            temp_obj2 = current_object
            for each object with label "frig_origin" do
               if temp_obj2 != current_object then -- and current_object.frig_gravity_obj == no_object then -- even push away from a frigate that is crashing!!!
                  temp_num0 = temp_obj2.get_distance_to(current_object)
                  --frigates_distance = temp_num0 -- store to debug!!!!
                  if temp_num0 < 600 then
                     temp_obj0 = temp_obj2.place_between_me_and(temp_obj2, sound_emitter_alarm_2, 0)
                     temp_obj0.copy_rotation_from(temp_obj2, true)
                     temp_obj0.face_toward(current_object, 0,0,0)
                     temp_obj2.frig_mover.attach_to(temp_obj0, -1,0,0,relative)
                     temp_obj0.set_scale(50)
                     temp_obj0.copy_rotation_from(temp_obj0, true)
                     temp_obj2.frig_mover.detach()
                     temp_obj0.delete()
                  end
               end
            end
            

            temp_obj0 = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
            -- fixup helper position + offset direction 1 to the left
            temp_obj0.attach_to(current_object, 0,1,0,relative)
            temp_obj0.detach()
            --temp_obj0.copy_rotation_from(current_object, true)
            -- then shift our direction object out really far
            current_object.frig_direction_obj.attach_to(temp_obj0, 100,0,0,relative)
            temp_obj0.set_scale(4400)
            temp_obj0.copy_rotation_from(temp_obj0, true)
            current_object.frig_direction_obj.detach()
            -- cleanup helper object
            temp_obj0.delete()

         end
      end
   ---
   ----------------------------
   -- FRIGATE CRASHING LOGIC --
   ----------------------------
      ---------------------------------------
      -- CRASH IF ALL WEAKPOINTS DESTROYED --
      ---------------------------------------
         for each object with label "frig_origin" do
            if current_object.frig_gravity_obj == no_object then
               -- initiate frigate crash if all engines and whatever are taken out!!
               temp_num0 = 0
               temp_obj0 = current_object
               for each object with label "frig_damage" do
                  if current_object.parent_frig == temp_obj0 then
                     temp_num1 = current_object.health
                     current_object.objective_health = temp_num1 -- update display value as well as do this check
                     if temp_num1 > 0 then 
                        temp_num0 += 1
                     end
                  end
               end
               if temp_num0 == 0 and global_ticker > 800 then
                  game.show_message_to(all_players, none, "crash activated!!")
                  current_object.frig_gravity_obj = current_object.place_at_me(phantom, none, suppress_effect, 0,0,0,none)
                  current_object.frig_gravity_obj.set_invincibility(1)
                  current_object.frig_gravity_obj.copy_rotation_from(current_object, true)
                  current_object.frig_gravity_obj.attach_to(current_object, 0,0,0,relative)
                  current_object.frig_gravity_obj.detach()
                  temp_obj0 = current_object.frig_gravity_obj
                  push_forward()
                  current_object.frig_gravity_obj.set_scale(1)
                  current_object.frig_gravity_obj.push_upward()
                  current_object.detach()
                  current_object.frig_direction_obj.delete() -- cleanup
                  current_object.frig_mover.delete() -- cleanup
                  current_object.attach_to(current_object.frig_gravity_obj, 0,0,0,relative)
               end
            end
         end
         -- hide waypoints for destroyed objectives
         for each object with label "frig_damage" do
            if current_object.objective_health <= 0 then
               current_object.set_waypoint_visibility(no_one)
            end
         end
      ---
      ------------------------------
      -- ACTIVATE FRIGATE CLEANUP --
      ------------------------------
         for each object with label "frig_origin" do
            -- trigger frigate full crash sequence
            if current_object.frig_init == 1 and current_object.frig_gravity_obj != no_object then
               check_for_ground()
               if ground_checker.offset.shape_contains(current_object) then
                  current_object.frig_init = 2
               end
            end
         end
      ---
      -----------------------------
      -- CLEANUP CRASHED FRIGATE --
      -----------------------------
         function detach_piece()
            if current_object.parent_frig != no_object then
               current_object.parent_frig = no_object -- so we dont detach again
               current_object.gravity_obj = current_object.place_at_me(scorpion, none, suppress_effect, 0,0,0,none)
               cleanup_target = current_object.gravity_obj
               cleanup_attachments()
               current_object.gravity_obj.set_invincibility(1)
               --current_object.gravity_obj.copy_rotation_from(current_object, true)
               current_object.gravity_obj.attach_to(current_object, 0,0,0,relative)
               current_object.gravity_obj.detach()
               current_object.gravity_obj.set_scale(1)
               current_object.detach()
               current_object.offset.delete()
               current_object.attach_to(current_object.gravity_obj, 0,0,0,relative)
            end
         end
         for each object with label "frig_origin" do
            -- wait for 40 ticks and then fully crash if crash sequence is active
            if current_object.frig_init > 1 then
               current_object.frig_init += 1
               if current_object.frig_init == 40 then
                  temp_obj0 = current_object
                  for each object with label "frig_attach" do
                     if current_object.parent_frig == temp_obj0 then
                        detach_piece()
                     end
                  end
                  current_object.frig_gravity_obj.delete()
                  --current_object.delete()
                  game.show_message_to(all_players, none, "frigate collapsed!!")
               end
            end
         end
      ---
      -------------------------------
      -- CLEANUP INDIVIDUAL PIECES --
      -------------------------------
         for each object with label "frig_attach" do
            if current_object.gravity_obj != no_object then
               temp_num0 = current_object.gravity_obj.get_speed()
               if temp_num0 == 0 then
                  current_object.detach()
                  current_object.gravity_obj.delete()
                  current_object.placeholder_obj = current_object.place_between_me_and(current_object, flag_stand, 0)
                  current_object.attach_to(current_object.placeholder_obj,0,0,0,relative)
               end
            end
            if current_object.parent_frig != no_object then
               temp_obj0 = current_object.parent_frig
               if temp_obj0.frig_gravity_obj != no_object then -- if parent frigate is falling
                  check_for_ground()
                  --current_object.detach()
                  -- TODO replace this with attach/detach as they would be less laggy
                  temp_obj2 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
                  if ground_checker.offset.shape_contains(temp_obj2) then
                     detach_piece()
                  end
                  temp_obj2.delete()
                  -- restore piece back onto thing
                  --if current_object.offset != no_object then
                  --   current_object.attach_to(current_object.offset, 0,0,0,relative)
                  --end
               end
            end
         end
      --
   ---
---   
--------------------------
-- FRIGATE ARMORY LOGIC --
--------------------------
   function random_weapon()
      temp_num0 = rand(24)
      if temp_num0 ==  0 then current_player.biped.add_weapon(assault_rifle,               force) end
      if temp_num0 ==  1 then current_player.biped.add_weapon(dmr,                         force) end
      if temp_num0 ==  2 then current_player.biped.add_weapon(grenade_launcher,            force) end
      if temp_num0 ==  3 then current_player.biped.add_weapon(magnum,                      force) end
      if temp_num0 ==  4 then current_player.biped.add_weapon(rocket_launcher,             force) end
      if temp_num0 ==  5 then current_player.biped.add_weapon(shotgun,                     force) end
      if temp_num0 ==  6 then current_player.biped.add_weapon(sniper_rifle,                force) end
      if temp_num0 ==  7 then current_player.biped.add_weapon(spartan_laser,               force) end
      if temp_num0 ==  8 then current_player.biped.add_weapon(target_locator,              force) end
      if temp_num0 ==  9 then current_player.biped.add_weapon(golf_club,                   force) end
      if temp_num0 == 10 then current_player.biped.add_weapon(detached_machine_gun_turret, force) end
      if temp_num0 == 11 then current_player.biped.add_weapon(concussion_rifle,            force) end
      if temp_num0 == 12 then current_player.biped.add_weapon(energy_sword,                force) end
      if temp_num0 == 13 then current_player.biped.add_weapon(fuel_rod_gun,                force) end
      if temp_num0 == 14 then current_player.biped.add_weapon(gravity_hammer,              force) end
      if temp_num0 == 15 then current_player.biped.add_weapon(focus_rifle,                 force) end
      if temp_num0 == 16 then current_player.biped.add_weapon(needle_rifle,                force) end
      if temp_num0 == 17 then current_player.biped.add_weapon(needler,                     force) end
      if temp_num0 == 18 then current_player.biped.add_weapon(plasma_launcher,             force) end
      if temp_num0 == 19 then current_player.biped.add_weapon(plasma_pistol,               force) end
      if temp_num0 == 20 then current_player.biped.add_weapon(plasma_repeater,             force) end
      if temp_num0 == 21 then current_player.biped.add_weapon(plasma_rifle,                force) end
      if temp_num0 == 22 then current_player.biped.add_weapon(spiker,                      force) end
      if temp_num0 == 23 then current_player.biped.add_weapon(detached_plasma_cannon,      force) end
   end
   script_widget[2].set_text("PULLING WEAPONS FROM ARMORY")
   script_widget[2].set_meter_params(timer, local_player.armory_cycle_timer)
   for each player do
      script_widget[2].set_visibility(current_player, false)
      current_player.armory_cycle_timer.set_rate(100%)
      if current_player.team == SPARTANS then
         for each object with label "frig_armory" do
            if current_object.shape_contains(current_player.biped) then
               script_widget[2].set_visibility(current_player, true)
               current_player.armory_cycle_timer.set_rate(-100%)
               if current_player.armory_cycle_timer.is_zero() then
                  current_player.armory_cycle_timer.reset()
                  current_player.biped.remove_weapon(secondary, true)
                  current_player.biped.remove_weapon(primary, true)
                  random_weapon()
                  random_weapon()
               end
            end
         end
      end
   end
   -- give visuals
   for each object with label "frig_armory" do
      current_object.set_waypoint_visibility(allies)
      current_object.set_waypoint_icon(supply_ammo)
      current_object.set_waypoint_range(0, 10)
      current_object.set_shape_visibility(allies)
   end
---
------------------
-- BANSHEE JUNK --
------------------
   ------------------------------
   -- INFECTED PLAYER SPAWNING --
   ------------------------------
      for each player do
         if current_player.team == ELITES then
            temp_obj0 = current_player.biped
            if temp_obj0 != no_object and not temp_obj0.is_of_type(monitor) then
               if temp_obj0.has_init == 0 then 
                  temp_obj0.has_init = 1
                  -- find valid frigate (NOTE: this will only work when theres 2 frigates)
                  temp_obj0 = get_random_object("frig_origin", no_object)
                  if temp_obj0.frig_gravity_obj != no_object then
                     temp_obj0 = get_random_object("frig_origin", temp_obj0)
                     if temp_obj0.frig_gravity_obj != no_object then
                        temp_obj0 = no_object
                     end
                  end
                  if temp_obj0 == no_object then
                     game.show_message_to(current_player, none, "no frigates available for spawning!!! game must be ending...")
                  end
                  if temp_obj0 != no_object then
                     -- generate a random point out infront of it
                     temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0)
                     temp_obj1.copy_rotation_from(temp_obj0, true)
                     temp_obj2 = temp_obj0.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
                     temp_obj2.attach_to(temp_obj1, 100, 0,0,relative)
                     temp_num1 = 1700
                     temp_obj1.set_scale(temp_num1)
                     temp_obj1.copy_rotation_from(temp_obj1, true)

                     -- check to make sure our banshee is going to spawn far enough away from all the frigates!!!
                     -- NOTE: this should be recursive but it isn't because we only actually need to do this for 1 other frigate
                     for each object with label "frig_origin" do
                        if temp_obj0 != current_object and current_object.frig_gravity_obj == no_object then
                           temp_obj3 = temp_obj2.place_between_me_and(temp_obj2, sound_emitter_alarm_2, 0)
                           temp_num0 = current_object.get_distance_to(temp_obj3)
                           if temp_num0 <= 850 then
                              temp_obj1.set_scale(2400)
                              temp_obj1.copy_rotation_from(temp_obj1, true)
                              game.show_message_to(current_player, none, "spawn blocked! spawning further back!!!")
                           end
                           temp_obj3.delete()
                        end
                     end


                     --temp_obj1.face_toward(temp_obj0.frig_mover_step, 0,0,0)
                     --temp_obj1.face_toward(temp_obj1, -1,0,0)
                     -- randomize direction
                     rotate_random() -- rotates temp_obj1
                     -- spawn banshee at the random point
                     temp_obj2 = temp_obj2.place_at_me(banshee, none, none, 0,0,0,none)
                     temp_obj2.set_invincibility(1)
                     --temp_obj2.copy_rotation_from(temp_obj0, true)
                     temp_obj2.face_toward(temp_obj0, 0,0,0)
                     current_player.force_into_vehicle(temp_obj2)
                     temp_obj1.delete()
                  end
               end
            end
         end
      end
   ---
   -----------------------------------------------
   -- PREVENT BANSHEE EXIT FROM KILLING PLAYERS -- + debuff banshee damage
   -----------------------------------------------
      do
         script_widget[3].set_text("DAMAGE DEBUFF - BANSHEES ARE WEAK")
      end
      for each player do
         script_widget[3].set_visibility(current_player, false)
         current_player.exit_vehicle_timer.set_rate(-100%)
         if current_player.biped != no_object and not current_player.biped.is_of_type(monitor) then
            temp_obj1 = current_player.biped



            -- if we left our vehicle and it blew up, then kill player too
            if temp_obj1.last_vehicle != no_object then --and temp_obj0 == no_object then
               temp_num0 = temp_obj1.last_vehicle.health
               if temp_num0 <= 0 then
                  current_player.biped.set_invincibility(0)
                  current_player.biped.kill(false)
                  game.show_message_to(all_players, none, "DEBUG: player vehicle destroyed!! not exited")
               end
            end
            -- debuff vehicle damage traits + store last vehicle state
            temp_obj1.last_vehicle = current_player.get_vehicle()
            if temp_obj1.last_vehicle != no_object then
               script_widget[3].set_visibility(current_player, true)
               current_player.exit_vehicle_timer.reset()
            end
            -- apply the vehicle exit safety traits
            if not current_player.exit_vehicle_timer.is_zero() then
               current_player.apply_traits(script_traits[2])
            end
         end
      end
   ---
---
----------------------------------
-- SURVIVOR OUT OF BOUNDS STUFF --
----------------------------------
   script_widget[1].set_text("RETURN TO BATTLEFIELD %n", local_player.out_of_bounds_timer)
   script_widget[1].set_meter_params(timer, local_player.out_of_bounds_timer)
   for each player do
      script_widget[1].set_visibility(current_player, false)
      current_player.out_of_bounds_timer.set_rate(100%)
      if current_player.team == SPARTANS and current_player.biped != no_object then
         if current_player.last_frigate == no_object then
            current_player.out_of_bounds_timer.set_rate(-100%)
            script_widget[1].set_visibility(current_player, true)
            if current_player.out_of_bounds_timer.is_zero() then
               current_player.biped.set_invincibility(0)
               current_player.biped.kill(false)
            end
         end
      end
   end
---
--------------------------------
-- KILL PLAYERS ON THE GROUND --
--------------------------------
   for each player do
      if current_player.biped != no_object and not current_player.biped.is_of_type(monitor) then
         player_check_for_ground()
         if ground_checker.offset.shape_contains(current_player.biped) then
            current_player.biped.set_invincibility(0)
            current_player.biped.kill(false)
         end
      end
   end
---
-------------------------
-- OVERSHIELDS EFFECTS --
-------------------------
   -- spawn in overshield effects
   -- for each player do
   --    temp_obj0 = current_player.biped
   --    if temp_obj0 != no_object and not temp_obj0.is_of_type(monitor) then
   --       temp_num0 = temp_obj0.shields
   --       if temp_num0 > 100 and temp_obj0.bpd_OS_visual == no_object then
   --          -- setup shield
   --          temp_obj0.bpd_OS_visual = temp_obj0.place_at_me(safe_boundary, none, none, 0,0,0,none)
   --          temp_obj0.bpd_OS_visual.copy_rotation_from(temp_obj0.bpd_OS_socket, true)
   --          temp_obj0.bpd_OS_visual.attach_to(temp_obj0.bpd_OS_socket, 0,0,0,relative)
   --       end
   --       if temp_num0 <= 100 and temp_obj0.bpd_OS_visual != no_object then
   --          temp_obj0.bpd_OS_visual.delete()
   --       end
   --    end
   -- end
   -- -- setup our overshield visuals socket for newly spawned players
   -- for each player do 
   --    temp_obj1 = current_player.biped
   --    -- if biped not init, then make it do the init thing!!
   --    if temp_obj1 != no_object and not temp_obj1.is_of_type(monitor) and temp_obj1.bpd_init == 0 then -- and temp_obj1.is_of_type(spartan) or temp_obj1.is_of_type(elite) then
   --       temp_obj1.bpd_init = 1
   --       if temp_obj1.is_of_type(spartan) then
   --          -- setup attach shield marker
   --          temp_obj2 = temp_obj1.place_between_me_and(temp_obj1, sound_emitter_alarm_2, 0)
   --          temp_obj1.bpd_OS_socket = temp_obj2.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   --          temp_obj1.bpd_OS_socket.face_toward(temp_obj1.bpd_OS_socket, 0,-1,0)

   --          temp_obj2.attach_to(temp_obj1.bpd_OS_socket, 0,0,0, relative)
   --          temp_obj1.bpd_OS_socket.copy_rotation_from(temp_obj1, true)
   --          -- then rotate the pitch marker
   --          temp_obj2.detach()
   --          temp_obj1.bpd_OS_socket.attach_to(temp_obj2, 0,0,0,relative)
      
   --          temp_obj2.face_toward(temp_obj2, 5,2,0)
   --          -- then do the yaw one again (we can do this before but the order wont squeeze us out any more actions)
   --          temp_obj1.bpd_OS_socket.detach()
   --          temp_obj1.bpd_OS_socket.face_toward(temp_obj1.bpd_OS_socket, 0,1,0)
   --          -- then slap it on our guy, done!!
   --          temp_obj1.bpd_OS_socket.attach_to(temp_obj1, 1,2,4,relative)
   --          temp_obj2.delete()
   --       end
   --    end
   -- end
---
--------------------------------
-- GIVE PLAYERS SOME SPLASERS --
--------------------------------
   for each player randomly do
      if current_player.team == SPARTANS and global_ticker > 690 then
         temp_obj0 = current_player.biped
         if temp_obj0 != no_object and not temp_obj0.is_of_type(monitor) then
            if temp_obj0.has_init == 0 then 
               temp_obj0.has_init = 1
               if splasers_given_out < 2 then 
                  splasers_given_out += 1
                  current_player.biped.remove_weapon(primary, true)
                  current_player.biped.add_weapon(spartan_laser, force)
               end
            end
         end
      end
   end
---


on object death: do
   ----------------------------------
   -- OUT OF BOUNDS MONITOR THINGO --
   ----------------------------------
      for each player do
         --if killed_object == current_player.biped then
         --   game.show_message_to(current_player, none, "died at tick %n", current_player.invincibilityTick)
         --end
         if killed_object == current_player.monitor_biped then
            current_player.synced = 1
            killed_object.delete()
            current_player.invincibilityTick = 0
         end
      end
   ---
   ---------------------------------
   -- FRIGATE WEAKPOINT DESTROYED --
   ---------------------------------
      if killed_object.has_forge_label("frig_damage") then
         if killer_player.team == SPARTANS then
            game.show_message_to(all_players, boneyard_generator_power_down, "%p betrayed a weakpoint", killer_player)
            killer_player.biped.set_invincibility(0)
            killer_player.biped.kill(false)
         end
         if killer_player.team == ELITES then
            game.show_message_to(all_players, boneyard_generator_power_down, "%p destroyed a weakpoint", killer_player)
         end
      end
   ---
end
on local: do
   -----------------------------
   -- SMOOTH FRIGATE ROTATION --
   -----------------------------
      for each object with label "frig_origin" do
         if current_object.frig_direction_obj != no_object and current_object.frig_mover != no_object then
            current_object.detach()
            current_object.face_toward(current_object.frig_direction_obj,0,0,0)
            current_object.attach_to(current_object.frig_mover, 0,0,0,relative)
         end
      end
   ---
   -------------------------
   -- LOCAL PLAYER FINDER --
   -------------------------
      if global_ticker <= 0 then
         for each player do
            if local_player_ == no_player and current_player.biped != no_object then
               if current_player.local_finder == no_object then
                  current_player.local_finder = current_player.biped.place_at_me(monitor, none, suppress_effect, 0, 0, 8, none)
                  current_player.local_finder.set_invincibility(1)
                  current_player.local_finder.set_scale(1100)
               end
               --temp_obj0 = current_player.get_vehicle()
               --if temp_obj0 == no_object then
                  current_player.local_finder.attach_to(current_player.biped, 20,0,0,relative)
                  current_player.local_finder.detach()
               --end
               temp_obj0 = current_player.get_crosshair_target()
               if temp_obj0 != no_object then
                  local_player_ = current_player
                  for each player do
                     current_player.local_finder.delete()
                  end
               end
            end
         end
      end
   ---
   -----------------------------------------
   -- FRIGATE COLLISION & CASCADE PHYSICS --
   -----------------------------------------
      temp_num3 = global_ticker
      temp_num3 %= 2
      if temp_num3 == 0 then
         ---------------------
         -- CASCADE PHYSICS --
         ---------------------
            for each player do
               if current_player.biped != no_object then
                  -- only run cargo physics for local player unless this machine is the host
                  if current_player == local_player_ or global_ticker > 0 then
                     temp_obj4 = current_player.last_frigate
                     -- cargo physics root detection system while either no root or while root is moving normally
                     if temp_obj4 == no_object or temp_obj4.frig_mover != no_object then
                        temp_obj4 = no_object
                        temp_num4 = 32000
                        temp_obj5 = current_player.last_frigate -- doody as code, this will be someone elses problem to deal with
                        -- we need to see if theres a closer frigate to cascade on???
                        for each object with label "frig_origin" do
                           -- if we aren't currently on a frigate, then we can be caught by a crashing frigate, otherwise we dont want to be caught by crashing frigates while on a non-crashing one
                           if current_player.last_frigate == no_object or current_object.frig_mover != no_object then
                              if current_object.shape_contains(current_player.biped) then
                                 temp_num3 = current_player.biped.get_distance_to(current_object)
                                 if temp_num3 < temp_num4 then
                                    temp_obj4 = current_object
                                    temp_num4 = temp_num3
                                 end
                              end
                           end
                        end
                     end
                     -- cargo physics root detection if we're on a crashing frigate (we're only released when we exit the boundary)
                     if temp_obj4 != no_object and temp_obj4.frig_mover == no_object then
                        if not temp_obj4.shape_contains(current_player.biped) then
                           temp_obj4 = no_object
                        end
                     end

                     -- cleanup last relative marker if last_frigate has changed
                     if current_player.last_frigate != temp_obj4 then
                        current_player.relative_pos.delete() -- we delete the last relative position if we swap frigates
                        current_player.last_frigate = temp_obj4
                        --game.show_message_to(current_player, none, "cascade physics root changed!")
                     end
                     -- then perform cascade
                     if temp_obj4 != no_object then
                        temp_obj5 = current_player.get_vehicle()
                        if temp_obj5 == no_object then --or temp_obj5.has_forge_label("frig_attach") then
                           temp_obj5 = current_player.biped
                        end
                        if current_player.global_pos == no_object then
                           current_player.global_pos = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
                           current_player.global_pos.set_hidden(false)
                        end
                        -- check if player already has an offset ready to go
                        if current_player.relative_pos != no_object then
                           -- first we generate our offset attach for the difference between our player and where they were last cargo tick
                           src = current_player.global_pos
                           dst = temp_obj5
                           cascade()
                           temp_obj3 = src
                           -- then we stick that offset to our stored relative position, so the foot of temp_obj3 is our new relative position
                           temp_obj0 = current_player.relative_pos
                           temp_obj3.attach_to(temp_obj0.foot, 0,0,0, relative)
                           
                           -- then we create a new offset attach from the player to the new relative position
                           src = temp_obj5
                           dst = temp_obj3.foot
                           cascade()
                           -- attach the offset to the player (its already at the player, just not attached)
                           src.attach_to(temp_obj5, 0,0,0, relative)
                           temp_obj5.attach_to(src.foot, 0,0,0, relative) -- complete the offset by attaching the player to the foot of this, automaticallly detaching them & maintaining momentumn

                           -- cleanup
                           src.delete()
                           temp_obj3.delete()
                           current_player.relative_pos.delete()
                        end
                        -- update previous position
                        current_player.global_pos.attach_to(temp_obj5, 0,0,0, relative)
                        current_player.global_pos.detach()
                        -- generate current relative position
                        src = temp_obj4
                        dst = temp_obj5
                        cascade()
                        src.attach_to(temp_obj4, 0,0,0, relative)
                        current_player.relative_pos = src
                     end
                  end
               end
            end
         ---
         --------------------------------
         -- OFFSET ATTACEHED COLLISION --
         --------------------------------
            if local_player_ != no_player then
               if global_ticker <= -60 then -- non-hosts -- idk why we have this delay???
             --if global_ticker > 1000 then -- hosts
                  for each object with label "frig_attach" do
                     if current_object.offset != no_object then
                        current_object.copy_rotation_from(current_object.offset, true)
                        current_object.attach_to(current_object.offset, 0,0,0,relative)
                        if current_object.parent_frig == local_player_.last_frigate and local_player_.last_frigate != no_object then
                           current_object.detach()
                        end
                     end
                  end
                  -- if local_player_.last_frigate != no_object then
                  --    for each object with label "frig_attach" do
                  --        and current_object.offset != no_object then
                  --       end
                  --    end
                  -- end
               end
            end
         ---
      end
   ---
   ------------------------------
   -- MAKE OVERSHIELDS VISIBLE --
   ------------------------------
      -- for each object with label 6 do
      --    if current_object.team == no_team then
      --       current_object.set_hidden(false)
      --       if global_ticker > 0 then -- just so we can keep this in one place
      --          current_object.set_scale(80)
      --          current_object.set_shape(none)
      --       end
      --    end
      -- end
   ---
   ---------------------
   -- NON HOST TICKER --
   ---------------------
      if global_ticker <= 0 then
         global_ticker -= 1
      end
   ---
   --------------------------
   -- DEBUG OBJECT COUNTER --
   --------------------------
      object_count = 0
      for each object do
         object_count += 1
      end
   ---
end

------------------------
-- INFECTION GAMEMODE --
------------------------
   -------------------------
   -- ANNOUNCE GAME START --
   -------------------------
      for each player do
         current_player.init_ticks += 1
         if current_player.init_ticks == 300 then 
            send_incident(infection_game_start, current_player, no_player)
         end
         -- annouce EPIC creators
         if current_player.init_ticks == 630 then 
            game.show_message_to(current_player, none, "EPIC moddy by Gamergotten (now this is epic)")
         end
         if current_player.init_ticks == 660 then 
            game.show_message_to(current_player, none, "EPIC out of bounds stuff by Sopitive, Weesee & Cantaloupe0")
         end
         -- then announce EPIC people
         if current_player.init_ticks == 720 then 
            game.show_message_to(current_player, none, "EPIC person: WeapoNate")
         end
         if current_player.init_ticks == 780 then 
            game.show_message_to(current_player, none, "EPIC person: Mr Dr Milk")
         end
      end
   ---
   -------------------------
   -- INFECT LATE JOINERS --
   -------------------------
      for each player do
         -- if a player has been in the game for less than 1 second and the game has been ticking for at least 30 seconds, auto infect them
         if current_player.init_ticks <= 60 and global_ticker > 1800 then
            current_player.is_infected = 1
         end
      end
   ---
   ------------------------------------
   -- APPLY INFECTED/SURVIVOR TRAITS --
   ------------------------------------
      for each player do
         if current_player.is_infected == 0 then 
            current_player.team = SPARTANS
            current_player.set_loadout_palette(spartan_tier_1)
            current_player.set_objective_text("Defend yourself from the zombie horde!")
         end
         if current_player.is_infected == 1 then 
            current_player.apply_traits(script_traits[0])
            current_player.set_loadout_palette(elite_tier_1)
            current_player.set_objective_text("Braaaaaains...")
            if current_player.is_infected == 1 and current_player.team != ELITES then 
               current_player.team = ELITES
               send_incident(inf_new_zombie, current_player, no_player)
               current_player.biped.kill(true)
            end
         end
      end
   ---
   ---------------------------
   -- RANDOMLY PICK ZOMBIES --
   ---------------------------
      do
         temp_num0 = 0
         temp_num1 = -1
      end
      for each player do
         temp_num1 += 1
         if current_player.is_infected == 1 then 
            temp_num0 += 1
         end
      end
      for each player randomly do
         if temp_num0 < 2 and temp_num0 < temp_num1 and current_player.is_infected != 1 then 
            current_player.is_infected = 1
            temp_num0 += 1
         end
      end
   --
   --------------------------
   -- HANDLE PLAYER DEATHS --
   --------------------------
      for each player do
         if current_player.killer_type_is(guardians | suicide | kill) and not current_player.biped.is_of_type(monitor) and current_player.init_ticks > 660 then 
            temp_player0 = current_player.try_get_killer()
            if current_player.killer_type_is(kill) and temp_player0 != no_player then
               temp_player0.score += 1
               if current_player.is_infected == 1 and temp_player0.is_infected == 0 then 
                  send_incident(zombie_kill_kill, temp_player0, current_player)
               end
               if current_player.is_infected == 0 then 
                  send_incident(inf_new_infection, temp_player0, current_player)
                  send_incident(infection_kill, temp_player0, current_player)
               end
            end
            current_player.is_infected = 1
         end
      end
   ---
   -----------------------
   -- GAME ENDING LOGIC --
   -----------------------
      players_left = 0
      for each player do
         if current_player.is_infected == 0 then 
            players_left += 1
         end
      end
      if players_left == 0 then 
         send_incident(infection_zombie_win, all_players, all_players)
         for each player do
            current_player.biped.set_invincibility(1)
         end
         game.end_round()
      end
      for each player do
         current_player.biped.set_waypoint_icon(none)
      end
      if game.round_timer.is_zero() and game.round_time_limit > 0 and players_left > 0 then 
         send_incident(infection_survivor_win, all_players, all_players)
         for each player do
            current_player.biped.set_invincibility(1)
         end
         game.end_round()
      end
      script_widget[0].set_value_text("Survivors: %n\r\n(objects: %n)", players_left, object_count)
      for each player do
         script_widget[0].set_visibility(current_player, true)
      end
      
   ---
   -----------------------------
   -- LAST MAN STANDING LOGIC --
   -----------------------------
      if players_left == 1 then 
         for each player do
            if current_player.is_infected == 0 then 
               current_player.apply_traits(script_traits[1])
               current_player.biped.set_waypoint_icon(skull)
               if current_player.is_last_man_standing == 0 then
                  send_incident(inf_last_man, current_player, all_players)
                  current_player.is_last_man_standing = 1
               end
            end
         end
      end
   ---
---