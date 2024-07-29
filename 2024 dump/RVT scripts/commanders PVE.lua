-- NOTE: map can be found on my fileshare, my gamertag: "Gamergotten"

-- ######################
-- ### GLOBAL ALAISES ###
-- ######################
alias SPARTANS = team[0]
alias ELITES   = team[1]

-- ##########################
-- ### INVASION VARIABLES ###
-- ##########################
alias   INV_objective_contested  = global.number[7]
alias   INV_phase                = global.number[8]
declare INV_objective_contested   with network priority high
declare INV_phase                 with network priority local = 1

alias   INV_core = global.object[11]
declare INV_core with network priority local

alias   INV_flag_carrier = global.player[2]
alias   INV_last_carrier = global.player[3]
declare INV_flag_carrier with network priority local
declare INV_last_carrier with network priority local

alias   INV_suddendeath_vo_timer   = global.timer[0]
alias   INV_game_end_delay         = global.timer[1]
alias   INV_vo_attack_timer        = global.timer[2]
alias   INV_vo_core_held_timer     = global.timer[3]
declare INV_suddendeath_vo_timer = 35
declare INV_game_end_delay       = 5
declare INV_vo_attack_timer      = 11
declare INV_vo_core_held_timer   = 3

-- for the 'INV_core' object
alias has_moved    = object.number[0]
alias reset_timer  = object.timer[1] -- could be reused as a global timer since theres only 1 core!!
alias bump_timer   = object.timer[3] -- bing bing booing booing, for when core gets stuck and we need to let players grab it still??
declare object.reset_timer = 45

-- for the 'inv_objective' labelled objects
alias sounder      = object.object[0]
alias cap_timer    = object.timer[0]
declare object.cap_timer = script_option[0]

alias INV_phase_duration = 240
alias INV_territory_regen = 7


-- ###########################
-- ### TEMPORARY VARIABLES ### 
-- ###########################
alias temp_num0 = global.number[0]
alias temp_num1 = global.number[2]
alias temp_num2 = global.number[3]
alias temp_num3 = global.number[4]
alias temp_num4 = global.number[6]
declare temp_num0 with network priority local
declare temp_num1 with network priority local
declare temp_num2 with network priority local
declare temp_num3 with network priority local
declare temp_num4 with network priority local

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[5]
alias temp_obj3 = global.object[6]
alias temp_obj4 = global.object[7]
alias temp_obj5 = global.object[13]
declare temp_obj0 with network priority local
declare temp_obj1 with network priority local
declare temp_obj2 with network priority local
declare temp_obj3 with network priority local
declare temp_obj4 with network priority local
declare temp_obj5 with network priority local

alias temp_player0 = global.player[1]
declare temp_player0 with network priority local

alias temp_team0 = global.team[0]
declare temp_team0 with network priority local

alias team_num0 = team.number[0]
alias ai_count  = team.number[1]
declare team.team_num0 with network priority local
declare team.ai_count  with network priority local

-- ########################
-- ### PLAYER VARIABLES ###
-- ########################
alias local_finder         = player.object[0] -- monitor to trigger crosshair (only used off-host & before local player code runs)
--alias platform             = player.object[0] -- the 1x1 beneath the player during top down mode (only used during top down state)
alias restore_biped        = player.object[0] -- the players biped when their controls get yoinked to help out an AI and give them a team
alias player_vehicle       = player.object[1] -- used to cache player vehicle so we dont have to call the action a bunch + 
--alias station              = player.object[1] -- the station the player has visited and been prompted to hologram to interact with (only used during hologram/interact states)
--alias location             = player.object[2] -- replicate player location to clients
--alias last_weapon          = player.object[3] -- 3nd player based object when in hologram table mode thing
alias state                = player.number[0] -- the monitor interaction state the player is currently in
alias init_ticks           = player.number[1] -- for our per player invasion intro
alias stored_ability       = player.number[2] -- used for when we need a diff ability on our players??
alias class                = player.number[3] -- so far only used to tell whether the player is a medic or not!!
--alias stowables_disabled   = player.number[4] -- blocks stowables while near command station or in a drop pod??
--alias is_in_droppod        = player.number[5] -- so we can give the player back their ability after exiting pod
alias class_disabled       = player.number[6] -- so we can sync class disabled text to clients, as well as prevent ability usage
alias in_spawn             = player.number[7] -- so AI can easily tell whether this player is available for borrowing
alias no_ability_timer     = player.timer[0]  -- used to prevent abilities from firing off multiple times without user letting go
alias grenade_regen_timer  = player.timer[1]
alias illegal_target_timer = player.timer[2]
alias available_for_yoinking_timer = player.timer[3]
--alias prevent_stow_timer   = player.timer[3]
declare player.local_finder         with network priority local
--declare player.station              with network priority low -- so we can read data for context widget
--declare player.location             with network priority high
--declare player.last_weapon          with network priority local
declare player.state                with network priority local
declare player.init_ticks           with network priority local
declare player.stored_ability       with network priority local
declare player.class                with network priority local 
--declare player.stowables_disabled   with network priority local 
--declare player.is_in_droppod        with network priority local
declare player.class_disabled       with network priority local

declare player.no_ability_timer     = 1
declare player.grenade_regen_timer  = 30
declare player.illegal_target_timer = 1
declare player.available_for_yoinking_timer = 2
--declare player.prevent_stow_timer   = 1
-- player.location variables
--alias og_biped             = object.object[0]
--alias tracked_player       = object.player[0]
-- player.STATION variables
-- ORDNANCE DEPRECATED --
-- COMMAND DEPRECATED --
--alias dropship_index      = object.number[7]
--alias ordnance_type       = object.number[7]
--alias controlled_dropship = object.object[0]
--alias current_droppod_pos = object.object[1] -- misleading name, its the 'holo_spawn' marker that it puts players at, it needs to track this so it can tell when the player leaves the boundary (we need to move this variable to the player ojbect!!)
--alias current_operator    = object.player[0] -- used to deny other players from also controlling a station (except drop pod station)
--alias ordnance_timer      = object.timer[1] 
--alias dropship_station   = 0
--alias AI_station         = 1
alias droppod_station    = 2
--alias ordnance_station   = 3
-- player.biped variables
alias bpd_init = object.number[0]
alias is_illegal_target = object.number[1]
alias bpd_OS_socket = object.object[0]
alias bpd_OS_visual = object.object[1]



--enum player_states
alias none_ = 0
alias hologram_to_interact = 1
alias controlling_hologram = 2
alias assigning_ai_team = 3
--enum player_class
alias no_class = 0
alias medic = 1
--alias spartan_medic   = 1
--alias elite_medic   = 2


-- ########################
-- ### OBJECT VARIABLES ###
-- ########################
declare object.object[0] with network priority local
declare object.object[1] with network priority local
declare object.object[2] with network priority local
declare object.object[3] with network priority high

declare object.number[0] with network priority local
declare object.number[1] with network priority local
declare object.number[2] with network priority local
declare object.number[3] with network priority local
declare object.number[4] with network priority local
declare object.number[5] with network priority local
declare object.number[6] with network priority local
declare object.number[7] with network priority high   -- used by the station to allow non hosts to tell what mode they're in

declare object.player[0] with network priority local
declare object.player[1] with network priority local
declare object.player[2] with network priority local
declare object.player[3] with network priority high

declare object.team[0] with network priority high


-- ########################
-- ### GLOBAL VARIABLES ###
-- ########################
alias is_host              = global.number[1]
alias local_player_        = global.player[0]
alias default_yaw          = global.object[2]
alias default_pitch        = global.object[8]
alias prong_left           = global.object[9]
alias prong_rght           = global.object[10]
declare is_host               with network priority local 
declare local_player_         with network priority local
declare default_yaw           with network priority high
declare default_pitch         with network priority high
declare prong_left            with network priority local
declare prong_rght            with network priority local


alias holo_local_marker = global.object[3]
alias holo_local_weapon = global.object[4]
declare holo_local_marker  with network priority local
declare holo_local_weapon  with network priority local

alias ai_spawn_interval_timer   = global.timer[4]
alias ai_droppod_interval_timer = global.timer[5]
alias dropship_initial_wait_timer = global.timer[6]
declare ai_spawn_interval_timer = 1
declare ai_droppod_interval_timer = 3
declare dropship_initial_wait_timer = 28

-- pick out the pelican that will stick around to be pick up the core
alias pickup_pelican = global.object[14]
declare pickup_pelican with network priority local

--alias context_wgt_obj      = global.object[12]
--declare context_wgt_obj       with network priority local 

-- ######################
-- ### SCRIPT WIDGETS ###
-- ######################
alias INV_under_attack_widget = script_widget[0]
alias stowed_weapon_wgt       = script_widget[1]
alias medic_widget            = script_widget[2]
alias medic_disabled_widget   = script_widget[3]

-- #####################
-- ### PLAYER TRAITS ###
-- #####################
--alias hologram_traits = script_traits[0]
--alias no_abilities_traits = script_traits[1] -- also used for invincibility??
alias INV_flag_traits = script_traits[0]
alias infinite_ammo_traits = script_traits[1]
alias spartan_traits = script_traits[2]
alias elite_traits = script_traits[3]


-- ###############################
-- ### STRAGGLERS (FU ALIASES) ###
-- ###############################
-- (these are redeclarations of the aliases later in the script, so above code can access them)
alias ai_state = object.number[1]
alias ai_looking_for_dropship = 0
alias ai_boarding_droppod     = 1
alias ai_deploying            = 2
alias ai_deployed             = 3
alias ai_biped   = object.object[3]


------------------
-- player teams --
------------------
for each player do
   current_player.team = SPARTANS
end


---------------------------------
-- BASIC CONFIGURATIONS SCRIPT --
---------------------------------
-- & widgets
do
   is_host += 1 -- this also doubles as a tick thing that we can % to run things like every second tick and whatever
   stowed_weapon_wgt.set_text("STOWED WEAPON")
   medic_widget.set_text("MEDIC: throw healthkits")
   medic_widget.set_meter_params(timer, local_player.grenade_regen_timer)
   medic_disabled_widget.set_text("MEDIC: ability disabled\r\ntry swapping weapons")
   ai_spawn_interval_timer.set_rate(-500%)
   ai_droppod_interval_timer.set_rate(-125%)
   dropship_initial_wait_timer.set_rate(-100%)
end
for each player do 
   --context_wgt0.set_visibility(current_player, true)
   -- show medic widgets (this will probably be a tick late!!)
   medic_widget.set_visibility(current_player, false)
   medic_disabled_widget.set_visibility(current_player, false)
   if current_player.class == medic then
      medic_widget.set_visibility(current_player, true)
      if current_player.class_disabled == 1 then
         medic_widget.set_visibility(current_player, false)
         medic_disabled_widget.set_visibility(current_player, true)
      end
   end
end
------------------------------------------------
-- SETUP DEFAULT OREINTATION OBJECT REFERENCE --
------------------------------------------------
-- TODO: we could potentially skip the need for an object get??
if default_yaw == no_object then
   temp_obj0 = get_random_object("holo_spawn", no_object)
   default_pitch = temp_obj0.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0)
   -- TODO: make default_pitch preplaced on forge by using the holospawn object? idk
   default_yaw = default_pitch.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   default_yaw.face_toward(default_yaw, 0,-1,0)
   prong_left = default_pitch.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   prong_rght = default_pitch.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
end
--------------------------------------
-- SETUP PLAYER ORIENTATION OBJECTS --
--------------------------------------
-- COMMAND DEPRECATED --
   -- for each player do
   --    if current_player.location == no_object and current_player.biped != no_object then
   --       temp_obj0 = current_player.biped.place_at_me(sound_emitter_alarm_2, "player_tracker",none, 0,0,0,none)
   --       temp_obj0.tracked_player = current_player
   --       current_player.location = temp_obj0
         
   --       -- TODO: debug stuff
   --       temp_obj3 = current_player.biped.place_at_me(covenant_power_core, none, none, 15,0,10,default)
   --       temp_obj3 = current_player.biped.place_at_me(covenant_power_core, none, none, 15,10,10,default)
         
   --    end
   -- end
   ---------------------------
   -- DISABLE ABILITY TIMER --
   --------------------------
   -- for each player do
   --    current_player.no_ability_timer.set_rate(-100%)
   --    -- also apply invincibilty because it bugs out and kills us once we leave the command top down view
   --    current_player.biped.set_invincibility(0)
   --    if not current_player.no_ability_timer.is_zero() then -- or current_player.state == controlling_hologram then
   --       current_player.biped.set_invincibility(1)
   --       if not current_player.no_ability_timer.is_zero() then
   --          current_player.apply_traits(no_abilities_traits)
   --       end
   --    end
   -- end

   ------------------------------
   -- PLAYER LEFT GAME CHECKER --
   ------------------------------
   -- COMMAND DEPRECATED --
   -- clear out player from station if they leave?? (TODO: this should be a redundant feature)
   -- for each object with label "player_tracker" do
   --    temp_player0 = current_object.current_operator
   --    for each player do
   --       if current_player == current_object.current_operator then
   --          temp_player0 = no_player
   --       end
   --    end
   --    if temp_player0 != no_player then
   --       game.show_message_to(all_players, none, "%p has been cleaned up", temp_player0)
   --       -- cleanup all the players extra junk
   --       current_object.og_biped.delete()
   --       temp_player0.biped.delete()
   --       temp_player0.platform.delete()
   --       -- clear station operator if they were in one
   --       temp_obj0 = temp_player0.station
   --       temp_obj0.current_operator = no_player
   --       -- then terminate the tracker
   --       current_object.delete()
   --    end
   -- end
-- END OF SECTION ------------------------------------------------------------------------------------------------


----------------------------------
-- PLAYER VEHICLE GETTING STUFF --
----------------------------------
for each player do
   current_player.player_vehicle = current_player.get_vehicle()
   if current_player.biped != no_object then 
      for each object with label "dropship" do
         temp_num0 = current_player.biped.get_distance_to(current_object)
         if temp_num0 == 0 then
            current_player.player_vehicle = current_object
         end
      end
      for each object with label "droppod" do
         temp_num0 = current_player.biped.get_distance_to(current_object)
         if temp_num0 == 0 then
            current_player.player_vehicle = current_object
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------


---------------------
-- SETUP DROPSHIPS --
---------------------
alias dropship_state  = object.number[0]
alias current_speed   = object.number[1]
alias is_returning    = object.number[2]
alias ai_passengers   = object.number[3]
alias yaw_helper      = object.object[0]
alias dest1           = object.object[1]
alias dest2           = object.object[2] 
alias cargo           = object.object[3]
alias standby_timer   = object.timer[2]
alias cargo_timer     = object.timer[3]
declare object.standby_timer = 5
declare object.cargo_timer = 5
-- enum dropship_states
alias uninitialized  = 0
alias at_home        = 1
--alias standby        = 1 -- general not doing anything or moving to location state
alias en_route       = 2
--alias parking        = 3 -- used to interp fixup rotation
alias nose_fixup     = 3 -- used to interp fixup rotation
alias dropping_off   = 4 -- used when pelican parks near players, just let it sit there for a bit so players can do their thing
-- 'yaw_helper' variables
alias pitch_helper  = object.object[0]
alias dir_helper = object.object[1]
alias home_location = object.object[2]
--alias parent_dropship = object.object[3]
alias rotation_correction = object.object[3]
-- 'dest' variables (dest1/2)
alias gravity_obj = object.object[0]

-- dropship constants
alias max_speed             = 410
alias min_parking_speed     = 15
alias dest_reached_distance = 30
alias middle_dest_reached_distance = 80
alias rotate_before_movement_ticks = -260 -- this also gives us this many ticks of the dropship raising from the ground
alias raise_speed = 40
alias max_ai_passengers = 4
-- dropship new destination constants
--alias max_single_dest_dist  = 400
--alias min_dest_dist         = 50
alias descend_ticks = -100

alias min_dest_dropoff_dist = 260
alias rand_dest_dropoff_dist = 170


-- function recurs_DownardsCollisionCast()
   --    temp_obj1 = temp_obj0.place_at_me(pickup_truck, none, none, 0,0,0,none)
   --    temp_num1 = temp_obj0.get_distance_to(temp_obj1)
   --    if temp_num1 <= 4 then
   --       temp_obj0.attach_to(temp_obj1, 0,0,-8, absolute)
   --       temp_obj0.detach()
   --    end
   --    temp_obj1.delete()
   --    if temp_num1 <= 4 then -- continue search
   --       temp_num0 -= 1
   --       if temp_num0 > 0 then
   --          recurs_DownardsCollisionCast()
   --       end
   --    end
   -- end
   -- function DownwardsCollisionCast() -- returns temp_obj0 as the position
   --    temp_num0 = 60
   --    temp_obj0 = temp_obj2.place_at_me(hill_marker, none, none, 0,0,-50, none)
   --    recurs_DownardsCollisionCast()
   -- end
   -- INPUTS
   --alias target_dropship = temp_obj1
   --alias new_dest        = temp_obj0
function set_dropship_destination()
   -- setup bomb object
   temp_obj0.set_invincibility(1)
   temp_obj0.set_pickup_permissions(no_one)
   temp_obj0.set_scale(1)

   --if current_object.dropship_state != uninitialized then
      -- true if we're in parking or dropping off mode
      -- or if we're in standby mode and we dont have a destination
      -- if target_dropship.dropship_state != standby or target_dropship.dest1 == no_object then
      current_object.current_speed = rotate_before_movement_ticks
      --    -- forces us out of parking mode and back into moving mode
      --    if target_dropship.dropship_state == parking then
      --       target_dropship.dropship_state = standby
      --    end 
      -- end

      current_object.dropship_state = en_route
      --target_dropship.dest1.delete()
      --target_dropship.dest2.delete()

      -- = temp_obj0 --.place_at_me(sound_emitter_alarm_2, none, none,  0,0,10,none)
      --target_dropship.dest1 = new_dest
      --temp_num0 = current_object.get_distance_to(temp_obj0)

      --if temp_num0 < min_dest_dist then 
      --   target_dropship.dest1.delete() 
      --   game.show_message_to(all_players, none, "Too close!! %n units", temp_num0)
      --end
      --if temp_num0 >= min_dest_dist then 
      --   -- if the distance is too great, then break it up into chunks?
      --   if temp_num0 > max_single_dest_dist then
            current_object.dest2 = current_object.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0)
            --temp_obj1 = current_object.dest2.place_at_me(sound_emitter_alarm_2, none, none,  0,0,127,none) -- spawn so we can boost the object further up
            current_object.dest1 = current_object.dest2.place_at_me(sound_emitter_alarm_2, none, none,  0,0,127,none)
            --temp_obj1.delete()
            temp_obj1 = current_object.dest2
            temp_obj1.gravity_obj = temp_obj0
            --temp_obj0.delete()
      --   end
      --end
   --end
   -- cleanup middle point if our destination is too close so we dont miss the target
   temp_num0 = current_object.get_distance_to(temp_obj0)
   if temp_num0 < 550 then
      current_object.dest1.delete()
      current_object.dest1 = current_object.dest2
      current_object.dest2 = no_object
   end

   -- DEWBUG setup temp waypoint
   --temp_obj0.set_waypoint_text("%n", hud_target_object.number[6])
   --temp_obj0.set_waypoint_visibility(everyone)
   --temp_obj0.number[6] = temp_num0
end
function dropship_reached_destination()
   temp_obj5.gravity_obj.delete() -- clear the bomb gravity object from our dest if it had one
   current_object.dest1.delete()
   current_object.dest1 = current_object.dest2
   current_object.dest2 = no_object -- probably not needed?? condiitons would need some reworking though
   if current_object.dest1 == no_object then
      --game.show_message_to(all_players, none, "destination reached")
      -- perform basic parking if we were just moving
      --if current_object.dropship_state == en_route then
         current_object.dropship_state = nose_fixup
         current_object.dest1 = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none) -- placeholder object so the other code runs that adjusts the thingo location
      --end 
   end
end
-- inputs
alias obj_to_move = temp_obj1
alias direction_obj = temp_obj0
function get_direction()
   prong_left.detach()
   prong_rght.detach()
   temp_num0 = prong_left.get_distance_to(direction_obj)
   temp_num1 = prong_rght.get_distance_to(direction_obj)
end
function interpt_rotation_pitch() -- run this after the yaw interp!!!!
   -- if the yaw rotation we just ran showed the object behind us, then dont rotate on pitch!!!
   if temp_num0 != -1 then 
      prong_left.attach_to(obj_to_move.dir_helper, 0,0,-8, relative)
      prong_rght.attach_to(obj_to_move.dir_helper, 0,0, 8, relative)
      get_direction()
      if temp_num0 != temp_num1 then -- we dont have to worry about accounting for backwards stuff because it'll just work
         -- turn down
         obj_to_move.pitch_helper.face_toward(obj_to_move.pitch_helper, 127, 1,0) 
         if temp_num1 < temp_num0 then -- turn up
            obj_to_move.pitch_helper.face_toward(obj_to_move.pitch_helper, 127,-2,0) 
         end 
      end
   end
end
-- inputs: temp_num2 -- rotation count
function recurse_interp_rotation_yaw()
   if temp_num2 > 0 then
      temp_num2 -= 1
      -- turn left
      obj_to_move.face_toward(obj_to_move, 127,-1,0) 
      if temp_num1 <= temp_num0 then  -- turn right (twice as much to account for the left turn)
         obj_to_move.face_toward(obj_to_move, 127, 2,0) 
      end
      recurse_interp_rotation_yaw()
   end
end
function interp_rotation_yaw() -- this function has to be inlined anyway!!
   -- process left/right direction
   prong_left.attach_to(obj_to_move, 8,-4,0, relative)
   prong_rght.attach_to(obj_to_move, 8, 4,0, relative)
   get_direction()
   temp_num3 = obj_to_move.get_distance_to(direction_obj)
   if temp_num3 <= temp_num0 and temp_num3 <= temp_num1 then -- TODO: im pretty sure we can optimize this
      temp_num0 = -1 -- so the lenghts are not equal, and so right isn't closer
   end
   if temp_num0 != temp_num1 then
      recurse_interp_rotation_yaw()
   end
end
-- NOTE: you have to multiply the inputs by 2.216613958442163 to actually get the degrees you want (IE. to input 90 degrees you need to set the number variable to 199)
-- ALSO NOTE: this rotates in either diretion, determined randomly (why would we only need to randomly rotate in a single direction??)
alias min_degrees = temp_num0
alias rand_degrees = temp_num2
function rotate_random()
   rand_degrees = rand(rand_degrees)
   rand_degrees += min_degrees
   temp_num1 = rand(2) -- which direction to turn
   min_degrees = 0 -- because this is used with the thing
   recurse_interp_rotation_yaw()
end
-- MOVEMENT STUFF --
function move_offs()
   temp_obj0.set_scale(temp_num0)
   temp_obj0.copy_rotation_from(temp_obj0, true)
   obj_to_move.detach()
   temp_obj0.delete()
end
function offset_upward()
   if temp_num0 > 0 then
      temp_obj0 = obj_to_move.place_between_me_and(obj_to_move, sound_emitter_alarm_2, 0)
      temp_obj0.copy_rotation_from(current_object, true)
      obj_to_move.attach_to(temp_obj0, 0,0,1,relative)
      move_offs()
   end
end
function offset_downward()
   if temp_num0 > 0 then
      temp_obj0 = obj_to_move.place_between_me_and(obj_to_move, sound_emitter_alarm_2, 0)
      temp_obj0.copy_rotation_from(obj_to_move, true)
      obj_to_move.attach_to(temp_obj0, 0,0,-1,relative)
      move_offs()
   end
end
function offset_forward()
   if temp_num0 > 0 then
      temp_obj0 = obj_to_move.place_between_me_and(obj_to_move, sound_emitter_alarm_2, 0)
      temp_obj0.copy_rotation_from(current_object, true)
      obj_to_move.attach_to(temp_obj0, 1,0,0,relative)
      move_offs()
   end
end
-- INIT DROPDHIPS --
for each object with label "dropship" do
   -- if pelican isn't initialized
   if current_object.dropship_state == uninitialized then
      current_object.dropship_state = at_home
      
      temp_obj0 = current_object.place_between_me_and(current_object, flag_stand, 0)
      current_object.yaw_helper = temp_obj0
      --temp_obj0.parent_dropship = current_object
      temp_obj0.pitch_helper = current_object.place_between_me_and(current_object, flag_stand, 0)
      current_object.yaw_helper.copy_rotation_from(default_yaw, true)
      temp_obj0.pitch_helper.attach_to(current_object.yaw_helper, 0,0,0,relative)
      current_object.yaw_helper.copy_rotation_from(current_object, false)
      -- this will flatten out the facing direction
      temp_obj0.dir_helper = current_object.yaw_helper.place_at_me(flag_stand, none, none, 0,0,0,none)
      temp_obj0.dir_helper.copy_rotation_from(current_object.yaw_helper, true)
      temp_obj0.dir_helper.attach_to(temp_obj0.pitch_helper, 0,0,0,relative)
      -- then create basically a duplicate that we can correct the weird rotation stuff from??
      temp_obj0.rotation_correction = current_object.yaw_helper.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
      temp_obj0.rotation_correction.copy_rotation_from(current_object.yaw_helper, true)
      temp_obj0.rotation_correction.attach_to(temp_obj0.pitch_helper, 0,0,0,relative)

      -- mark home location
      temp_obj0.home_location = current_object.yaw_helper.place_at_me(flag_stand, none, none, -40,0,-8,none)
      temp_obj0.home_location.copy_rotation_from(current_object, true) -- probably redundant
      --temp_obj0.home_location.attach_to(current_object.yaw_helper, -40, 0,-8, relative) -- this is gravity checked anyway
      --temp_obj0.home_location.detach()

      -- fixup visual placement 
      if current_object.team == ELITES then -- spirit
         current_object.attach_to(temp_obj0.dir_helper, 28,0,-26,relative)
         -- slap some seats on there
         temp_obj1 = current_object.place_at_me(mongoose, none, none, 0,0,0,none)
         temp_obj1.attach_to(current_object, 0, 25,13,relative)
         temp_obj1 = current_object.place_at_me(mongoose, none, none, 0,0,0,none)
         temp_obj1.attach_to(current_object, 0,-25,13,relative)
      end
      if current_object.team == SPARTANS then -- pelican
         current_object.attach_to(temp_obj0.dir_helper, -20,0,-12,relative)
      end
   end
end
-- COMPLETE STANDBY MODE --
for each object with label "dropship" do
   if current_object.dropship_state == dropping_off then
      current_object.standby_timer.set_rate(-200%)
      if current_object.standby_timer.is_zero() then
         -- dont return if we're selected to wait for the carrier
         if current_object.is_returning == 0 and current_object != pickup_pelican then -- we need to start the return trip
            temp_obj0 = current_object.yaw_helper
            temp_obj0 = temp_obj0.home_location.place_at_me(bomb, none, none, 0,0,30,none)
            current_object.is_returning = 1
            set_dropship_destination()
         end
      end
   end
end
function get_random_objective()
   --temp_obj0 = no_object -- unneeded
   for each object do -- just so it iterates a large number of times
      if temp_obj0.spawn_sequence != INV_phase then
         temp_obj0 = get_random_object("inv_objective", temp_obj0)
      end
   end

end

-- if dropship at home, wait for passengers and then go go
for each object with label "dropship" do
   current_object.set_waypoint_visibility(everyone)
   current_object.set_waypoint_range(0,15)
   current_object.set_waypoint_priority(low)
   current_object.yaw_helper.set_waypoint_text("DOCK VEHICLE")
   current_object.yaw_helper.set_waypoint_visibility(no_one)
   current_object.yaw_helper.set_waypoint_range(0,15)
   if current_object.dropship_state == at_home then
      temp_obj0 = current_object
      temp_num0 = -1
      for each player do
         if current_player.biped != no_object and temp_num0 != 0 then
            temp_num0 = temp_obj0.get_distance_to(current_player.biped) 
         end
      end
      for each object with label "AI" do
         if current_object.ai_biped != no_object and temp_num0 != 0 then
            temp_num0 = temp_obj0.get_distance_to(current_object.ai_biped) 
         end
      end
      
      current_object.set_waypoint_text("DROPSHIP")
      -- if theres at least one guy in passenger of the dropship, then start countdown
      -- or if this is the dedicated pickup pelican, then call it in
      if temp_num0 == 0 or current_object == pickup_pelican then
         current_object.set_waypoint_text("DEPARTING")
         current_object.set_waypoint_priority(blink)
         current_object.standby_timer.set_rate(-125%)
         if current_object.standby_timer.is_zero() and dropship_initial_wait_timer.is_zero() then
            current_object.is_returning = 0 -- reset this value here
            current_object.set_waypoint_text("")
            -- then generate a new destination
            get_random_objective()
            -- generate position
            temp_obj1 = temp_obj0.place_at_me(sound_emitter_alarm_2, none, none, 0,0,127,none) -- we place it above our thingo so we can collision cast
            temp_obj2 = temp_obj1.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
            temp_obj2.attach_to(temp_obj1, 100,0,0,relative)
            -- rotate position towards dropship with random deviation
            temp_obj1.face_toward(current_object, 0,0,0)
            min_degrees  = 0 
            rand_degrees = 48 -- 22 degrees
            rotate_random() -- spans for a total possible span of 94 degrees, wheres the whole front side would be 180 degrees
            -- extend the position out randomly
            temp_num0 = rand(rand_dest_dropoff_dist)
            temp_num0 += min_dest_dropoff_dist
            temp_obj1.set_scale(temp_num0)
            temp_obj1.copy_rotation_from(temp_obj1, true)
            temp_obj4 = temp_obj1 -- shift around variables so we dont get overlap
            --DownwardsCollisionCast() -- out: temp_obj0 in: temp_obj2
            temp_obj0 = temp_obj2.place_at_me(bomb, none, none, 0,0,127,none)
            temp_obj4.delete()
            set_dropship_destination()
         end
      end
   end
end

-- DROPSHIP DESCENT LOGIC & detach passengers
for each object with label "dropship" do
   if current_object.dropship_state == nose_fixup then
      if current_object.current_speed <= 0 then
         obj_to_move = current_object.yaw_helper
         temp_num0 = raise_speed
         offset_downward()
         if current_object.current_speed == 0 then
            current_object.dropship_state = dropping_off
            current_object.dest1.delete() -- clear the thingo
            current_object.ai_passengers = 0 -- clear the passengers in this guy
            current_object.standby_timer.reset()
            if current_object.cargo != no_object then -- 1 free condition + action
               current_object.cargo.detach()
               current_object.cargo = no_object
            end
            -- exit all our AI and players
            temp_obj0 = current_object
            for each player do
               if current_player.biped != no_object and current_player.state == none_ then -- we have to check that this isn't a possessed AI, because we could possibly detach them and then they wont register as actually being detached
                  temp_num0 = current_player.biped.get_distance_to(temp_obj0)
                  if temp_num0 == 0 then
                     current_player.biped.detach()
                  end
               end
            end
            for each object with label "AI" do
               if current_object.ai_biped != no_object then
                  temp_num0 = current_object.ai_biped.get_distance_to(temp_obj0)
                  if temp_num0 == 0 then
                     --current_object.detach()
                     current_object.ai_biped.detach()
                     current_object.ai_state = ai_deployed
                  end
               end
            end
            if current_object.is_returning == 1 then -- then we just skip straight back to at home state
               current_object.dropship_state = at_home
            end
         end
      end
   end
end
-- DROPSHIP MOVEMENT LOGIC
for each object with label "dropship" do
   if current_object.dest1 != no_object 
   and current_object.dropship_state == en_route or current_object.dropship_state == nose_fixup then 
      obj_to_move = current_object.yaw_helper
      -- update position of ground finder nodes?
      temp_obj5 = current_object.dest1
      if temp_obj5.gravity_obj != no_object then
         temp_obj5.attach_to(temp_obj5.gravity_obj, 0,0,60,relative)
         temp_obj5.detach()
         -- spirits need to park slightly higher!! but they still need to park at normal height for returns, or else no one can get in!
         if current_object.team == ELITES and current_object.is_returning == 0 then
            temp_obj5.attach_to(temp_obj5.gravity_obj, 0,0,75,relative)
            temp_obj5.detach()
         end
      end
      -- we dont do any regular movement if we're descending in nose fixup mode
      if current_object.dropship_state == en_route or current_object.current_speed > 0 then
         --if current_object.dropship_state == en_route or current_object.dropship_state == nose_fixup or current_object.dropship_state == nose_fixup then
         -- this gets cancelled if speed is less than or = to 0, saves nesting into a condition here
         if current_object.dropship_state == nose_fixup then
            current_object.dest1.delete() -- remove previous one and reset
            current_object.dest1 = obj_to_move.place_at_me(sound_emitter_alarm_2, none, none, 127,0,0,none)
            
            if current_object.is_returning == 1 then 
               temp_obj0 = obj_to_move.home_location.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
               temp_obj0.attach_to(obj_to_move, 0,0,0,relative)
               current_object.dest1.attach_to(temp_obj0, 127, 0,0,relative)
               current_object.dest1.detach()
               temp_obj0.delete()
            end
         end
         temp_num0 = current_object.current_speed -- speed input value
         offset_forward()
         -- perform movement
         if current_object.current_speed <= 0 then
            temp_num0 = raise_speed
            offset_upward()
         end
      
         --end
         -- rotate on yaw
         direction_obj = current_object.dest1
         temp_num2 = 2
         interp_rotation_yaw()
         -- rotate on pitch
         obj_to_move.pitch_helper.detach()
         interpt_rotation_pitch()
         obj_to_move.pitch_helper.attach_to(current_object.yaw_helper, 0,0,0,relative)
         -- is fixing up nose, then we check whether the distances were equal?? this could be bad that it only checks for equality on the pitch axis
         if current_object.dropship_state == nose_fixup then
            if current_object.current_speed >= 2 then
               current_object.current_speed -= 2
               --if current_object.is_returning == 1 then
               --   current_object.current_speed = 0
               --end
            end
            if temp_num0 == temp_num1 then
               temp_num2 = 1
               interp_rotation_yaw() -- we need to double check that the yaw axis is also perfect
               if temp_num0 == temp_num1 then
                  current_object.current_speed = descend_ticks
               end
            end
         end

         --skip the middle node if we flew past it and are closer to the last node (also dest2 & dest1 will become the same object after reaching a node for optimizations sake)
         if current_object.dest2 != no_object then
            temp_num2 = current_object.yaw_helper.get_distance_to(current_object.dest2)
            temp_num4 = current_object.dest1.get_distance_to(current_object.dest2)
            if temp_num2 <= temp_num4 then
               dropship_reached_destination()
            end
         end
         -- if close to destination
         if current_object.dropship_state == en_route and temp_num3 <= dest_reached_distance then
            dropship_reached_destination()
         end
      end

      -- accelerate/decelerate when appropratie
      current_object.current_speed += 1
      -- if we dont have a 2nd destination, then we have to slowdown when we get close
      -- or if we're going too fast we also have to slow down??
      if current_object.dropship_state == en_route then
         if current_object.current_speed > 4 then
            if current_object.current_speed > max_speed then
               current_object.current_speed -= 4
            end
            if current_object.dest2 == no_object and current_object.current_speed > min_parking_speed then
               temp_num3 += 25 -- /= 2 -- make the effect start much sooner? 
               if current_object.current_speed >= temp_num3 then
                  current_object.current_speed -= 4
               end
            end
         end
      end
   end
end
-- attach/detach the thingo to fixup rotation
for each object with label "dropship" do
   temp_obj0 = current_object.yaw_helper
   temp_obj0.dir_helper.attach_to(temp_obj0.pitch_helper, 0,0,0,relative)
   temp_obj0.dir_helper.detach()
   temp_obj0.dir_helper.copy_rotation_from(temp_obj0.rotation_correction, true)
end
-- DROPSHIP CARGO LOGIC
for each object with label "dropship" do 
   -- clear cargo data for if we aren't cargoing right now
   current_object.cargo_timer.set_rate(1000%)
   -- we only cargo when at home? and not when moving or any of that, especially not when parked dropping off units on the battlefield
   if current_object.dropship_state == at_home then 
      -- perform checks to see if player is trying to put cargo into the dropship
      for each player do
         current_object.set_progress_bar(object.cargo_timer, mod_player, current_player, 0)
         if current_object.cargo == no_object then
            if current_player.player_vehicle != no_object and not current_player.player_vehicle.has_forge_label("dropship") then
               -- do cargo waypoints to let players know they can attach
               current_object.set_waypoint_visibility(mod_player, current_player, 0)
               current_object.yaw_helper.set_waypoint_visibility(mod_player, current_player, 1)
               if current_object.shape_contains(current_player.player_vehicle) then
                  temp_num0 = current_player.player_vehicle.get_speed()
                  if temp_num0 < 5 then
                     current_object.cargo_timer.set_rate(-500%)
                     current_object.set_progress_bar(object.cargo_timer, mod_player, current_player, 1)
                     if current_object.cargo_timer.is_zero() then
                        current_object.cargo = current_player.player_vehicle
                        if current_object.team == ELITES then 
                           current_object.cargo.attach_to(current_object, 8,0,4,relative)
                        end
                        if current_object.team == SPARTANS then 
                           current_object.cargo.attach_to(current_object, -20,0,8,relative)
                        end
                     end
                  end
               end  
            end
         end
      end
   end
end
-- select dedicated core pickup dropship 
for each object with label "dropship" do
   if INV_phase == 3 and pickup_pelican == no_object and current_object.team == SPARTANS and current_object.dropship_state == at_home then
      pickup_pelican = current_object
   end
end
-- give it the waypoints
do 
   pickup_pelican.set_waypoint_visibility(everyone)
   pickup_pelican.set_waypoint_icon(ordnance)
   pickup_pelican.set_waypoint_priority(high)
   pickup_pelican.set_waypoint_range(0, 350)
   if pickup_pelican.dropship_state == dropping_off then
      pickup_pelican.set_shape_visibility(everyone)
   end
end
-- for each object with label "dropship" do
--    current_object.dest1.set_waypoint_visibility(everyone)
--    current_object.dest2.set_waypoint_visibility(everyone)
-- end
-- END OF SECTION ------------------------------------------------------------------------------------------------


--------------------
-- DROP POD STUFF --
--------------------
alias dp_alive_ticks       = object.number[0]
--alias dp_is_mine           = object.number[1]
alias dp_object_to_detach  = object.object[0]
--alias dp_root              = object.object[1]
alias dp_ai_passenger      = object.object[1]
--alias dp_ground_boundary   = object.object[2]
alias dp_visual            = object.object[3]
alias dp_max_life = 520
alias dp_max_life_next = 521
alias dp_remove_invinc_at = 580
alias dp_ticks_till_garbage = 1000
--alias dp_min_fall_speed = 100
-- covenant droppod prop stuff
alias used_by_droppod = object.number[5]

-- current_object the object to accelerate 
-- temp_num0 iteration count
   -- function ApplyVelocity()
   --    if temp_num0 > 0 then

   --       temp_obj1.attach_to(current_object, -1, 0, 0, relative)
   --       temp_obj1.detach()
   --       current_object.attach_to(temp_obj1, 1, 0, 0, relative)
   --       current_object.detach()

   --       temp_num0 -=1
   --       ApplyVelocity()
   --    end
   -- end
-- inputs: temp_obj1 the location
--         temp_obj4 the object to attach
function create_droppod_at()
   temp_obj0 = temp_obj1.place_at_me(sound_emitter_alarm_2, none, none, 0,-127,0,none)
   temp_obj2 = temp_obj1.place_at_me(bomb, "droppod", none, 0,0,0,none) -- inherit reotations from biped??
   temp_obj2.attach_to(temp_obj0, 0,100,0,relative)
   temp_num0 = rand(255)
   temp_obj0.set_scale(temp_num0) -- note that 0 defaults to offset -127 as it does not scale
   temp_obj0.copy_rotation_from(temp_obj0, true)
   temp_obj2.detach()
   temp_obj0.delete() -- cleaup our randomized location

   -- setup our thing
   temp_obj2.set_invincibility(1)
   temp_obj2.set_pickup_permissions(no_one)
   temp_obj2.copy_rotation_from(temp_obj1, true)
   temp_obj2.dp_object_to_detach = temp_obj4
   temp_obj2.dp_object_to_detach.set_invincibility(1)
   temp_obj2.dp_object_to_detach.attach_to(temp_obj2, 0,0,0,relative)

   -- mark destination
   --DownwardsCollisionCast()
   --temp_obj2.dp_ground_boundary = temp_obj0
   --temp_obj2.dp_ground_boundary.set_shape(cylinder, 32000, 15,15)

   -- create visuals
   if temp_obj4.team == SPARTANS then
      temp_obj2.dp_visual = temp_obj2.place_between_me_and(temp_obj2, oni_van, 0)
      temp_obj2.dp_visual.set_scale(75)
      -- rotate the object so it faces the same direction as the location object??
      temp_obj0 = temp_obj2.place_between_me_and(temp_obj2, sound_emitter_alarm_2, 0)

      temp_obj0.copy_rotation_from(default_yaw, true)
      temp_obj0.face_toward(temp_obj0, 0,1,0)
      temp_obj2.dp_visual.attach_to(temp_obj0, 0,0,0,relative)
      temp_obj0.copy_rotation_from(temp_obj2, true)
      -- detach/cleanup
      temp_obj2.dp_visual.detach()
      temp_obj2.dp_visual.attach_to(temp_obj2, -6,0,-1,relative)
      temp_obj0.delete()
   end
   -- if elite drop pod or ordnance drop pod
   if temp_obj4.team == ELITES then -- or temp_obj4.team == no_team then
      --temp_obj2.set_scale(1)
      --if temp_obj4.team == ELITES then
      for each object with label "droppod" do
         if current_object.team == team[2] and current_object.used_by_droppod == 0 and temp_obj2.dp_visual == no_object then
            current_object.used_by_droppod = 1
            current_object.detach() -- for if it is being reused
            temp_obj2.dp_visual = current_object
            temp_obj2.dp_visual.copy_rotation_from(temp_obj2, true)
            temp_obj2.dp_visual.attach_to(temp_obj2, 0,0,0,relative)
         end
      end
      --end
      -- ORDNANCE DEPRECATED --
         -- if temp_obj4.team == no_team then
         --    temp_obj2.dp_is_mine = 1
         --    if temp_obj2.dp_object_to_detach.is_of_type(landmine) or temp_obj2.dp_object_to_detach.is_of_type(covenant_bomb) then -- mostly unnecessary thing, but if we take this out of the conditon then it further breaks the drop pod if theres no covenant pods to grab
         --       temp_obj2.dp_visual = temp_obj2.dp_ground_boundary -- assign to unkillable object so theres no explosion when the pod opens
         --    end
         -- end
         -- supply drops will use the fusion coil as a model (except landmines)
         --if not temp_obj2.dp_object_to_detach.is_of_type(landmine) and not temp_obj2.dp_object_to_detach.is_of_type(covenant_bomb) then
            --if temp_obj4.team == no_team then
            --   temp_obj2.dp_visual = temp_obj0.place_at_me(fusion_coil, none, suppress_effect, 0,0,10,none)
            --end
            --temp_obj2.dp_visual.copy_rotation_from(temp_obj0, true)
            --temp_obj2.dp_visual.face_toward(temp_obj2.dp_visual, 0,-1,0)
            --temp_obj2.dp_visual.attach_to(temp_obj0, 6,0,0,relative)
         --end
   end
end
-- we actually detach the objects 1 tick after it 'collides' so the detached object has time for velocity to reset???
   -- for each object with label "droppod" do
   --    if current_object.dp_object_to_detach != no_object then
   --       current_object.dp_object_to_detach.set_invincibility(0)
   --       -- if this was an ordnance drop, then we dont need the drop pod shell anymore + it interferes with the landmine and causes it to detonate
   --       -- ORDNANCE DEPRECATED --
   --          --if current_object.dp_is_mine == 1 then -- we dont need a droppod
   --          --   current_object.dp_root.delete()
   --          --end
   --       -- let the AI know that they are out of the pod now!!!
         
   --    end
   -- end

function open_pod()
   if current_object.dp_alive_ticks < dp_max_life_next then
      --current_object.dp_root = current_object.place_at_me(bomb, none, none, 0,0,5,none)
      --current_object.dp_root = current_object.place_between_me_and(current_object, bomb, 0)
      --current_object.dp_root.set_pickup_permissions(no_one)
      -- reset attached object's velocity
      --current_object.dp_object_to_detach.detach() -- potentially redundant
      --current_object.dp_object_to_detach.attach_to(current_object.dp_root, 0,0,0,relative)

      --if current_object.dp_visual == no_object then
      --   current_object.set_invincibility(0)
      --   current_object.kill(false)
      --end
      --current_object.dp_ground_boundary.delete() -- must be deleted after, as the weapon drops use this as a placeholder to prevent the script from creating explosions
      --current_object.dp_visual.detach()
      --current_object.attach_to(current_object.dp_root, 0,0,0,relative)
      -- we only make the van explode if we dont have another visual object thats supposed to do that
      --game.show_message_to(all_players, none, "drop pod disengaged!!")
      --game.show_message_to(all_players, none, "time: %n", current_object.dp_alive_ticks)


      -- update dropped AI's status (if it is an AI)
      temp_obj0 = current_object.dp_ai_passenger
      --if dp_ai_passenger.ai_state == ai_deploying then
      temp_obj0.ai_state = ai_deployed
      --end

      current_object.dp_object_to_detach.detach()
      -- make sure the tick thingo is synced up, so bipeds have their invincibility removed after 60 ticks
      current_object.dp_alive_ticks = dp_max_life_next
      -- explode the thing (we should only explode the oni van, not cove pod)
      --if current_object.dp_visual.is_of_type(oni_van) then 
         current_object.dp_visual.kill(false)
      --end

   end
end
-- exit droppod if it has fallen into the ground
for each object with label "droppod" do
   -- if the thing is still live (all redundant conditions)
   if current_object.team == no_team then -- and current_object.dp_ground_boundary != no_object then
      temp_num0 = current_object.get_speed()
      -- check if the object isn't moving, then count down ticks to explode or something
      --if current_object.dp_ground_boundary.shape_contains(current_object) then
      if temp_num0 == 0 then
         open_pod()
         --game.show_message_to(all_players, none, "drop pod grounded!!")
      --end
      end
   end 
end
-- garbage collect the droppod after 1000 ticks
for each object with label "droppod" do 
   if current_object.team == no_team then
      current_object.dp_alive_ticks += 1
      -- abort the player if they've been stuck in the pod for longer than expected
      if current_object.dp_alive_ticks >= dp_max_life then
         open_pod()
         if current_object.dp_alive_ticks > dp_remove_invinc_at then
            current_object.dp_object_to_detach.set_invincibility(0)
            current_object.dp_object_to_detach = no_object -- kinda redundant but who knows
            if current_object.dp_alive_ticks > dp_ticks_till_garbage then
               -- restore elite pod if we had one
               temp_obj0 = current_object.dp_visual
               if not temp_obj0.is_of_type(oni_van) then --and temp_obj0 != no_object then
                  temp_obj0.detach()
                  temp_obj0.attach_to(default_yaw, 0,0,0,relative) -- yeah just stick it wherever that is
                  temp_obj0.used_by_droppod = 0
               end   
               current_object.delete()
            end
         end
      end
   end
end
-- apply more speed to drop pod if it isn't meeting speed requirements
   -- for each object with label "droppod" do
   --    if current_object.team == no_team and current_object.dp_ground_boundary != no_object then
   --       temp_num0 = current_object.get_speed()
   --       if temp_num0 < dp_min_fall_speed then
   --          game.show_message_to(all_players, none, "speed: %n", temp_num0)


   --          -- create velocity affecting object
   --          temp_obj1 = current_object.place_at_me(sound_emitter_alarm_2, none, suppress_effect, 0, 0, 0, none)
   --          temp_obj1.copy_rotation_from(current_object, true)
   --          --temp_obj1.copy_rotation_from(default_pitch, true)
   --          temp_obj1.face_toward(temp_obj1, -1, 0,0)
   --          temp_num0 = 5
   --          ApplyVelocity()
   --          temp_obj1.delete()
   --       end
   --    end
   -- end
-- apply damage resist to players on droppods (and this will apply for a whole second after they exit!!)
   -- for each player do
   --    for each object with label "droppod" do
   --       if current_object.team == no_team and current_object.dp_object_to_detach == current_player.biped then
   --          current_player.no_ability_timer.reset()
   --       end   
   --    end
   -- end
   -- give players back their ability once they are out of their drop pod??
   -- for each player do
   --    if current_player.is_in_droppod == 1 and current_player.no_ability_timer.is_zero() then
   --       current_player.is_in_droppod = 0
   --       --restore_player_ability() -- so this will happen a second aftr the player exits the pod, and it could cause issues if they also stow a weapon immediately after??
   --    end
   -- end
-- END OF SECTION ------------------------------------------------------------------------------------------------


-------------------------
-- ORDNANCE DROP STUFF --
-------------------------
-- ~30 conditions ~40 actions
   -- function random_UNSC_powerweapon()
   --    temp_num1 = rand(10)
   --    -- 4/10 rocket launcher -- 3/10 sniper -- 2/10 gravity hammer -- 1/10 target locator
   --    if temp_num1 <= 3                   then temp_obj4 = temp_obj1.place_at_me(rocket_launcher, none, none, 0,0,0,none) end
   --    if temp_num1 > 3 and temp_num1 <= 6 then temp_obj4 = temp_obj1.place_at_me(sniper_rifle,    none, none, 0,0,0,none) end
   --    if temp_num1 == 7                   then temp_obj4 = temp_obj1.place_at_me(target_locator,  none, none, 0,0,0,none) end
   --    if temp_num1 > 7                    then temp_obj4 = temp_obj1.place_at_me(gravity_hammer,  none, none, 0,0,0,none) end
   -- end
   -- function random_COVE_powerweapon()
   --    temp_num1 = rand(10)
   --    -- 4/10 fuel rod -- 3/10 focus rifle -- 3/10 plasma_launcher
   --    if temp_num1 <= 3                   then temp_obj4 = temp_obj1.place_at_me(fuel_rod_gun,    none, none, 0,0,0,none) end
   --    if temp_num1 > 3 and temp_num1 <= 6 then temp_obj4 = temp_obj1.place_at_me(focus_rifle,     none, none, 0,0,0,none) end
   --    if temp_num1 > 6                    then temp_obj4 = temp_obj1.place_at_me(plasma_launcher, none, none, 0,0,0,none) end
   -- end
   -- alias DROP_mines = 0
   -- alias DROP_supplies = 1
   -- alias drop_tick_interval = 50
   -- alias drop_max_ticks = 250 -- MAKE THIS A MULTIPLE OF 'drop_tick_interval' (drop_tick_interval / drop_max_ticks = num_of_drops) so it must be at least a multiple of 1

   -- alias drop_mover     = object.object[0]
   -- alias drop_waypoint  = object.object[1]
   -- alias drop_type      = object.number[0]
   -- alias drop_ticker    = object.number[1]
   -- for each object with label "ordnance" do
   --    current_object.drop_ticker += 1
   --    if current_object.drop_ticker > drop_max_ticks then
   --       current_object.drop_mover.delete()
   --       current_object.drop_waypoint.delete()
   --       current_object.delete()
   --    end
   -- end
   -- for each object with label "ordnance" do
   --    temp_num0 = current_object.drop_ticker
   --    temp_num0 %= drop_tick_interval
   --    if temp_num0 == 0 then -- so every 50th tick except the first tick??
   --       temp_obj1 = current_object.drop_mover -- just so this value interfaces with the functions
   --       -- call in whatever type of drop this is
   --       if current_object.drop_type == DROP_mines then
   --          if current_object.team == SPARTANS then
   --             temp_obj4 = temp_obj1.place_at_me(landmine, none, none, 0,0,0,none)
   --             create_droppod_at()  
   --          end
   --          if current_object.team == ELITES then
   --             temp_obj4 = temp_obj1.place_at_me(covenant_bomb, "landmine", none, 0,0,0,none)
   --             --temp_obj4.set_scale(900)
   --             create_droppod_at()  
   --          end
   --       end
   --       if current_object.drop_type == DROP_supplies then
   --          if current_object.team == SPARTANS then
   --             random_UNSC_powerweapon()
   --             create_droppod_at()  
   --          end
   --          if current_object.team == ELITES then
   --             random_COVE_powerweapon()
   --             create_droppod_at()  
   --          end
   --       end
   --       -- move the objects
   --       current_object.drop_mover.attach_to(current_object, 20, 0,0,relative)
   --       current_object.attach_to(current_object.drop_mover, 0, 0,0,relative)
   --    end
   -- end
   -- -- logic for the placed landmines
   -- alias mine_activate_distance = 15
   -- alias mine_closest_distance = object.number[0]
   -- alias mine_timer = object.timer[3] -- 5 seconds
   -- for each object with label "landmine" do
   --    temp_num0 = current_object.get_speed()
   --    if temp_num0 == 0 then
   --       for each player do
   --          if current_object.mine_closest_distance > mine_activate_distance or current_object.mine_closest_distance == 0 and current_player.biped != no_object and current_player.state != controlling_hologram then
   --             current_object.mine_closest_distance = current_object.get_distance_to(current_player.biped)
   --          end
   --       end
   --       if current_object.mine_closest_distance <= mine_activate_distance and current_object.mine_closest_distance > 0 then
   --          current_object.mine_timer.set_rate(-200%)
   --          current_object.set_waypoint_visibility(everyone)
   --          current_object.set_waypoint_range(0, 50)
   --          current_object.set_waypoint_priority(blink)
   --          if current_object.mine_timer.is_zero() then
   --             current_object.kill(false)
   --          end
   --       end
   --    end
   -- end
-- END OF SECTION ------------------------------------------------------------------------------------------------

-----------------------------------
-- NEW SIMPLE DROPPOD ZONE LOGIC --
-----------------------------------
for each object with label "com_station" do
   if current_object.spawn_sequence == droppod_station then
      -- do decorators
      current_object.set_waypoint_visibility(allies)
      current_object.set_waypoint_priority(low)
      current_object.set_waypoint_text("DROP PODS")
      current_object.set_shape_visibility(allies)
      current_object.set_waypoint_range(0, 25)
      -- check if players are in the boundary
      for each player do
         if current_object.team == current_player.team and current_player.state == none_ and current_player.player_vehicle == no_object then
            temp_obj4 = current_player.biped
            if current_object.shape_contains(temp_obj4) then
               for each object with label "holo_spawn" do
                  if current_object.team == current_player.team and current_object.spawn_sequence == INV_phase then
                     -- force any thingo weapon to get stowed??
                     temp_obj1 = current_player.try_get_weapon(primary)
                     if temp_obj1.is_of_type(detached_machine_gun_turret) or temp_obj1.is_of_type(detached_plasma_cannon) then
                        current_player.biped.remove_weapon(primary, false)
                     end

                     temp_obj1 = current_object
                     --current_player.biped.copy_rotation_from(temp_obj3.current_droppod_pos, true) -- we do not care
                     create_droppod_at()
                     --current_player.is_in_droppod = 1
                     --game.show_message_to(current_player, none, "Launching droppod!!") 
                  end
               end
            end
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------

--------------------------------
-- GARBAGE COLLECTION SCRIPTS --
--------------------------------
alias turret_min_prevent_cleanup_range = 30
alias turret_cleanup_timer = object.timer[3] -- 5 seconds
alias body_cleanup_timer = object.timer[3] -- 5 / 2.00 seconds
--alias splaser_min_cleanup_range = 5 -- splasers that are within 5 units of the player will not be cleaned up
for each object do
   -- cleanup deployed turrets
   if current_object.is_of_type(machine_gun_turret) or current_object.is_of_type(plasma_cannon) and current_object.team == ELITES then
      temp_num0 = turret_min_prevent_cleanup_range
      for each player do
         if current_player.biped != no_object and temp_num0 >= turret_min_prevent_cleanup_range then
            temp_num0 = current_player.biped.get_distance_to(current_object)
         end
      end
      -- players are close, reset garbage timer
      if temp_num0 < turret_min_prevent_cleanup_range then 
         current_object.turret_cleanup_timer.reset()
      end
      -- if players are too far away, start countdown and delete
      if temp_num0 >= turret_min_prevent_cleanup_range then
         current_object.turret_cleanup_timer.set_rate(-100%)
         if current_object.turret_cleanup_timer.is_zero() then
            current_object.delete()
            --game.show_message_to(all_players, none, "turret cleaned up!!")
         end
      end
   end
   -- cleanup dead bodies sooner
   if current_object.is_of_type(spartan) or current_object.is_of_type(elite) then
      temp_num0 = current_object.health
      if temp_num0 == 0 then
         current_object.body_cleanup_timer.set_rate(-200%)
         if current_object.body_cleanup_timer.is_zero() then 
            current_object.delete()
            --game.show_message_to(all_players, none, "body cleaned up!!")
         end
      end
   end
end
-- garbage collection logic - which effectively just looks for objects that have since spawned in and deletes them
alias garbage_collect_distance = 20
alias tracked_object = object.object[0]
-- todo: none of these need to be functions (3 free actions)
function prepare_garbage_collect()
   --temp_num1 = 0
   for each object do
      --if temp_obj5 == no_object or current_object.is_of_type(detached_plasma_cannon) then
         if not current_object.is_of_type(sound_emitter_alarm_2) then
            temp_num0 = current_object.get_distance_to(temp_obj1)
            -- prevent nearby bipeds from taking damage
            if current_object.is_of_type(elite) or current_object.is_of_type(spartan) and temp_num0 < 30 then
               current_object.set_invincibility(1)
            end
            if temp_num0 < garbage_collect_distance and temp_num0 > 0 then
               temp_obj2 = current_object.place_at_me(sound_emitter_alarm_2, "garbage_collect", none, 0,0,0,none)
               temp_obj2.tracked_object = current_object
               --temp_num1 += 1
            end   
         end
      --end
   end
   --game.show_message_to(all_players, none, "%n objects in garbage collect area", temp_num1)
end
function garbage_collect()
   --temp_num1 = 0
   for each object do
      -- conditions to reuse this logic for exploding a plasma cannon without invincibility
      --if temp_obj5 == no_object or current_object.is_of_type(detached_plasma_cannon) then
         if not current_object.is_of_type(sound_emitter_alarm_2) then
            temp_num0 = current_object.get_distance_to(temp_obj1)
            -- release invincibility from nearby bipeds
            if current_object.is_of_type(elite) or current_object.is_of_type(spartan) and temp_num0 < 30 then
               current_object.set_invincibility(0)
            end
            if temp_num0 < garbage_collect_distance and temp_num0 > 0 then
               temp_obj2 = current_object
               for each object with label "garbage_collect" do
                  if temp_obj2 == current_object.tracked_object then
                     temp_obj2 = no_object
                  end
               end
               if temp_obj2 != no_object then
                  current_object.delete()
                  --temp_num1 += 1
               end
            end  
         end 
      --end
   end
   --game.show_message_to(all_players, none, "%n objects were garbage collected", temp_num1)
   -- we could do it as we match up objects, but we need to be sure that we delete ALL of these
   for each object with label "garbage_collect" do
      current_object.delete()
   end
end
function cleanup_plasma_turrets()
   for each object do
      if current_object.is_of_type(detached_plasma_cannon) then
         temp_num0 = current_object.get_distance_to(temp_obj1)
         if temp_num0 < 10 and temp_num0 > 0 then
            current_object.delete()
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------


--------------------------
-- PLAYER ABILIT THINJG --
--------------------------
alias aa_unstored = 0
alias aa_none = 1
alias aa_spnt = 2
alias aa_evde = 3
alias aa_lock = 4
alias aa_camo = 5
alias aa_shld = 6
-- excluding hologram & jetpack as neither are used
alias ability = temp_obj2
function store_player_ability()
   if current_player.stored_ability == aa_unstored then
      ability = current_player.try_get_armor_ability()
      -- map player ability type
      current_player.stored_ability = aa_spnt
      if not ability.is_of_type(sprint) then
         current_player.stored_ability = aa_evde 
         if not ability.is_of_type(evade) then
            current_player.stored_ability = aa_lock 
            if not ability.is_of_type(armor_lock) then
               current_player.stored_ability = aa_camo 
               if not ability.is_of_type(active_camo_aa) then
                  current_player.stored_ability = aa_shld 
                  if not ability.is_of_type(drop_shield) then
                     current_player.stored_ability = aa_none 
                  end
               end
            end
         end
      end
      -- then delete it!!
      ability.delete()
   end
end
function restore_player_ability()
   ability = current_player.try_get_armor_ability()
   if current_player.stored_ability != aa_unstored then
      ability.delete()
      if current_player.stored_ability == aa_spnt then
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, sprint, 0)
      end
      if current_player.stored_ability == aa_evde then
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, evade, 0)
      end
      if current_player.stored_ability == aa_lock then
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, armor_lock, 0)
      end
      if current_player.stored_ability == aa_camo then
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, active_camo_aa, 0)
      end
      if current_player.stored_ability == aa_shld then
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, drop_shield, 0)
      end
      current_player.stored_ability = aa_unstored
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------
----------------------
-- STOWABLE TURRETS --
----------------------
alias stowed_weapon = object.object[0]
alias placeholder_weapon = object.object[1]
alias stowed_state  = object.number[0] -- 0: means on back, 1: means held out in hands
function drop_stowed_weapon()
   if ability.stowed_weapon != no_object then
      if ability.stowed_state == 1 then -- if stowed weapon is in hands, then we need to drop literally everything
         current_player.biped.remove_weapon(primary, false) -- drop the turret
         --ability.stowed_state = 0 -- not needed at the moment
      end
      ability.placeholder_weapon.delete()
      --current_player.biped.remove_weapon(secondary, false) -- drop secondary
      --current_player.biped.remove_weapon(secondary, true) -- delete laser
      --current_player.add_weapon(temp_obj1)

      temp_obj3 = ability.stowed_weapon -- for if we're holding the core
      --if ability.stowed_weapon.is_of_type(detached_machine_gun_turret) or ability.stowed_weapon.is_of_type(detached_plasma_cannon) then
         --temp_obj3.delete()
         if ability.stowed_weapon.is_of_type(detached_machine_gun_turret) then
            temp_obj3.delete()
            temp_obj3 = current_player.biped.place_at_me(machine_gun_turret, none, none, 5,0,0,none)
            temp_obj3.attach_to(current_player.biped, 5,0,0,relative)
         end
         if ability.stowed_weapon.is_of_type(detached_plasma_cannon) then
            temp_obj3.delete()
            temp_obj3 = current_player.biped.place_at_me(plasma_cannon, none, none, 5,0,0,none)
            temp_obj3.attach_to(current_player.biped, 5,0,0,relative)
         end
      --end
      temp_obj3.team = ELITES -- mark them as idk specifically non garbage ones
      -- this doesn't work because its already attached to our player???
      --if ability.stowed_weapon.is_of_type(covenant_power_core) then
      --   temp_obj3.attach_to(current_player.biped, 5,0,5,relative)
         temp_obj3.detach()
      --end
      ability.stowed_weapon = no_object -- we have to clear this if we dropped a core in the holo to interact zones
      --game.show_message_to(current_player, none, "Weapon dropped!!")
   end
end
-- remove stowed weapons from players inside comm station areas
-- COMMAND DEPRECATED --
-- for each player do
--    current_player.stowables_disabled = 0
--    for each object with label "com_station" do 
--       if current_object.shape_contains(current_player.biped) then
--          current_player.stowables_disabled = 1
--       end
--    end
--    if not current_player.no_ability_timer.is_zero() then -- so if they're on the droppod or something
--       current_player.stowables_disabled = 1
--    end
--    -- TODO: we also need a case where this doesn't run if we're in a vehicle??? maybe not???
-- end
-- for each player do
--    if current_player.stowables_disabled == 1 then
--       -- check to make sure we dont have any stowed weapons then, else dump them
--       if current_player.stored_ability != aa_unstored then -- NOTE: this is also true when in hologram to interact
--          ability = current_player.get_armor_ability()
--          if ability.stowed_weapon != no_object then -- this is only true for when we've got a stowed weapon on our ability
--             temp_obj1 = current_player.try_get_weapon(secondary)
--             drop_stowed_weapon()
--             restore_player_ability()
--          end
--       end
--    end
-- end
for each player do
   stowed_weapon_wgt.set_visibility(current_player, false)
   if current_player.state == none_ then -- just in the off chance that this solves the random issue we have with the drop shields randomly spawning??
   --if current_player.stowables_disabled == 0 then
      temp_obj0 = current_player.get_weapon(primary)
      temp_obj1 = current_player.get_weapon(secondary)
      ability = current_player.get_armor_ability()

      if ability.stowed_weapon != no_object then
         -- clear placeholder weapon while in vehicles, so we cant just swap to it??
         if current_player.player_vehicle != no_object and ability.placeholder_weapon != no_object then
            ability.placeholder_weapon.delete()
         end
         stowed_weapon_wgt.set_visibility(current_player, true)
         -- if not holding stowed weapon and its marked as in primary, then stow it
         if temp_obj0 != ability.stowed_weapon and ability.stowed_state == 1 then
            ability.stowed_state = 0
            ability.stowed_weapon.copy_rotation_from(temp_obj1, true)
            ability.stowed_weapon.attach_to(ability, 1,0,0,relative)
            --game.show_message_to(current_player, none, "Weapon stowed!!") 
            if temp_obj0 == ability.placeholder_weapon and ability.placeholder_weapon != no_object then
               -- second weapon despawned, pad out inventory??
               temp_obj1 = current_player.biped.place_at_me(spiker, none, none, 0,0,0,none)
               --current_player.add_weapon(temp_obj1)
               game.show_message_to(current_player, none, "bad inventory, padding!!") 
            end
         end
         -- the player swapped to the placeholder weapon (splaser), equip the stowed weapon
         -- placeholder and primary are both no_object
         if temp_obj0 == ability.placeholder_weapon and ability.placeholder_weapon != no_object and ability.stowed_state == 0 then
            ability.stowed_state = 1
            current_player.biped.remove_weapon(secondary, false)
            current_player.biped.remove_weapon(primary, false)
            current_player.add_weapon(temp_obj1)
            current_player.add_weapon(ability.placeholder_weapon)
            -- take it off our back and put it in our hands!!
            ability.stowed_weapon.detach()
            current_player.add_weapon(ability.stowed_weapon)
            --game.show_message_to(current_player, none, "Weapon taken out of backpack!!")
         end
         -- if the player is using their ability, then we deploy their stowed weapon
         if ability.is_in_use() and ability.stowed_state == 0 then 
            drop_stowed_weapon()
            restore_player_ability() -- other things that call this function are going to do this at some later moment
         end
      end
      if current_player.player_vehicle == no_object then
         -- if we're holding a stowable but this isn't marked as our stowable, then we have to enter stowable mode!!!
         --current_player.prevent_stow_timer.is_zero() and
         if temp_obj0.is_of_type(detached_machine_gun_turret) or temp_obj0.is_of_type(detached_plasma_cannon) or temp_obj0.is_of_type(covenant_power_core) then
            -- infinite ammo when turret, so we dont deplete the ammo and cause it to despawn!
            current_player.apply_traits(infinite_ammo_traits)
            -- if we haven't swapped abilities yet, do that
            if current_player.stored_ability == aa_unstored then
               store_player_ability()
               temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, drop_shield, 0)
            end
            -- and if we swapped abilities and haven't registered our weapon, then do that now
            if ability.is_of_type(drop_shield) and current_player.stored_ability != aa_unstored then
               if ability.stowed_weapon != temp_obj0 then
                  drop_stowed_weapon() -- stowed state here will always be 0, since the above code will put it in the backpack if our weapon changes
                  ability.stowed_weapon = temp_obj0
                  if ability.stowed_weapon.is_of_type(detached_machine_gun_turret) then
                     ability.stowed_weapon = current_player.biped.place_at_me(detached_machine_gun_turret, none, suppress_effect | never_garbage_collect, 0,0,0,none)
                     current_player.biped.remove_weapon(primary, true)
                  end
                  if ability.stowed_weapon.is_of_type(detached_plasma_cannon) then
                     ability.stowed_weapon = current_player.biped.place_at_me(detached_plasma_cannon, none, suppress_effect | never_garbage_collect, 0,0,0,none)
                     current_player.biped.remove_weapon(primary, true)
                  end
               end
            end
         end
         -- give spartan laser placeholder weapon if we dont have one (this is like for if we just got out of a vehicle)
         if ability.stowed_weapon != no_object and ability.placeholder_weapon == no_object then

            current_player.biped.remove_weapon(primary, false)
            current_player.biped.remove_weapon(secondary, false)
            current_player.biped.remove_weapon(secondary, false)
            ability.placeholder_weapon = current_player.biped.place_at_me(spartan_laser, none, suppress_effect | never_garbage_collect, 0,0,0,none)
            current_player.add_weapon(ability.placeholder_weapon)
            current_player.add_weapon(temp_obj1)
            if temp_obj1 == no_object then
               current_player.add_weapon(temp_obj0)
               --game.show_message_to(current_player, none, "secondary failed, giving primary instead!!")
            end
         end
      end
   end
end
-- clear stored ability if player is dead, also reset stow restriction timer
for each player do
   --current_player.prevent_stow_timer.set_rate(-100%)
   if current_player.biped == no_object then
      current_player.stored_ability = aa_unstored
      --current_player.prevent_stow_timer.reset()
   end
end
-- 'cleanup' dropped spartan lasers, although this will only prevent players from picking them up for now
for each object with label 2 do
   current_object.set_pickup_permissions(no_one)
end
-- END OF SECTION ------------------------------------------------------------------------------------------------


-------------------------
-- OVERSHIELDS EFFECTS --
-------------------------
function create_overshield_visual()
   -- setup shield
   temp_obj0.bpd_OS_visual = temp_obj0.place_at_me(soft_safe_boundary, none, none, 0,0,0,none)
   temp_obj0.bpd_OS_visual.copy_rotation_from(temp_obj0.bpd_OS_socket, true)
   temp_obj0.bpd_OS_visual.attach_to(temp_obj0.bpd_OS_socket, 0,0,0,relative)
end
function check_overshields()
   if temp_obj0 != no_object then
      temp_num0 = temp_obj0.shields
      if temp_num0 > 100 and temp_obj0.bpd_OS_visual == no_object then
         create_overshield_visual()
      end
      if temp_num0 <= 100 and temp_obj0.bpd_OS_visual != no_object then
         temp_obj0.bpd_OS_visual.delete()
      end
   end
end
for each player do
   temp_obj0 = current_player.biped
   check_overshields()
end
for each object with label "AI" do 
   temp_obj0 = current_object.ai_biped
   check_overshields()
end
-- END OF SECTION ------------------------------------------------------------------------------------------------




---------------------
-- MEDIC ABILITIES --
---------------------
alias con_visual = object.object[0]
alias con_ticks = object.number[0]
alias con_min_ticks_till_usable = 15
alias con_lifespan_ticks = 1800
alias con_pickup_distance = 20
alias con_heal_amount = 100
alias con_max_shields_to_take = 150
-- disable ability if in vehicle or holding a bad weapon
for each player do
   current_player.class_disabled = 0
   temp_obj0 = current_player.get_weapon(primary)
   if current_player.player_vehicle != no_object or temp_obj0.is_of_type(grenade_launcher) or temp_obj0.is_of_type(concussion_rifle) or temp_obj0.is_of_type(rocket_launcher) or temp_obj0.is_of_type(plasma_launcher) then
      current_player.class_disabled = 1
   end
end
function try_apply_healthpack()
   if temp_obj0.shape_contains(temp_obj1) then
      temp_num0 = temp_obj1.shields
      if temp_num0 <= con_max_shields_to_take then
         temp_obj1.shields = 300
         temp_obj1.health = 100 
         temp_obj0.delete()
      end
   end
end
-- detect player consuming the thing
for each object with label "consumable" do
   current_object.con_ticks += 1
   if current_object.con_ticks > con_min_ticks_till_usable then
      temp_obj0 = current_object
      for each player do
         temp_obj1 = current_player.biped
         try_apply_healthpack()
      end
      for each object with label "AI" do
         temp_obj1 = current_object.ai_biped
         try_apply_healthpack()
      end
   end
end
-- cleanup consumables after X seconds
for each object with label "consumable" do
   if current_object.con_ticks > con_lifespan_ticks then
      current_object.delete()
   end
end
-- regenerate grenades
for each player do
   if current_player.class == medic then -- NOTE: this will set the grenades of some AI that we borrow the player for?
      current_player.frag_grenades = 0
      current_player.plasma_grenades = 0
      current_player.grenade_regen_timer.set_rate(-100%)
      if current_player.grenade_regen_timer.is_zero() and current_player.class_disabled == 0 then
         current_player.frag_grenades = 1
      end
   end
end
-- ability thrown detection script
alias has_been_init = object.number[0]
for each object with label 0 do
   if current_object.has_been_init == 0 then
      temp_num0 = current_object.health
      if temp_num0 == 100 and not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) then
         -- match this object up against the 
         temp_obj0 = current_object
         for each object do
            if current_object == temp_obj0 then
               temp_num0 = -1
            end
         end
         if temp_num0 == 100 then
            temp_player0 = no_player
            for each player do
               if temp_num0 != 0 and current_player.biped != no_object then
                  temp_num1 = current_object.get_distance_to(current_player.biped)
                  -- if this player is closer, then they probably created this projectile
                  if temp_num1 < temp_num0 then -- NOTE: this logic caps out the max distance at 100, which should never be a problem
                     temp_player0 = current_player
                     temp_num0 = temp_num1
                  end
               end
            end
            -- check to make sure its not attached to our player at the moment
            if temp_num0 != 0 then
               -- mark this projectile so we dont interact with it ever again!!!!
               current_object.has_been_init = 1
               -- check if the player is using this projectile for their abilities
               if temp_player0 != no_player then
                  if temp_player0.class == medic and temp_player0.grenade_regen_timer.is_zero() and temp_player0.class_disabled == 0 then
                     temp_player0.grenade_regen_timer.reset()
                     temp_obj0 = temp_player0.biped.place_at_me(bomb, "consumable", none, 0,0,0,none)
                     temp_obj0.set_invincibility(1)
                     -- add decorative thingo
                     temp_obj0.con_visual = temp_player0.biped.place_at_me(soft_safe_boundary, none, none, 0,0,0,none)
                     --temp_obj0.set_scale(1) -- doesn't work
                     temp_obj0.con_visual.attach_to(temp_obj0, 0,0,0,relative)
                     -- then attach to inherit velocity and then clean up the projectile
                     temp_obj0.attach_to(current_object, 0,0,0,relative)
                     temp_obj0.detach()
                     --temp_obj0.team = temp_player0.team
                     temp_obj0.set_shape(sphere, con_pickup_distance)
                     temp_obj0.set_waypoint_visibility(everyone)
                     temp_obj0.set_waypoint_priority(low)
                     temp_obj0.set_waypoint_range(0, 5)
                     current_object.delete() 
                     --game.show_message_to(temp_player0, none, "thrown ability activated!!")
                  end
               end
            end
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------

---------------------------
-- PLAYERS AT SPAWN CODE --
---------------------------
for each player do
   current_player.in_spawn = 0 -- reset player is in spawn state
end
for each player do
   if current_player.player_vehicle == no_object then
      for each object with label "inv_objective" do
         if current_object.spawn_sequence == 0 then
            if current_player.team == current_object.team then
               current_player.set_primary_respawn_object(current_object)
               if current_object.shape_contains(current_player.biped) then
                  current_player.in_spawn = 1
               end
            end
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------

-------------------------
-- PLAYER CLASSES CODE -- + SPAWNING ON AIs +
-------------------------
-- basically init per spawn stuff, like spawning into AI bipeds
function setup_shield_socket()
   -- setup attach shield marker
   temp_obj1.bpd_OS_socket = temp_obj1.place_between_me_and(temp_obj1, sound_emitter_alarm_2, 0)
   temp_obj2 = temp_obj1.place_between_me_and(temp_obj1, sound_emitter_alarm_2, 0)
   temp_obj1.bpd_OS_socket.copy_rotation_from(default_yaw, true)
   temp_obj2.attach_to(temp_obj1.bpd_OS_socket, 0,0,0, relative)
   temp_obj1.bpd_OS_socket.copy_rotation_from(temp_obj1, true)
   -- then rotate the pitch marker
   temp_obj2.detach()
   temp_obj1.bpd_OS_socket.attach_to(temp_obj2, 0,0,0,relative)
end
function setup_elite_shield_socket()
   setup_shield_socket()
   temp_obj2.face_toward(temp_obj2, 4,-1,0)
   -- then do the yaw one again (we can do this before but the order wont squeeze us out any more actions)
   temp_obj1.bpd_OS_socket.detach()
   temp_obj1.bpd_OS_socket.face_toward(temp_obj1.bpd_OS_socket, 2,1,0)
   -- then slap it on our guy, done!!
   temp_obj1.bpd_OS_socket.attach_to(temp_obj1, 3,1,4,relative)
   temp_obj2.delete()
end
function setup_spartan_shield_socket()
   setup_shield_socket()
   temp_obj2.face_toward(temp_obj2, 5,2,0)
   -- then do the yaw one again (we can do this before but the order wont squeeze us out any more actions)
   temp_obj1.bpd_OS_socket.detach()
   temp_obj1.bpd_OS_socket.face_toward(temp_obj1.bpd_OS_socket, 0,1,0)
   -- then slap it on our guy, done!!
   temp_obj1.bpd_OS_socket.attach_to(temp_obj1, 1,2,4,relative)
   temp_obj2.delete()
end
for each player do 
   temp_obj1 = current_player.biped
   -- if biped not init, then make it do the init thing!!
   if temp_obj1 != no_object and temp_obj1.bpd_init == 0 then -- and temp_obj1.is_of_type(spartan) or temp_obj1.is_of_type(elite) then
      temp_obj1.bpd_init = 1
      current_player.class = no_class
      current_player.grenade_regen_timer.reset()
      if current_player.in_spawn == 0 then
         --game.show_message_to(current_player, none, "player posses AI init")
         --temp_ob0 = no_object
         temp_num0 = 100 -- max AI spawn at distance?
         for each object with label "AI" do
            if current_object.ai_biped != no_object and current_object.team == current_player.team and current_object.ai_state >= ai_deployed then
               temp_num1 = current_object.ai_biped.get_distance_to(current_player.biped)
               if temp_num1 < temp_num0 then
                  temp_num0 = temp_num1
                  temp_obj1 = current_object
               end
            end
         end
          -- if we found a biped? we should never not find one, that would be really bad
         if temp_obj1 == current_player.biped then
            current_player.in_spawn = 1 -- lets just pretend ok, just so the whole thing does't explode
            -- we dont need this debug message anymore!!
            --game.show_message_to(current_player, none, "BAD SPAWN, no valid AI found for bro spawn location!!!")
         end
         if temp_obj1 != current_player.biped then
            game.show_message_to(current_player, none, "Possessing AI unit... (loadout disregarded!)")
            -- clear spawn & waypoint status
            temp_obj1.ai_biped.set_spawn_location_permissions(no_one)
            temp_obj1.ai_biped.set_waypoint_visibility(no_one)
            temp_obj1.ai_biped.set_waypoint_text("")
            temp_num0 = temp_obj1.ai_biped.shields
            -- put us into our new biped
            current_player.biped.delete()
            current_player.set_biped(temp_obj1.ai_biped)
            temp_obj1.ai_biped = no_object
            -- restore any overshields that the AI biped had??
            if temp_num0 > 100 then
               current_player.biped.shields = temp_num0
            end
            if current_player.biped.is_of_type(spartan) then
               current_player.frag_grenades = 2
               current_player.biped.add_weapon(magnum, secondary)
               current_player.biped.place_at_me(sprint, none, none, 0,0,5,none)
            end
            if current_player.biped.is_of_type(elite) then
               current_player.frag_grenades = 0
               current_player.plasma_grenades = 2
               current_player.biped.add_weapon(plasma_repeater, secondary)
               current_player.biped.place_at_me(evade, none, none, 0,0,5,none)
            end
         end
      end
      if current_player.in_spawn == 1 then
         --game.show_message_to(current_player, none, "player biped init")
         temp_obj3 = current_player.get_weapon(primary)
         if temp_obj1.is_of_type(spartan) then
            setup_spartan_shield_socket()
            if temp_obj3.is_of_type(assault_rifle) then
               current_player.class = medic
            end
         end
         if temp_obj1.is_of_type(elite) then
            setup_elite_shield_socket()
            if temp_obj3.is_of_type(plasma_rifle) then
               current_player.class = medic
            end
         end
      end
   end
end
-- END OF SECTION ------------------------------------------------------------------------------------------------


---------------------------
-- PLAYER AI DETECTION?? --
---------------------------
alias biped_is_illegal = -12345
alias biped_is_camo    =  -4321
for each player do
   temp_obj0 = current_player.get_armor_ability()
   current_player.illegal_target_timer.set_rate(1000%) -- count back up
   if temp_obj0.is_in_use() then
      if temp_obj0.is_of_type(active_camo_aa) then
         current_player.illegal_target_timer.set_rate(-100%)
      end
      if temp_obj0.is_of_type(armor_lock) then
         current_player.illegal_target_timer.set_rate(-200%)
      end
   end
   temp_obj1 = current_player.biped 
   temp_obj1.is_illegal_target = 0
   if current_player.illegal_target_timer.is_zero() then
      temp_obj1.is_illegal_target = biped_is_illegal
      if temp_obj0.is_of_type(active_camo_aa) then
         temp_obj1.is_illegal_target = biped_is_camo
      end
   end
end   
-- END OF SECTION ------------------------------------------------------------------------------------------------


-------------------
-- SCALING STUFF --
-------------------
-- ~10 condtions ~30 actions
   alias recursions = temp_num0
   function _330x_recurs()
      if recursions > 0 then 
         recursions -= 1
         temp_num2 = temp_num3
         temp_num2 /= 33
         temp_num1 = temp_num3
         temp_num1 /= 228
         temp_num3 += temp_num2
         temp_num3 += temp_num1
         _330x_recurs()
      end
   end
   function _330x()
      if current_object.spawn_sequence != 0 then
         temp_num3 = 100
         recursions = current_object.spawn_sequence
         if current_object.spawn_sequence < 0 then 
            recursions *= 5
            temp_num3 += recursions
            if current_object.spawn_sequence <= -20 then 
               recursions = current_object.spawn_sequence
               recursions += 201
               if current_object.spawn_sequence == -20 then 
                  temp_num3 = 1
                  --current_object.set_hidden(true) -- probably not needed
               end
            end
         end
         if current_object.spawn_sequence < -20 or current_object.spawn_sequence > 0 then 
            temp_num3 = 100
            if current_object.team == team[0] then
               temp_num3 = 32732
            end
            _330x_recurs()
         end
         current_object.set_scale(temp_num3)
         current_object.copy_rotation_from(current_object, false)
      end
   end
   if is_host <= 30 then
      if is_host >= 20 then -- skip scaling things right at the start?? no clue what this was for
         for each object with label "scale" do
            if current_object.spawn_sequence != -20 then
               _330x()
            end
         end
      end
   end
   for each object with label "scale" do
      if current_object.team == team[6] then
         current_object.set_invincibility(1)
      end
      if current_object.team == team[7] then -- 2 actions for 1 condition
         current_object.set_invincibility(1)
         current_object.set_hidden(true)
         --if is_host == 31 and current_object.team == team[7] then
            
            -- if the next tick after scaling, then stick it on our pedestal so it doesn't interfere with projectiles and all that
            --temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            --current_object.attach_to(temp_obj0, 0,0,0,relative)
         --end
      end
   end
-- END OF SECTION ------------------------------------------------------------------------------------------------


------------------------------------
-- PORTABLE FORTIFICATION OBJECTS --
------------------------------------
-- ~16 conditions ~20 actions
   -- alias p_scale        = object.number[0] -- local
   -- alias p_plant_ticks  = object.number[1] -- local 
   -- alias p_dome         = object.object[0] -- local
   -- alias p_pedestal     = object.object[1] -- local
   -- alias p_interact     = object.object[3] -- low -- so clients can fixup the attach on their end
   -- alias p_holder       = object.player[0] -- local
   -- alias p_last_holder  = object.player[3] -- low -- we need this to translate to clients so they can do the attach thing too
   -- alias p_ticks_to_plant = 10
   -- alias p_scale_increase = 75
   -- alias p_max_size = 4000
   -- -- label teams
   -- alias p_shield = neutral_team
   -- alias p_camo   = team[0] -- red team
   -- alias p_antena = team[1] -- blue team
   -- -- create grabbable bomb for portables
   -- for each object with label "portable" do
   --    if current_object.team != p_camo then
   --       -- antenna doesn't reset the interactable object, so if interable is null and the object either hasn't been initialized or it isn't an antenna then reset
   --       if current_object.p_interact == no_object and current_object.p_pedestal == no_object then
   --          current_object.p_interact = current_object.place_at_me(covenant_bomb, none,none, 0,5,3,none)
   --          if current_object.team == p_antena then
   --             temp_obj0 = current_object
   --             for each object with label "portable" do
   --                if current_object.team == p_camo and current_object.spawn_sequence == temp_obj0.spawn_sequence then
   --                   temp_obj0.p_dome = current_object
   --                end
   --             end
   --          end
   --       end
   --    end
   -- end
   -- -- check for when player has dropped it, and it has settled
   -- -- standalone shield, then reset cycle by deleting interactable (it will be respawned!!)
   -- for each object with label "portable" do
   --    if current_object.p_interact != no_object then
   --       current_object.p_last_holder = current_object.p_holder
   --       if current_object.p_last_holder != no_player then -- TODO debug code that we could fix up a bit???
   --          current_object.detach()
   --          current_object.copy_rotation_from(current_object.p_last_holder.biped, false)
   --          current_object.face_toward(current_object, 0,1,0)
   --          current_object.attach_to(current_object.p_last_holder.biped, 0,0,0,relative)
   --          current_object.p_plant_ticks = p_ticks_to_plant
   --       end
   --       current_object.p_holder = current_object.p_interact.get_carrier()
   --       if current_object.p_holder == no_player and current_object.p_plant_ticks > 0 then
   --          temp_num0 = current_object.p_interact.get_speed()
   --          if temp_num0 < 3 then
   --             current_object.p_plant_ticks -= 1
   --             if current_object.p_plant_ticks == 0 then
   --                current_object.detach()
   --                current_object.p_interact.delete()
   --                if current_object.team == p_antena then
   --                   current_object.p_pedestal = current_object.place_between_me_and(current_object, flag_stand, 0)
   --                   current_object.attach_to(current_object.p_pedestal, 0,0,0,relative)
   --                end
   --             end
   --          end
   --       end
   --    end
   -- end
   -- -- run animation for antena thing if its fully setup
   -- for each object with label "portable" do
   --    if current_object.p_pedestal != no_object then
   --       current_object.p_scale += p_scale_increase
   --       current_object.p_dome.detach()
   --       current_object.p_dome.set_scale(current_object.p_scale)
   --       current_object.p_dome.attach_to(current_object, 0,0,0,relative)
   --       -- TODO: script that disables vehicles if they're inside this boundary!!

   --       if current_object.p_scale >= p_max_size then -- this doesn't actually cap it at that number, it caps at that number + the scale increase
   --          current_object.p_scale = p_max_size
   --       end
   --    end
   -- end
   -- -- delete the antenna if health is 0
   -- for each object with label "portable" do
   --    if current_object.p_pedestal != no_object then
   --       temp_num0 = current_object.health
   --       if temp_num0 <= 0 then
   --          current_object.p_pedestal.delete() -- this deletes all of the related objects!! since they're all attached to our pedestal
   --       end
   --    end
   -- end
-- END OF SECTION ------------------------------------------------------------------------------------------------






------------------------------------------------
-- PUT PLAYERS IN/OUT OF HOLOGRAM TO INTERACT --
------------------------------------------------
-- ORDNANCE DEPRECATED --
-- COMMAND DEPRECATED --
-- ~60 condtions, ~120 actions
   -- display shape boundaries for command stations
   -- for each object with label "com_station" do 
   --    if current_object.team != neutral_team then
   --       current_object.set_shape_visibility(allies)
   --    end
   -- end
   -- for each object with label "com_station" do
   --    if current_object.team != neutral_team then
   --       current_object.set_waypoint_priority(low)
   --       current_object.set_waypoint_range(0, 5)
   --       current_object.set_waypoint_visibility(allies)
   --       -- assign station label
   --       current_object.set_waypoint_text("DROPSHIPS")
   --       if current_object.spawn_sequence >= AI_station then
   --          current_object.set_waypoint_text("AI SQUADS")
   --          if current_object.spawn_sequence >= droppod_station then
   --             current_object.set_waypoint_text("DROP PODS")
   --             if current_object.spawn_sequence == ordnance_station then
   --                current_object.ordnance_timer.set_rate(-50%)
   --                current_object.set_waypoint_text("ORDNANCE")
   --                if current_object.ordnance_timer.is_zero() then
   --                   current_object.set_waypoint_priority(blink)
   --                end
   --             end
   --          end
   --       end
   --    end
   -- end
   -- -- if player enters the zone and isn't hologram to interact, then enter hologram to interact mode
   -- for each player do
   --    if current_player.state == none_ and current_player.biped != no_object then
   --       temp_obj0 = current_player.get_vehicle()
   --       if temp_obj0 == no_object then
   --          current_player.station = no_object
   --          for each object with label "com_station" do 
   --             if current_player.state == none_ and current_object.shape_contains(current_player.biped) and current_player.station == no_object and current_object.team != neutral_team then -- and current_object.team == current_player.team then
   --                current_player.station = current_object
   --                current_player.state = hologram_to_interact
   --                temp_obj1 = current_player.location
   --                temp_obj1.og_biped = current_player.biped
   --                -- then just swap out our player ability (this will only happen when they aren't already in a dropshield/holo to interact state)
   --                store_player_ability()
   --                current_player.biped.place_at_me(hologram, none,none, 0,0,3, none)
   --             end
   --          end
   --       end
   --    end
   -- end
   -- function RestorePlayer()
   --    -- clear station operator
   --    temp_obj1 = current_player.station
   --    temp_obj1.current_operator = no_player
   --    -- swap the bipeds
   --    current_player.biped.delete()

   --    temp_obj1 = current_player.location
   --    current_player.set_biped(temp_obj1.og_biped)
   --    -- clear state
   --    current_player.state = hologram_to_interact
   --    current_player.no_ability_timer.reset()
   -- end
   -- -- HOLOGRAM DETECTION SCRIPT
   -- for each player do
   --    if current_player.biped != no_object and current_player.state == hologram_to_interact and current_player.station != no_object then
   --       -- we also need to check whether this object is inside a thingo zone thats looking for a hologram
   --       for each object do
   --          if current_player.state == hologram_to_interact then 
   --             temp_num0 = current_object.get_distance_to(current_player.biped)
   --             if temp_num0 < 4  then -- this is probably our hologram
   --                temp_num0 = current_object.shields
   --                if temp_num0 > 97 and not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) and not current_object.has_forge_label("portable") then -- has shields, aand was a single unit away, very likely that this object is our hologram
   --                   -- we dont want multiple players controlling the same station
   --                   temp_obj0 = current_player.station
   --                   if temp_obj0.current_operator != no_player and temp_obj0.spawn_sequence != droppod_station then
   --                      current_object.delete()
   --                      game.show_message_to(current_player, none, "this station is already in use!!")
   --                   end
   --                   if temp_obj0.current_operator == no_player or temp_obj0.spawn_sequence == droppod_station then
   --                      --current_player.og_biped = current_player.biped -- covered by intermediate biped state thing
   --                      current_player.set_biped(current_object)
   --                      current_player.biped.add_weapon(energy_sword, secondary) -- put it in the second slot??
   --                      current_player.biped.add_weapon(golf_club, force)
   --                      --current_player.frag_grenades -= 100
   --                      current_player.state = controlling_hologram
   --                      -- put player's hologram at a random spawn point
   --                      for each object with label "holo_spawn" do
   --                         if current_object.team == current_player.team and current_object.spawn_sequence == INV_phase then
   --                            temp_obj0.current_droppod_pos = current_object 
   --                         end
   --                      end
   --                      temp_obj0.current_operator = current_player
   --                      current_player.biped.attach_to(temp_obj0.current_droppod_pos, 0,0,0,relative)
   --                      current_player.biped.detach()

   --                      -- setup hologram holder upper object
   --                      current_player.platform = current_player.biped.place_between_me_and(current_player.biped, grid, 0)
   --                      current_player.platform.copy_rotation_from(default_yaw, true) -- we need to do this because the grid has to place perfectly or else player will be auto booted out of the machine
   --                      current_player.platform.set_shape(box, 100,100, 2,5)
   --                      current_object.place_at_me(active_camo_aa, none,none, 0,0,5,none) -- hopefully never falls out of reach of our hologram!!
   --                   end
   --                end
   --             end
   --          end
   --       end
   --    end
   -- end

   -- -- return player to original biped if they leave the zone
   -- for each player do
   --    if current_player.state == hologram_to_interact and not current_player.station.shape_contains(current_player.biped) then
   --       current_player.state = none_
   --       if current_player.is_in_droppod == 0 then
   --          restore_player_ability()
   --       end
   --    end
   -- end
   -- -- check if player left platform
   -- for each player do
   --    if current_player.state == controlling_hologram then
   --       if not current_player.platform.shape_contains(current_player.biped) then 
   --          current_player.platform.delete()
   --          RestorePlayer()
   --          game.show_message_to(current_player, none, "aborted action via jump")
   --       end
   --    end
   -- end
   -- -- clear all holo spawn shape visibilities
   -- for each object with label "holo_spawn" do 
   --    current_object.set_shape_visibility(no_one)
   -- end
   -- -- check if the player left their holo spawn radius
   -- for each player do
   --    if current_player.state == controlling_hologram then
   --       temp_obj0 = current_player.station
   --       if temp_obj0.spawn_sequence == droppod_station then
   --          temp_obj0.current_droppod_pos.set_shape_visibility(mod_player, current_player, 1)
   --          if not temp_obj0.current_droppod_pos.shape_contains(current_player.biped) then 
   --             current_player.platform.delete()
   --             RestorePlayer()
   --             game.show_message_to(current_player, none, "aborted action via leaving drop boundary")
   --          end
   --       end
   --    end
   -- end

   -- -- move platform beneath player in top down mode
   -- for each player do
   --    if current_player.state == controlling_hologram then
   --       temp_num0 = is_host
   --       temp_num0 %= 3 -- surely enough time for a jump to fail out?
   --       if temp_num0 == 0 then
   --          current_player.platform.attach_to(current_player.biped, 0,0,0,relative)
   --          current_player.platform.detach()
   --       end
   --    end
   -- end
   -- -- check for player weapon swap, cycle commands if it did
   -- for each player do
   --    if current_player.state == controlling_hologram then
   --       temp_obj0 = current_player.get_weapon(primary)
   --       if temp_obj0 != current_player.last_weapon then
   --          current_player.last_weapon = temp_obj0
            
   --          -- cycle selected dropship
   --          temp_obj0 = current_player.station
   --          if temp_obj0.spawn_sequence == ordnance_station then
   --             temp_obj0.ordnance_type ^= 1
   --          end
   --          if temp_obj0.spawn_sequence == dropship_station then
   --             temp_obj0.controlled_dropship = no_object
   --             temp_obj1 = no_object -- reference to the one with spawn sequence 0
   --             for each object with label "dropship" do
   --                if current_object.team == temp_obj0.team then
   --                   if current_object.spawn_sequence == temp_obj0.dropship_index then
   --                      temp_obj0.controlled_dropship = current_object
   --                   end
   --                   if current_object.spawn_sequence == 0 then
   --                      temp_obj1 = current_object
   --                   end
   --                end
   --             end
   --             game.show_message_to(current_player, none, "Dropship %n Selected", temp_obj0.dropship_index) -- note this doesn't roll over!!
   --             temp_obj0.dropship_index += 1 -- iterate after so the first cycle picks 0???
   --             -- if we didn't find a dropship with the next index, then use the default one with spawn sequence 0
   --             if temp_obj0.controlled_dropship == no_object then
   --                temp_obj0.controlled_dropship = temp_obj1
   --                temp_obj0.dropship_index = 1 -- 1 because thats our next index, not the index of the current one
   --             end
   --          end

   --       end
   --    end
   -- end
   -- -- check for hologram player using ability to issue a command
   -- -- TODO: move this to the
   -- for each player do
   --    if current_player.state == controlling_hologram and current_player.no_ability_timer.is_zero() then
   --       temp_obj0 = current_player.get_armor_ability()
   --       if temp_obj0.is_in_use() then 
   --          current_player.no_ability_timer.reset()
   --          -- send destination command to dropship
   --          temp_obj3 = current_player.station
   --          if temp_obj3.spawn_sequence == dropship_station then
   --             temp_obj2 = current_player.biped
   --             DownwardsCollisionCast()
   --             target_dropship = temp_obj3.controlled_dropship
   --             set_dropship_destination()
   --             game.show_message_to(current_player, none, "Dropship %n on its way", temp_obj3.dropship_index)
   --          end
   --          -- put our player into a drop pod and blast it!!
   --          if temp_obj3.spawn_sequence == droppod_station then
   --             -- cleaup hologram stuff first
   --             current_player.platform.delete()
   --             RestorePlayer()
   --             -- then spawn in drop pod and go for it
   --             --current_player.biped.add_weapon(unsc_data_core, force)
   --             temp_obj4 = current_player.biped
   --             --current_player.biped.copy_rotation_from(temp_obj3.current_droppod_pos, true) -- we do not care
   --             create_droppod_at()
   --             current_player.is_in_droppod = 1
   --             game.show_message_to(current_player, none, "Launching droppod!!") 
   --          end
   --          -- put our player into a drop pod and blast it!!
   --          if temp_obj3.spawn_sequence == ordnance_station then
   --             if not temp_obj3.ordnance_timer.is_zero() then
   --                game.show_message_to(current_player, none, "Ordnance is on cooldown!") 
   --             end
   --             if temp_obj3.ordnance_timer.is_zero() then
   --                temp_obj3.ordnance_timer.reset()
   --                temp_obj2 = current_player.biped.place_at_me(sound_emitter_alarm_2, "ordnance", none, -40,0,-10,none)
   --                temp_obj2.drop_mover = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, -40,0,-10,none)
   --                temp_obj2.drop_type = temp_obj3.ordnance_type
   --                temp_obj2.team = temp_obj3.team
   --                -- then do a cool visual element so players are aware of the impending package
   --                DownwardsCollisionCast()
   --                temp_obj2.drop_waypoint = temp_obj0
   --                temp_obj2.drop_waypoint.set_waypoint_visibility(everyone)
   --                temp_obj0.team = temp_obj2.team
   --                game.show_message_to(current_player, none, "Launching ordnance!!") 

   --                temp_obj2.drop_waypoint.set_waypoint_text("MINES")
   --                if temp_obj2.drop_type == DROP_supplies then
   --                   temp_obj2.drop_waypoint.set_waypoint_text("SUPPLIES")
   --                end
   --             end
   --          end


   --       end
   --    end
   -- end
   -- -- SYNC BIPED LOCATION TO CLIENTS AND FIXUP MOVEMENT DIRECTION
   -- for each player do
   --    if current_player.state == controlling_hologram then
   --       -- update location object for clients
   --       current_player.location.attach_to(current_player.biped, 0,0,0,relative)
   --       current_player.location.detach()
   --       -- then force biped rotation, so movement is correctly applied from player perspective
   --       current_player.biped.copy_rotation_from(default_yaw, true)
   --       current_player.biped.face_toward(current_player.biped, 0,1,0)
   --    end
   -- end
   -- -- display hologram state
   -- -- enable invincibility for hologram players, so they dont expire
   -- for each player do
   --    if current_player.state == controlling_hologram then 
   --       current_player.apply_traits(hologram_traits)
   --    end
   -- end
   -- -- prevent hologram to interact while holding bomb?? (for some reason this gives the bomb to the hologram they spawn????
   -- for each player do
   --    if current_player.state == hologram_to_interact then
   --       temp_obj1 = current_player.get_weapon(primary)
   --       if temp_obj1.is_of_type(covenant_bomb) then
   --          current_player.no_ability_timer.reset()
   --       end
   --    end
   -- end
-- END OF SECTION ------------------------------------------------------------------------------------------------



-------------------------
-- AI INFANTRY SCRIPTS --
-------------------------
-- standing guard (at objective)
-- pushing enemies
-- waiting at spawn (droppod/dropship or even for a vehicle for the dropship)
-- waiting for player at spawn??
-- alertness (how quickly they will avoid danger)
-- plays with allies
-- likelihood of following friendly
-- likelihood of entering vehicle
-- likelihood of jumping
-- swaps weapons

alias ai_dest    = object.object[0] -- this will be like static per life, so the AI will only go towards 1 destination??
--alias ai_target  = object.object[1]
alias ai_guide_obj = object.object[2]
--alias ai_vehicle = object.object[1]
alias ai_biped   = object.object[3] -- needs to sync

alias ai_team_helper = object.player[0]

alias ai_name_index = object.number[6]
alias ai_max_names = 80 -- 1 in 4 chance that an AI is given a name?

alias ai_spawn_timer = object.timer[2]
alias ai_retarget_timer = object.timer[1]
alias ai_jump_timer = object.timer[3]

alias ai_attack_ticks = object.number[3]
alias ai_attack_type = object.number[4] -- and how much damage
alias ai_type_shottie  = 100
alias ai_type_sword    = 200
alias ai_type_ranged   = 16

alias ai_activity_average = object.number[0]

alias ai_path_index = object.number[2]

alias ai_prevent_walking_animation = object.team[0]

-- DEBUG ACTIVITY INDICATOR
for each object with label "AI" do
   temp_num0 = current_object.ai_biped.get_speed()
   temp_num0 *= 50 -- 5%
   -- take 95% of the last state
   current_object.ai_activity_average *= 95
   current_object.ai_activity_average /= 100
   -- combine
   current_object.ai_activity_average += temp_num0 
end
-- DEBUG JUMPER
for each object with label "AI" do
   current_object.ai_jump_timer.set_rate(-175%)
   if current_object.ai_biped != no_object then
      if current_object.ai_jump_timer.is_zero() then
         if current_object.ai_activity_average < 16000 then
            current_object.ai_jump_timer.reset()
            current_object.ai_biped.push_upward()
            current_object.ai_biped.push_upward()
            --current_object.ai_biped.push_upward()
            current_object.ai_prevent_walking_animation = neutral_team
         end
      end
   end
end


alias ai_state = object.number[1]
alias ai_looking_for_dropship = 0
alias ai_boarding_droppod     = 1
alias ai_deploying            = 2
alias ai_deployed             = 3
--alias ai_following            = 4
alias ai_objective            = 4
alias ai_pathing              = 5 -- this is not any different to 'ai_objective' but also costs nothing extra to have, so added for clarity's sake
alias ai_fighting             = 6
alias ai_fighting_vehicle     = 7
-- at spawn, depolyed, waiting to enter, in vehicle, in dropship, in droppod

alias ai_generate_sword_count = object.number[7]
alias ai_shots_fired   = object.number[5] -- only used for counting bursts in a gun shoot thingo thing idk, used to be used to tell clients to make this guy shoot
-- ONLY LOCALSIDED
alias ai_generate_sword_count_client = object.number[4]
--alias ai_shots_fired_client = object.number[5]
--lias ai_client_last_pos_update_ticks = object.number[5]
--alias ai_client_pos_update_ticks = object.number[3]
--alias ai_client_pos_update_ticker = object.number[2]


-- ai.ai_biped variables
-- alias bpd_init          = object.number[0] -- declared on player bipeds (DO NOT OVERWRITE)
-- alias is_illegal_target = object.number[1] -- declared on player bipeds (DO NOT OVERWRITE)
alias ai_has_team = object.number[2]

-- constants
alias ai_lunge_range = 30
alias ai_lunge_interval = 50 -- this is the amount of ticks AFTER a lunge has been completed that it can happen again
alias ai_lunge_duration = -120

alias ai_stab_range = 8
alias ai_stab = -150
alias ai_stab_timeout = -121
alias ai_stab_damage = -135


alias ai_shottie_range = 22
alias ai_shottie_interval = 100

alias ai_ranged_range = 45
alias ai_ranged_interval = 18
alias ai_ranged_burst_count = 7
alias ai_ranged_burst_cooldown_min = 50
alias ai_ranged_burst_cooldown = 60

alias ai_min_goto_range = 15
alias ai_walk_speed = 16

-- targeting constants
alias ai_max_see_player_distance = 290
alias ai_max_see_camo_player_distance = 24
alias ai_min_objective_distance = 120 -- there are no words to explain this one, the distance reading will be a minimum of this value to encourage AI to move away to attack aggressors
--alias ai_min_objective_defender_dist = 60


function get_biped_weapon()
   temp_obj2 = current_object.ai_biped
   temp_obj1 = no_object
   -- looks for an object thats on red team and attached to the ai_biped, this is most likely a weapon
   for each object do
      if current_object.team == team[0] and temp_obj2 != current_object then
         temp_num0 = current_object.get_distance_to(temp_obj2)
         if temp_num0 == 0 then
            temp_obj1 = current_object
         end
      end
   end
end
-- equip or swap weapon
function update_ai_weapon()
   current_object.ai_biped.remove_weapon(primary, true)
   if current_object.ai_biped.is_of_type(elite) then 
      current_object.ai_biped.add_weapon(energy_sword, primary)
      if current_object.ai_attack_type == ai_type_ranged then
         current_object.ai_biped.remove_weapon(primary, true) -- saves 1 condition
         current_object.ai_biped.add_weapon(plasma_rifle, primary)
      end
   end
   if current_object.ai_biped.is_of_type(spartan) then 
      current_object.ai_biped.add_weapon(shotgun, primary)
      if current_object.ai_attack_type == ai_type_ranged then
         current_object.ai_biped.remove_weapon(primary, true) -- saves 1 condition
         current_object.ai_biped.add_weapon(assault_rifle, primary)
      end
   end
end

-- SPAWN ZONE STUFF
alias max_spartan_ai = script_option[1]
alias max_elite_ai = script_option[2]
function place_ai_tracker()
   current_team.ai_count += 1
   temp_obj0 = current_object.place_at_me(sound_emitter_alarm_2, "AI", none, 0,0,0,none)
   temp_obj0.team = current_team
   temp_obj0.ai_name_index = rand(ai_max_names)
end
-- configure spawn stuff
for each object with label "inv_objective" do
   if current_object.spawn_sequence == 0 then
      current_object.set_spawn_location_permissions(allies)
      -- create team AI managers
      for each team do
         if current_team == current_object.team then
            if current_object.team == SPARTANS and current_team.ai_count < max_spartan_ai then
               place_ai_tracker()
            end
            if current_object.team == ELITES and current_team.ai_count < max_elite_ai then
               place_ai_tracker()
            end
         end
      end
      temp_obj0 = current_object
      -- respawn AI here if they need respawning
      for each object with label "AI" do
         if temp_obj0.team == current_object.team then
            if current_object.ai_biped == no_object then
               -- reset AI state
               current_object.ai_state = ai_looking_for_dropship
               current_object.ai_dest = no_object
               -- then respawn when respawn timer says so
               current_object.ai_spawn_timer.set_rate(-75%)
               if current_object.ai_spawn_timer.is_zero() then
                  if ai_spawn_interval_timer.is_zero() then
                     ai_spawn_interval_timer.reset()

                     current_object.ai_spawn_timer.reset()
                     --game.show_message_to(all_players, none, "AI has respawned!")

                     if current_object.team == SPARTANS then
                        temp_obj1 = temp_obj0.place_at_me(spartan, none, none, 0,0,0,none)
                        setup_spartan_shield_socket()
                        current_object.ai_attack_type = ai_type_shottie
                     end
                     if current_object.team == ELITES then
                        temp_obj1 = temp_obj0.place_at_me(elite, none, none, 0,0,0,none)
                        setup_elite_shield_socket()
                        current_object.ai_attack_type = ai_type_sword
                     end
                     temp_obj1.bpd_init = 1 
                     current_object.ai_biped = temp_obj1
                     current_object.ai_biped.set_waypoint_visibility(everyone)
                     current_object.ai_biped.set_waypoint_range(0, 8)
                     current_object.ai_biped.set_waypoint_priority(low)
                     -- configure AI name??
                     current_object.ai_biped.set_waypoint_text("Mr Rabbit") -- Rabid Magicman
                     if current_object.ai_name_index >= 1 then
                        current_object.ai_biped.set_waypoint_text("Mr Milker") -- Mr Dr Milk
                        if current_object.ai_name_index >= 2 then
                           current_object.ai_biped.set_waypoint_text("Mr CarJay") -- Cardinal
                           if current_object.ai_name_index >= 3 then
                              current_object.ai_biped.set_waypoint_text("Mr Morbo") -- Moro
                              if current_object.ai_name_index >= 4 then
                                 current_object.ai_biped.set_waypoint_text("Mr Loi") -- Master Loi
                                 if current_object.ai_name_index >= 5 then
                                    current_object.ai_biped.set_waypoint_text("Mr Wifi") -- Phi
                                    if current_object.ai_name_index >= 6 then
                                       current_object.ai_biped.set_waypoint_text("Mr Gametyper") -- MCC gametypers
                                       if current_object.ai_name_index >= 7 then
                                          current_object.ai_biped.set_waypoint_text("Mr Cartographer") -- Rampant Cartographers
                                          if current_object.ai_name_index >= 8 then
                                             current_object.ai_biped.set_waypoint_text("Mr Anvil") -- The Anvil
                                             if current_object.ai_name_index >= 9 then
                                                current_object.ai_biped.set_waypoint_text("Mr Korncobb") -- Kornman/Cobb
                                                if current_object.ai_name_index >= 10 then
                                                   current_object.ai_biped.set_waypoint_text("Mr Obamna") -- President Obama
                                                   if current_object.ai_name_index >= 11 then
                                                      current_object.ai_biped.set_waypoint_text("Mr Goober") -- Gamergotten
                                                      if current_object.ai_name_index >= 12 then
                                                         current_object.ai_biped.set_waypoint_text("Mr Sleeper") -- Sofasleeper
                                                         if current_object.ai_name_index >= 13 then
                                                            current_object.ai_biped.set_waypoint_text("Mr Skibidi") -- Weesee
                                                            if current_object.ai_name_index >= 14 then
                                                               current_object.ai_biped.set_waypoint_text("Mr Looper") -- Cantaloupe
                                                               if current_object.ai_name_index >= 15 then
                                                                  current_object.ai_biped.set_waypoint_text("Mr Battery") -- WeapoNate
                                                                  if current_object.ai_name_index >= 16 then
                                                                     current_object.ai_biped.set_waypoint_text("Mr Snooper") -- Trusty snooze
                                                                     if current_object.ai_name_index >= 17 then
                                                                        current_object.ai_biped.set_waypoint_text("Mr Funky") -- I Can't Funk Up
                                                                        if current_object.ai_name_index >= 18 then
                                                                           current_object.ai_biped.set_waypoint_text("Mr Silly") -- Sopitive (what kind of nickname can i even do here??)
                                                                           if current_object.ai_name_index >= 19 then
                                                                              current_object.ai_biped.set_waypoint_text("Mr Zaddy") -- Zaddy Hammer
                                                                              if current_object.ai_name_index >= 20 then
                                                                                 current_object.ai_biped.set_waypoint_text("")
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

                     -- randomize type
                     --current_object.ai_attack_type = ai_type_ranged
                     temp_num0 = rand(2)
                     if temp_num0 == 0 then
                        current_object.ai_attack_type = ai_type_ranged
                     end
                     update_ai_weapon()
                  end
               end
            end
         end
      end

   end
end
-- players spawn on AI stuff --
for each object with label "AI" do
   current_object.ai_biped.set_spawn_location_permissions(no_one)
   if current_object.ai_biped != no_object and current_object.ai_state >= ai_deployed then
      current_object.ai_biped.set_spawn_location_permissions(allies)
   end
end

-- guide zone; detect AI entering guide zone & clear once left & progres paths
for each object with label "AI" do
   temp_obj1 = current_object.ai_guide_obj
   -- if path and stuff is valid, then check to see if we've progressed it yet or not
   if current_object.ai_guide_obj != no_object and current_object.ai_biped != no_object 
   and temp_obj1.spawn_sequence == current_object.ai_path_index then
      temp_num0 = current_object.ai_guide_obj.get_distance_to(current_object.ai_biped)
      if temp_num0 < 15 then
         current_object.ai_path_index += 1 -- so we can move onto the next step of this path and so we stop tracking this path if there are no more steps
      end
   end
   -- clear AI guide zone once we've reached the end and left its boundary, or if we died along the way
   --if not current_object.ai_guide_obj.shape_contains(current_object.ai_biped) and temp_obj1.spawn_sequence < current_object.ai_path_index or current_object.ai_biped == no_object then
   if not current_object.ai_guide_obj.shape_contains(current_object.ai_biped) then -- or current_object.ai_biped == no_object then
      current_object.ai_guide_obj = no_object
      current_object.ai_path_index = 0 -- so it looks for index 0
   end


   temp_num0 = current_object.ai_path_index
   -- if we've already reached the end of the current zone, then we dont need to increment our next node index
   -- otherwise we should be looking for nodes with a higher index
   if current_object.ai_guide_obj != no_object and temp_obj1.spawn_sequence == current_object.ai_path_index then
      temp_num0 += 1
   end

   -- check for paths or next zones in a path
   temp_obj0 = current_object
   for each object with label "path_guide" do
      -- only look for guide zones when we dont have one, or if this zone has a higher index than our current zone
      --if  temp_obj0.ai_guide_obj == no_object or current_object.spawn_sequence > temp_obj1.spawn_sequence 

      -- then check if this new guide zone has a matching our next node index
      if  current_object.spawn_sequence == temp_num0
      -- then if the biped is actually in this zone
      and current_object.shape_contains(temp_obj0.ai_biped) then
         temp_obj0.ai_guide_obj = current_object
         temp_obj0.ai_retarget_timer = 0 
         temp_obj0.ai_path_index = current_object.spawn_sequence
      end
   end
end

function ai_move()
   if temp_num0 > 0 then
      current_object.ai_prevent_walking_animation = no_team
      current_object.copy_rotation_from(current_object.ai_biped, true)
      current_object.attach_to(current_object.ai_biped, -1, 0, 0, relative)
      current_object.detach()
      current_object.ai_biped.attach_to(current_object, 1, 0, 0, relative)
      current_object.ai_biped.detach()
      temp_num0 -= 1
      ai_move()
   end
end
function ai_attack()

   -- then create the object that will be used to create the explosion effect
   get_biped_weapon() -- outputs to temp_obj1
   -- create shot
   if current_object.ai_biped.is_of_type(spartan) then -- we could get away with stacking these conditions here??
      temp_obj0 = temp_obj1.place_at_me(machine_gun_turret, "detonate", suppress_effect, 0,0,0,none)
   end
   if current_object.ai_biped.is_of_type(elite) then
      temp_obj0 = temp_obj1.place_at_me(plasma_cannon, "detonate", suppress_effect, 0,0,0,none)
   end
   temp_obj0.set_scale(1)
   temp_obj0.attach_to(temp_obj1, 3,0,0, relative)
   temp_obj0.object[0] = temp_obj1 -- dont tell sofasleeper

   -- update shot count
   current_object.ai_shots_fired += 1
   -- then apply damage to target
   if current_object.ai_state == ai_fighting then
      -- create the damage effect bounce bounce thing idk what you call it
      temp_obj0 = current_object.ai_dest.place_at_me(monitor, none, none, 0,0,8,none)
      temp_obj0.attach_to(current_object.ai_dest, 0,0,8, relative)
      temp_obj0.kill(true)

      -- perform damage calculations
      temp_num1 = current_object.ai_attack_type
      temp_num0 = current_object.ai_dest.shields
      current_object.ai_dest.shields -= temp_num1
      temp_num1 -= temp_num0
      if temp_num1 > 0 then
         temp_num1 *= 2
         current_object.ai_dest.health -= temp_num1
      end
   end
   -- or to target vehicle
   if current_object.ai_state == ai_fighting_vehicle then
      temp_obj1 = current_object.ai_dest.place_between_me_and(current_object.ai_dest, plasma_cannon, 0)
      temp_obj1.kill(true) -- this should also delete
      temp_obj1 = current_object.ai_dest
      cleanup_plasma_turrets()
   end
end
-- cleanup all shooting effect thingos
for each object with label "detonate" do
   temp_obj1 = current_object.object[0]
   prepare_garbage_collect() -- takes temp_obj1
   current_object.kill(true) -- this should also delete
   garbage_collect()
   --current_object.delete()
end


-- figure out which players are able to be selected (we let AI use them for 1 second after they spawn in)
for each player do
   current_player.available_for_yoinking_timer.set_rate(-100%)
   if current_player.biped == no_object then -- TODO: free condition probably
      current_player.available_for_yoinking_timer.reset()
   end
end
-- find a player to help set this AI's team
function restore_helper_player()
   if current_object.ai_team_helper != no_player then
      temp_player0 = current_object.ai_team_helper
      temp_player0.set_biped(temp_player0.restore_biped)
      temp_player0.state = none_
      current_object.ai_team_helper = no_player
   end
end
for each object with label "AI" do
   if current_object.ai_biped != no_object then
      temp_obj4 = current_object.ai_biped
      temp_obj4.team = current_object.team -- assign team
      if temp_obj4.ai_has_team == 0 then
         for each player do
            if current_player.team == current_object.team and current_player.state == none_ and current_player.biped != no_object and current_player.in_spawn == 1 and not current_player.available_for_yoinking_timer.is_zero() and current_object.ai_team_helper == no_player then
               current_object.ai_team_helper = current_player
               current_player.state = assigning_ai_team
               current_player.restore_biped = current_player.biped
               current_player.set_biped(current_object.ai_biped)
               game.show_message_to(current_player, none, "Borrowing player controls... (buggy screen)")
            end
         end
      end
      -- let a player go if this AI was borrowing them
      if current_object.ai_team_helper != no_player then
         temp_obj4.ai_has_team += 1
         if temp_obj4.ai_has_team >= 6 then
            restore_helper_player()
         end
      end
   end
end
-- reset AI destination timer after too long
for each object with label "AI" do
   if current_object.ai_retarget_timer.is_zero() then
      current_object.ai_dest = no_object
      temp_num0 = rand(40)
      temp_num0 += 5
      current_object.ai_retarget_timer = temp_num0
   end 
end
-- give AI an initial destination and also give them a objective/player target
for each object with label "AI" do
   if current_object.ai_biped != no_object then
      temp_obj0 = current_object
      -- initial destination
      if current_object.ai_state == ai_looking_for_dropship then
         if current_object.ai_dest == no_object then
            -- hop into a pelican if theres one available
            for each object with label "dropship" do
               if temp_obj0.ai_dest == no_object and current_object.team == temp_obj0.team and current_object.dropship_state == at_home and current_object.ai_passengers < max_ai_passengers then
                  temp_obj0.ai_dest = current_object.yaw_helper -- we want them to go for the vehicle origin point??
                  current_object.ai_passengers += 1 -- we essentially claim this seat
               end
            end
            if current_object.ai_dest == no_object then
               -- or go into a droppod
               for each object with label "com_station" do
                  if current_object.team == temp_obj0.team and current_object.spawn_sequence == droppod_station then
                     temp_obj0.ai_dest = current_object
                     temp_obj0.ai_state = ai_boarding_droppod -- this locks them into the decision
                  end
               end
            end
         end
      end
      -- target to attack
      if current_object.ai_state >= ai_deployed then
         current_object.ai_retarget_timer.set_rate(-1000%)
         if current_object.ai_dest == no_object then
            -- find our new objective
            temp_num1 = 32000 -- max distance
            -- look for active guide zone
            if current_object.ai_guide_obj != no_object then
               temp_obj1 = current_object.ai_guide_obj
               if temp_obj1.spawn_sequence == current_object.ai_path_index then
                  temp_num1 = 10 -- make it so we can only target other things that are within 10 units while pathing, this also means that we cant go after objectives as they never fall within this distance as they are minium dist of 120?
                  temp_obj0.ai_dest = current_object.ai_guide_obj
                  temp_obj0.ai_state = ai_pathing
               end
            end
            -- look for enemy players
            for each player do
               if current_player.biped != no_object and current_player.team != temp_obj0.team then
                  temp_num0 = temp_obj0.ai_biped.get_distance_to(current_player.biped)
                  if temp_num0 < temp_num1 and temp_num0 < ai_max_see_player_distance then
                     temp_obj1 = current_player.biped
                     if temp_obj1.is_illegal_target != biped_is_illegal then
                        -- cant see camo players unless they are close??
                        if temp_obj1.is_illegal_target != biped_is_camo or temp_num0 < ai_max_see_camo_player_distance then
                           temp_num1 = temp_num0
                           temp_obj0.ai_dest = current_player.biped
                           temp_obj0.ai_state = ai_fighting
                           if current_player.player_vehicle != no_object and not current_player.player_vehicle.has_forge_label("dropship") and not current_player.player_vehicle.has_forge_label("droppod") then
                              temp_obj0.ai_dest = current_player.player_vehicle
                              temp_obj0.ai_state = ai_fighting_vehicle
                           end
                        end
                     end
                  end
               end
            end
            -- look for enemy ai 
            for each object with label "AI" do
               if current_object.ai_biped != no_object and current_object.team != temp_obj0.team then
                  temp_num0 = temp_obj0.ai_biped.get_distance_to(current_object.ai_biped)
                  if temp_num0 < temp_num1 and temp_num0 < ai_max_see_player_distance then
                     temp_num1 = temp_num0
                     temp_obj0.ai_dest = current_object.ai_biped
                     temp_obj0.ai_state = ai_fighting
                  end
               end
            end
            -- look for objectives
            for each object with label "inv_objective" do
               if INV_core == no_object and current_object.spawn_sequence == INV_phase then
                  temp_num0 = temp_obj0.ai_biped.get_distance_to(current_object)
                  if temp_num0 < ai_min_objective_distance then
                     temp_num0 = ai_min_objective_distance
                  end
                  if temp_num0 < temp_num1 then
                     temp_num1 = temp_num0
                     temp_obj0.ai_dest = current_object
                     temp_obj0.ai_state = ai_objective
                  end
               end
            end
            -- look for core
            -- TODO if phase 3 then we need to spread out around the core
            if INV_core != no_object then
               temp_num0 = temp_obj0.ai_biped.get_distance_to(INV_core)
               if temp_num0 < ai_min_objective_distance then
                  temp_num0 = ai_min_objective_distance
               end
               if temp_num0 < temp_num1 then
                  temp_num1 = temp_num0
                  temp_obj0.ai_dest = INV_core
                  temp_obj0.ai_state = ai_objective
               end
            end



         end
      end
   end
end
-- clear AI target if its a dropship and its left without them, and also clear target player if they are in an illegal targetting state
for each object with label "AI" do
   if current_object.ai_dest != no_object then
      temp_obj0 = current_object.ai_dest
      if current_object.ai_state == ai_looking_for_dropship then
         -- temp_obj1 = temp_obj0.parent_dropship
         temp_obj1 = current_object
         for each object with label "dropship" do
            if temp_obj0 == current_object.yaw_helper and current_object.dropship_state != at_home then
               temp_obj1.ai_dest = no_object
            end
         end
      end
      if current_object.ai_state == ai_fighting and temp_obj0.is_illegal_target == biped_is_illegal then
         current_object.ai_dest = no_object
      end
   end
end


-- make AI do shooting and walking and boardig droppods/dropships
for each object with label "AI" do
   current_object.ai_attack_ticks += 1
   -- DEBUG: rotation and shooting script
   if current_object.ai_biped != no_object then
      if current_object.ai_dest != no_object then
         -- make the AI walk towards us??
         -- TODO add some slight randomousity in here
         current_object.ai_biped.face_toward(current_object.ai_dest, 0,0,0)
         temp_num2 = current_object.ai_biped.get_distance_to(current_object.ai_dest)
         temp_num1 = current_object.ai_biped.get_speed()
         if current_object.ai_state > ai_deployed then
            if temp_num2 > ai_min_goto_range and temp_num1 < ai_walk_speed 
            and current_object.ai_attack_ticks >= 0 or current_object.ai_attack_type == ai_type_ranged then
               temp_num0 = 1
               ai_move()
            end
         end
         
         -- if they reached destination during init stage
         if current_object.ai_state <= ai_boarding_droppod then
            if temp_num1 < ai_walk_speed then
               temp_num0 = 1
               ai_move()
            end
            -- we need to prevent walking animations before the AI gets to the objective thingo, so the client doesn't detach them once they board it
            if temp_num2 <= 35 then
               current_object.ai_prevent_walking_animation = neutral_team
               if temp_num2 <= 22 then
                  --current_object.ai_biped.attach_to(current_object, 0,0,0,relative) -- stick the biped to the location so its a bit easier to track and release
                  -- if droppod dest, then shoot them out
                  if current_object.ai_state == ai_looking_for_dropship then
                     current_object.ai_biped.attach_to(current_object.ai_dest, 0,0,0,relative)
                     current_object.ai_state = ai_deploying
                  end
                  -- if dropship dest, then pop them in
                  if current_object.ai_state == ai_boarding_droppod and ai_droppod_interval_timer.is_zero() then
                     current_object.ai_state = ai_deploying
                     -- quickly find the spot and then droppod mode them
                     temp_obj4 = current_object.ai_biped
                     temp_obj5 = current_object
                     for each object with label "holo_spawn" do
                        if current_object.team == temp_obj5.team and current_object.spawn_sequence == INV_phase then
                           temp_obj1 = current_object
                           create_droppod_at()
                           temp_obj2.dp_ai_passenger = temp_obj5 -- so they can release the AI properly
                           ai_droppod_interval_timer.reset()
                        end
                     end
                  end
               end
            end
         end

         -- if the AI is just cruising along on the map 
         if current_object.ai_state >= ai_fighting then
            -- make sure we're using the right weapon to fight vehicles
            if current_object.ai_state == ai_fighting_vehicle and current_object.ai_attack_type != ai_type_ranged then
               current_object.ai_attack_type = ai_type_ranged
               update_ai_weapon()
               current_object.ai_attack_ticks = -52 -- give a bit of a cooldown before they can shoot, as they've just swapped weapons!
            end

            -- ranged attacking
            if current_object.ai_attack_type == ai_type_ranged then
               if current_object.ai_attack_ticks >= ai_ranged_interval and temp_num2 <= ai_ranged_range then
                  current_object.ai_attack_ticks = 0
                  ai_attack()
                  -- check if we have completed the burst, then give us a big cooldown on shooting
                  temp_num0 = current_object.ai_shots_fired
                  temp_num0 %= ai_ranged_burst_count
                  if temp_num0 == 0 then
                     current_object.ai_attack_ticks = rand(ai_ranged_burst_cooldown)
                     current_object.ai_attack_ticks += ai_ranged_burst_cooldown_min
                     current_object.ai_attack_ticks *= -1
                  end
               end
            end
            -- close quarters attacking
            -- SPARTAN SHOTTIE SHOOT SYSTEM
            if current_object.ai_attack_type == ai_type_shottie then
               if temp_num2 <= ai_shottie_range then
                  if current_object.ai_attack_ticks >= ai_shottie_interval then
                     current_object.ai_attack_ticks = 0
                     -- TODO: do at least half damage based on distance to the target as our dynamic feature
                     ai_attack()
                  end
               end
            end
            -- ELITE LUNGE SYSTEM
            if current_object.ai_attack_type == ai_type_sword then
               if temp_num2 <= ai_lunge_range then
                  -- initiate lunge
                  if current_object.ai_attack_ticks >= ai_lunge_interval then
                     current_object.ai_attack_ticks = ai_lunge_duration
                     -- dont lunge if they're close enough to just stab
                     if temp_num2 > ai_stab_range then
                        temp_num0 = 15
                        ai_move()
                     end
                  end
               end
               -- if lunge in progress, check to see if its connected
               if current_object.ai_attack_ticks < 0 then
                  current_object.ai_prevent_walking_animation = neutral_team -- we dont play walking animations while lunging
                  if current_object.ai_attack_ticks > ai_stab_timeout then 
                     if temp_num2 <= ai_stab_range then
                        -- initiate stab
                        current_object.ai_attack_ticks = ai_stab

                        current_object.ai_biped.remove_weapon(primary, true)
                        current_object.ai_biped.add_weapon(plasma_pistol, primary)
                        -- signal to clients that they need to update
                        current_object.ai_generate_sword_count += 1
                     end
                  end
               end
               if current_object.ai_attack_ticks == ai_stab_damage then 
                  ai_attack()
               end
            end
         end
      end
      -- clear stab animation stuff
      if current_object.ai_attack_type == ai_type_sword and current_object.ai_attack_ticks == ai_stab_timeout then 
         current_object.ai_biped.remove_weapon(primary, true)
         current_object.ai_biped.add_weapon(energy_sword, primary)
         current_object.ai_attack_ticks = 0
      end
   end
end
-- death detecting script
   -- for each object with label "AI" do
   --    if current_object.ai_biped != no_object then
   --       temp_num0 = current_object.ai_biped.health
   --       if temp_num0 == 0 then
   --       end
   --    end
   -- end
-- AI rubbish cleanup script
on object death: do
   -- check if this was an AI's biped
   for each object with label "AI" do
      if killed_object == current_object.ai_biped and current_object.ai_biped != no_object then -- second is potentially redundant??
         -- clear helper player if we had one, so players wont randomly die during the start of the their spawn thingo
         restore_helper_player()
         -- clear spawn & waypoint status
         current_object.ai_biped.set_spawn_location_permissions(no_one)
         current_object.ai_biped.set_waypoint_visibility(no_one)
         --game.show_message_to(all_players, none, "AI has died!")
         current_object.ai_biped = no_object

         for each object do
            temp_num0 = current_object.get_distance_to(killed_object)
            if temp_num0 == 0 then
               -- if current_object.is_of_type(frag_grenade) then
               --    current_object.delete()
               --    game.show_message_to(all_players, none, "frag deleted at %n", temp_num0)
               -- end
               -- we need to delete the weapons they drop (the plasma pistol is used for the energy sword animation)
               if current_object.is_of_type(shotgun) or current_object.is_of_type(plasma_rifle) or current_object.is_of_type(plasma_pistol) or current_object.is_of_type(energy_sword) or current_object.is_of_type(assault_rifle) then
                  -- then check to see if the weapon is held by another player or AI before deleting
                     --temp_obj0 = current_object
                     -- can be simplified
                     -- for each player do
                     --    if current_player.biped != no_object and temp_num0 != 0 then
                     --       temp_num0 = temp_obj0.get_distance_to(current_player.biped)
                     --    end
                     -- end
                     -- for each object with label "AI" do
                     --    if current_object.ai_biped != no_object and temp_num0 != 0 then
                     --       temp_num0 = temp_obj0.get_distance_to(current_object.ai_biped)
                     --    end
                     -- end
                     -- game.show_message_to(all_players, none, "weapon at %n", temp_num0)
                     -- for each object do
                     --    if current_object.is_of_type(spartan) or current_object.is_of_type(elite) and temp_num0 != 0 then
                     --       temp_num0 = temp_obj0.get_distance_to(current_object.ai_biped)
                     --    end
                     -- end
                  --if temp_num0 == 0 then 
                  current_object.delete()
                  --end
               end
            end
         end
      end
   end
end
-- cleanup all dropped grenades
for each object with label 1 do
   current_object.delete()
end
-- END OF SECTION ------------------------------------------------------------------------------------------------






----------------
-- LOCAL CODE --
----------------
-- for each object with label "AI" do
--    current_object.set_waypoint_text("t:%n", hud_target_object.ai_client_last_pos_update_ticks)
--    current_object.set_waypoint_visibility(everyone)
--    current_object.set_waypoint_range(0, 6)
-- end
on local: do
   -- TESTING AI LOGIC -- TODO: move to bottom of local section
   if is_host <= 0 then
      -- move turret effect generator thingos outta the way?
      for each object with label "client_detonate_tracker" do
         if current_object.object[0] == no_object then
            current_object.delete()
         end
      end
      for each object with label "detonate" do
         if current_object.object[0] == no_object then
            temp_obj0 = current_object.place_at_me(sound_emitter_alarm_2, "client_detonate_tracker", none, 0,0,0,none)
            temp_obj0.attach_to(current_object, 0,0,0, relative)
            temp_obj0.detach()
            temp_obj0.object[0] = current_object
            current_object.object[0] = temp_obj0
            current_object.detach()
            current_object.attach_to(current_object.object[0], 0,0,0, relative)
         end
      end
      -- AI walking and sword swing animations
      for each object with label "AI" do
         if current_object.ai_biped != no_object then
            -- tick the debug ticker thing
            -- current_object.ai_client_pos_update_ticker += 1
            -- if current_object.ai_client_pos_update_ticker == 60 then
            --    current_object.ai_client_pos_update_ticker = 0
            --    current_object.ai_client_last_pos_update_ticks = current_object.ai_client_pos_update_ticks
            --    current_object.ai_client_pos_update_ticks = 0
            -- end
            -- -- boop the biped if its moving so we can get walking animations
            -- temp_num0 = current_object.ai_biped.get_speed()
            -- if temp_num0 > 2 then
            --    current_object.ai_client_pos_update_ticks += 1
            -- end
            --    temp_num0 = current_object.ai_biped.get_distance_to(current_object)
            --    -- if they aren't moving much, then 
            --    if temp_num0 < 10 then
            --       current_object.ai_biped.attach_to(current_object, 0,0,0,relative)
            --       current_object.ai_biped.detach()
            --    end
            --    if temp_num0 >= 10 then
            --       temp_obj0 = current_object.ai_biped.place_between_me_and(current_object.ai_biped, sound_emitter_alarm_2, 0)
            --       temp_obj0.copy_rotation_from(current_object.ai_biped, true)
            --       temp_obj0.face_toward(current_object, 0,0,0)
            --       current_object.ai_biped.attach_to(temp_obj0, 10,0,0, relative)
            --       current_object.ai_biped.detach()
            --       temp_obj0.delete()
            --    end
            -- end

            if current_object.ai_prevent_walking_animation == no_team then
               temp_num0 = current_object.ai_biped.get_distance_to(current_object)
               if temp_num0 > 1 then
                  -- then cancel velocity and move our dude a small bit backwards
                  temp_obj0 = current_object.ai_biped.place_between_me_and(current_object.ai_biped, sound_emitter_alarm_2, 0)
                  temp_obj0.copy_rotation_from(current_object.ai_biped, true)
                  temp_obj0.face_toward(current_object, 0,0,0)

                  current_object.ai_biped.attach_to(temp_obj0, 1,0,0,relative)
                  temp_obj0.set_scale(25)
                  temp_obj0.copy_rotation_from(temp_obj0, true)
                  current_object.ai_biped.detach()
                  temp_obj0.delete()
               end
            end

            -- update weapon to pretend like its an energy sword
            if current_object.ai_generate_sword_count_client != current_object.ai_generate_sword_count then
               current_object.ai_generate_sword_count_client =  current_object.ai_generate_sword_count

               get_biped_weapon()
               temp_obj1.set_scale(1)
               temp_obj2 = temp_obj1.place_at_me(energy_sword, none, suppress_effect, 0,0,0,none)
               temp_obj2.copy_rotation_from(temp_obj1, true)
               temp_obj2.attach_to(temp_obj1, 0,0,0,relative)
            end
         end
      end   
      -- fixup attached portable objects
      -- for each object with label "portable" do
      --    if current_object.p_interact != no_object and current_object.p_last_holder != no_player then
      --       current_object.detach()
      --       current_object.copy_rotation_from(current_object.p_last_holder.biped, false)
      --       current_object.face_toward(current_object, 0,1,0)
      --       current_object.attach_to(current_object.p_interact, 0,0,0,relative)
      --       -- we could put a host check here but it honest to god does not matter and we're going to run out of conditions soon!!
      --       current_object.p_plant_ticks = p_ticks_to_plant
      --    end
      -- end
   end

   -- do client/host stuff for objects of type
   for each object do
      -- hide placeholder weapons (splaser)
      --if current_object.is_of_type(spartan_laser) then
      --   current_object.set_hidden(true)
      --end
      -- show shield objects
      if current_object.is_of_type(soft_safe_boundary) then
         if current_object.team == no_team then
            current_object.set_hidden(false)
            if is_host > 0 then -- just so we can keep this in one place
               current_object.set_scale(80)
               current_object.set_shape(sphere, 0)
            end
         end
      end
      if current_object.is_of_type(grid) or current_object.is_of_type(spartan_laser) then
         current_object.set_hidden(true)
      end  
      -- move all detonation effect turrets to the thingo?
      
      -- if is_host <= 0 then
      --    if current_object.is_of_type(machine_gun_turret) or current_object.is_of_type(plasma_cannon) and current_object.team != ELITES then
      --       current_object.attach_to()
      --    end
      -- end
   end
   -- hide all scale seq -20 objects
   for each object with label "scale" do
      if current_object.spawn_sequence == -20 then
         current_object.set_hidden(true)
      end
   end
   -- INV thing
   set_scenario_interpolator_state(1, INV_objective_contested)
   --if is_host <= 0 then -- is not the host
      -------------------------
      -- LOCAL PLAYER FINDER --
      -------------------------
      -- for each player do
		-- 	if local_player_ == no_player and current_player.biped != no_object then
		-- 		if current_player.local_finder == no_object then
		-- 			current_player.local_finder = current_player.biped.place_at_me(elite, none, suppress_effect, 5, 0, 2, none)
		-- 		end
		-- 		temp_obj0 = current_player.get_crosshair_target()
		-- 		if temp_obj0 != no_object then
		-- 			local_player_ = current_player
		-- 			for each player do
		-- 				current_player.local_finder.delete()
		-- 			end
		-- 		end
		-- 	end
		-- end
      -- local player section
      --if local_player_ != no_player then
         -----------------------------------------
         -- CONFIGURE LOCAL PLAYER TOP DOWN POV --
         -----------------------------------------
         -- if local_player_.biped != no_object and local_player_.state == controlling_hologram then 
         --    -- check if weapon was misconfigured -> reset (i think this fires when the player detaches??))
         --    if holo_local_weapon == no_object then 
         --       -- throw some quick checks out first, to make sure everything has sync'd
         --       if local_player_.location != no_object then
         --          -- clear previous attachment
         --          local_player_.biped.detach()
         --          holo_local_marker.delete()
         --          -- here we configure the hologram
         --          local_player_.biped.add_weapon(unsc_data_core, force) -- POTENTIAL FOR FAILIRE; MIGHT NOT BEABLE TO HOLD WEAPON
         --          holo_local_weapon = local_player_.get_weapon(primary) -- remember which weapon we were holding

         --          holo_local_marker = local_player_.location.place_between_me_and(local_player_.location, flag_stand, 0) -- pitch agent
         --          -- alias yaw_agent = temp_obj1
         --          --temp_obj1 = holo_local_marker.place_at_me(flag_stand, none, none, 0,0,0, none)
         --          -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
         --          --temp_obj1.face_toward(temp_obj1,0,-1,0)
         --          --holo_local_marker.attach_to(temp_obj1, 0,0,0,relative)
         --          -- get position and then fix it up??
         --          --temp_obj1.copy_rotation_from(default_yaw, true)
         --          --temp_obj1.face_toward(temp_obj1, 0,1,0)
         --          --holo_local_marker.detach()
         --          --temp_obj1.delete()
                  
         --          local_player_.biped.copy_rotation_from(default_yaw, true)
         --          local_player_.biped.attach_to(holo_local_marker, 0,10,0,relative)
         --          holo_local_marker.face_toward(holo_local_marker, 0, 1, 0)

         --          holo_local_marker.attach_to(local_player_.location, 0,0,60, relative)
         --       end
         --    end
         -- end

         ---------------------
         -- CONTEXT WIDGETS --
         ---------------------
         -- context_wgt0.set_text("")
         -- context_wgt0.set_meter_params(none)
         -- if local_player_.class == elite_medic or local_player_.class == spartan_medic then
         --    context_wgt0.set_text("MEDIC: throw healthkits") 
         --    context_wgt0.set_meter_params(timer, local_player.grenade_regen_timer)
         --    if local_player_.class_disabled == 1 then
         --       context_wgt0.set_text("MEDIC: ability disabled") 
         --    end
         -- end
         
      -- ORDNANCE DEPRECATED --
      -- COMMAND DEPRECATED --
         -- if local_player_.state != none_ or local_player_.stowables_disabled == 1 then
         --    context_wgt0.set_meter_params(none)
         -- end
         -- if local_player_.stowables_disabled == 1 then
         --    context_wgt0.set_text("Stowables are disabled here")
         -- end
         -- if local_player_.state == hologram_to_interact then 
         --    context_wgt0.set_text("Hologram to interact")
         -- end
         -- alias dropship_station   = 0
         -- alias AI_station         = 1
         -- alias droppod_station    = 2
         -- alias ordnance_station   = 3
         -- TODO: use unicodes to demonstrate the button to press??
         -- context_wgt_obj = local_player_.station
         -- if context_wgt_obj.spawn_sequence == ordnance_station then
         --    context_wgt0.set_meter_params(timer, context_wgt_obj.ordnance_timer)
         -- end
         -- if local_player_.state == controlling_hologram then 
         --    if context_wgt_obj != no_object then
         --       if context_wgt_obj.spawn_sequence == dropship_station then
         --          context_wgt0.set_text("Controlling dropship %n, SWAP to change\r\nABILITY to direct dropship\r\nJUMP to exit", context_wgt_obj.dropship_index)
         --       end
         --       if context_wgt_obj.spawn_sequence == AI_station then
         --          --context_wgt0.set_text("\r\nJUMP to exit")
         --       end
         --       if context_wgt_obj.spawn_sequence == droppod_station then
         --          context_wgt0.set_text("ABILITY to enter droppod\r\nJUMP to exit")
         --       end
         --       if context_wgt_obj.spawn_sequence == ordnance_station then
         --          context_wgt0.set_text("ABILITY to lay mines\r\nSWAP to change\r\nJUMP to exit")
         --          if context_wgt_obj.ordnance_type == DROP_supplies then
         --             context_wgt0.set_text("ABILITY to drop supplies\r\nSWAP to change\r\nJUMP to exit")
         --          end
         --       end
         --    end
         -- end
      --end
      -- end of local player section
   --end
   -- DEBUG OBJ COUNTER
   -- temp_num0 = 0
   -- for each object do
   --    temp_num0 += 1
   -- end 
end
-- END OF SECTION ------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- COMPACT INVASION CODE --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- INVASION
   on pregame: do
      game.symmetry = 0
   end

   do
      INV_objective_contested = 0
      game.round_timer.set_rate(-100%) -- because apparently this stops counting down under some conditions??
      INV_vo_attack_timer.set_rate(-100%)
      INV_suddendeath_vo_timer.set_rate(-100%)
      INV_vo_core_held_timer.set_rate(-100%)
      INV_under_attack_widget.set_text("Your objective is under attack!")
   end

   -------------------------------
   -- PLAYER INTRO AND LOADOUTS --
   -------------------------------
   for each player do
      current_player.set_co_op_spawning(true)
      current_player.init_ticks += 1
      INV_under_attack_widget.set_visibility(current_player, false)
      if current_player.init_ticks == 300 then -- 5 seconds
         send_incident(custom_game_start, current_player, no_player)
         send_incident(invasion_game_start_c, current_player, no_player)
         if current_player.team == ELITES then 
            --send_incident(isle_cv_ph1_intro, current_player, no_player)
            send_incident(team_defense, current_player, no_player)
         end
         if current_player.team == SPARTANS then
            --send_incident(isle_sp_ph1_intro, current_player, no_player)
            send_incident(team_offense, current_player, no_player)
         end
      end
   end
   -- intro mod message
   for each player do 
      if current_player.init_ticks == 350 then 
         game.show_message_to(current_player, none, "Epic mod by Gamergotten, shoutout: Rabid, Milk & Cartographers")
      end
   end
   -- title cards team things + spartan traits
   for each player do
      current_player.biped.set_waypoint_visibility(allies)
      current_player.biped.set_waypoint_priority(normal)
      --current_player.set_objective_allegiance_icon(covenant)
      --current_player.set_objective_allegiance_name("Elite")
      if current_player.team == SPARTANS then 
         --current_player.set_objective_allegiance_icon(noble)
         --current_player.set_objective_allegiance_name("Spartan")
         current_player.apply_traits(spartan_traits)
      end
   end
   -- elite traits
   for each player do
      if current_player.team == ELITES then
         current_player.apply_traits(elite_traits)
      end
   end
   -- title card objective text + loadouts
   for each player do
      if INV_phase == 1 then 
         current_player.set_loadout_palette(spartan_tier_1)
         current_player.set_objective_text("CAPTURE THE OBJECTIVE")
         if current_player.team == ELITES then 
            current_player.set_loadout_palette(elite_tier_1)
            current_player.set_objective_text("DEFEND THE OBJECTIVE")
         end
      end
   end
   for each player do
      if INV_phase == 2 then 
         current_player.set_loadout_palette(spartan_tier_2)
         current_player.set_objective_text("CAPTURE ALL OBJECTIVES")
         if current_player.team == ELITES then 
            current_player.set_loadout_palette(elite_tier_2)
            current_player.set_objective_text("DEFEND ALL OBJECTIVES")
         end
      end
   end
   for each player do
      if INV_phase == 3 then 
         current_player.set_loadout_palette(spartan_tier_3)
         current_player.set_objective_text("CAPTURE THE CORE")
         if current_player.team == ELITES then 
            current_player.set_loadout_palette(elite_tier_3)
            current_player.set_objective_text("DEFEND THE CORE")
         end
      end
   end
   -- END OF SECTION --------------------------------------------------------------------


   ----------------------------
   -- PHASE SPECIFIC OBJECTS --
   ----------------------------
   for each object with label "inv_thing" do
      if current_object.spawn_sequence > INV_phase then 
         current_object.delete()
      end
   end   
   -- END OF SECTION --------------------------------------------------------------------

   -----------------------
   -- TERRITORIES LOGIC --
   -----------------------
   -- for each object with label "inv_objective" do -- this is probably redundant as objectives have to be deleted to progress
   --    if current_object.spawn_sequence < INV_phase and current_object.spawn_sequence != 0 then 
   --       current_object.delete()
   --    end
   -- end
   for each object with label "inv_objective" do -- also dobles for flag capture zone
      if current_object.spawn_sequence == INV_phase and INV_phase <= 2 then 
         current_object.set_waypoint_visibility(everyone)
         current_object.set_waypoint_icon(ordnance)
         current_object.set_waypoint_priority(high)
         current_object.set_shape_visibility(everyone)
         current_object.set_progress_bar(0, enemies)
         current_object.set_waypoint_timer(object.cap_timer)
         if current_object.sounder == no_object then -- store as object reference just so its only run once!!
            current_object.sounder = current_object.place_at_me(sound_emitter_alarm_1, none, never_garbage_collect | suppress_effect, 0, 0, 0, none)
            current_object.sounder.attach_to(current_object, 0,0,5,relative) -- so its deleted when this is deleted
         end
      end
   end
   for each object with label "inv_objective" do
      if current_object.spawn_sequence == INV_phase and INV_phase <= 2 then 
         current_object.cap_timer.set_rate(0%)
         -- count players in hill
         SPARTANS.team_num0 = 0
         ELITES.team_num0 = 0
         for each player do
            if current_object.shape_contains(current_player.biped) then 
               temp_team0 = current_player.team
               temp_team0.team_num0 += 1
            end
         end
         -- count AI in hill
         temp_obj0 = current_object
         for each object with label "AI" do
            if temp_obj0.shape_contains(current_object.ai_biped) then 
               temp_team0 = current_object.team
               temp_team0.team_num0 += 1
            end
         end
         -- if controlled by SPARTANS, blink and allow sudden death
         if SPARTANS.team_num0 > 0 then 
            INV_objective_contested = 1
            current_object.set_waypoint_priority(blink)
            if ELITES.team_num0 == 0 then -- contest if ELITES
               current_object.cap_timer.set_rate(-100%)
            end
         end
         -- regenerate timer if no SPARTANS
         if SPARTANS.team_num0 == 0 and current_object.cap_timer < INV_territory_regen then 
            current_object.cap_timer.set_rate(100%)
         end
      end
   end
   -- if objective is complete then get rid of it
   for each object with label "inv_objective" do
      if current_object.cap_timer.is_zero() then 
         current_object.delete() -- clear current objective
         game.play_sound_for(all_players, boneyard_generator_power_down, true)
         if INV_phase == 1 then -- phase 1 we only need to cap a single objective
            for each object with label "inv_objective" do
               if current_object.spawn_sequence == 1 then
                  current_object.delete()
               end
            end
         end
      end
   end
   -- show objective under attack widget
   if INV_objective_contested == 1 and INV_phase <= 2 then
      for each player do
         if current_player.team == ELITES then 
            INV_under_attack_widget.set_visibility(current_player, true)
         end
      end
      if INV_vo_attack_timer.is_zero() then
         game.play_sound_for(ELITES, announce_a_under_attack, true)
         INV_vo_attack_timer.reset()
      end
   end
   -- END OF SECTION --------------------------------------------------------------------


   ---------------------
   -- CTF PHASE LOGIC --
   ---------------------
   -- reset core
   if INV_core.is_out_of_bounds() or INV_core.reset_timer.is_zero() then 
      INV_core.delete()
      send_incident(INV_core_reset, all_players, all_players)
   end
   -- determine core holder
   do
      INV_flag_carrier = no_player -- INV_core.get_carrier()
      if INV_core != no_object then
         for each player do
            if current_player.biped != no_object then
               temp_num0 = current_player.biped.get_distance_to(INV_core)
               if temp_num0 == 0 then
                  INV_flag_carrier = current_player
               end 
            end
         end
      end
   end
   -- spawn core
   for each object with label "inv_objective" do
      if current_object.spawn_sequence == 5 and INV_phase == 3 then 
         if INV_core == no_object then 
            INV_core = current_object.place_at_me(covenant_power_core, none, never_garbage_collect, 0, 0, 3, none)
            INV_core.team = ELITES
            INV_core.set_pickup_permissions(enemies)
            INV_core.set_weapon_pickup_priority(high)
            INV_core.set_shape(sphere, 10)
         end
      end
   end
   function recurse_pushup()
      if temp_num0 > 0 then
         INV_core.push_upward()
         temp_num0 -= 1
         recurse_pushup()
      end
   end
   -- update core icons + bump if players trying to pick it up??
   if INV_core != no_object then -- this condition is also redundant -- and INV_flag_carrier == no_player
      INV_core.set_waypoint_icon(flag)
      INV_core.set_waypoint_visibility(everyone)
      INV_core.set_waypoint_priority(high)
      INV_core.set_progress_bar(object.reset_timer, allies)
      -- do the core extract widget stuff
      INV_under_attack_widget.set_text("Bring the core aboard a pelican for extract!")
      for each player do
         INV_under_attack_widget.set_visibility(current_player, false)
      end
      INV_under_attack_widget.set_visibility(INV_flag_carrier, true)

      -- bump logic
      INV_core.bump_timer.set_rate(1000%)
      if INV_flag_carrier == no_player then
         for each player do
            if current_player.biped != no_object and current_player.team == SPARTANS then
               temp_num0 = current_player.biped.get_distance_to(INV_core)
               if temp_num0 <= 5 then
                  INV_core.bump_timer.set_rate(-300%)
                  if INV_core.bump_timer.is_zero() then
                     INV_core.bump_timer.reset()
                     temp_num0 = 20
                     recurse_pushup()
                  end
               end
            end
         end
      end
   end
   -- remove flag carrier icon
   for each player do
      current_player.biped.set_waypoint_icon(none)
   end
   -- capture logic + flag icons and stuff
   if INV_flag_carrier != no_player then -- and INV_core != no_object then 
      INV_core.has_moved = 1
      INV_flag_carrier.apply_traits(INV_flag_traits)
      INV_flag_carrier.biped.set_waypoint_icon(flag)
      INV_core.set_waypoint_visibility(no_one)
      INV_core.set_progress_bar(object.reset_timer, no_one)
      INV_objective_contested = 1
      -- check if core holder is on a dropship!!
      for each object with label "dropship" do
         if current_object.team == SPARTANS then 
            if current_object.shape_contains(INV_flag_carrier.biped) then
               INV_core.delete()
               INV_flag_carrier.biped.detach()
               INV_flag_carrier.force_into_vehicle(current_object)
               send_incident(INV_core_captured, INV_flag_carrier, all_players)
               for each object with label "inv_objective" do
                  if current_object.spawn_sequence == INV_phase then
                     current_object.delete()
                  end
               end
            end
         end
      end
   end
   -- determine whether core is being reset or not
   if INV_core != no_object and INV_core.has_moved == 1 and INV_flag_carrier == no_player then 
      INV_core.reset_timer.set_rate(100%)
      temp_num0 = 0
      for each player do
         if INV_core.shape_contains(current_player.biped) then
            if current_player.team == ELITES then 
               temp_num0 |= 1
            end
            if current_player.team == SPARTANS then 
               temp_num0 |= 2
            end
         end
      end
      for each object with label "AI" do
         if INV_core.shape_contains(current_object.ai_biped) then
            if current_object.team == ELITES then 
               temp_num0 |= 1
            end
            if current_object.team == SPARTANS then 
               temp_num0 |= 2
            end
         end
      end
      -- if elites in boundary then we should start counting down
      if temp_num0 == 1 or temp_num0 == 3 then
         INV_core.reset_timer.set_rate(-100%)
         INV_core.set_waypoint_priority(blink)
         -- if theres also a spartan in there then it needs to be contested
         if temp_num0 == 3 then 
            INV_core.reset_timer.set_rate(0%)
            INV_core.set_waypoint_priority(high)
         end
      end
   end
   -- announce players picking up or dropping the flag
   if INV_phase == 3 and INV_vo_core_held_timer.is_zero() then 
      if INV_last_carrier != INV_flag_carrier then
         if INV_last_carrier == no_player then 
            send_incident(INV_core_grabbed, INV_flag_carrier, all_players)
         end
         if INV_last_carrier != no_player then 
            send_incident(INV_core_dropped, INV_flag_carrier, all_players)
         end
         INV_vo_core_held_timer.reset()
         INV_last_carrier = INV_flag_carrier
      end
   end
   -- announce flag carrier kill
   if INV_flag_carrier.killer_type_is(kill) then -- INV_phase == 3 and
      temp_player0 = INV_flag_carrier.try_get_killer()
      send_incident(flagcarrier_kill, temp_player0, INV_flag_carrier)
   end
   -- detach core when not held by player (to prevent getting stuck on dead bodies?)
   if INV_flag_carrier == no_player then
      INV_core.detach()
   end
   -- END OF SECTION --------------------------------------------------------------------


   -----------------------------
   -- PHASE PROGRESSION LOGIC --
   -----------------------------
   do
      temp_num0 = 0
   end
   for each object with label "inv_objective" do
      if current_object.spawn_sequence == INV_phase then
         temp_num0 += 1
      end
   end
   if INV_phase < 4 and temp_num0 == 0 then
      INV_phase += 1
      game.round_timer.reset() -- = INV_phase_duration -- by default its 4 minutes
      game.sudden_death_timer.reset()
      SPARTANS.score += 1

      -- phase 1 complete
      if INV_phase == 2 then 
         game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
         -- for each player do
            --    if current_player.team == SPARTANS then 
            --       send_incident(isle_sp_ph1_victory, current_player, no_player)
            --    end
            --    if current_player.team == ELITES then 
            --       send_incident(isle_cv_ph2_intro, current_player, no_player)
            --    end
            -- end
      end
      -- phase 2 complete
      if INV_phase == 3 then 
         game.play_sound_for(all_players, inv_cue_spartan_win_2, true)
         -- for each player do
            --    if current_player.team == SPARTANS then 
            --       send_incident(isle_sp_ph2_victory, current_player, no_player)
            --    end
            --    if current_player.team == ELITES then 
            --       send_incident(isle_cv_ph3_intro, current_player, no_player)
            --    end
            -- end
      end
      -- phase 3 complete
      if INV_phase == 4 then 
         pickup_pelican = no_object -- clear this so pelican starts to move away??
         --send_incident(inv_spartan_win, all_players, no_player)
         game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
         -- for each player do
            --    if current_player.team == SPARTANS then 
            --       send_incident(isle_sp_victory, current_player, no_player)
            --    end
            --    if current_player.team == ELITES then 
            --       send_incident(isle_cv_defeat, current_player, no_player)
            --    end
            -- end
      end
   end
   -- END OF SECTION --------------------------------------------------------------------

   ---------------------
   -- GANE OVER LOGIC --
   ---------------------
   if INV_phase == 4 then 
      INV_game_end_delay.set_rate(-100%)
      if INV_game_end_delay.is_zero() then 
         game.end_round()
      end
   end
   if not game.round_timer.is_zero() then 
      game.grace_period_timer = 0
   end
   if not game.grace_period_timer.is_zero() then
      game.grace_period_timer.set_rate(-100%)
   end
   if game.round_timer.is_zero() then 
      if INV_objective_contested == 1 then 
         game.sudden_death_timer.set_rate(-100%)
         game.grace_period_timer.reset()
         if game.sudden_death_time > 0 and game.grace_period_timer > game.sudden_death_timer then 
            game.grace_period_timer = game.sudden_death_timer
         end
         if INV_suddendeath_vo_timer.is_zero() then 
            INV_suddendeath_vo_timer.reset()
            send_incident(sudden_death, all_players, all_players)
         end
      end
      if INV_objective_contested == 0 or game.sudden_death_timer.is_zero() then 
         if game.grace_period_timer.is_zero() or game.sudden_death_timer.is_zero() then 
            -- this is supposed to be called the next tick but whatever
            game.end_round()
            if SPARTANS.score == 0 then 
               send_incident(inv_ELITES_win_rd1, all_players, no_player)
            end
            if SPARTANS.score != 0 then 
               send_incident(inv_elite_win, all_players, no_player)
            end
            
            -- -- ELITES defended p1
               -- if SPARTANS.score == 0 then 
               --    game.play_sound_for(all_players, inv_cue_covenant_win_1, true)
               --    for each player do
               --       if current_player.team == SPARTANS then 
               --          send_incident(isle_sp_ph1_defeat, current_player, no_player)
               --       end
               --       if current_player.team == ELITES then 
               --          send_incident(isle_cv_ph1_victory, current_player, no_player)
               --       end
               --    end
               -- end
               -- -- ELITES defended p2
               -- if SPARTANS.score == 1 then 
               --    game.play_sound_for(all_players, inv_cue_covenant_win_2, true)
               --    for each player do
               --       if current_player.team == SPARTANS then 
               --          send_incident(isle_sp_ph2_defeat, current_player, no_player)
               --       end
               --       if current_player.team == ELITES then 
               --          send_incident(isle_cv_ph2_victory, current_player, no_player)
               --       end
               --    end
               -- end
               -- -- ELITES defended p3
               -- if SPARTANS.score == 2 then 
               --    send_incident(inv_elite_win, ELITES, SPARTANS)
               --    game.play_sound_for(all_players, inv_cue_covenant_win_big, true)
               --    for each player do
               --       if current_player.team == SPARTANS then 
               --          send_incident(isle_sp_defeat, current_player, no_player)
               --       end
               --       if current_player.team == ELITES then 
               --          send_incident(isle_cv_ph3_victory, current_player, no_player)
               --       end
               --    end
               -- end
            --
         end
      end
   end
-- END OF SECTION --------------------------------------------------------------------

-- DEBUG OBJECT COUNTER!!
-- temp_num0 = 0
-- stowed_weapon_wgt.set_value_text("objects %n", temp_num0)
-- for each object do
--    temp_num0 += 1
-- end 
-- for each player do
--    stowed_weapon_wgt.set_visibility(current_player, true)
-- end