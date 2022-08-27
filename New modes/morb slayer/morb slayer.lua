
declare global.player[0] with network priority high -- morbius
declare global.player[1] with network priority local -- local player

declare global.player[2] with network priority local -- temp_player[0]

declare global.player[3] with network priority high -- borbius

declare global.number[0] with network priority local -- temp number[0]
declare global.number[1] with network priority local -- temp number[1]

declare global.number[2] with network priority local -- host indicator

-- declare global.number[3] with network priority local -- ### unused, i think

declare global.number[4] with network priority local -- timer ping display
declare global.number[5] with network priority high -- timer ping host 


declare global.number[6] with network priority local -- DEBUG numerbous, client corrections count
declare global.number[7] with network priority local -- DEBUG numerbous, client FAILED corrections count



declare global.object[0] with network priority local -- temp object[0]
declare global.object[1] with network priority local -- temp object[1]
declare global.object[2] with network priority local -- temp object[2]
declare global.object[3] with network priority local -- temp object[3]
declare global.object[4] with network priority local -- temp object[4]
declare global.object[5] with network priority high  -- global.propane_storage, also object place at for global objects

declare global.object[6] with network priority local -- global.latencytest -- only exists on clients
declare global.object[7] with network priority local -- global.positiontest -- only exists on clients
declare global.object[8] with network priority local -- global.positiontestprev -- only exists on clients

declare global.object[9] with network priority local -- temp object[9]
declare global.object[10] with network priority local -- temp object[10]

declare object.object[0] with network priority local -- player.biped.heldweap
                                                     -- player.tracker.forwardtest
                                                     -- propane_manager.p1
declare object.object[1] with network priority local -- propane_manager.p2
declare object.object[2] with network priority local -- propane_manager.p3
declare object.object[3] with network priority local -- player.biped.local_test_obj


declare object.number[0] with network priority local -- propane tank state
                                                     -- player held weapon

declare object.player[0] with network priority local -- biped owner

declare player.number[0] with network priority local -- player is morbius

declare player.number[1] with network priority local -- player ability

declare player.number[2] with network priority local -- player biped existance confirmation
declare player.number[3] with network priority local -- undeclared
declare player.number[4] with network priority local -- undeclared
declare player.number[5] with network priority local -- undeclared

declare player.number[6] with network priority local -- player rubberband pos test
declare player.number[7] with network priority local -- player rubberband last valid velocity

declare player.object[0] with network priority local -- used for thruster calculations, remember where the player was a tick ago
declare player.object[1] with network priority local -- thrusters management object


declare player.timer[0] = 1 -- check ground height test
declare player.timer[1] = 5 -- transition to morb timer
declare player.timer[2] = 0 -- ? i think we're no longer using this
declare player.timer[3] = 60 -- morb weaken timer

declare global.timer[0] = 11

declare global.timer[1] = 0



-- ////////////////////////
-- // NETWORKING ALIASES //
-- ////////////////////////

alias sync_timer = global.timer[1]
alias sync_display = global.number[4]
alias sync_host_value = global.number[5]

alias client_corrections = global.number[6]
alias client_failed_corrections = global.number[7]


-- //////////////////////
-- // CONSTANT ALIASES //
-- //////////////////////

alias suicide_points = 0
alias betrayal_points = 1
alias morbius_killed_points = -1000
alias morbius_kill_points = -1000

alias morbius_traits = script_traits[0]
alias weak_morb_traits = script_traits[6]
alias weaker_morb_traits = script_traits[7]
alias weakest_morb_traits = script_traits[8]

alias morbius_flying_traits = script_traits[1]
alias premorb_traits = script_traits[2]
alias non_morb_head = script_traits[3]
alias aa_disabled = script_traits[4]
alias borbius_traits = script_traits[5]

alias invincible_traits = script_traits[9]

alias team_existance_delay = 40

-- //////////////////
-- // TEMP ALIASES //
-- //////////////////

alias temp_num0 = global.number[0]
alias temp_num1 = global.number[1]

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias temp_obj3 = global.object[3]
alias temp_obj4 = global.object[4]
alias temp_obj5 = global.object[9]
alias temp_obj6 = global.object[10]

alias temp_player0 = global.player[2]



-- ////////////////////
-- // GLOBAL ALIASES //
-- ////////////////////

alias propane_base = global.object[5] -- for attaching reserve propane tanks to

alias ms_sync_obj = global.object[6]
alias pos_tracker = global.object[7]
alias prev_pos_tracker = global.object[8]

alias morbius = global.player[0] -- morbius
alias borbius = global.player[3] -- borbius
alias local_player = global.player[1] -- local player reference, according to the machine its stored on


alias host_indicator = global.number[2] -- used in figuring out which machine running 'local' is the host machine
alias host_existance_check = global.timer[0]



-- //////////////////////
-- // PLAYER VARIABLES //
-- //////////////////////

alias existence_check = player.number[2]


alias morb_state = player.number[0]
alias morb_pretimer = player.timer[1]


alias tick_distance = player.number[6] 
alias last_tick_distance = player.number[7] 

alias tracker = player.object[0] -- tracks their distance over ticks
alias propanes = player.object[1] -- wrapper object to store propane objects

alias ability = player.number[1] -- for both survivors and morbius
alias morb_weaken_timer = player.timer[3] -- prevent morbius from flying away, make him weaker
enum surv_abilities
   none      = 0
   sentry    = 1 -- the pocket turret, cool turret vehi that targets morbius
   jammer    = 2 -- like those projectile jammers in rainbow six siege but against morbius
   explosive = 3 -- potentially remote detonated bomb 
   grapple   = 4 -- grapple hook thingo
   disguise  = 5
end


-- //////////////////////
-- // OBJECT VARIABLES //
-- //////////////////////

alias held_weap = object.object[0] -- biped.held_weapon
alias local_test_obj = object.object[3] 

alias state = object.number[0] -- used to determine what state a propane tank is in

alias b_owner = object.player[0] -- used to find the owner of a killed biped, to silently kill them

-- used for logging network complications
alias counter = object.number[0]
alias 📲1 = object.number[1]
alias 📲2 = object.number[2]
alias 📲3 = object.number[3]
alias 📲4 = object.number[4]
alias 📲5 = object.number[5]


-- //////////////////
-- // HEHE ALIASES //
-- //////////////////

alias 🍔 = player.biped
alias 👽 = current_player
alias 🌑 = propane_base
alias 👴 = temp_obj4 -- for our bipeds

alias ✅ = 1
alias ❌ = 0

alias ⛽1 = object.object[0]
alias ⛽2 = object.object[1]
alias ⛽3 = object.object[2]



-- //////////////////
-- // PROPANE TANK //
-- //////////////////

alias p_activation_health = 9
enum p_state_enum
   unactivated = 0
   initialized = 1
   activated = 2
   in_use = 3
end

if 🌑 == no_object then
   🌑 = get_random_object("p_base", no_object)
end
for each object with label "propane" do
   alias propane_tank = current_object
   alias curr_p_health = temp_num0
   -- read object health to determine whether it has been activated or not yet
   curr_p_health = propane_tank.health
   if curr_p_health >= p_activation_health and propane_tank.state == p_state_enum.unactivated then 
      propane_tank.state = p_state_enum.initialized
      -- weaken object to allow the plasma cannon destruction to easily activate it
      propane_tank.health = 40
      temp_obj0 = propane_tank.place_between_me_and(propane_tank, plasma_cannon, 0)
      temp_obj0.kill(false)
   end
   if curr_p_health < p_activation_health and propane_tank.state == p_state_enum.initialized then 
      propane_tank.set_invincibility(1)
      -- store another state number so if it fails to activate for whatever reason, we will know
      propane_tank.state = p_state_enum.activated
      propane_tank.attach_to(🌑, 0,0,0, relative)
   end
end

-- ////////////////////////
-- // INITIALIZE MORBIUS //
-- ////////////////////////
alias propane_man = temp_obj5
enum player_speed
   thrust1 = 150
   thrust2 = 100
   thrust3 = 75
end
function release⛽()
   temp_obj1.detach()
   temp_obj1.attach_to(🌑, 0,0,0,relative)
   temp_obj1.state = p_state_enum.activated
end
function release_⛽1()
   if propane_man.⛽1 != no_object then
      temp_obj1 = propane_man.⛽1
      propane_man.⛽1 = no_object
      release⛽()
   end
end
function release_⛽2()
   if propane_man.⛽2 != no_object then
      temp_obj1 = propane_man.⛽2
      propane_man.⛽2 = no_object
      release⛽()
   end
end
function release_⛽3()
   if propane_man.⛽3 != no_object then
      temp_obj1 = propane_man.⛽3
      propane_man.⛽3 = no_object
      release⛽()
   end
end
function release_propane_tanks()
   release_⛽1()
   release_⛽2()
   release_⛽3()
end
alias p_axis = temp_obj2
alias y_axis = temp_obj3
function find_valid_propane__return_temp_obj1()
   temp_obj1 = no_object
   for each object with label "propane" do
      if current_object.state == p_state_enum.activated and temp_obj1 == no_object then
         current_object.detach() -- detach from the storage object
         current_object.state = p_state_enum.in_use -- set this propane as in use, so no one else steals it
         --temp_obj2 = no_object
         --temp_obj3 = no_object
         -- the basic "figure out the rotations method"
         p_axis = 👴.held_weap.place_between_me_and(👴.held_weap, hill_marker, 0) -- pitch object 
         y_axis = p_axis.place_at_me(hill_marker, none, none, 0,0,0, none) -- yaw object

         -- rotate our forward 90 degrees so our roll axis is now the yaws relative pitch
         y_axis.face_toward(y_axis,0,-1,0)

         -- copy rotation from target object to make our pitch relative to the object in question
         p_axis.attach_to(y_axis, 0, 0, 0, relative)
         y_axis.copy_rotation_from(👴.held_weap, true)
         --y_axis.face_toward(y_axis, -1,0,0) -- rotate the local yaw 180, so its facing the right way
         p_axis.detach()

         -- rotate yaw to become roll, facing in the direction we want it to be (dependant on weapon class, ranged/melee)
         y_axis.attach_to(p_axis, 0, 0, 0, relative)
         p_axis.face_toward(p_axis, 0,-1,0) -- rotate pitch 90, so yaw is now roll
         -- adjust the angle just a little if not melee weapon
         if not 👴.held_weap.is_of_type(gravity_hammer) and not 👴.held_weap.is_of_type(golf_club) then
            p_axis.face_toward(p_axis, 110, -40, 0) -- rotate pitch 15 degrees to hopefully help stablize flying
         end
         y_axis.detach()

         current_object.copy_rotation_from(y_axis, true)
         current_object.attach_to(👴.held_weap, -10, 0, 0, relative)

         p_axis.delete()
         y_axis.delete()
         temp_obj1 = current_object
      end
   end
end

-- //////////////
-- // raytrace //
-- //////////////
alias distance_iterations = temp_num0
alias collision_size = temp_num1

alias collision_check = temp_obj0
alias max_distance = 7
function trigger_1()
   distance_iterations += 1
   collision_check = temp_obj1.place_at_me(bomb, none, none, 0, 0, 0, none)
   collision_size = collision_check.get_distance_to(temp_obj1)
   if collision_size > 0 then 
      distance_iterations = 999
   end
   temp_obj1.attach_to(collision_check, 0, 0, -2, relative)
   temp_obj1.detach()
   collision_check.delete()
   if distance_iterations < max_distance then 
      trigger_1()
   end
end



alias weap_index = object.number[0]
function doodoo()
   if 👴.weap_index == 0 then
      👴.add_weapon(spiker, secondary)
   end
   if 👴.weap_index == 1 then
      👴.add_weapon(shotgun, secondary)
   end
   if 👴.weap_index == 2 then
      👴.add_weapon(grenade_launcher, secondary)
   end
   if 👴.weap_index == 3 then
      👴.add_weapon(needle_rifle, secondary)
   end
   if 👴.weap_index == 4 then
      👴.add_weapon(assault_rifle, secondary)
   end
   if 👴.weap_index == 5 then
      👴.add_weapon(plasma_launcher, secondary)
   end
   if 👴.weap_index == 6 then
      👴.add_weapon(energy_sword, secondary)
   end
   if 👴.weap_index == 7 then
      👴.add_weapon(plasma_rifle, secondary)
   end
   if 👴.weap_index == 8 then
      👴.add_weapon(concussion_rifle, secondary)
   end
   if 👴.weap_index == 9 then
      👴.add_weapon(rocket_launcher, secondary)
   end
   if 👴.weap_index == 10 then
      👴.add_weapon(needler, secondary)
   end
   if 👴.weap_index == 11 then
      👴.add_weapon(magnum, secondary)
   end
   if 👴.weap_index == 12 then
      👴.add_weapon(focus_rifle, secondary)
   end
   if 👴.weap_index == 13 then
      👴.add_weapon(fuel_rod_gun, secondary)
   end
   if 👴.weap_index == 14 then
      👴.add_weapon(plasma_pistol, secondary)
   end
   if 👴.weap_index == 15 then
      👴.add_weapon(spartan_laser, secondary)
   end
   if 👴.weap_index == 16 then
      👴.add_weapon(dmr, secondary)
   end
   if 👴.weap_index == 17 then
      👴.add_weapon(plasma_repeater, secondary)
   end
   if 👴.weap_index == 18 then
      👴.add_weapon(sniper_rifle, secondary)
   end
   -- reset our number if it overflows
   👴.weap_index += 1
   if 👴.weap_index == 19 then
      👴.weap_index = 0 
   end
end

-- ////////////////////
-- // MORBIUS FLIGHT //
-- ////////////////////

enum morb_states
   pre_morb = -1
   not_morbius = 0
   morbing = 1
   morb_grounded = 2
   morb_flying = 3
end

for each player do
   👴 = 👽.🍔
   -- pre-morb script, transition to morbius
   if 👽.morb_state == morb_states.not_morbius then
      👽.apply_traits(non_morb_head)
   end
   if 👽.morb_state != morb_states.not_morbius then
      -- apply pre morb traits and invincibility for an extra two seconds after transitioning to morbius
      👽.morb_pretimer.set_rate(-100%)
      if not 👽.morb_pretimer.is_zero() then
         👽.apply_traits(invincible_traits)
      end
      -- apply pre morb (low movement) traits 
      if 👽.morb_state == morb_states.pre_morb then 
         👽.apply_traits(premorb_traits)
         if 👽.morb_pretimer <= 2 then
            👽.morb_state = morb_states.morb_grounded
         end
      end
   end
   -- store propane tanks on data object, to save the 3 object slots for other stuff
   if 👽.propanes == no_object then
      👽.propanes = current_player.biped.place_at_me(hill_marker, none, none, 0,0,0, none)
   end
   propane_man = 👽.propanes
   -- only excute if morbius
   if 👽.morb_state > morb_states.not_morbius then
      -- morbius traits
      👽.apply_traits(morbius_traits)
      -- check to see if the player is alive and eligable to be given propane tanks
      if 👴 != no_object then
         temp_obj0 = 👽.get_weapon(primary)

         if 👽.morb_state == morb_states.morb_flying then
             -- flying traits
            👽.apply_traits(morbius_flying_traits)
            temp_num0 = 👴.get_speed() -- might as well leave this, we do need to assign it to something before
            alias tracker_obj = temp_obj1
            alias player_forward = object.object[0]

            tracker_obj = 👽.tracker
            --👽.dist_covered = 👴.get_distance_to(👽.tracker)
            tracker_obj.player_forward.attach_to(temp_obj0, 5,0,0, relative)
            tracker_obj.player_forward.detach()
            temp_num1 = tracker_obj.get_distance_to(tracker_obj.player_forward) -- 0-10 is the general scope

            👽.tracker.attach_to(temp_obj0, 0,0,0, relative)
            👽.tracker.detach()

            if tracker_obj != no_object then
               temp_num0 = 999
               if temp_num1 < 8 then
                  temp_num0 = player_speed.thrust1
                  if temp_num1 < 7 then
                     temp_num0 = player_speed.thrust2
                     if temp_num1 < 5 then
                        temp_num0 = player_speed.thrust3
                     end
                  end
               end
            end
            if tracker_obj == no_object then
               👽.tracker = 👴.place_at_me(hill_marker, none, none, 0,0,0, none)
               tracker_obj = 👽.tracker
               tracker_obj.player_forward = tracker_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
            end
            
            --
            -- if they are holding something different this tick, remove propanes so we can give them new ones
            if temp_obj0 != no_object then
               if propane_man.⛽1 == no_object and temp_num0 <= player_speed.thrust1 then
                  find_valid_propane__return_temp_obj1()
                  propane_man.⛽1 = temp_obj1
               end
               if propane_man.⛽2 == no_object and temp_num0 <= player_speed.thrust2 then
                  find_valid_propane__return_temp_obj1()
                  propane_man.⛽2 = temp_obj1
               end
               if propane_man.⛽3 == no_object and temp_num0 <= player_speed.thrust3 then
                  find_valid_propane__return_temp_obj1()
                  propane_man.⛽3 = temp_obj1
               end
            end
            -- cleanup tanks if going too fast
            if temp_num0 > player_speed.thrust1 then
               release_⛽1()
            end
            if temp_num0 > player_speed.thrust2 then
               release_⛽2()
            end
            if temp_num0 > player_speed.thrust3 then
               release_⛽3()
            end
         end
         -- morbius unlimited weapon script, written in a function so it doens't bloat this section
         if 👴.held_weap != temp_obj0 then
            👴.held_weap = temp_obj0
            👴.remove_weapon(secondary, true)
            doodoo()
         end
         -- the height checker, to switch between flying and grounded
         👽.timer[0].set_rate(-200%)
         if 👽.timer[0].is_zero() then
            👽.timer[0].reset()

            temp_obj1 = 👴.place_between_me_and(👴, hill_marker, 0)
            distance_iterations = 0
            trigger_1()
            temp_obj1.delete()
            if distance_iterations == 999 and 👽.morb_state == morb_states.morb_flying then -- is flying & 
               👽.timer[0] = 2
               👽.morb_state = morb_states.morb_grounded
               game.show_message_to(current_player, none, "grounded, stopping flight")
               release_propane_tanks()
            end
            if distance_iterations != 999 and 👽.morb_state == morb_states.morb_grounded then -- is grounded & is lifting off
               👽.morb_state = morb_states.morb_flying
               game.show_message_to(current_player, none, "taking off")
            end
         end
      end
   end
   -- clean up propane tanks if the owner has died, even if not morbius, just in case
   if 👴 == no_object then
      release_propane_tanks()
   end
end

do
   script_widget[2].set_text("ITS MORBIN' TIME\r\n\r\n")
   script_widget[2].set_value_text("client server position corrections %n\r\nFAILED %n", client_corrections, client_failed_corrections)
   script_widget[3].set_text("Aproximate latency (%nms)\r\n\r\n", sync_display)
end



-- //////////////////////////
-- // LOCAL CODE EXECUTION //
-- //////////////////////////

do
   sync_timer.set_rate(-100%)
   if sync_timer.is_zero() then
      sync_timer = 100
   end
   sync_host_value = sync_timer

   host_indicator = ✅
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


-- //// INPUTS ////
alias lookat_obj = temp_obj3
alias basis = temp_obj5
alias offset_scale = temp_num0
-- //// OUTPUTS ////
alias yaw_obj = temp_obj0
alias pitch_obj = temp_obj1
alias offset_obj = temp_obj2
-- yaw_obj - create a new object at basis that looks at "lookat_obj" on both pitch and yaw
-- then take a variable number offset_scale and create offset_obj at that distance forward from yaw_obj
function basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   -- place pitch and yaw objects
   pitch_obj = basis.place_between_me_and(basis, hill_marker, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   yaw_obj.attach_to(basis, 0,0,0, relative)
   yaw_obj.detach()
   -- convert roll rotation to pitch via 90 degrees yaw rotation on world axis
   pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
   yaw_obj.face_toward(yaw_obj,0,1,0)
   pitch_obj.detach()
   -- reorient yaw axis to how its supposed to be (-90 degrees rotation)
   yaw_obj.face_toward(yaw_obj,0,-1,0)
   -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
   pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
   yaw_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.detach()
   -- setup offset object & attach-offset it in the forward direction
   offset_obj = pitch_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
   offset_obj.attach_to(yaw_obj, 1,0,0, relative)
   -- apply the relative pitch rotation to our yaw axis
   yaw_obj.attach_to(pitch_obj, 0,0,0, relative) 
   pitch_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.face_toward(pitch_obj,0,-1,0)
   yaw_obj.detach()
   -- now we just do the attaching forward
   -- convert our forge units to scale units
   offset_scale *= 100
   -- set scale of yaw obj, thus scaling the attachment offset of offset_obj
   yaw_obj.set_scale(offset_scale)
   yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
end
-- you will have to cleanup (delete pitch, yaw & offset objects after you're done with them)


on local: do
   -- /////////////////////////////
   -- // PING CALCULATING SCRIPT //
   -- /////////////////////////////
   if host_indicator == ❌ then
      if ms_sync_obj == no_object and 🌑 != no_object then
         ms_sync_obj = 🌑.place_at_me(hill_marker, none, none, 0,0,0, none)
      end
      --
      if ms_sync_obj != no_object then
         if sync_timer != sync_host_value then
            ms_sync_obj.counter += 1
         end
         if sync_timer == sync_host_value then
            if ms_sync_obj.counter > 0 then
               -- shift all recorded values down one
               ms_sync_obj.📲5 = ms_sync_obj.📲4
               ms_sync_obj.📲4 = ms_sync_obj.📲3
               ms_sync_obj.📲3 = ms_sync_obj.📲2
               ms_sync_obj.📲2 = ms_sync_obj.📲1
               ms_sync_obj.📲1 = ms_sync_obj.counter
               ms_sync_obj.📲1 *= 17
               -- add up all the counts and divide by count, returning the average
               sync_display = ms_sync_obj.📲1
               sync_display += ms_sync_obj.📲2
               sync_display += ms_sync_obj.📲3
               sync_display += ms_sync_obj.📲4
               sync_display += ms_sync_obj.📲5
               sync_display /= 5
               -- reset the counter, ready for the next update
               ms_sync_obj.counter = 0
            end
         end 
      end
   end
   -- /////////////////////////////////
   -- // LOCAL PLAYER FINDING SCRIPT //
   -- /////////////////////////////////
   if local_player == no_player and host_indicator == ❌ or not host_existance_check.is_zero() then 
      -- a bit complicated, but only run this code if: 
      -- 1. this machine has not found their local player yet
      -- 2. this machine is not the host, OR they are the host and it hasn't been ~10 seconds yet
      -- this is to prevent the CGB server host from having bipeds in front of clients the entire session
      for each player do  
         👴 = 👽.🍔
         -- spawn and postion a crosshair triggering target
         if 👴.local_test_obj == no_object then 
            if host_indicator == ✅ then 
               👴.local_test_obj = 👴.place_at_me(spartan, "hosttarget", none, 0, 0, 0, none)
            end
            if host_indicator == ❌ then 
               👴.local_test_obj = 👴.place_at_me(spartan, "clienttarget", none, 0, 0, 0, none)
            end
            👴.local_test_obj.set_scale(160)
            👴.local_test_obj.copy_rotation_from(👴.local_test_obj, true)
         end

         👴.local_test_obj.attach_to(👴, 5, 0, 0, relative)
         👴.local_test_obj.detach()
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
   if host_indicator > ❌ and local_player != no_player or host_existance_check.is_zero() then 
      for each object with label "hosttarget" do
         current_object.delete()
      end
   end
   -- here we check to see if we've found the local player yet, host & clients
   if local_player != no_player then 
      -- clean up this clients targets if they found they self
      script_widget[0].set_text("")
      if local_player == borbius then
         script_widget[0].set_text("YOU ARE THE ANTI MORB")
      end
      if local_player == morbius then
         script_widget[0].set_text("YOU ARE MORBIUS")
      end

      if host_indicator == ❌ then 
         for each object with label "clienttarget" do
            current_object.delete()
         end
         -- ///////////////////////
         -- // RUBBERBANDING FIX //
         -- ///////////////////////
         -- run rubberbanding only on clients, as hosts will not experience the issue
         👴 = local_player.🍔
         if 👴 == no_object then
            if pos_tracker != no_object then
               pos_tracker.delete()
            end
            if prev_pos_tracker != no_object then
               prev_pos_tracker.delete()
            end
         end
         if 👴 != no_object then
            temp_obj3 = 👴.place_between_me_and(👴, hill_marker, 0)
            local_player.tick_distance = temp_obj3.get_distance_to(pos_tracker)
            temp_obj3.delete()
            if pos_tracker == no_object then
               pos_tracker = 👴.place_between_me_and(👴, hill_marker, 0)
               local_player.tick_distance = 0
            end
            if prev_pos_tracker == no_object then
               prev_pos_tracker = pos_tracker.place_between_me_and(pos_tracker, hill_marker, 0)
            end
            if pos_tracker != no_object then
               temp_obj3 = local_player.get_vehicle()
               if local_player.tick_distance > 15 and temp_obj3 == no_object then
                  alias extrapolated_dist_obj = temp_obj6
                  client_corrections += 1
                  --
                  -- calculate position of where the player should be
                  basis = prev_pos_tracker
                  lookat_obj = pos_tracker
                  offset_scale = prev_pos_tracker.get_distance_to(pos_tracker)
                  offset_scale += local_player.last_tick_distance -- this is so we extrapolate their distance, so they dont go slow when client postion overriding
                  -- DEBUG
                  --temp_obj0 = basis.place_between_me_and(basis, flag_stand, 0) -- debug where we last recorded the player position -- red
                  --temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, light_purple , 0)
                  --temp_obj1.set_scale(20)
                  --temp_obj1.copy_rotation_from(temp_obj1, true)
                  --temp_obj1.attach_to(temp_obj0, 0,0,0, relative)
                  -- DEBUG
                  --temp_obj0 = lookat_obj.place_between_me_and(lookat_obj, flag_stand, 0) -- debug the direction we want the player to end up -- white
                  --temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, light_white, 0)
                  --temp_obj1.set_scale(20)
                  --temp_obj1.copy_rotation_from(temp_obj1, true)
                  --temp_obj1.attach_to(temp_obj0, 0,0,0, relative)
                  --
                  basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
                  offset_obj.detach()
                  extrapolated_dist_obj = offset_obj.place_between_me_and(offset_obj, hill_marker, 0)
                  -- cleanup the objects
                  offset_obj.delete()
                  yaw_obj.delete()
                  pitch_obj.delete()
                  -- DEBUG
                  --temp_obj0 = extrapolated_dist_obj.place_between_me_and(extrapolated_dist_obj, flag_stand, 0) -- debug where the player SHOULD end up -- green
                  --temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, light_green, 0)
                  --temp_obj1.set_scale(20)
                  --temp_obj1.copy_rotation_from(temp_obj1, true)
                  --temp_obj1.attach_to(temp_obj0, 0,0,0, relative)
                  --
                  -- determine (via collision check) whether it is necessesary to restrict extrapolated movement, this will not cover cases where they will go through ceilings i think
                  temp_obj5 = extrapolated_dist_obj.place_at_me(hill_marker, none, none, 0,0,0, none)
                  temp_obj5.attach_to(extrapolated_dist_obj, 0,0,3, relative)
                  temp_obj5.detach()
                  temp_obj3 = temp_obj5.place_at_me(fuel_rod_gun, none, none, 0, 0, 0, none)
                  temp_num1 = temp_obj3.get_distance_to(temp_obj5)
                  if temp_num1 > 0 then 
                     extrapolated_dist_obj.attach_to(pos_tracker, 0,0,0, relative)
                     extrapolated_dist_obj.detach()
                     client_failed_corrections += 1
                  end
                  temp_obj3.delete()
                  temp_obj5.delete()
                  -- teleport player to the position we figured out above
                  -- do a quick placement to get the true distance
                  temp_obj3 = 👴.place_between_me_and(👴, hill_marker, 0)
                  offset_scale = temp_obj3.get_distance_to(extrapolated_dist_obj)
                  -- DEBUG
                  --temp_obj0 = temp_obj3.place_between_me_and(temp_obj3, flag_stand, 0) -- debug where the player was going to end up -- red
                  --temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, light_red, 0)
                  --temp_obj1.set_scale(20)
                  --temp_obj1.copy_rotation_from(temp_obj1, true)
                  --temp_obj1.attach_to(temp_obj0, 0,0,0, relative)
                  --
                  temp_obj3.delete()
                  --
                  basis = 👴
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
               if local_player.tick_distance <= 15 then
                  local_player.last_tick_distance = local_player.tick_distance
                  -- only do this within a valid movement
                  prev_pos_tracker.attach_to(pos_tracker, 0,0,0, relative)
                  prev_pos_tracker.detach()
               end

               pos_tracker.attach_to(👴, 0,0,0, relative)
               pos_tracker.detach()
            end
         end
      end
      -- //////////////////////////
      -- // LOCAL CODE EXECUTION //
      -- //////////////////////////
      -- if local_player.ability == surv_abilities.none then
      --    script_widget[1].set_value_text("Ability: None")
      -- end
      -- if local_player.ability == surv_abilities.sentry then
      --    script_widget[1].set_value_text("Ability: Sentry")
      -- end
      -- if local_player.ability == surv_abilities.jammer then
      --    script_widget[1].set_value_text("Ability: Jammer")
      -- end
      -- if local_player.ability == surv_abilities.explosive then
      --    script_widget[1].set_value_text("Ability: Explosive")
      -- end
      -- if local_player.ability == surv_abilities.grapple then
      --    script_widget[1].set_value_text("Ability: Grapple")
      -- end
      -- if local_player.ability == surv_abilities.disguise then
      --    script_widget[1].set_value_text("Ability: Disguise")
      -- end
   end
end

-- //////////////////////////////
-- // MORBIUS SELECTION SCRIPT //
-- //////////////////////////////
-- targets current_player
function morbify()
   morbius.morb_state = morb_states.pre_morb
   morbius.morb_pretimer.reset()
   morbius.morb_weaken_timer.reset()
   morbius.set_round_card_title("")
   morbius.set_round_card_title("ITS MORBIN' TIME")
   game.show_message_to(all_players, none, "%p is about to morb!", morbius)
   -- do a really annoying round title card FOR EVERYONE
   temp_num1 = rand(23)
   for each player do
      if 👽 != morbius then
         👽.set_round_card_title("") -- intentially empty
         -- morbius funnies
         if temp_num1 >= 0 then
         👽.set_round_card_title("\"Rated M for Morbius\" - Dr. Michael Morbius")
         if temp_num1 >= 1 then
         👽.set_round_card_title("\"It's Morbin' time\" - Dr. Michael Morbius")
         if temp_num1 >= 2 then
         👽.set_round_card_title("\"Based off the hit movie: Morbius\" - Dr. Michael Morbius")
         if temp_num1 >= 3 then
         👽.set_round_card_title("\"-25 MORBILLION points to win\" - Dr. Michael Morbius")
         if temp_num1 >= 4 then
         👽.set_round_card_title("\"GET READY FOR A MORBIN GOOD TIME\" - Dr. Michael Morbius")
         if temp_num1 >= 5 then
         👽.set_round_card_title("\"Im gonna morb\" - Dr. Michael Morbius")
         if temp_num1 >= 6 then
         👽.set_round_card_title("\"I. AM. MORBIUS.\" - Dr. Michael Morbius")
         if temp_num1 >= 7 then
         👽.set_round_card_title("\"Perfectly balanced, as all things should be\" - Dr. Michael Morbius")
         if temp_num1 >= 8 then
         👽.set_round_card_title("\"May the Morb be with you.\" - Dr. Michael Morbius")
         if temp_num1 >= 9 then
         👽.set_round_card_title("\"WHAT ARE YA DOIN IN MY SWAMP\" - Dr. Michael Morbius")
         if temp_num1 >= 10 then
         👽.set_round_card_title("\"I need more random popup suggestions\" - Dr. Michael Morbius")
         if temp_num1 >= 11 then
         👽.set_round_card_title("\"I'll be back.\" - Dr. Michael Morbius")
         if temp_num1 >= 12 then
         👽.set_round_card_title("\"I am your father.\" - Dr. Michael Morbius")
         if temp_num1 >= 13 then
         👽.set_round_card_title("\"To morbfinity and beyond!\" - Dr. Michael Morbius")
         if temp_num1 >= 14 then
         👽.set_round_card_title("\"e = mc²\" - Dr. Michael Morbius")
         -- megalo funnies
         if temp_num1 >= 15 then
         👽.set_round_card_title("\"Make sure to update an object's position when scaling\" - Dr. Michael Morbius")
         if temp_num1 >= 16 then
         👽.set_round_card_title("\"4 widgets X 2 strings X 2 variables allows displaying of 16 \r\n different variables on screen\" - Dr. Michael Morbius")
         if temp_num1 >= 17 then
         👽.set_round_card_title("\"Check out Halocustoms.com for more cool stuff\" - Dr. Michael Morbius")
         if temp_num1 >= 18 then
         👽.set_round_card_title("\"Did you know that you can do gametype modding in Halo: Reach, 4 & 2A?\" - Dr. Michael Morbius")
         if temp_num1 >= 19 then
         👽.set_round_card_title("\"On each object you can nest: 8 numbers, 4 objects, \r\n4 players, 2 teams & 4 timers\" - Dr. Michael Morbius")
         if temp_num1 >= 20 then
         👽.set_round_card_title("\"You cannot have variables nested on more than \r\n256 objects at a time\" - Dr. Michael Morbius")
         if temp_num1 >= 21 then
         👽.set_round_card_title("\"You must store the biped onto an intermediate object\r\nto access its variables\" - Dr. Michael Morbius")
         if temp_num1 >= 22 then
         👽.set_round_card_title("\"\" - Dr. Michael Morbius")
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
         end
      end
   end
end

-- ///////////////////////
-- // PLAYER INITIALIZE //
-- ///////////////////////
for each player do
   if 👽.🍔 != no_object then
      if 👽.existence_check < team_existance_delay then
         👽.existence_check += 1
      end
   end
end


-- ////////////////////////////
-- // HIDE KILLFEED MESSAGES //
-- ///////////////////////////
-- store the owner on everyone's biped
for each player do
   👴 = 👽.🍔
   if 👴 != no_object then
      👴.b_owner = 👽
   end
end
-- check for any players death and attempt to prevent the game from sending a kill feed message
-- then override the killfeed messages with our own
on object death: do
   if killed_object.is_of_type(spartan) or killed_object.is_of_type(elite) then
      alias morbed_player = temp_player0
      morbed_player = killed_object.b_owner
      if morbed_player != no_player then

         morbed_player.morb_state = morb_states.not_morbius

         if killer_player == no_player then
            game.show_message_to(all_players, none, "%p died!", morbed_player)
            if morbed_player == morbius then
               morbius = no_player
            end
         end
         if killer_player != no_player then
            -- morbius got a kill
            if killer_player == morbius and morbed_player != morbius then
               morbius.score += morbius_kill_points
               morbius.morb_weaken_timer.reset()
               if morbed_player != borbius then
                  game.show_message_to(all_players, none, "%p morbed %p!", morbius, morbed_player)
               end
               if morbed_player == borbius then
                  game.show_message_to(all_players, none, "%p morbed the anti-morb!", morbius)
               end
            end
            -- regular death (betrayal)
            if killer_player != morbius and morbius != morbed_player and killer_player != morbed_player then
               killer_player.score += betrayal_points
               if morbed_player != borbius then
                  game.show_message_to(all_players, none, "%p betrayed %p!", killer_player, morbed_player)
               end
               if morbed_player == borbius then
                  game.show_message_to(all_players, none, "%p betrayed the anti-morb!", killer_player)
               end
            end
            -- self death (suicide)
            if killer_player == morbed_player then
               killer_player.score += suicide_points
               if morbed_player != borbius and morbed_player != morbius then
                  game.show_message_to(all_players, none, "%p morbed themself! (epic fail)", morbed_player)
               end
               if morbed_player == morbius then
                  game.show_message_to(all_players, none, "%p morbed themself! (lol, they were morbius but suck)", morbed_player)
               end
               if morbed_player == borbius then
                  game.show_message_to(all_players, none, "the anti-morb no longer wants to hate morbius! (they died)")
               end
            end
            -- morbius was killed
            if morbed_player == morbius and killer_player != morbius then
               if morbed_player != borbius then
                  game.show_message_to(all_players, none, "morbius was outmorbed by %p!", killer_player)
               end
               if morbed_player == borbius then
                  game.show_message_to(all_players, none, "morbius was anti-morbed!")
               end
               --morbius = no_player
               morbius = killer_player
               killer_player.score += morbius_killed_points
               morbify()
            end
         end
         temp_obj0 = killed_object.place_at_me(monitor, none, none, 0,0,0, none)
         killed_object.b_owner.set_biped(temp_obj0)
         temp_obj0.kill(false)
      end
   end
end
-- get a player and make them morbius if no one is morbing
if morbius == no_player and host_existance_check.is_zero() then
   for each player randomly do
      if current_player != borbius then
         👽.morb_state = morb_states.not_morbius
      end
      if 👽.🍔 != no_object and morbius == no_player then
         morbius = 👽
         morbify()
      end
   end
end
-- correct player teams
for each player do
   script_widget[1].set_visibility(current_player, false)
   if 👽.team != team[0] and 👽.existence_check >= team_existance_delay and 👽 != morbius then
      👽.team = team[0]
   end
end
if morbius != no_player then
   -- if morbius not on the right team do
   if morbius.team != team[1] and morbius.existence_check >= team_existance_delay then
      morbius.team = team[1]
   end
   -- morbius weaken timer
   morbius.morb_weaken_timer.set_rate(-100%)
   morbius.🍔.set_waypoint_priority(normal)
   if morbius.morb_weaken_timer <= 40 then
      script_widget[1].set_value_text("YOU ARE SLOWLY DRAINING\r\nMorb someone to recover")
      morbius.apply_traits(weak_morb_traits)
      script_widget[1].set_visibility(morbius, true)
      if morbius.morb_weaken_timer <= 20 then
         script_widget[1].set_value_text("YOU ARE DRAINING\r\nMorb someone to recover")
         morbius.apply_traits(weaker_morb_traits)
         if morbius.morb_weaken_timer.is_zero() then
            script_widget[1].set_value_text("YOU ARE RAPIDLY DRAINING\r\nMorb like your life depends on it")
            morbius.apply_traits(weakest_morb_traits)
            morbius.🍔.set_waypoint_priority(blink)
         end
      end
   end
   -- do some morbius stuff, so they know they are the big morb
   morbius.🍔.set_waypoint_text("MORBIUS")
   morbius.🍔.set_waypoint_visibility(everyone)
   morbius.🍔.set_waypoint_range(0, 999)
   -- clear morbius if they are no longer in the game
   temp_num0 = 0
   for each player do
      if 👽 == morbius then
         temp_num0 = 1
      end  
      -- also while we're here, wipe their waypoints
      if 👽 != morbius and 👽.🍔 != no_object and 👽 != borbius then
         👽.🍔.set_waypoint_visibility(everyone)
         👽.🍔.set_waypoint_priority(normal)
         👽.🍔.set_waypoint_text("")
         👽.🍔.set_waypoint_range(0, 999)
      end
   end
   if temp_num0 == 0 then
      morbius = no_player
   end
   -- if after all that, morbius is invalid, toss the morbius error
   if morbius.🍔 == no_object then
      --game.show_message_to(all_players, none, "Morbius error, no biped (%p)", morbius)
      -- THIS RUNS WHEN MORBIUS HAS MORBED THEMSELF
      morbius = no_player
   end
end

-- incase morbius was given to borbius by random
if borbius == morbius then
   borbius = no_player
end

-- select new borbius
-- get a player and make them morbius if no one is morbing
if borbius == no_player and host_existance_check.is_zero() then
   for each player randomly do
      if 👽.🍔 != no_object and borbius == no_player and current_player != morbius then
         borbius = 👽
         borbius.morb_state = morb_states.pre_morb
         borbius.morb_pretimer.reset()
         borbius.set_round_card_title("")
         borbius.set_round_card_title("HUNT DOWN MORBIUS; YOU ARE THE ANTI MORB!")
         game.show_message_to(all_players, none, "%p HATES MORBIUS!", borbius)
      end
   end
end

if borbius != no_player then
   borbius.apply_traits(borbius_traits)
   -- do some morbius stuff, so they know they are the big morb
   borbius.🍔.set_waypoint_text("THE ANTI-MORB")
   borbius.🍔.set_waypoint_visibility(everyone)
   borbius.🍔.set_waypoint_range(0, 999)
   -- clear morbius if they are no longer in the game
   temp_num0 = 0
   for each player do
      if 👽 == borbius then
         temp_num0 = 1
      end  
   end
   if temp_num0 == 0 then
      borbius = no_player
   end
   -- if after all that, morbius is invalid, toss the morbius error
   if borbius.🍔 == no_object then
      --game.show_message_to(all_players, none, "Morbius error, no biped (%p)", morbius)
      -- THIS RUNS WHEN BORBIUS HAS MORBED THEMSELF
      borbius = no_player
   end
end

for each player do
   temp_obj0 = 👽.get_armor_ability()
   if temp_obj0.is_in_use() and temp_obj0.is_of_type(active_camo_aa) then
      👽.🍔.set_waypoint_visibility(no_one)
   end
end


-- alert users of nearby item
for each object with label "m_item" do
   temp_player0 = current_object.get_carrier()
   if temp_player0 == no_player then
      current_object.set_waypoint_visibility(everyone)
      current_object.set_waypoint_priority(low)
      current_object.set_waypoint_range(0,5)
   end
   if temp_player0 != no_player then
      current_object.set_waypoint_visibility(no_one)
   end
end

-- score end game criteria
for each player do
   if current_player.score <= -25000 then
      game.show_message_to(all_players, none, "%p has reached 25 MORBILLION points", current_player)
      game.end_round()
   end
end
-- timer end game criteria
if game.round_time_limit > 0 and game.round_timer.is_zero() then
   game.end_round()
end


-- ////////////////////////
-- // SURVIVOR ABILITIES //
-- ////////////////////////
-- for each player do
--    👽.aa_cooldown.set_rate(-100%)
--    if not 👽.aa_cooldown.is_zero() then
--       👽.apply_traits(aa_disabled)
--    end
--    if 👽.aa_cooldown.is_zero() then
--       temp_obj0 = 👽.get_armor_ability()
--       if temp_obj0.is_of_type(active_camo_aa) and temp_obj0.is_in_use() then
--          -- they are trying to ability-interact
--          👽.aa_cooldown.reset()
--          -- sentry ability
--          if 👽.ability == surv_abilities.none then
--             temp_obj1 = no_object
--             for each object with label "m_sentry" do
--                if current_object.number[0] == 0 and temp_obj1 == no_object then
--                   temp_obj1 = current_object
--                   current_object.number[0] = 1
--                end
--             end
--             -- revert script if failed
--             if temp_obj1 == no_object then
--                game.show_message_to(👽, none, "Missing object; ability failed")
--             end
--             if temp_obj1 != no_object then
--                temp_obj2 = 👽.🍔.place_at_me(bomb, "a_sentry", none, 0,0,0, none) -- the pocket turret
--                temp_obj2.object[0] = 👽.🍔.place_at_me(falcon, none, none, 0,0,0, none) -- reload station 
--                temp_obj2.object[0].set_scale(1)
--                temp_obj2.object[0].copy_rotation_from(temp_obj2.object[0], true)
--                -- strip all the extra stuff off of the falcon
--                temp_num1 = 0
--                for each object do
--                   temp_num0 = current_object.get_distance_to(temp_obj2.object[0])
--                   if temp_num0 == 0 and current_object != temp_obj2.object[0] then
--                      temp_num1 += 1
--                      if temp_num1 == 1 then
--                         current_object.set_scale(1)
--                         current_object.detach()
--                         current_object.copy_rotation_from(current_object, true) -- potentially unneeded
--                         current_object.attach_to(temp_obj2.object[0], 0,0,0, relative)
--                      end
--                      if temp_num1 > 1 then
--                         current_object.delete()
--                      end
--                   end
--                end
--                -- configure decoration
--                temp_obj2.object[1] = temp_obj1
--                temp_obj2.object[1].set_scale(17)
--                temp_obj2.object[1].copy_rotation_from(temp_obj2.object[1], true)
--                -- stick it all together
--                temp_obj2.object[1].attach_to(temp_obj2, 0,0,1, relative)
--                temp_obj2.object[0].set_shape(cylinder, 10, 10, 10)
--                temp_obj2.object[0].attach_to(temp_obj2, 0,0,1, relative)
--             end
--          end
--       end
--    end
-- end

--for each object with label "a_sentry" do
--   if current_object.player[0] == no_player then
--      for each player do
--
--      end
--
--   end
--
--
--end
