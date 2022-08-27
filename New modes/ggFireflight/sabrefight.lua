
declare global.number[0] with network priority local -- temp number also host indicator
declare global.number[1] with network priority local
declare global.number[2] with network priority local 
declare global.number[3] with network priority local

declare global.number[4] with network priority local
alias client_corrections = global.number[4]

declare global.number[5] with network priority high -- wave count
declare global.number[6] with network priority local -- wave confirmed count, ups once no thingos left; new wave counter
declare global.number[7] with network priority local = 1 -- is intermission
declare global.number[8] with network priority high -- bad guys counter

declare global.number[9] with network priority local -- difficulty damage boost
declare global.number[10] with network priority local -- difficulty heavy shot speed
declare global.number[11] with network priority high -- difficulty set count

declare global.object[0] with network priority local
declare global.object[1] with network priority local
declare global.object[2] with network priority local
declare global.object[3] with network priority local 
declare global.object[5] with network priority local 
declare global.object[6] with network priority local 
declare global.object[9] with network priority local 

declare global.object[7] with network priority local -- pos tracker
declare global.object[8] with network priority local -- prev pos tracker
declare global.object[4] with network priority local -- global.ground_obj // we could swap this for a global number tbh
declare global.object[10] with network priority high -- game extra info object


declare global.player[0] with network priority local
declare global.player[1] with network priority local -- local player

declare global.timer[0] = 15 -- new wave spawn timer
declare global.timer[1] = 11
declare global.timer[2] = 18 -- reinforcements timer

declare object.player[0] with network priority high -- vehicle target

declare object.number[0] with network priority local -- also spawner ai left to spawn -- also biped consecutive kills

declare object.number[2] with network priority local -- special attack ticks
declare object.number[3] with network priority local -- face_toward interval ticks
declare object.number[4] with network priority local -- shoots fired in a row
declare object.number[5] with network priority local -- rotation horizontal ticks
declare object.number[6] with network priority local -- rotation verticle ticks
declare object.number[7] with network priority high -- i forgot which numbers i've used, phantom.is_in_use, also game.lives_left

declare object.object[0] with network priority high
declare object.object[1] with network priority local -- also using this as static pitch rotation for AI evasion
declare object.object[2] with network priority high
declare object.object[3] with network priority local -- player.biped.local_test_obj

declare object.timer[0] = 5
declare object.timer[1] = 1
declare object.timer[2] = 100 -- vehicle health bar
declare object.timer[3] = 1 -- AI spawner timer delay

declare player.number[0] with network priority local
declare player.number[1] with network priority local
declare player.number[2] with network priority low
declare player.number[3] with network priority local
declare player.number[4] with network priority local -- consecutive kill count
declare player.number[5] with network priority local -- player.has_initialized

declare player.number[6] with network priority local -- player.has_used_inital_life
declare player.number[7] with network priority local -- player.is_spectating

declare player.timer[0] = 5


declare player.timer[2] = 1 -- spectator abil attempt_give_AA timer
declare player.timer[3] = 1 -- spectator abil disabled timer


-- CONSTANTS
alias AI_max_firing_range = script_option[8] -- 1925
alias AI_face_towards_interval = 7

alias PROJ_max_life_ticks = script_option[9] -- 400

alias SPAWNER_min_active = 2
alias SPAWNER_max_active = 6
alias SPAWNER_spawn_count = 5

-- ALIASES
alias temp_num0 = global.number[0]
alias temp_num1 = global.number[1]
alias temp_num2 = global.number[2]
alias temp_num3 = global.number[3]

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias temp_obj3 = global.object[3]
alias temp_obj4 = global.object[5]
alias temp_obj5 = global.object[6]
alias temp_obj6 = global.object[9]

alias pos_tracker = global.object[7]
alias prev_pos_tracker = global.object[8]

alias host_existance_check = global.timer[1]

alias local_player = global.player[1]

alias tick_distance = player.number[0] 
alias last_tick_distance = player.number[1] 

alias host_indicator = temp_num0

alias local_test_obj = object.object[3] 

-- initialize players thing
for each player do
   if current_player.number[5] < 300 then
      current_player.number[5] += 1
      if current_player.number[5] >= 300 then -- signal game started
         send_incident(dogfight_game_start, current_player, no_player)
         current_player.set_round_card_title("Welcome to Reach Spartan\r\nObjective: Suvive.\r\nBy Gamergotten")
      end
   end
end



-- kill invinc players function
function trigger_0()
   temp_obj0.object[2].delete()
   temp_obj0.object[1].delete()
   temp_obj0.object[0].set_invincibility(0)
   temp_obj0.object[0].kill(false)
   temp_obj0.set_invincibility(0)
   temp_obj0.kill(false)
end


if global.object[10] == no_object then
   global.object[10] = get_random_object("S_Ground", no_object)
   global.object[10].number[0] = script_option[4] -- starting lives
end
-- player registration script
for each player do
   if current_player.number[2] == 0 then
      if global.object[10].shape_contains(current_player.biped) then
         current_player.number[2] = 1
      end
   end
end

-- //// INPUTS ////
alias self = temp_obj6
function random_face_toward()
	temp_num0 = rand(12)
	if temp_num0 == 0 then -- 30 
		self.face_toward(self, 97, 56,0)
	end
	if temp_num0 == 1 then -- 60
		self.face_toward(self, 56, 97,0)
	end
	if temp_num0 == 2 then -- 90
		self.face_toward(self, 0, 1,0)
	end
	if temp_num0 == 3 then -- 120
		self.face_toward(self, -56, 97,0)
	end
	if temp_num0 == 4 then -- 150
		self.face_toward(self, -97, 56,0)
	end
	if temp_num0 == 5 then -- 180
		self.face_toward(self, -1, 0,0)
	end
	if temp_num0 == 6 then -- 15
		self.face_toward(self, 56, 15,0)
	end
	if temp_num0 == 7 then -- 45
		self.face_toward(self, 70, 70,0)
	end
	if temp_num0 == 8 then -- 75
		self.face_toward(self, 15, 56,0)
	end
	if temp_num0 == 9 then -- 105
		self.face_toward(self, -15, 56,0)
	end
	if temp_num0 == 10 then -- 135
		self.face_toward(self, -70, 70,0)
	end
	if temp_num0 == 11 then -- 165
		self.face_toward(self, -56, 15,0)
	end
end
-- player "spawning" script
-- biped.object[0] == our current vehicle
-- biped.object[1] == our vehicles bullet sponge holder
-- biped.object[2] == our vehicles bullet sponge object (as in the vehicle)
-- biped.object[3] == our AA we dropped for us as a spectator
for each player do
   temp_obj0 = current_player.biped
   temp_obj0.set_invincibility(1)
   if temp_obj0 != no_object and current_player.number[2] == 1 then 
      if temp_obj0.object[0] == no_object and global.object[10].number[0] == 0 and current_player.number[6] == 1 and not current_player.biped.is_of_type(monitor) then -- if not in a sabre & there are no spare lives & ahs already initially spawned
         -- turn them into a monitor
         temp_obj1 = current_player.biped.place_at_me(monitor, none, none, 0,0,0, none)
         temp_obj1.add_weapon(spartan_laser, force)
         current_player.set_biped(temp_obj1)
         temp_obj0.delete()
         temp_obj0 = temp_obj1
         -- 
         current_player.number[7] = 1
      end
      if current_player.number[7] == 1 then -- is no lives & spectating
         current_player.apply_traits(script_traits[4])
         current_player.timer[2].set_rate(-100%) -- try give aa timer
         current_player.timer[3].set_rate(-100%) -- AA cooldown timer
         if not current_player.timer[3].is_zero() then -- disable traits
            current_player.apply_traits(script_traits[5])
         end
         if current_player.timer[3].is_zero() then -- disable traits
            temp_obj2 = current_player.get_armor_ability()
            if temp_obj2 == no_object and current_player.timer[2].is_zero() then -- give them a new armor ability to pick up
               if temp_obj0.object[3] != no_object then -- if we already tried that, give them a new one
                  temp_obj0.object[3].delete()
               end
               temp_obj0.object[3] = temp_obj0.place_between_me_and(temp_obj0, active_camo_aa, 0)
               current_player.timer[2].reset()
               game.show_message_to(current_player, none, "Use your armor ability to jump back into the fight!")
            end
            if temp_obj2.is_in_use() then
               current_player.timer[3].reset()
               temp_obj6 = no_object
               for each player randomly do
                  temp_obj5 = current_player.biped
                  if current_player.number[7] == 0 and temp_obj5.object[0] != no_object and temp_obj6 == no_object then -- is this a reasonable player to spectate?
                     temp_obj6 = temp_obj5.object[0]
                  end
               end
               if temp_obj6 != no_object then
                  current_player.biped.detach()
                  current_player.biped.attach_to(temp_obj6, 5, 0, -10, relative)
               end
            end
         end
      end
      if temp_obj0.object[0] == no_object and global.object[10].number[0] != 0 or current_player.number[6] == 0 then -- if there are lives left, or unlimited lives
         if global.object[10].number[0] > 0 and current_player.number[6] == 1 then
            global.object[10].number[0] -= 1 -- reduce number of active lives
            if global.object[10].number[0] == 0 then
               game.show_message_to(all_players, none, "No lives remaining")
            end
            if global.object[10].number[0] == 1 then
               game.show_message_to(all_players, none, "1 life remaining")
            end
            if global.object[10].number[0] == 2 then
               game.show_message_to(all_players, none, "2 lives remaining")
            end
            if global.object[10].number[0] == 3 then
               game.show_message_to(all_players, none, "3 lives remaining")
            end
            if global.object[10].number[0] == 5 then
               game.show_message_to(all_players, none, "5 lives remaining")
            end
         end
         if current_player.number[6] == 0 then
            current_player.number[6] = 1 -- they get one free life, that allows them to spawn initially
         end
         current_player.number[7] = 0
         temp_obj1 = get_random_object("S_Spawn", no_object)
         -- real vehi
         if script_option[0] == 0 then
            temp_obj1 = temp_obj1.place_at_me(sabre, none, none, 0, 0, 0, none)
         end
         if script_option[0] == 1 then
            temp_obj1 = temp_obj1.place_at_me(falcon, none, none, 0, 0, 0, none)
         end
         temp_obj0.object[0] = temp_obj1
         temp_obj1.team = current_player.team
         temp_obj1.set_invincibility(1)
         temp_obj1.set_scale(100)
         temp_obj0.object[1] = temp_obj1.place_at_me(flag_stand, none, none, 0, 0, 0, none)
         temp_obj0.object[1].copy_rotation_from(temp_obj1, true)
         -- damage sponge vehi
         if script_option[0] == 0 then
            temp_obj0.object[2] = temp_obj1.place_at_me(sabre, none, none, 0, 0, 0, none)
            if script_option[2] == 0 then
               temp_obj0.object[2].set_scale(1)
            end
            if script_option[2] == 1 then
               temp_obj0.object[2].set_scale(140)
            end
            temp_obj0.object[2].copy_rotation_from(temp_obj1, true)
            temp_obj0.object[2].attach_to(temp_obj0.object[1], 0, 0, 0, relative)
         end
         if script_option[0] == 1 then
            temp_obj0.object[2] = temp_obj1.place_at_me(falcon, none, none, 0, 0, 0, none)
            if script_option[2] == 0 then
               temp_obj0.object[2].set_scale(1)
            end
            if script_option[2] == 1 then
               temp_obj0.object[2].set_scale(140)
            end
            temp_obj0.object[2].copy_rotation_from(temp_obj1, true)
            temp_obj0.object[2].attach_to(temp_obj0.object[1], -4, 0, -2, relative)
         end
      end
      if temp_obj0.object[0] != no_object then 
         if temp_obj0.object[1] != no_object then 
            temp_obj0.object[1].attach_to(temp_obj0.object[0], 0, 0, 0, relative)
            temp_obj0.object[1].detach()
            temp_obj0.object[1].copy_rotation_from(temp_obj0.object[0], true)
         end
         if temp_obj0.object[2] != no_object then 
            temp_obj1 = temp_obj0.object[0]
            temp_obj2 = temp_obj0.object[2]
            temp_obj6 = temp_obj0.object[1]

            temp_obj6.set_progress_bar(2, mod_player, current_player, 1)
            temp_obj6.set_shape(sphere, 85)

            temp_num1 = temp_obj2.shields
            temp_obj1.shields = temp_num1

            temp_num0 = temp_obj2.health
            temp_obj1.health = temp_num0
            -- visual health indicator
            temp_num0 += temp_num1
            temp_num0 /= 2
            temp_obj6.timer[2] = temp_num0

            if temp_num0 <= 0 then 
               trigger_0() -- explode
            end
         end
         if temp_obj0.object[1] == no_object then 
            game.show_message_to(all_players, none, "Sabre Sponge Base is missing!")
         end
         if temp_obj0.object[2] == no_object then 
            trigger_0() -- explode
         end
         temp_obj1 = no_object
         temp_obj1 = current_player.try_get_vehicle()
         if temp_obj1 != temp_obj0.object[0] then 
            current_player.force_into_vehicle(temp_obj0.object[0])
            game.show_message_to(all_players, none, "Test function message (we should make this blip everyone with a cooldown)")
         end
      end
   end
end

if global.object[10].number[0] == 0 then -- no spare lives 
   temp_num0 = 0
   for each player do -- can optimize into bitwise operation
      if current_player.number[7] == 0 then -- if they're not in spectator mode
         temp_num0 = 1
      end
   end
   if temp_num0 == 0 then
      game.show_message_to(all_players, none, "Objective status: failed")
      game.end_round()
   end
end

-- //// INPUTS ////
alias lookat_obj = temp_obj3
alias basis = temp_obj5
-- //// OUTPUTS ////
alias yaw_obj = temp_obj0
alias pitch_obj = temp_obj1
-- yaw_obj - create a new object at basis that looks at "lookat_obj" on both pitch and yaw
function basis_toward_lookat__return_yaw_pitch_obj()
   -- place pitch and yaw objects
   pitch_obj = basis.place_between_me_and(basis, hill_marker, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   yaw_obj.attach_to(basis, 0,0,0, relative)
   yaw_obj.detach()
   -- reorient yaw axis to how its supposed to be (-90 degrees rotation)
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
end
-- you will have to cleanup (delete pitch & yaw objects after you're done with them)

-- //// INPUTS ////
alias lookat_obj = temp_obj3
alias basis = temp_obj5
alias offset_scale = temp_num1
-- //// OUTPUTS ////
alias yaw_obj = temp_obj0
alias pitch_obj = temp_obj1
alias offset_obj = temp_obj2
-- yaw_obj - create a new object at basis that looks at "lookat_obj" on both pitch and yaw
-- then take a variable number offset_scale and create offset_obj at that distance forward from yaw_obj
function basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   basis_toward_lookat__return_yaw_pitch_obj() -- all the code is in here in the sibling function
   -- setup offset object & attach-offset it in the forward direction
   offset_obj = yaw_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
   offset_obj.copy_rotation_from(yaw_obj, true)
   offset_obj.attach_to(yaw_obj, 1,0,0, relative)
   -- convert our forge units to scale units
   offset_scale *= 100
   -- set scale of yaw obj, thus scaling the attachment offset of offset_obj
   yaw_obj.set_scale(offset_scale)
   yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
end
-- you will have to cleanup (delete pitch, yaw & offset objects after you're done with them)

function ai_lookat()
   --lookat_obj = current_object.object[2]
   --basis = current_object
   basis_toward_lookat__return_yaw_pitch_obj()
   basis.copy_rotation_from(yaw_obj, true)
   yaw_obj.delete()
   pitch_obj.delete()
end

do
   host_indicator = 1
   -- host_indicator is set to local priority, so it will be set to ❌ for clients
   host_existance_check.set_rate(-100%)
   if host_existance_check.is_zero() then
      -- this number is for debugging purposes, so we can tell whether we are running CGB logic, or local customs logic
      if local_player == no_player then
         host_indicator = 2
         script_widget[3].set_value_text("Dedicated Server ")
      end
   end
end
if local_player != no_player then
   script_widget[3].set_value_text("Locally Hosted ")
end

function ai_update_pos_on_clients()
   current_object.object[0].detach()
   current_object.object[0].attach_to(current_object.object[2], 0,0,0, relative)
   current_object.object[0].detach()

   current_object.detach()
   current_object.copy_rotation_from(current_object.object[2], true)
   current_object.attach_to(current_object.object[2], 0,0,0, relative)
end

on local: do
   -- skybox flipping script
   if script_option[7] == 1 and global.object[4] == no_object then -- can delete this to save a condition
      for each object do
         if global.object[4] == no_object then
            global.object[4] = current_object
            temp_obj0 = current_object.place_between_me_and(current_object, flag_stand, 0)
            global.object[4].attach_to(temp_obj0,0,0,0,relative)
            temp_obj0.face_toward(temp_obj0, -1,0,0)
            global.object[4].detach()
            temp_obj0.delete()
         end
      end
   end
   -- sabre visual scaling script, so clients don't have to see any of the goofy stuff we're doing behind the scenes
   if host_indicator == 0 then -- is not host
      for each player do
         temp_obj0 = current_player.biped
         if temp_obj0 != no_object then 
            if temp_obj0.object[0] != no_object then -- real sabre
               temp_obj0.object[0].set_scale(100)
            end
            if temp_obj0.object[2] != no_object then -- damage sponge sabre
               temp_obj0.object[2].set_scale(1)
            end
         end
      end
   end
   -- /////////////////////////////////
   -- // LOCAL PLAYER FINDING SCRIPT //
   -- /////////////////////////////////
   if local_player == no_player and host_indicator == 0 or not host_existance_check.is_zero() then 
      -- a bit complicated, but only run this code if: 
      -- 1. this machine has not found their local player yet
      -- 2. this machine is not the host, OR they are the host and it hasn't been ~10 seconds yet
      -- this is to prevent the CGB server host from having bipeds in front of clients the entire session
      for each player do  
         temp_obj4 = current_player.biped
         -- spawn and postion a crosshair triggering target
         if temp_obj4.local_test_obj == no_object then 
            if host_indicator == 1 then 
               temp_obj4.local_test_obj = temp_obj4.place_at_me(spartan, "hosttarget", none, 0, 0, 0, none)
            end
            if host_indicator == 0 then 
               temp_obj4.local_test_obj = temp_obj4.place_at_me(spartan, "clienttarget", none, 0, 0, 0, none)
            end
            temp_obj4.local_test_obj.set_scale(160)
            temp_obj4.local_test_obj.copy_rotation_from(temp_obj4.local_test_obj, true)
         end

         temp_obj4.local_test_obj.attach_to(temp_obj4, 5, 0, 0, relative)
         temp_obj4.local_test_obj.detach()
         -- this action is only capable of finding the crosshair target on the player that this machine currently owns
         temp_obj0 = current_player.get_crosshair_target()
         if temp_obj0 != no_object then 
            -- if an object was found, this means we found the player whos crosshair works, this player can ONLY be the one that is us
            local_player = current_player
         end
      end
   end
   -- run this cleanup seperate, as we want this to work with the CGB server as a host
   -- meaning we need it to cleanup the hosttargets regardless or not if it managed to find 
   if host_indicator > 0 and local_player != no_player or host_existance_check.is_zero() then 
      for each object with label "hosttarget" do
         current_object.delete()
      end
   end
   -- here we check to see if we've found the local player yet, host & clients
   if local_player != no_player then 
      -- clean up this clients targets if they found they self
      if host_indicator == 0 then
         for each object with label "clienttarget" do
            current_object.delete()
         end
         for each object with label "S_SeraphOBJ" do
            if current_object.object[2] != no_object then
               ai_update_pos_on_clients()
            end
         end
         for each object with label "S_SabreOBJ" do
            if current_object.object[2] != no_object then
               ai_update_pos_on_clients()
            end
         end
         -- for each object with label "S_BansheeOBJ" do
         --    if current_object.object[2] != no_object then
         --       ai_update_pos_on_clients()
         --    end
         -- end
         -- for each object with label "S_PhantomOBJ" do
         --    if current_object.object[2] != no_object then
         --       ai_update_pos_on_clients()
         --    end
         -- end
         -- for each object with label "S_PelicanOBJ" do
         --    if current_object.object[2] != no_object then
         --       ai_update_pos_on_clients()
         --    end
         -- end
      end

      temp_obj4 = local_player.get_vehicle()
      -- rubberbanding fix script -- only vehicles
      if host_indicator == 0 and local_player.number[2] == 1 and script_option[15] == 1 then -- is not host and is registered && and is using rubberbanding fix
         if temp_obj4 == no_object then
            if pos_tracker != no_object then
               pos_tracker.delete()
            end
            if prev_pos_tracker != no_object then
               prev_pos_tracker.delete()
            end
         end
         if temp_obj4 != no_object then
            temp_obj3 = temp_obj4.place_between_me_and(temp_obj4, hill_marker, 0)
            local_player.tick_distance = temp_obj3.get_distance_to(pos_tracker)
            temp_obj3.delete()
            if pos_tracker == no_object then
               pos_tracker = temp_obj4.place_between_me_and(temp_obj4, hill_marker, 0)
               local_player.tick_distance = 0
            end
            if prev_pos_tracker == no_object then
               prev_pos_tracker = pos_tracker.place_between_me_and(pos_tracker, hill_marker, 0)
            end
            if pos_tracker != no_object then
               if local_player.tick_distance > 35 then
                  alias extrapolated_dist_obj = temp_obj6
                  client_corrections += 1
                  -- calculate position of where the player should be
                  basis = prev_pos_tracker
                  lookat_obj = pos_tracker
                  offset_scale = prev_pos_tracker.get_distance_to(pos_tracker)
                  offset_scale += local_player.last_tick_distance -- this is so we extrapolate their distance, so they dont go slow when client postion overriding
                  basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
                  offset_obj.detach()
                  extrapolated_dist_obj = offset_obj.place_between_me_and(offset_obj, hill_marker, 0)
                  -- cleanup the objects
                  offset_obj.delete()
                  yaw_obj.delete()
                  pitch_obj.delete()
                  -- teleport player to the position we figured out above
                  -- do a quick placement to get the true distance
                  temp_obj3 = temp_obj4.place_between_me_and(temp_obj4, hill_marker, 0)
                  offset_scale = temp_obj3.get_distance_to(extrapolated_dist_obj)
                  temp_obj3.delete()
                  --
                  basis = temp_obj4
                  lookat_obj = extrapolated_dist_obj
                  basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
                  -- now attach to biped, then attach the biped to it, seamlessly teleporting the player to the object :)
                  yaw_obj.attach_to(basis, 0,0,0, relative)
                  basis.attach_to(offset_obj,0,0,0, relative)
                  -- cleanup the objects
                  offset_obj.delete()
                  yaw_obj.delete()
                  pitch_obj.delete()
                  -- cleanup our extrapolated position object too
                  extrapolated_dist_obj.delete()
               end
               if local_player.tick_distance <= 35 then
                  local_player.last_tick_distance = local_player.tick_distance
                  -- only do this within a valid movement
                  prev_pos_tracker.attach_to(pos_tracker, 0,0,0, relative)
                  prev_pos_tracker.detach()
               end
               pos_tracker.attach_to(temp_obj4, 0,0,0, relative)
               pos_tracker.detach()
            end
         end
      end
   end
end

function random_direction()
   -- set up the rotation stuff
	lookat_obj = current_object
	basis = current_object
	basis_toward_lookat__return_yaw_pitch_obj()
	-- offset global yaw axis
	yaw_obj.attach_to(pitch_obj, 0,0,0, relative) 
	self = pitch_obj
   random_face_toward()
   yaw_obj.detach()
	-- offset global pitch axis
	self = yaw_obj
   random_face_toward()
   game.show_message_to(all_players, none, "DEBUG AI evade")
   current_object.copy_rotation_from(yaw_obj, true)
   yaw_obj.delete()
   pitch_obj.delete()
end

function ai_evade()
   --random_direction() -- we're now using the interpolation evasion
   current_object.number[0] = 2
   current_object.timer[0].reset()
   temp_num0 = rand(4) -- somewhere between 1 and 5 seconds for their evade (so between 60 and 300 ticks)
   current_object.timer[0] -= temp_num0
   -- set rotation values
   temp_num0 = current_object.timer[0]
   temp_num0 *= 120 -- 60 ticks * chance to be negative
   current_object.number[5] = rand(temp_num0)
   current_object.number[6] = rand(temp_num0)
   -- make the number negative
   temp_num0 /= 2 -- finding the max cap
   current_object.number[5] -= temp_num0
   current_object.number[6] -= temp_num0
   current_object.number[6] /= 2 -- half verticle turning thingo
end

function distance_check_ai()
   if current_object != temp_obj0 and current_object.team != temp_obj0.team and current_object.number[0] != 0 then
      temp_num1 = temp_obj0.get_distance_to(current_object)
      if temp_num1 < temp_num0  and temp_num1 > 0 then
         temp_num0 = temp_num1
         temp_obj0.object[1] = current_object
      end
   end
end

function ai_target_finding()
   temp_num0 = 29999 -- max distance
   current_object.object[1] = no_object
   for each player do
      if current_player.biped != no_object and current_player.team != current_object.team then
         temp_num1 = current_object.get_distance_to(current_player.biped)
         if temp_num1 < temp_num0 and temp_num1 > 0 then
            temp_num0 = temp_num1
            current_object.object[1] = current_player.biped
         end
      end
   end
   -- consider other ai as potential targets
   temp_obj0 = current_object
   for each object with label "S_SabreOBJ" do
      distance_check_ai()
   end
   for each object with label "S_BansheeOBJ" do
      distance_check_ai()
   end
   for each object with label "S_SeraphOBJ" do
      distance_check_ai()
   end
   for each object with label "S_PhantomOBJ" do
      distance_check_ai()
   end
   for each object with label "S_PelicanOBJ" do
      distance_check_ai()
   end
end

function ai_attempt_fire()
   temp_num1 = current_object.get_distance_to(current_object.object[1])
   temp_num1 /= 10 -- this is so we can actually fit our range within the script option values
   if current_object.timer[1].is_zero() and temp_num1 < AI_max_firing_range and current_object.timer[2].is_zero() and current_object.number[2] >= 0 then -- ENGAGEMENT RANGE
      current_object.number[4] += 1
      if current_object.number[2] > 0 then
         current_object.timer[3].reset() -- has been not shooting for this long timer
         current_object.timer[1].reset() -- single shot cooldown
         if not current_object.is_of_type(sabre) and not current_object.has_forge_label("S_PelicanOBJ") then
            temp_obj0 = current_object.place_at_me(light_purple, "Active_Projectile", none, 0,0,0, none)
         end
         if current_object.is_of_type(sabre) or current_object.has_forge_label("S_PelicanOBJ") then
            temp_obj0 = current_object.place_at_me(light_red, "Active_Projectile", none, 0,0,0, none)
         end
         -- damage
         temp_obj0.number[2] = script_option[13] -- 15
         temp_obj0.set_scale(50)
      end
      if current_object.number[2] == 0 then
         current_object.number[2] = -1 -- this grants special and normal firing cooldown, normal firing is enabled once this number becomes positive
         if not current_object.is_of_type(sabre) and not current_object.has_forge_label("S_PelicanOBJ") then
            temp_obj0 = current_object.place_at_me(light_green, "Active_Projectile", none, 0,0,0, none)
         end
         if current_object.is_of_type(sabre) or current_object.has_forge_label("S_PelicanOBJ") then
            temp_obj0 = current_object.place_at_me(light_white, "Active_Projectile", none, 0,0,0, none)
         end
         -- target tracking
         temp_obj0.object[3] = current_object.object[1] -- target to track
         temp_obj0.number[3] = 85 -- 85 ticks for tracking
         -- damage
         temp_obj0.number[2] = script_option[14] -- 40
         temp_obj0.set_scale(65)
      end
      temp_obj0.copy_rotation_from(current_object, true) -- apply projectile scale

      temp_obj0.number[2] += global.number[9] -- apply set based damage boost

      temp_obj0.team = current_object.team -- make sure we know whos team this projectiles is
      -- if temp_obj0.team == team[0] then -- UNSC projectile
      --    temp_obj0.object[1] = current_object.place_between_me_and(current_object, bomb, 0)
      -- end
      -- if temp_obj0.team != team[0] then -- Covenant projectile
      --    temp_obj0.object[1] = current_object.place_between_me_and(current_object, covenant_bomb, 0)
      -- end
      temp_obj0.object[1] = current_object.place_between_me_and(current_object, flag_stand, 0)
      --temp_obj0.object[1].set_invincibility(1)
      --temp_obj0.object[1].set_scale(500)
      temp_obj0.object[1].copy_rotation_from(current_object, true)
      temp_obj0.attach_to(temp_obj0.object[1], 0,0,0, relative)
   end
end

-- object.object[0] is our client.fix_kungfu_obj -- only for sabres&seraphs
-- object.object[1] is our AI's target
-- object.object[2] is our all in one position assistant, also used to fix kungfu on clients
-- object.object[3] is our propane tank - only for banshees
--                  it is also our object shell for pelicans&phantoms
function ai()
	if current_object.number[0] == 1 then
      ai_target_finding()
      if current_object.object[1] == no_object then
         ai_evade()
      end
		if current_object.object[1] != no_object then
         -- multiply chance to evade by distance to nearest player
			temp_num1 = temp_num0 -- potentially uneeded
         temp_num1 /= 3 -- 1 outcomes per 3 forge units
         if current_object.has_forge_label("S_PhantomOBJ") or current_object.has_forge_label("S_PelicanOBJ") then -- phantoms will be more likely to evade
            temp_num1 /= 2
         end
         if temp_num1 <= 100 then
            temp_num1 /= 3 -- divide by another 3 if within 100 units of range
         end
         temp_num1 = rand(temp_num1)
			if temp_num1 == 0 then -- if returned 0, then they got that 1 in X chance to evade
            current_object.object[1] = no_object
            ai_evade()
			end
         if temp_num1 != 0 then -- then engage the target
            basis = current_object
            lookat_obj = current_object.object[1]

            current_object.number[3] += 1
            if current_object.number[3] > AI_face_towards_interval then
               current_object.number[3] = 0
               ai_lookat()
               if not current_object.has_forge_label("S_PhantomOBJ") and not current_object.has_forge_label("S_PelicanOBJ") then
                  ai_attempt_fire()
               end
            end
         end
		end
	end
	if current_object.number[0] == 2 then
      temp_obj0 = current_object.object[2]
      if temp_obj0 != no_object then
         if temp_obj0.object[1] == no_object then -- our pitch baked object
            -- place pitch and yaw objects
            temp_obj0.object[1] = current_object.place_between_me_and(current_object, hill_marker, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
            temp_obj0.object[2] = temp_obj0.object[1].place_at_me(hill_marker, none, none, 0,0,0, none)
            -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
            temp_obj0.object[2].attach_to(current_object, 0,0,0, relative)
            temp_obj0.object[2].detach()
            -- reorient yaw axis to how its supposed to be (-90 degrees rotation)
            temp_obj0.object[2].face_toward(temp_obj0.object[2],0,-1,0)
            -- rotate the pitch to be relative to our AI
            temp_obj0.object[1].attach_to(temp_obj0.object[2], 0,0,0, relative)
            temp_obj0.object[2].copy_rotation_from(current_object, true)
            temp_obj0.object[1].detach()
            temp_obj0.object[2].attach_to(temp_obj0.object[1], 0,0,0,relative)
            temp_obj0.object[1].attach_to(current_object, 0,0,0,relative)
         end
         -- interpolated rotation code
         if current_object.number[5] < 0 then -- negative yaw turn
            current_object.number[5] += 1
            current_object.face_toward(current_object, 127, -1, 0)
            if current_object.has_forge_label("S_SeraphOBJ") or current_object.has_forge_label("S_SabreOBJ") then
               current_object.face_toward(current_object, 127, -1, 0)
            end
         end
         if current_object.number[5] > 0 then -- positive yaw turn
            current_object.number[5] -= 1
            current_object.face_toward(current_object, 127, 1, 0)
            if current_object.has_forge_label("S_SeraphOBJ") or current_object.has_forge_label("S_SabreOBJ") then
               current_object.face_toward(current_object, 127, 1, 0)
            end
         end
         if current_object.number[6] < 0 then -- negative pitch turn
            current_object.number[6] += 1
            -- annoying code to get pitch working too
            temp_obj0.object[1].detach()
            temp_obj0.object[1].face_toward(temp_obj0.object[1], 127, -1, 0)
            if current_object.has_forge_label("S_SeraphOBJ") or current_object.has_forge_label("S_SabreOBJ") then
               temp_obj0.object[1].face_toward(temp_obj0.object[1], 127, -1, 0)
            end
            current_object.copy_rotation_from(temp_obj0.object[2], true)
            temp_obj0.object[1].attach_to(current_object, 0,0,0,relative)
         end
         if current_object.number[6] > 0 then -- positive pitch turn
            current_object.number[6] -= 1
            -- annoying code to get pitch working too
            temp_obj0.object[1].detach()
            temp_obj0.object[1].face_toward(temp_obj0.object[1], 127, 1, 0)
            if current_object.has_forge_label("S_SeraphOBJ") or current_object.has_forge_label("S_SabreOBJ") then
               temp_obj0.object[1].face_toward(temp_obj0.object[1], 127, 1, 0)
            end
            current_object.copy_rotation_from(temp_obj0.object[2], true)
            temp_obj0.object[1].attach_to(current_object, 0,0,0,relative)
         end
      end

		current_object.timer[0].set_rate(-100%)
		if current_object.timer[0].is_zero() then
			current_object.number[0] = 1
		end
	end
   if current_object.number[0] != 0 then
      current_object.timer[2].set_rate(-1000%)
      if current_object.number[2] != 0 then
         current_object.number[2] -= 1 -- special attack cooldown
      end
      if current_object.team != team[0] then -- covies are visible only when theres a few of them left
         if global.number[8] <= 7 then
            current_object.set_waypoint_visibility(everyone)
         end
         if global.number[8] > 7 then
            current_object.set_waypoint_visibility(no_one)
         end
      end
      if current_object.team == team[0] then -- sabres are visible always
         current_object.set_waypoint_visibility(everyone)
      end

      current_object.set_waypoint_priority(normal)
      current_object.set_waypoint_range(-1,-1)
      if current_object.object[0] == no_object then
         current_object.object[0] = current_object.place_at_me(plasma_cannon, "S_cleanup", none, 0,0,0, none)
         temp_obj6 = current_object.object[0]
         temp_obj6.object[0] = current_object -- set this so when parent is dead, cleanup
         temp_obj6.set_invincibility(1)
         temp_obj6.attach_to(current_object, 0,0,0,relative) -- stick it to vehicle on host, so it never gets in the way
      end
      if current_object.object[2] == no_object then
         current_object.object[2] = current_object.place_at_me(flag_stand, "S_cleanup", none, 0,0,0, none)
         temp_obj6 = current_object.object[2]
         temp_obj6.object[0] = current_object -- set this so when parent is dead, cleanup
      end
      -- banshee boosting mechanic
      if current_object.is_of_type(banshee) then
         current_object.timer[3].set_rate(-25%)
         if not current_object.timer[3].is_zero() and current_object.object[3] != no_object then
            current_object.object[3].delete()
         end
         if current_object.timer[3].is_zero() then -- ingage boost
            current_object.object[2].attach_to(current_object, 3,0,0, relative)
            current_object.attach_to(current_object.object[2], 0,0,0, relative)
            current_object.detach()
            current_object.object[2].detach()
         end
      end
      -- phantom/pelican movement and shooting 
      if current_object.has_forge_label("S_PhantomOBJ") or current_object.has_forge_label("S_PelicanOBJ") then -- attempt firing mechanic 
         -- apply custom moving logic for the phantoms 
         current_object.attach_to(current_object.object[2], 1, 0,0,relative)
         current_object.detach()

         -- attempt to shoot if can
         if current_object.timer[1].is_zero() then -- is ready to shoot
            ai_target_finding()
            if current_object.object[1] != no_object then
               basis = current_object.object[2]
               lookat_obj = current_object.object[1]
               ai_lookat()
               ai_attempt_fire()
               temp_obj0.object[1].copy_rotation_from(current_object.object[2], true) -- reorient projectile
            end
         end
      end
      -- position infront of the object'
      --current_object.detach()
      current_object.object[2].attach_to(current_object, 0, 0,0,relative)
      current_object.object[2].detach()
      current_object.object[2].copy_rotation_from(current_object, true)
   end
end
-- reset multikill after a second of not getting a kill 
for each player do
   current_player.timer[0].set_rate(-100%)
   if current_player.timer[0].is_zero() then
      current_player.number[4] = 0
   end
end

-- play death effect and what not when pelican/phantom dies
on object death: do -- seraphs dont seem to trigger this event, weird
   if killed_object.has_forge_label("S_BansheeOBJ") or killed_object.has_forge_label("S_SeraphOBJ") or killed_object.has_forge_label("S_SabreOBJ") 
   or killed_object.has_forge_label("S_PhantomOBJ") or killed_object.has_forge_label("S_PelicanOBJ") then
      if killed_object.number[0] != 0 and killer_player != no_player then
         banshee kill
         if killed_object.has_forge_label("S_BansheeOBJ") then
            --send_incident(supercombine_kill, killer_player, no_player)
            killer_player.score += 1
         end
         -- seraph kill
         if killed_object.has_forge_label("S_SeraphOBJ") then
            send_incident(supercombine_kill, killer_player, no_player)
            killer_player.score += 3
         end
         -- phantom kill
         if killed_object.has_forge_label("S_PhantomOBJ") then
            send_incident(laser_kill, killer_player, no_player)
            killer_player.score += 5
         end
         -- betrayal kill
         if killed_object.has_forge_label("S_SabreOBJ") or killed_object.has_forge_label("S_PelicanOBJ") then
            killer_player.score -= 1
         end

         -- find multikill and award medal
         killer_player.number[4] += 1
         killer_player.timer[0].reset()
         if killer_player.number[4] == 2 then
            send_incident(multikill_x2, killer_player, no_player)
         end
         if killer_player.number[4] == 3 then
            send_incident(multikill_x3, killer_player, no_player)
         end
         if killer_player.number[4] == 4 then
            send_incident(multikill_x4, killer_player, no_player)
         end
         if killer_player.number[4] == 5 then
            send_incident(multikill_x5, killer_player, no_player)
         end
         if killer_player.number[4] == 6 then
            send_incident(multikill_x6, killer_player, no_player)
         end
         if killer_player.number[4] == 7 then
            send_incident(multikill_x7, killer_player, no_player)
         end
         if killer_player.number[4] == 8 then
            send_incident(multikill_x8, killer_player, no_player)
         end
         if killer_player.number[4] == 9 then
            send_incident(multikill_x9, killer_player, no_player)
         end
         if killer_player.number[4] == 10 then
            send_incident(multikill_x10, killer_player, no_player)
         end
         -- find spree and award medal
         temp_obj0 = killer_player.biped
         temp_obj0.number[0] += 1
         if temp_obj0.number[0] == 5 then
            send_incident(5_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 10 then
            send_incident(10_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 15 then
            send_incident(15_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 20 then
            send_incident(20_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 25 then
            send_incident(25_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 30 then
            send_incident(30_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 35 then
            send_incident(35_in_a_row, killer_player, no_player)
         end
         if temp_obj0.number[0] == 40 then
            send_incident(40_in_a_row, killer_player, no_player)
         end
      end
   end
   if killed_object.is_of_type(falcon) then
      if killed_object.has_forge_label("S_PhantomOBJ") or killed_object.has_forge_label("S_PelicanOBJ") then -- was an ai 
         game.show_message_to(all_players, none, "DEBUG MAJOR AI DEATH")
         if killed_object.object[3] != no_object then -- phantom shell for the phantom & unsc bomb for pelican
            killed_object.object[3].detach()
            killed_object.object[3].set_invincibility(0)
            killed_object.object[3].kill(false)
         end
      end
      killed_object.set_invincibility(0)
      killed_object.delete()
   end
end


for each object with label "S_BansheeOBJ" do
	if current_object.number[0] != 0 then
      current_object.timer[1].set_rate(-300%)
	   ai()
      -- firing pattern cooldown
      if current_object.number[4] >= 5 then
         current_object.timer[2] = 17 -- 1.7 seconds
         current_object.number[4] = 0
      end
      -- special attack firing pattern
      if current_object.number[2] < -80 then -- 40 tick attack cooldown
         current_object.number[2] = rand(920) -- 2 seconds deviation
         current_object.number[2] = 390 -- 390 +220 +40 ticks special cooldown
         -- difficulty scaling + min absolute min
         current_object.number[2] -= global.number[10]
         if current_object.number[2] < 320 then
            current_object.number[2] = 320
         end
      end
   end
end
for each object with label "S_SeraphOBJ" do
	if current_object.number[0] != 0 then
      current_object.timer[1].set_rate(-500%)
	   ai()
      -- firing pattern cooldown
      if current_object.number[4] >= 3 then
         current_object.timer[2] = 28 -- 2.8 seconds
         current_object.number[4] = 0
      end
      -- special attack firing pattern
      if current_object.number[2] < -20 then -- 20 tick attack cooldown
         current_object.number[2] = rand(420) -- 2 seconds deviation
         current_object.number[2] += 300 -- 490 (+20) ticks special cooldown
         -- difficulty scaling + min absolute min
         current_object.number[2] -= global.number[10]
         if current_object.number[2] < 320 then
            current_object.number[2] = 320
         end
      end
   end
end
for each object with label "S_SabreOBJ" do
	if current_object.number[0] != 0 then
      current_object.timer[1].set_rate(-500%)
	   ai()
      -- firing pattern cooldown
      if current_object.number[4] >= 3 then
         current_object.timer[2] = 28 -- 2.8 seconds
         current_object.number[4] = 0
      end
      -- special attack firing pattern
      if current_object.number[2] < -110 then -- 20 tick attack cooldown
         current_object.number[2] = rand(420) -- 2 seconds deviation
         current_object.number[2] += 400 -- 490 (+20) ticks special cooldown
         -- difficulty scaling + min absolute min
         current_object.number[2] -= global.number[10]
         if current_object.number[2] < 320 then
            current_object.number[2] = 320
         end
      end
   end
end
for each object with label "S_PhantomOBJ" do
	if current_object.number[0] != 0 then
      current_object.timer[1].set_rate(-300%)
	   ai()
      -- firing pattern cooldown
      if current_object.number[4] >= 11 then
         current_object.timer[2] = 22 -- 2.2 seconds
         current_object.number[4] = 0
      end
      -- prevent "zombie phantom glitch"
      temp_num0 = current_object.health 
      if temp_num0 <= 0 then
         current_object.delete()
      end
      -- special attack firing pattern
      if current_object.number[2] < -40 then -- 20 tick attack cooldown
         current_object.number[2] = rand(120) -- 2 seconds deviation
         current_object.number[2] += 490 -- 490 (+20) ticks special cooldown
         -- difficulty scaling + min absolute min
         current_object.number[2] -= global.number[10]
         if current_object.number[2] < 320 then
            current_object.number[2] = 320
         end
      end
   end
end
for each object with label "S_PelicanOBJ" do
	if current_object.number[0] != 0 then
      current_object.timer[1].set_rate(-300%)
	   ai()
      -- firing pattern cooldown
      if current_object.number[4] >= 11 then
         current_object.timer[2] = 22 -- 2.2 seconds
         current_object.number[4] = 0
      end
      -- prevent "zombie phantom glitch"
      temp_num0 = current_object.health 
      if temp_num0 <= 0 then 
         current_object.delete()
      end
      -- special attack firing pattern
      if current_object.number[2] < -40 then -- 20 tick attack cooldown
         current_object.number[2] = rand(120) -- 2 seconds deviation
         current_object.number[2] += 490 -- 490 (+20) ticks special cooldown
         -- difficulty scaling + min absolute min
         current_object.number[2] -= global.number[10]
         if current_object.number[2] < 320 then
            current_object.number[2] = 320
         end
      end
   end
end

-- function for having the AI projectiles impact on other AI
alias target_size = temp_num3
function AI_projectile()
   if temp_num2 == 0 and current_object.number[0] != 0 and current_object.team != temp_obj0.team then
      temp_num0 = current_object.get_distance_to(temp_obj0)
      if temp_num0 <= target_size then -- is in damage range and isn't on owners team
         temp_num0 = current_object.shields
         temp_num1 = temp_obj0.number[2] -- our intended damage
         if current_object.has_forge_label("S_PhantomOBJ") or current_object.has_forge_label("S_PelicanOBJ") then
            temp_num1 /= 5 -- take a 5th of the damage (base damage is 15, which is then translated to 3 damage points on major units, 33 hits to kill)
         end
         if not current_object.has_forge_label("S_PhantomOBJ") and not current_object.has_forge_label("S_PelicanOBJ") then
            -- apply 2 times damage to sabres/seraphs
            temp_num1 *= 2
            if current_object.is_of_type(banshee) then
               temp_num1 *= 17
               temp_num1 /= 10 -- apply 1.7 times damage to banshees
            end
         end
         if temp_num0 <= 0 then -- has no shields, reduce health instead
            current_object.health -= temp_num1
            temp_num1 = current_object.health
            if temp_num1 <= 0 then
               current_object.kill(true)
            end
         end
         if temp_num0 > 0 then -- has shields, do shield damage
            if current_object.has_forge_label("S_PhantomOBJ") or current_object.has_forge_label("S_PelicanOBJ") then -- free action & trigger
               temp_num1 *= 100 -- deal instant shield health (these vehicles aren't supposed to have shields)
            end
            -- we calculated the damage multipliers before, they wont be overriden by the health check
            current_object.shields -= temp_num1
         end
         -- do damage effect to update health
         temp_obj1 = current_object.place_between_me_and(current_object, plasma_cannon, 0)
         temp_obj1.kill(true)
         temp_obj0.object[1].delete()
         temp_obj0.delete() 
         -- notify that projectile has expired
         temp_num2 = 1
      end
   end
end
 
-- main script for making AI projectiles interact
for each object with label "Active_Projectile" do
   -- scoot forward every tick
   current_object.detach()
   if current_object.number[3] == 0 then -- regular projectile speed
      if global.number[11] < script_option[12] then -- normal mode speed
         current_object.object[1].attach_to(current_object, 22,0,0,relative)
      end
      if global.number[11] >= script_option[12] then -- set +1 speed
         current_object.object[1].attach_to(current_object, 28,0,0,relative)
      end
   end
   if current_object.number[3] != 0 then -- tracking projectile speed
      if global.number[11] < script_option[12] then -- normal mode speed
         current_object.object[1].attach_to(current_object, 6,0,0,relative)
      end
      if global.number[11] >= script_option[12] then -- set +1 speed
         current_object.object[1].attach_to(current_object, 8,0,0,relative)
      end
   end
   current_object.object[1].detach()
   current_object.attach_to(current_object.object[1], 0,0,0, relative)

   -- if projectile has homing, then do that
   -- decay homing attribute after X amount of ticks, as it would always hit the player otherwise
   if current_object.number[3] > 0 and current_object.object[3] != no_object then
      current_object.number[3] -= 1
      if current_object.number[3] == 0 then
         current_object.number[3] = -1 -- so we remember that this was a homing projectile
      end
      temp_num0 = current_object.number[3]
      temp_num0 %= 15 -- run this every 15 ticks
      if temp_num0 == 0 then -- this is the 5th tick
         lookat_obj = current_object.object[3]
         basis = current_object.object[1]
         ai_lookat()
      end
   end
   -- check to see if should be damaging things
   temp_num2 = 0 -- projectile has expired?
   for each player do
      if temp_num2 == 0 then -- prevent execution if already hit someone, this is to prevent "ghost shots"
         temp_obj0 = current_player.biped
         if temp_obj0 != no_object and temp_obj0.object[2] != no_object then 
            temp_num0 = current_object.get_distance_to(temp_obj0)
            if temp_num0 <= 25 then -- is in damage range
               -- apply damage
               temp_num0 = temp_obj0.object[2].shields
               if temp_num0 <= 0 then -- has no shields, reduce health instead
                  temp_obj0.object[2].health -= current_object.number[2]
               end
               if temp_num0 > 0 then -- has shields, do shield damage
                  temp_obj0.object[2].shields -= current_object.number[2]
               end
               -- do damage effect to update health
               temp_obj1 = temp_obj0.object[2].place_between_me_and(temp_obj0.object[2], plasma_cannon, 0)
               temp_obj1.kill(true)
               if current_object.number[3] != 0 then -- is a heavy projectile
                  temp_obj1 = current_object.place_between_me_and(current_object, covenant_bomb, 0)
                  temp_obj1.kill(true)
               end
               current_object.object[1].delete()
               current_object.delete() 
               -- we need to prevent execution now that we've deleted this object
               temp_num2 = 1
            end
         end
      end
   end
   temp_obj0 = current_object
   target_size = 35
   for each object with label "S_SabreOBJ" do
      AI_projectile()
   end
   target_size = 15
   for each object with label "S_BansheeOBJ" do
      AI_projectile()
   end
   target_size = 35
   for each object with label "S_SeraphOBJ" do
      AI_projectile()
   end
   target_size = 50
   for each object with label "S_PhantomOBJ" do
      AI_projectile()
   end
   target_size = 50
   for each object with label "S_PelicanOBJ" do
      AI_projectile()
   end
   if current_object != no_object then -- incase we deleted it before
      -- cleanup after this many ticks
      current_object.number[0] += 1
      if current_object.number[0] >= PROJ_max_life_ticks then
         current_object.object[1].delete()
         current_object.delete()
      end
   end
end


-- clean up the plasma turrets used to apply damage effects to player's vehicles
for each object with label 8 do
   current_object.number[0] += 1
   if current_object.number[0] >= 220 then
      current_object.delete()
   end
end

for each object with label 9 do -- spartan bipeds
   temp_num0 = current_object.health
   if temp_num0 <= 0 then
      current_object.delete()
   end
end
for each object with label 10 do -- elite bipeds
   temp_num0 = current_object.health
   if temp_num0 <= 0 then
      current_object.delete()
   end
end

-- spawner spawning logic
for each object with label "S_Spawner" do
   current_object.timer[3].set_rate(-25%) -- so the first spawn always takes 4 secs
   if current_object.number[1] == 1 then
      current_object.timer[3].set_rate(-125%) -- -125% if has done at least one spawn
   end
   if current_object.timer[3].is_zero() then
      temp_obj2 = no_object
      for each player do
         if temp_obj2 == no_object then
            temp_obj0 = current_player.biped
            if temp_obj0 != no_object and current_player.number[2] == 1 and current_object.timer[3].is_zero() then 
               current_object.number[1] = 1 -- first spawn
               current_object.timer[3].reset()


               temp_num1 = global.number[5]
               if script_option[3] == 0 then -- 10 waves logic
                  -- wave 1: 100% banshees                         (min:1 max:10)
                  -- wave 2: 90% banshees 10% seraphs              (min:2 max:11)
                  -- wave 3: 80% banshees 20% seraphs              (min:3 max:12)
                  -- wave 4: 70% banshees 30% seraphs              (min:4 max:13)
                  -- wave 5: 60% banshees 40% seraphs              (min:5 max:14)
                  -- wave 6: 50% banshees 50% seraphs              (min:6 max:15)
                  -- wave 7: 40% banshees 50% seraphs 10% phantoms (min:7 max:16)
                  -- wave 8: 30% banshees 50% seraphs 20% phantoms (min:8 max:17)
                  -- wave 9: 20% banshees 50% seraphs 30% phantoms (min:9 max:18)
                  -- wave10: 10% banshees 50% seraphs 40% phantoms (min:10max:19)
                  temp_num0 = rand(10)
                  temp_num0 += temp_num1 -- range of between 20, base is 10

                  if temp_num0 <= 10 then -- 0-10
                     temp_num1 = 2 -- banshees
                  end
                  if temp_num0 > 10 and temp_num1 <= 15 then -- 11-15
                     temp_num1 = 1 -- seraph
                  end
                  if temp_num0 > 15 then -- 16-19
                     temp_num1 = 0 -- phantom
                  end
               end
               if script_option[3] == 1 then -- 5 waves logic
                  -- wave 1: 100% banshees                         (min:1 max:5) 
                  -- wave 2: 80% banshees 20% seraphs              (min:2 max:6) 
                  -- wave 3: 60% banshees 40% seraphs              (min:3 max:7) 
                  -- wave 4: 40% banshees 40% seraphs 20% phantoms (min:4 max:8) 
                  -- wave 5: 20% banshees 40% seraphs 40% phantoms (min:5 max:9) 
                  temp_num0 = rand(5)
                  temp_num0 += temp_num1 -- range of between 10, base is 5

                  if temp_num0 <= 5 then -- 0-5
                     temp_num1 = 2 -- banshees
                  end
                  if temp_num0 > 5 and temp_num1 <= 7 then -- 5-7
                     temp_num1 = 1 -- seraph
                  end
                  if temp_num0 > 7 then -- 8-9
                     temp_num1 = 0 -- phantom
                  end
               end


               -- is team sabre
               if current_object.team == team[0] then
                  temp_num1 = 3
               end
               -- PHANTOM
               if temp_num1 == 0 then
                  for each object with label "S_PhantomOBJ" do
                     if current_object.number[0] == 0 and current_object.number[7] == 0 and temp_obj2 == no_object then 
                        current_object.number[7] = 1
                        temp_obj2 = current_object.place_at_me(falcon, "S_PhantomOBJ", none, 0, 0, 0, none)
                        current_object.set_invincibility(1)
                        current_object.attach_to(temp_obj2, 0,0,-10, relative)
                        temp_obj2.max_health = 3500 -- player damage health
                        temp_obj2.health = 100
                        temp_obj2.set_scale(50)
                        temp_obj2.copy_rotation_from(temp_obj2, true)
                        temp_obj2.object[3] = current_object -- destruction effect
                     end
                  end
                  if temp_obj2 == no_object then -- skip to seraph if failed to spawn phantom
                     temp_num1 = 1 
                  end
               end
               -- SERAPH
               if temp_num1 == 1 then
                  for each object with label "S_SeraphOBJ" do
                     if current_object.number[0] == 0 and temp_obj2 == no_object then 
                        temp_obj2 = current_object
                     end
                  end
                  if temp_obj2 == no_object then -- skip to banshee if failed to spawn sabre
                     temp_num1 = 2  
                  end
               end
               -- BANSHEE
               if temp_num1 == 2 then
                  if temp_obj2 == no_object then 
                     temp_obj2 = temp_obj0.place_at_me(banshee, "S_BansheeOBJ", none, 0, 0, 0, none)
                  end
               end
               -- SABRE
               if temp_num1 == 3 then
                  temp_num1 = rand(8)
                  if temp_num1 == 0 then
                     for each object with label "S_PelicanOBJ" do
                        if current_object.number[0] == 0 and current_object.number[7] == 0 and temp_obj2 == no_object then 
                           current_object.number[7] = 1
                           temp_obj2 = current_object.place_at_me(falcon, "S_PelicanOBJ", none, 0, 0, 0, none)
                           current_object.set_invincibility(1)
                           current_object.attach_to(temp_obj2, -8,0,-15, relative)
                           temp_obj2.max_health = 3500 -- player damage health
                           temp_obj2.health = 100
                           temp_obj2.set_scale(50)
                           temp_obj2.copy_rotation_from(temp_obj2, true)
                           -- destruction effect
                           temp_obj2.object[3] = temp_obj2.place_at_me(bomb, none, none, 0, 0, 0, none) 
                           temp_obj2.object[3].attach_to(temp_obj2, 0,0,0,relative)
                           temp_obj2.object[3].set_invincibility(1)
                        end
                     end
                     if temp_obj2 == no_object then -- skip to sabre if failed to spawn pelican
                        temp_num1 = 3 
                     end
                  end
                  if temp_obj2 == no_object then
                     temp_obj2 = temp_obj0.place_at_me(sabre, "S_SabreOBJ", none, 0, 0, 0, none)
                  end
               end
               if temp_obj2 != no_object then 
                  game.play_sound_for(all_players, timer_beep, true) -- ai spawned
                  temp_obj2.number[0] = 1 -- notify the vehicle that its now an ai
                  -- some defaults relating to firing patterns
                  temp_obj2.timer[2] = 0 -- to prevent AI from having an initial 10 sec firing delay
                  temp_obj2.number[2] = -1 -- so this will reset to its proper value
                  --
                  temp_obj2.team = current_object.team
                  -- reposition the vehicle
                  temp_obj6 = current_object.place_at_me(flag_stand, none, none, 0,0,0,none)
                  temp_obj2.attach_to(temp_obj6, 25,0,0,relative)
                  temp_obj6.set_scale(2500)
                  temp_obj6.copy_rotation_from(temp_obj6, true)
                  random_face_toward()
                  temp_obj2.detach()
                  temp_obj1 = temp_obj0.place_at_me(monitor, none, none, 0, 0, 0, none)
                  temp_obj1.team = current_object.team
                  current_player.set_biped(temp_obj1)
                  current_player.force_into_vehicle(temp_obj2)
                  current_player.set_biped(temp_obj0)
                  temp_obj6.delete()
                  -- we just spawned one, reduce spawns left to go
                  current_object.number[0] -= 1
                  if current_object.number[0] <= 0 then -- spawner completed, self destruct
                     current_object.delete()
                  end
               end
            end
         end
      end
   end
end

-- spawner spawning system
function create_spawner()
   -- set up the spawner object
   temp_obj2 = temp_obj0.place_at_me(hill_marker, "S_Spawner", none, 0,0,0,none)
   temp_obj2.number[0] = SPAWNER_spawn_count -- each spawner spawns X amount of AI
   -- reposition the spawner  
   temp_obj6 = temp_obj0.place_at_me(flag_stand, none, none, 0,0,0,none)

   temp_obj2.attach_to(temp_obj6, 15,0,0,relative)
   temp_obj6.set_scale(25000)
   temp_obj6.copy_rotation_from(temp_obj6, true)
   random_face_toward()
   temp_obj2.detach()

   current_player.set_biped(temp_obj1)
   current_player.force_into_vehicle(temp_obj2)
   current_player.set_biped(temp_obj0)

   temp_obj6.delete()
   -- setup waypoints for this spawner
   temp_obj2.set_waypoint_text("INCOMING")
   temp_obj2.set_waypoint_range(-1,-1)
   temp_obj2.set_waypoint_priority(blink)
   temp_obj2.set_waypoint_visibility(enemies)
   -- setup the alt waypoints for allies
   temp_obj3 = temp_obj2.place_between_me_and(temp_obj2, hill_marker, 0)
   temp_obj3.set_waypoint_text("REINFORCEMENTS")
   temp_obj3.set_waypoint_range(-1,-1)
   temp_obj3.set_waypoint_priority(blink)
   temp_obj3.set_waypoint_visibility(allies)
   temp_obj3.attach_to(temp_obj2,0,0,0,relative)
end

-- sabre spawning logic
do
   temp_num3 = 0
   for each object with label "S_SabreOBJ" do 
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   for each object with label "S_PelicanOBJ" do 
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   global.timer[2].set_rate(-100%)
   if temp_num3 > 1 then -- count teammate AI and reset counter if theres too many to want to respawn them
      global.timer[2].reset()
   end
   if global.timer[2].is_zero() then
      for each player randomly do
         temp_obj0 = current_player.biped
         if temp_obj0 != no_object and current_player.number[2] == 1 and global.timer[2].is_zero() then 
            game.play_sound_for(all_players, firefight_lives_added, true)
            global.timer[2].reset()
            create_spawner()
            temp_num1 = rand(4)
            temp_num1 += 2
            temp_obj2.number[0] = temp_num1
            temp_obj2.team = team[0]
            temp_obj3.team = temp_obj2.team
         end
      end
   end
end

function set_complete()
   global.number[11] += 1 -- set count
   global.number[9] += script_option[10] -- AI damage modifier
   global.number[10] += script_option[11] -- heavy shot speed modifier
   game.show_message_to(all_players, none, "Set Complete")
   global.number[5] = 0
   for each player do
      temp_obj0 = current_player.biped
      if temp_obj0.object[0] == no_object and current_player.number[6] == 1 then -- if they are currently in a vehicle, then we would just be giving out extra lives
         current_player.number[6] = 0 -- they get to revive for free at the end of a round
      end
   end
end

-- covenant spawning logic
do
   temp_num3 = 0
   for each object with label "S_BansheeOBJ" do
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   for each object with label "S_SeraphOBJ" do
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   for each object with label "S_PhantomOBJ" do
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   if global.number[5] == 0 and global.number[11] == 0 then -- make initial countdown slower
      global.timer[0].set_rate(-50%)
   end
   if global.number[5] > 0 or global.number[11] > 0 then -- regular countdown speed
      global.timer[0].set_rate(-100%)
   end
   if temp_num3 > 0 then -- count AI and reset wave timer if theres still some left
      global.timer[0].reset()
   end
   global.number[8] = temp_num3 -- record the number of bad guys 
   temp_num1 = 0
   for each object with label "S_Spawner" do 
      if current_object.team != team[0] then -- is not a sabre spawner
         temp_num1 += 1
      end
   end
   temp_obj2 = no_object
   temp_num0 = SPAWNER_min_active
   temp_num0 += global.number[5]
   if temp_num0 > SPAWNER_max_active then
      temp_num0 = SPAWNER_max_active
   end
   if temp_num3 <= 0 and temp_num1 <= 0 then -- no enemies, new wave incoming
      if global.number[6] != global.number[5] then -- its a new wave
         -- set complete, restart round thingo
         if global.number[5] == 10 and script_option[3] == 0 then -- unneeded condition here
            set_complete()
         end
         if global.number[5] == 5 and script_option[3] == 1 then
            set_complete()
         end
         global.number[6] = global.number[5]
         global.number[7] = 1
         send_incident(survival_wave_completed, all_players, no_player)
         game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
         -- increment lives
         global.object[10].number[0] += script_option[6] -- bonus lives per live completion
         game.show_message_to(all_players, none, "Lives added")
         if global.object[10].number[0] > script_option[5] and script_option[5] > -1 then -- cap spare lives at maximum
            global.object[10].number[0] = script_option[5]
         end
      end
   end
   for each player randomly do
      if temp_obj2 == no_object then
         temp_obj0 = current_player.biped
         if temp_obj0 != no_object and current_player.number[2] == 1 and global.timer[0].is_zero() then 
            game.play_sound_for(all_players, boneyard_generator_power_down, true)
            temp_num1 += 1
            if temp_num1 >= temp_num0 then
               global.timer[0].reset()
               global.number[5] += 1 -- assign new wave
               global.number[7] = 0
            end
            create_spawner()
            temp_obj2.team = team[1]
            temp_obj3.team = temp_obj2.team
         end
      end
   end
end

-- player auto team to team[0]
for each player do
   if current_player.biped != no_object then
      current_player.team = team[0]
   end
end

-- projectile cleanup script
do 
   temp_num1 = 0
   for each object with label "Active_Projectile" do
      temp_num1 += 1
   end
   if temp_num1 > script_option[1] then
      temp_obj0 = no_object 
      for each object with label "Active_Projectile" do
         temp_obj0 = current_object
      end
      if temp_obj0 != no_object then 
         game.show_message_to(all_players, none, "DEBUG projectile overflow")
         temp_obj0.object[1].delete()
         temp_obj0.delete()
      end
   end
end

-- player balancing script
do
   temp_num0 = 0
   for each player do
      if current_player.number[0] != 0 then -- has been validated
         temp_num0 += 1
      end
   end
   for each player do
      -- 1-2 player traits
      if temp_num0 <= 2 then 
         current_player.apply_traits(script_traits[0])
      end
      -- 3-5 players traits
      if temp_num0 > 2 and temp_num0 <= 5 then 
         current_player.apply_traits(script_traits[1])
      end
      -- 6-10 players traits
      if temp_num0 > 5 and temp_num0 <= 10 then 
         current_player.apply_traits(script_traits[2])
      end
      -- 11-16 players traits
      if temp_num0 > 10 then 
         current_player.apply_traits(script_traits[3])
      end
   end
   if temp_num0 <= 2 then 
      script_widget[0].set_text("1-2 players balancing")
   end
   if temp_num0 > 2 and temp_num0 <= 5 then 
      script_widget[0].set_text("3-5 players balancing")
   end
   if temp_num0 > 5 and temp_num0 <= 10 then 
      script_widget[0].set_text("6-10 players balancing")
   end
   if temp_num0 > 10 then 
      script_widget[0].set_text("11-16 players balancing")
   end
end

-- debug widget code
do
   temp_num0 = 0
   for each object do 
      temp_num0 += 1
   end
   temp_num2 = 0
   temp_num3 = 0
   for each object with label "S_BansheeOBJ" do
      if current_object.number[0] != 0 then
         temp_num2 += 1
      end
   end
   for each object with label "S_SeraphOBJ" do
      if current_object.number[0] != 0 then
         temp_num3 += 1
      end
   end
   script_widget[0].set_value_text("%n objects on the map\r\n%n projectiles", temp_num0, temp_num1)
   if script_option[4] > -1 then
      script_widget[1].set_value_text("%n Lives\r\n%n bad guys", global.object[10].number[0], global.number[8])
   end
   if script_option[4] == -1 then
      script_widget[1].set_value_text("%n bad guys", global.number[8])
   end
   script_widget[3].set_text("client server position corrections %n\r\n", client_corrections)
   if global.number[11] > 0 then
      script_widget[2].set_text("Set %n Wave %n", global.number[11], global.number[5])
   end
   if global.number[11] == 0 then
      script_widget[2].set_text("Wave %n", global.number[5])
   end
   if global.number[7] == 1 then -- is wave intermission
      script_widget[2].set_value_text("Intermission %n", global.timer[0])
      script_widget[2].set_meter_params(timer, global.timer[0])
   end
   if global.number[7] == 0 then -- is not wave intermission
      script_widget[2].set_value_text("")
      script_widget[2].set_meter_params(none)
   end
end

-- cleanup object cleanup (if object.object[0] == no_object)
for each object with label "S_cleanup" do
   if current_object.object[0] == no_object then
      current_object.delete()
   end
end

