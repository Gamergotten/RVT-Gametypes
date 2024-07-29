

-- orthodox rabbi magic man ALIASES --
-- //////////////////////////////////////////////////////////////////////////////////////////
-- brute flag decoration
declare global.team[0] with network priority local = team[0]      -- brute flag (always red)
alias brute_team = global.team[0]

-- // 'L_Damage' object rabbi variables
alias dam_waypoint = object.object[0]
-- then for the 'L_Damage.dam_waypoint' variables
--alias dam_owner = object.object[0] -- also unused??
alias fadeaway_ticks = object.number[6]
alias display_health = object.timer[1]
--alias dam_health = object.number[7] -- unused??


-- // silly extra globals, how have i never thought to use these as extra globals, this is amazing
alias last_building_announced = team[0].number[0]
alias global_tick_counter = team[0].number[3]
global_tick_counter += 1

-- // free globals
declare global.number[9] with network priority local 
declare global.number[10] with network priority local

-- /////////////////////////////////////////////////////////////////////////////////////////

-- TODO LABELS:

-- GG TODO 			- stuff i need to fix up
-- CHECK ALIASES 	- areas that need aliasing

-- fix for leg inversion  - make the face towards larger to make the effect rarer??
-- debris flag stand issue - simple bug when debris objects are deleted because they're obstructing the scarab, it doesn't delete the flag stand that they're attached to, not much of an issue 

--  2 actions: local finder failsafe  - two potentially free actions that just make sure the local player finder biped thing moves with the player, wheres the player will i imagine always see the biped before they could either look away or otherwise
--  9 actions: player squishing       - code that makes players get squised instead of being shoved through the ground if the scarab sits on them, kinda a minor feature and getting pushed under the ground honestly isn't that bad
--  9 actions: local player finder    - if you can optimize the amount of objects the scarab uses, you could potentially just remove the whole 'no collision while local player is away from scarab' stuff because less objects on the scarab means less lag
--  3 actions: territories aggressive - stuff to make scarab more aggressive when there is a territory objective: chasing falcons, putting as much priority on players as objectives, not going only for players in its sightlines

-- 10 actions: wall collie fixup      - code that rotates the wall collies precisely: this is 10 free actions if you decide to disable it, but the og apoc map might need a slight adjustment
--  4 actions: rabbi AA health regen  - bits of code that related to the AA turret having health (yeah theres not a whole lot of actions to save here)
--  9 actions: multi ground shapes    - code that could be optimized if we only had a single shape boundary for the map's ground
-- 12 actions: brute flag decoration  - looks cool, i just listed this here so it was easy to evaluate impact if you do need more script space for something big
--  2 actions: core blocker           - hardly worth removing, but it just looks kinda silly, and most text prompts let you know that you cant take out the core yet anyway

alias SPARTANS = team[0] -- attacking the scarab?
alias ELITES = team[1] -- defending the scarab!


on pregame: do -- is this needed?
   game.symmetry = 0
end
-- alias temp_num0 = global.number[0] -- you win this time
-- brute flag decoration
on init: do
   -- team colour tracking, for brute flag colour.
	global.number[0] = game.current_round
	global.number[0] %= 2
	if global.number[0] != 0 then 
		brute_team = team[1]
	end
end
-- Rabid added
for each object with label "Detonation" do
   current_object.kill(false)
end

-- timers & stuff
declare global.team[1] with network priority high = no_team
alias scenario_iterp_state = global.team[1]

declare global.timer[0] = 5
alias scarab_ready_timer = global.timer[0]
declare global.timer[1] = 8 
alias under_attack_timer = global.timer[1]
declare global.timer[3] = 12        -- Rabid access announcement delay
alias rabid_timer = global.timer[3]

--declare global.timer[2] = 250
--alias scarab_health_display = global.timer[2]

do 
   scarab_ready_timer.set_rate(-100%)
   under_attack_timer.set_rate(-100%)
   --scarab_health_display = 0
end
function call_attack_on_objective()
   if under_attack_timer.is_zero() then
      game.play_sound_for(SPARTANS, announce_a_under_attack, true)
   end
   under_attack_timer.reset()
end

declare global.object[0] with network priority local
declare global.object[1] with network priority local
declare global.object[2] with network priority local
declare global.object[4] with network priority local
declare global.object[5] with network priority local
declare global.object[6] with network priority local
declare global.object[7] with network priority local
declare global.object[8] with network priority local
declare global.object[9] with network priority local


declare global.object[10] with network priority high
alias Scarab = global.object[10]

declare global.object[11] with network priority local 
alias c_goal = global.object[11]


declare global.object[14] with network priority local 
alias projectile_collision_test_agent = global.object[14]

declare global.object[13] with network priority low
alias scrb_mover = global.object[13]

declare global.object[3] with network priority high
alias AA_turret = global.object[3]

declare global.number[8] with network priority local  
alias AA_reset_orientation = global.number[8]
alias AA_reset_ticks = 120


declare global.object[12] with network priority high
alias scrb_phys = global.object[12] -- cargo phys zone

declare global.object[15] with network priority high
alias host_scarab_rotation = global.object[15] -- unattached object that the host also rotates and clients can reference for the correct rotation data

-- player squishing
declare team.object[0] with network priority low
alias squish_boundary = team[0].object[0]

-- part of the lazy fix to push up/down players along with scarab going up/down
declare team.number[5] with network priority high
alias scrb_downed_timer = team[0].number[5]

declare global.number[0] with network priority local
declare global.number[1] with network priority local
declare global.number[2] with network priority local
declare global.number[3] with network priority local
declare global.number[4] with network priority local
declare global.number[5] with network priority local

declare global.number[6] with network priority local -- host indicator


declare global.number[7] with network priority local
alias toggle = global.number[7]

declare global.number[11] with network priority local -- game end state, we set this when either the scarab blows up, or all the buildings collapse
alias game_end_state = global.number[11]


declare object.number[0] with network priority low
declare object.number[1] with network priority local
declare object.number[2] with network priority high
declare object.number[3] with network priority low
declare object.number[4] with network priority local
declare object.number[5] with network priority local
declare object.number[6] with network priority local
declare object.number[7] with network priority local

declare object.player[0] with network priority local

declare global.player[0] with network priority local
alias temp_player0 = global.player[0]

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias temp_obj3 = global.object[4]
alias temp_obj4 = global.object[5]
alias temp_obj5 = global.object[6]
alias temp_obj6 = global.object[7] 

alias mover_agent1 = global.object[8]
alias mover_agent2 = global.object[9]

alias temp_num0 = global.number[0]
alias temp_num1 = global.number[1]
alias temp_num2 = global.number[2]
alias temp_num3 = global.number[3]
alias temp_num4 = global.number[4]
alias temp_num5 = global.number[5]

alias host_indicator = global.number[6]
-- HELL YEAH, pure unoptimized network mayhem 😎👍 
-- thats probably 800 object references it has to sync (800*4bytes = 3.2kb worth of object refs lmao)
declare object.object[0] with network priority low
declare object.object[1] with network priority low
declare object.object[2] with network priority low
declare object.object[3] with network priority low

-- actual AI stuff
alias Setup = object.number[0]
alias L_Queued = object.number[1]
alias L_Active = object.number[7]
alias backstep_ticks = object.number[3]
alias firing_ticks = object.number[4] 
alias firing_mode = object.number[5]
alias rotation_stuck = object.number[6]
alias downed_state = object.number[2] -- make this one sync
alias interp_down_ticks = 86
enum f
   moving     = 0
   locking_on = 1
   -- skip to prefire if the player is still in the boundary
   -- cannot walk
   prefire    = 2
   firing     = 3
   cooling    = 4 -- this will be cancelled if players enter the proximity
end
alias lock_on_ticks = 60
alias charging_ticks = 90
alias firing_ticks = 255
alias cooling_ticks = 190
--alias mover = object.object[0] -- FREE OBJECT SLOT ON THE SCARAB !!!!!
alias s_target = object.object[1]
alias proximity = object.object[2]
alias sight = object.object[3]
--'scrb_mover' AI mover stuff (technically also Base, but we overflowed to this object for more room)
alias l_prong = object.object[0]
alias r_prong = object.object[1]
alias B_core = object.object[3]
alias rotation_ticks = object.number[1] -- unused??
alias legs_destroyed = object.number[2] -- sync this number
alias legs_destroyed_to_perma_down = 4

alias time_till_retarget = object.number[5]
alias min_retarget_time = 60
alias rand_retarget_time = 150
--alias downed_timer = object.number[6]
alias max_downed_timer = 1800 -- 30 seconds


-- AI weapon stuff
alias W_socket = object.object[0] 
alias W_yaw = object.object[1]
alias W_pitch = object.object[2]
--alias W_visual = object.object[3]
alias burst_ticks = object.number[1]
alias burst_interval = object.number[4]
alias burst_cluster_ticks = 35 -- this is the amount of ticks that a singluar burst will occur for, divide this by "ticks_between_burst_cluster" for total amount of projectiles during burst
alias ticks_between_burst_cluster = 5 -- this is how many ticks inbetween each red dot of that singluar burst
alias ticks_between_burst_fire = 95 -- this is how many ticks downtime between each stream of the burst

-- AI projectile stuff
alias lifespan = object.number[1]
alias max_static_lifespan = 500
alias p_mover = object.object[0] -- TODO: bake into a single reserved mover global.object
alias collision_check_ticks = object.number[4]
alias is_building_shot = object.number[5]
alias ticks_till_collision_check = 2

-------------------------------------------------------------------------------------------------------------------------------
-- new stuff here --
-------------------------------------------------------------------------------------------------------------------------------
-- joint rotation stuff (Upper)
alias initialized = object.number[0]
alias UpperLenght = object.number[2]
--alias LowerLength = object.number[3] -- no longer used
alias outta_bounds_for = object.number[5]
alias socket = object.object[0] 
alias pitch = object.object[1]
alias knee = object.object[2]
alias foot = object.object[3]
-- 'L_Joint' joint rotation stuff (Lower, tracking leg damage) 
--alias socket = object.object[0] -- already declared
alias L_destoyed = object.number[1] -- used to determine if this leg has been destroyed already
alias D_child = object.object[1] -- used to tell if the child has been destroyed -- send a message to parent to be disabled
alias D_cleanup = object.object[2]
alias visual_splode = object.object[3] -- bomb explosion
alias core_health = script_option[2] -- this will be assigned to the object labelled "L_Damage" with team nuetral
alias leg_health  = script_option[3] --0 this will be assigned to the object labelled "L_Damage" not on neutral team
-- new joint rotation stuff (bound to upper joint.pitch)
-- object.object[0] == p_y_helper
alias R_kneepoint = object.object[2]
alias R_pivot = object.object[3]
--alias R_has_scaled = object.number[5] -- priority local -- no longer needed

alias building_health = script_option[4] -- building health, this will be assigned to toweres * 10

-- foot calculations stuff
alias Interpolating = object.number[1]
alias pitch_helper = object.object[0] 
   alias p_y_helper = object.object[0] -- child to above reference
alias forward = object.object[1]
alias backward = object.object[2]
alias bounds = object.object[3]


-- scale offset attachment stuff
alias parent = object.object[0]
alias offset = object.object[1] 
alias block = object.object[2]
alias designated_scale = object.number[0]
alias has_scaled = object.number[1]

-- player stick to scarab stuff (cargo physics)
declare player.object[0] with network priority local
declare player.object[1] with network priority local
declare player.object[2] with network priority local
alias r_base = player.object[0] -- last position the player was, relative to scarab
alias r_last = player.object[2] -- the global position of the player last tick

alias local_finder = player.object[1] -- used to spawn monitor on players to trigger their crosshair
alias p_vehicle = player.object[1] -- on host ONLY, saves 4-5 actions!! too many get vehicle calls hahaha
for each player do
	current_player.p_vehicle = current_player.get_vehicle()
end

declare global.player[1] with network priority local
alias _local_player = global.player[1]


declare player.object[3] with network priority local
alias b_ability = player.object[3]

declare player.number[0] with network priority local
alias relatives = player.number[0]
declare player.number[1] with network priority local 
-- player UI stuff
--declare player.timer[0] = 1
--alias cargo_phys_test = player.timer[0]
-- player scarab tracking
declare player.timer[1] = 5 -- if the player is pushing us backwards for 5 secs, then they are doing it on purpose
alias dickhead_timer = player.timer[1]
alias is_a_dickhead = player.number[1]
alias dickhead_ticks = 1500 -- ignore that player for 25 seconds

alias bp_owner = object.player[1]

-- alias turret_enter_cooldown = 180

-- objective aliases
alias ob_status = object.number[1]
alias enemy_icon = object.object[0]
alias ally_icon = object.object[1]

declare object.timer[0] = script_option[0] -- 15
alias ob_cap_time = object.timer[0] -- time to capture zone
alias theoretical_damage = object.number[4]
declare object.timer[1] = 100    -- leg health waypoint.    scarab distracted_timer.
alias distracted_timer = object.timer[1] 


-- objective special stuff aliases (bump & splosion)
alias bomb_visual = object.object[0]

declare player.number[2] with network priority low -- this will be used to tell clients what their bump count is
alias HOST_bumpcount = player.number[2]
declare player.number[3] with network priority local -- clients message confirmed counter
alias CLIENT_bumpcount = player.number[3]

alias bpd_initialized = object.number[6]

declare player.number[4] with network priority local -- will be used to track starting game message
alias p_initilized = player.number[4]

-- explosion stuff
alias countdown_ticks = object.number[4]
alias ex_del1 = object.object[0]
alias min_countdownticks = 600 -- 10 seconds
alias rand_countdownticks = 300 -- 5 seconds -- explosions will occur between 10-15 seconds


-- falling objects stuff
alias max_ticks_still_before_staticifying = 30
alias ticks_still = object.number[4]
alias f_o_attached_object = object.object[0]
alias debris_static_indicator_team = team[7]

-- Rabid added
alias access_point_announcement_delay = global.timer[3]
if access_point_announcement_delay.is_zero() and Scarab.Setup >= 0 then
   access_point_announcement_delay.reset()
   game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
   game.play_sound_for(SPARTANS, inv_spire_vo_spartan_p1_extra, false)     -- you must maintain control of that platform spartans!
end 

-- // ////////////////// //
-- // GENERAL FUNCTIONS //
-- // //////////////// //
function Auto6D16E321_103() -- you can find the aliased code as commented out below the function calls (yeah this saves a single action)
   global.object[1] = global.object[4].place_between_me_and(global.object[4], sound_emitter_alarm_2, 0)
   global.object[0] = global.object[1].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
end
-- INPUTS
alias lookat_obj = temp_obj2
alias basis = temp_obj3
alias offset_scale = temp_num0
alias pitch_obj = temp_obj1 -- this gets deleted
-- OUTPUTS
alias yaw_obj = temp_obj0 -- also input
alias offset_obj = temp_obj4 -- optional input
-- yaw_obj - create a new object at basis that looks at "lookat_obj" on both pitch and yaw
-- then take a variable number offset_scale and create offset_obj at that distance forward from yaw_obj
function attach_rotate_basis()
   yaw_obj.attach_to(basis, 0,0,0, relative)
   yaw_obj.detach()   
   -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
   yaw_obj.face_toward(yaw_obj,0,-1,0)
   -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
   pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
end
function basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   attach_rotate_basis()
   yaw_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.detach()
   -- apply the relative pitch rotation to our yaw axis
   yaw_obj.attach_to(pitch_obj, 0,0,0, relative) 
   pitch_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.face_toward(pitch_obj,0,-1,0)
   yaw_obj.detach()
   -- setup offset object & attach-offset it in the forward direction
   pitch_obj.delete()
	if offset_obj == no_object then -- otherwise we literally just attach offset_object
		offset_obj = yaw_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
		offset_obj.copy_rotation_from(current_object, true)
	end
   offset_obj.attach_to(yaw_obj, 100,0,0, relative)
   -- now we just do the attaching forward
   -- set scale of yaw obj, thus scaling the attachment offset of offset_obj
   yaw_obj.set_scale(offset_scale)
   yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
end
function config_thingo() -- only used by cargo physics
   Auto6D16E321_103()
	--pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   --yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
	offset_obj = no_object
   basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
end

alias recursions = temp_num0
-- temp_num1
-- temp_num2
-- temp_num3
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
   if lookat_obj.spawn_sequence != 0 then
      temp_num3 = 100
      recursions = lookat_obj.spawn_sequence
      if lookat_obj.spawn_sequence < 0 then 
         recursions *= 5
         temp_num3 += recursions
         if lookat_obj.spawn_sequence <= -20 then 
            recursions = lookat_obj.spawn_sequence
            recursions += 201
            if lookat_obj.spawn_sequence == -20 then 
               temp_num3 = 1
            end
         end
      end
      if lookat_obj.spawn_sequence < -20 or lookat_obj.spawn_sequence > 0 then 
         temp_num3 = 100
         -- cosmic scale.     2nd condition exempts scarab's front right leg ODST pods from scaling up.
         if temp_obj2.team == team[0] and temp_obj2.has_forge_label("scale") then       -- and not temp_obj2.has_forge_label("L_Attach")
            temp_num3 = 32732
         end
         _330x_recurs()
      end
      lookat_obj.set_scale(temp_num3)
      lookat_obj.copy_rotation_from(lookat_obj, false)
   end
end
function _330_current_object()
   lookat_obj = current_object
   _330x()
end


function offset_attach_step2() -- used just below and by the turret thing
   -- place pitch and yaw objects
	Auto6D16E321_103()
   --pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   --yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
   -- unnesting the function because it was only used here!!!
   lookat_obj = temp_obj6.place_between_me_and(temp_obj6, sound_emitter_alarm_2, 0)
   offset_scale = lookat_obj.get_distance_to(pitch_obj)
	-- mark whether this offset attach needs to give out lookat_obj a scoket, so it can reattach to when it needs, (no_object means it will generate a socket)
	offset_obj = no_object
   if temp_obj6.has_forge_label("B_Attach") or temp_obj6.has_forge_label("U_Attach") 
   or temp_obj6.has_forge_label("L_Attach") or temp_obj6.has_forge_label("L_Damage") then
		offset_obj = temp_obj6
		if temp_obj6.has_forge_label("B_Attach") and temp_obj6.team != team[7] then
			offset_obj = no_object -- we need a socket for these ones!!!
		end
	end
   basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   yaw_obj.designated_scale = offset_scale
   lookat_obj.delete()
   lookat_obj = temp_obj6
   if lookat_obj.has_forge_label("B_Attach") or lookat_obj.has_forge_label("U_Attach") 
   or lookat_obj.has_forge_label("L_Attach") or lookat_obj.has_forge_label("L_Damage") then -- only scale objects that are marked to support scaling
      _330x()
		-- some B_Attach objects are marked so that they detach to provide collision to players, nest the socket directly to this object so we attach/detach without accessing the root object that gets attached to the scarab
		if lookat_obj.has_forge_label("B_Attach") and lookat_obj.team != team[7] then
			lookat_obj.offset = offset_obj
		end
   end
   temp_obj6.attach_to(offset_obj, 0,0,0,relative)
   yaw_obj.attach_to(basis, 0,0,0,relative)
   yaw_obj.parent = basis
   yaw_obj.offset = offset_obj
   yaw_obj.block = temp_obj6
   yaw_obj.has_scaled = 1
   yaw_obj.team = temp_obj6.team
end
function offset_attach_object()
   temp_obj6 = current_object
   offset_attach_step2()
end

-- // //////////////////// //
-- // CARGO PHYSICS STUFF //
-- // ////////////////// //
-- cargo phys aliases
alias cas_knee = object.object[0] -- used as 'tip' or 'point' in cascade operation, but when completed becomes the knee/joint of a connection
alias cas_foot = object.object[1] -- opposite end of the triangle object formation
alias cascade_length = 50
alias cascade_amount = 50

alias cas_counter = temp_num0 -- input
alias cas_src = temp_obj0 -- input
alias cas_dst = temp_obj1 -- input
function cascade_loop()
	cas_src.face_toward(cas_dst.cas_knee, 0,0,0)
	cas_dst.face_toward(cas_src.cas_knee, 0,0,0)
	cas_counter += 1
	if cas_counter < cascade_amount then
		cascade_loop()
	end
end
--    cas_src = temp_obj0 -- input/output
--    cas_dst = temp_obj1 -- input/output
alias cas_rot_helper = temp_obj2 -- internal
function cascade() 
	-- DEBUG: too far apart exception
	-- temp_num0 = cas_src.get_distance_to(cas_dst)
	-- temp_num0 /= 2 -- we need to check if distance is greater than twice the cascade length, alternatively we check if half the distance is greater than a single cascade length
	-- if temp_num0 > cascade_length then
		-- game.show_message_to(all_players, none, "failure: range exceeded, increase the 'cascade_length'")
	-- end
	
	cas_src = cas_src.place_between_me_and(cas_src, sound_emitter_alarm_2, 0)
	cas_dst = cas_dst.place_between_me_and(cas_dst, sound_emitter_alarm_2, 0)

	-- create rotation helper to orient our locations towards another
	-- NOTE: we could replace this with a global helper object, so that it only needs to be spawned in once, however reseting coords might not be the easiest, which is probably why we always spawned it from scratch in the original pitch axis functions
	cas_rot_helper = cas_src.place_at_me(sound_emitter_alarm_2, none,none, 0,0,0, none)
	cas_rot_helper.attach_to(cas_src, 0,0,0, relative)
	cas_rot_helper.detach()
	-- then offset rotation, converting roll to pitch
	cas_rot_helper.face_toward(cas_rot_helper,0,-1,0)
	cas_src.attach_to(cas_rot_helper, 0,0,0,relative)
	-- then correct our cas_src's yaw to face towards cas_dst
	cas_rot_helper.face_toward(cas_dst, 0,0,0)
	cas_src.detach()
	cas_rot_helper.delete() -- no longer needed
	-- we can simply copy the rotation over to cas_dst as well, so they will now have the exact same pitch heading
	cas_dst.copy_rotation_from(cas_src, true)
	
	-- setup the edge things
	cas_src.cas_knee = cas_src.place_between_me_and(cas_src, sound_emitter_alarm_2, 0)
	cas_dst.cas_knee = cas_dst.place_between_me_and(cas_src, sound_emitter_alarm_2, 0)
	-- src knee needs to have the same orientation, so we can rotate it later
	cas_src.cas_knee.copy_rotation_from(cas_src, true)

	cas_src.cas_knee.attach_to(cas_src, cascade_length,0,0, relative)
	cas_dst.cas_knee.attach_to(cas_dst, cascade_length,0,0, relative)
	
	-- here we need to apply whatever fixup we can to make this work??
	-- NOTE: we have to change the rotation of DST not SRC, because SCR is the first that gets updated from the cascade loop, so any rotation we make is wiped
	--cas_dst.face_toward(cas_dst,127,-10,0) -- this whould hopefully avoid deadlock situations where one point is direction ontop of another???
	
	
	-- call the cascade recursive function
	cas_counter = 0
	cascade_loop()
	cas_dst.cas_knee.delete() -- no longer needed
	
	-- fixup cas_src.cas_knee 
	cas_src.cas_knee.detach()
	cas_src.cas_knee.face_toward(cas_dst, 0,0,0)
	cas_src.cas_knee.attach_to(cas_src, cascade_length,0,0, relative)
	-- bind cas_foot to our thing
	cas_dst.attach_to(cas_src.cas_knee, cascade_length,0,0, relative)
	cas_src.cas_foot = cas_dst
end



-- configure attchment offsets script
-- l_prong 2 2 0
-- r_prong 1 -2 0

-- target object
-- beneath scarab boundary

if Scarab == no_object then 
   for each object with label "B_Misc" do
      if current_object.spawn_sequence == 0 then
         Scarab = current_object
      end
   end
end
-- projectile collision check, setup collision offset test object
if projectile_collision_test_agent == no_object and Scarab != no_object then 
   projectile_collision_test_agent = Scarab.place_at_me(sound_emitter_alarm_2, none, none,0,0,0,none)
end

alias ticks_till_first_explosion = -170
alias ticks_till_second_explosion = -230
alias ticks_till_third_explosion = -270

alias ticks_till_sim_physics = -300
alias ticks_till_sim_physics_end = -450

alias ticks_till_legs_detach = -330

alias ticks_till_meltdown = -435
alias ticks_till_meltdown_end = -1000

alias ticks_till_game_end_scarab_destroyed = -280

function setup_bomb()
   --temp_obj0 = temp_obj1.place_at_me(covenant_bomb, "Detonation", none, 0, 0, 0, none)
   temp_obj0 = temp_obj1.place_at_me(phantom, "Detonation", none, 0, 0, 0, none)
   --temp_obj0.number[4] = 40
   --temp_obj0.set_scale(1)
   
   -- only 1 in 4 chance of phantom explosion during final meltdown chain reaction explosions (otherwise too much phantom debris, causing floor grids to delete).
   if Scarab.Setup <= -435 then
      -- do exactly 3 phantom explosions in final meltdown.
      if Scarab.Setup != -436 and Scarab.Setup != -446 and Scarab.Setup != -456 then
         --temp_num1 = rand(4)
         --if temp_num1 != 0 then
            temp_obj0.delete()
            temp_obj0 = temp_obj1.place_at_me(covenant_bomb, "Detonation", none, 0, 0, 0, none)
         --end
      end
   end
   temp_obj0.attach_to(temp_obj1, 0, 0, 0, relative)
end
function splode_leg_joint()
   current_object.detach()
   temp_obj0 = current_object.place_between_me_and(current_object, dice, 0)
   temp_obj0.set_scale(1)    -- Rabid added
   temp_obj1 = current_object.place_at_me(landmine, "Detonation", none, -3, 0, 0, none)
   --temp_obj1.kill(true)
   --temp_obj0.push_upward()
   --temp_obj0.push_upward()
   current_object.attach_to(temp_obj0, 0, 0, 0, relative)
   
   --temp_obj1 = current_object.place_at_me(fusion_coil, none, none, -3, 0, 0, none)
   --temp_num1 = rand(100)
   --temp_obj1.health = temp_num1
end

if Scarab != no_object and Scarab.Setup < 0 then -- then the scarab has been destroyed, and now we're running the destroyed logic
   Scarab.Setup -= 1
   -- the first possible value is '-2', so dont have any effects fire on the 0th tick
   -- initial explosion effects
	if Scarab.Setup == ticks_till_first_explosion or Scarab.Setup == ticks_till_second_explosion or Scarab.Setup == ticks_till_third_explosion then
      temp_obj1 = get_random_object("B_Attach", no_object)
      setup_bomb()
   end
end
if Scarab != no_object then
   -- simulate physics effect (use Scarab.sight as a placeholder)
   if Scarab.Setup == ticks_till_sim_physics then
      Scarab.sight = Scarab.place_between_me_and(Scarab, dice, 0)
      Scarab.sight.copy_rotation_from(Scarab, true)
      -- Scarab.detach() -- unneeded
      Scarab.attach_to(Scarab.sight, 0,0,0,relative)
   end
end

--if Scarab != no_object and Scarab.Setup < 0 and Scarab.Setup == -435 then
-- I tried to make the legs detach at the same time as the final meltdown, but it spazzes out due to the main body trying to drop/fall at an earlier time point.    <-- the block immediately above this.
if Scarab != no_object then
   -- funny legs blow off effect
   if Scarab.Setup == ticks_till_legs_detach then
      for each object with label "U_Joint" do
         current_object.initialized = -1 -- so we know this leg is now outta action
         splode_leg_joint()
      end
      for each object with label "L_Joint" do
         splode_leg_joint()
      end
   end
end

if Scarab != no_object then
   -- end physics simulation
   if Scarab.Setup == ticks_till_sim_physics_end then
      Scarab.detach()
      Scarab.sight.delete()
   end
end
 
if Scarab != no_object then
   -- commnence meltdown
   if Scarab.Setup <= ticks_till_meltdown and Scarab.Setup >= ticks_till_meltdown_end then
      temp_num0 = Scarab.Setup
      temp_num0 %= 2 -- every 2th tick
      if temp_num0 == 0 then
         temp_obj1 = no_object
         for each object with label "B_Attach" do
            if current_object.spawn_sequence != 0 and current_object.number[7] == 0 then -- only run this for the scaled objects i guess, we'll probably come up with a better method later
               temp_obj1 = current_object
            end
         end
         if temp_obj1 != no_object then
            temp_obj1.number[7] = 1
            setup_bomb()
            temp_obj0.ex_del1 = temp_obj1
         end
      end
   end
end
if Scarab != no_object then
   if Scarab.Setup == ticks_till_game_end_scarab_destroyed then
      game_end_state = -1
      game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
      --game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p1_win, true)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
		--game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_loss, true)      -- Your failure here is troubling.     The fleetmaster will be displeased to hear of this failure.       This failure will NOT go unnoticed.
		game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p3_win, true)        -- Outstanding spartans! air surpport will clean up the mess.
		game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p3_loss, true)      -- No! The humans deny us our rightful victory!     The humans defeat us this time. But SOON, they will fall.    So close, and yet the filth deny us our victory.
	end
end

function evalutate_target()
   if temp_obj0 != no_object and not Scarab.shape_contains(temp_obj0)  then
      if temp_num2 != 0 then -- is not on the turrets of the scarab (no longer a feature)
         if Scarab.sight.shape_contains(temp_obj0) then -- favour players in sightline
				-- territories aggressive
				if c_goal.team != team[0] then
					temp_num2 /= 4 -- massively prioritize players who are in its sightlines, opposed to players who aren't
				end
				if c_goal.team == team[0] then
					temp_num2 -= 20 -- only apply a little bit of incentive to go towards targets in sightlines
				end
         end
         if Scarab.proximity.shape_contains(temp_obj0) then
            temp_num2 += 150 -- less likely to target players directly beneath us
         end
         if temp_num2 < temp_num1 and current_player.is_a_dickhead == 0 then -- is in range, and player isn't being stupid
            temp_num1 = temp_num2 -- new closest player
            temp_obj1 = temp_obj0
         end
      end
   end
end

function move_scarab_attached_to_mover()
   projectile_collision_test_agent.set_scale(22)
   projectile_collision_test_agent.copy_rotation_from(projectile_collision_test_agent, true)
   scrb_mover.detach()
   projectile_collision_test_agent.set_scale(100)
   projectile_collision_test_agent.copy_rotation_from(projectile_collision_test_agent, true)
end
function reset_scarab_firing_state()
   Scarab.firing_mode = f.moving
   Scarab.firing_ticks = 0
end
-- function setup_objective_marker_vis()
   -- temp_obj0 = Scarab.s_target.place_between_me_and(Scarab.s_target, hill_marker, 0)
   -- temp_obj0.set_waypoint_priority(high)
   -- temp_obj0.team = SPARTANS
   -- temp_obj0.attach_to(c_goal, 0,0,0,relative)
-- end
alias v_direction = temp_num4
function scarab_check_rapid_rotation_swaps()
   -- read the last bit
   temp_num3 = 1
   temp_num3 &= Scarab.rotation_stuck
   if temp_num3 == v_direction then -- we were just on this one
      Scarab.rotation_stuck &= 1 -- clear all bits except the first
   end
   if temp_num3 != v_direction then -- direction change
      Scarab.rotation_stuck += 2 -- add 1 to the second bit, ranging to the 3rd bit
      temp_num3 = 6
      temp_num3 &= Scarab.rotation_stuck
      if temp_num3 > 4 then -- has been two consective direction changes
         Scarab.rotation_stuck |= 320
      end 
   end
   temp_num3 = 1
end
function thingo_face_towards()
   temp_obj0.W_yaw.detach()
   temp_obj0.W_yaw.face_toward(temp_obj1,0,0,0)
   temp_obj0.W_pitch.detach()
   temp_obj0.W_pitch.face_toward(temp_obj1,0,0,0)
   -- use this opportunity to find the distance
   -- temp_num0 = temp_obj0.W_yaw.get_distance_to(temp_obj1) -- no longer used
   -- reattach
   temp_obj0.W_pitch.attach_to(temp_obj0.W_yaw, 0,0,0,relative)
end

-- function Scarab_visual_face_towards_target() -- only 1 reference now, disabled
   -- -- orientate turret to face towards
   -- temp_obj1 = Scarab.s_target
   -- thingo_face_towards()
   -- temp_obj0.W_yaw.attach_to(temp_obj0, 0,0,0,relative)
   -- -- configure guns
   -- --temp_obj0.W_visual.set_shape(cylinder, 3, temp_num0, 1)
-- end
function configure_projectile()
   temp_obj3.p_mover = temp_obj3.place_between_me_and(temp_obj3, sound_emitter_alarm_2, 0)         -- capture_plate (test)
   temp_obj3.detach()
   --temp_obj3.object[0].set_scale(1)      -- this doesn't scale for clients
   temp_obj3.copy_rotation_from(temp_obj0.W_pitch, true)
end
function setup_yaw_pitch_objects()
	Auto6D16E321_103()
   --pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   --yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   attach_rotate_basis()
   yaw_obj.copy_rotation_from(basis, true)
   pitch_obj.detach()
end
function Scarab_interp_face_towards() -- NOTE: this rotates the scarab object, not the mover!!! clients will rotate the scarab independently!!
   temp_num3 = 0
   if not Scarab.proximity.shape_contains(Scarab.s_target) and Scarab.backstep_ticks == 0 then
      --temp_obj1 = Scarab.mover
      scrb_mover.l_prong.detach()
      scrb_mover.r_prong.detach()
      -- find distances
      temp_num0 = scrb_mover.l_prong.get_distance_to(Scarab.s_target)
      temp_num1 = scrb_mover.r_prong.get_distance_to(Scarab.s_target)
      temp_num2 = Scarab.get_distance_to(Scarab.s_target)
      -- restore attached status 
      scrb_mover.r_prong.attach_to(Scarab, 2, 2,0, relative)
      scrb_mover.l_prong.attach_to(Scarab, 2,-2,0, relative)

      -- if else table
      Scarab.detach()
      if Scarab.rotation_stuck >= 16 then
         Scarab.rotation_stuck -= 16
         temp_num3 = -1 -- disable rotation if rotation is stuck, but allow movement
      end
      if temp_num3 == 0 and temp_num2 < temp_num0 and temp_num2 < temp_num1 then -- target is behind us
         Scarab.face_toward(Scarab, 127,1,0)
         temp_num3 = 1
      end
      if temp_num3 == 0 and temp_num0 < temp_num1 then -- the target is to the left of us, rotation direction: '1'
         v_direction = 1 -- temp_num4
         scarab_check_rapid_rotation_swaps()
         Scarab.rotation_stuck |= v_direction -- set the last bit to '1'
         Scarab.face_toward(Scarab, 127,-1,0)
      end
      if temp_num3 == 0 and temp_num0 > temp_num1 then -- the target is to the right of us
         v_direction = 0
         scarab_check_rapid_rotation_swaps()
         Scarab.rotation_stuck &= 0b1111111111111110 -- set the last bit to '0'
         Scarab.face_toward(Scarab, 127,1,0)
      end
      Scarab.attach_to(scrb_mover, 0,0,0,relative)
		-- update the rotation so our non-hosts can get the correct rotation
		if host_indicator == 3621 then -- whoops this was running on every client
			host_scarab_rotation.attach_to(Scarab, 127,0,0,relative)
			host_scarab_rotation.detach()
		end
   end
end
-- B_turret stuff
alias t_socket = object.object[0]
alias t_target = object.object[3]
alias t_fire_ticks_interval = object.number[4]
alias t_max_fire_ticks_interval = 30
--alias t_retarget_interval = object.number[5]
alias t_max_retarget_interval = 280
alias t_shots_in_burst = object.number[6]
alias t_max_shots_in_burst = 7
alias t_cooling_ticks = 800
alias t_lockon_ticks = 110
--alias max_aa_shoot_range = 950
alias t_is_attached = object.number[7]
alias t_last_health = object.number[7] -- cheeky

alias seraph_health = script_option[5]

function turret_lookat()
	AA_reset_orientation = 0 -- let the system know that it should reset rotation in at least 'AA_reset_ticks' (120 ticks)
   temp_obj0 = AA_turret
   temp_obj1 = AA_turret.t_target -- already set, conincidently -- nevermind
   thingo_face_towards()
   AA_turret.W_yaw.attach_to(AA_turret.t_socket, 0,0,0,relative)
end
function setup_scarab_mover_agent()
   --Scarab.detach() 
   projectile_collision_test_agent.copy_rotation_from(Scarab, true) -- use the scarab rotation, not scarab mover rotation1!!
   projectile_collision_test_agent.attach_to(scrb_mover,0,0,0,relative)
   projectile_collision_test_agent.detach()
end

if Scarab != no_object and Scarab.Setup == 1 and scarab_ready_timer.is_zero() then -- has been initialized
   --temp_obj0 = Scarab.sight
   --temp_obj0.W_visual.set_shape_visibility(no_one)

   --scrb_mover = Scarab.mover
   temp_num0 = scrb_mover.B_core.health
   -- if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
   --    scrb_downed_timer = max_downed_timer
   -- end
   if scrb_mover.B_core == no_object or temp_num0 <= 0 then
      scenario_iterp_state = team[0]
      game.show_message_to(all_players, none, "Scarab DESTROYED!!!")
		game.play_sound_for(ELITES, inv_spire_vo_covenant_loss, true)      -- Our power core is lost to the humans. You shall never outlive this shame.   You've lost the power core! A thousand torments upon you!   You've lost the power core. this will not go unpunished.
      game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p1_win, true)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
      Scarab.Setup = -1 -- disable the scarab AI
      Scarab.downed_state = -1
      Scarab.sight.delete()
      Scarab.proximity.delete()
      Scarab.detach()
      scrb_mover.attach_to(Scarab, 0,0,0,relative)
      --scrb_mover.delete()
		-- delete core waypoint
      for each object with label "L_Damage" do
         current_object.dam_waypoint.delete()
      end
   end
   --temp_num0 /= 2
   --scarab_health_display += temp_num0
   -- if the scarab has been downed, play the downed script
   if Scarab.downed_state > 0 then
      -- clear values from turret
      AA_turret.t_target = no_object
      -- end visibility for turret thing
      scrb_downed_timer -= 1 -- counting down, including the time it took to 
      if Scarab.downed_state < interp_down_ticks or scrb_downed_timer <= 0 then -- should be interpolating atm
         setup_scarab_mover_agent()
         if scrb_downed_timer <= 0 then -- then we're packing up and almost good to go
            scrb_mover.attach_to(projectile_collision_test_agent, 0,0,2, relative)
            Scarab.downed_state -= 1
         end
         if scrb_downed_timer > 0 then -- we're parking
            scrb_mover.attach_to(projectile_collision_test_agent, 0,0,-2, relative)
            Scarab.downed_state += 1
            scenario_iterp_state = team[0]
         end
         move_scarab_attached_to_mover()

         --scrb_mover.attach_to(Scarab, 0,0,0,relative)
         --scrb_mover.detach()

         --Scarab.attach_to(scrb_mover, 0,0,0,relative)
      end
   end
   -- if the scarab is not downed, then work properly
   if Scarab.downed_state == 0 then

      if c_goal.team != team[0] and c_goal.team != team[1] then -- if its a territories objective, we should let the territory control the sound emitter
         scenario_iterp_state = no_team
      end
      if scrb_downed_timer > 0 then
         Scarab.downed_state = 1
      end
      scrb_mover.time_till_retarget -= 1
      if scrb_mover.time_till_retarget <= 0 and Scarab.firing_mode == f.cooling or Scarab.firing_mode == f.moving then
         --temp_obj1 = Scarab.s_target -- use this to determine if we just found the same target or not
         Scarab.s_target = no_object
         scrb_mover.time_till_retarget = rand(rand_retarget_time)
         scrb_mover.time_till_retarget += min_retarget_time
      end
      -- here we just let the turret do its thing 
		
		
		
		
		
		-- if target gets too close, then untarget them and reset firing sequnece if we were mid way through it
		-- if Scarab.proximity.shape_contains(AA_turret.t_target) then
			-- AA_turret.t_target = no_object 
			-- -- if we didn't clear the whole volley when target was dropped, make sure we apply the firing cooldown still
			-- if AA_turret.t_shots_in_burst > 0 and AA_turret.t_shots_in_burst < t_max_shots_in_burst then
				-- AA_turret.t_fire_ticks_interval = t_cooling_ticks
			-- end
		-- end
		-- if AA_turret.t_shots_in_burst == 0 and not AA_turret.W_yaw.shape_contains(AA_turret.t_target) then
			-- AA_turret.t_target = no_object 
		-- end
		-- version that costs less actions (saves 2 actions), this script cancels the target if it either has gotten too close or we haven't locked on yet and it left the shooting range!
		if  Scarab.proximity.shape_contains(AA_turret.t_target) or AA_turret.t_shots_in_burst == 0 -- hasn't fired first shot of the volley
		and Scarab.proximity.shape_contains(AA_turret.t_target) or not AA_turret.W_yaw.shape_contains(AA_turret.t_target) then -- and has left shoot range
		   -- the condition works like this: (Z or (X and Y)) it resolves to ((Z or X) and (Z or Y))
			AA_turret.t_target = no_object 
			-- if we didn't clear the whole volley when target was dropped, make sure we apply the firing cooldown still
			if AA_turret.t_shots_in_burst > 0 and AA_turret.t_shots_in_burst < t_max_shots_in_burst then
				AA_turret.t_fire_ticks_interval = t_cooling_ticks
			end
		end
		
		if AA_turret.t_target == no_object then
		
			AA_turret.t_shots_in_burst = 0
			AA_turret.W_yaw.detach() -- detach so we can measure distance from the turret itself
			temp_num1 = 32000 -- max range
			for each player do
				if current_player.team == SPARTANS  -- is a defender, thus a badguy
				and current_player.biped != no_object 
				and not Scarab.proximity.shape_contains(current_player.biped) -- not too close to the scarab
				and AA_turret.W_yaw.shape_contains(current_player.biped) then -- within the range boundary
					temp_num2 = current_player.biped.get_distance_to(AA_turret.W_yaw)
					if temp_num2 != 0 then -- is not apart of the scarab either
						if temp_num2 < temp_num1  then -- is in range, and player isn't being stupid
							temp_num1 = temp_num2 -- new closest player
							AA_turret.t_target = current_player.biped
							-- new target means we need to relock on
							if AA_turret.t_fire_ticks_interval < t_lockon_ticks then
								AA_turret.t_fire_ticks_interval = t_lockon_ticks
								--AA_turret.t_retarget_interval = t_max_retarget_interval
							end
						end
					end
				end
			end
			AA_turret.W_yaw.attach_to(AA_turret.t_socket, 0,0,0,relative)
		end
		AA_turret.t_fire_ticks_interval -= 1
		if AA_turret.t_target != no_object then
			turret_lookat()
			if AA_turret.t_fire_ticks_interval <= 0  then -- fire at the target
				AA_turret.t_fire_ticks_interval = t_max_fire_ticks_interval
				temp_obj3 = AA_turret.W_pitch.place_at_me(light_blue, "Projectile", none, 0,0,0,none) --### change team to match scarab
				temp_obj3.attach_to(AA_turret,-30,0,8,relative)
				--temp_obj0 = temp_obj3.place_at_me(monitor, "Detonation", none, 0,0,0,none)      -- AA gun firing aesthetic
				temp_obj1 = AA_turret.place_at_me(monitor, "Detonation", none, 0,0,0,none)      -- AA gun firing aesthetic              -- landmine. nice and loud, but very firey.
				temp_obj1.attach_to(AA_turret, -35, 0, 7, relative)


				--temp_obj3.object[0] = temp_obj3.place_between_me_and(temp_obj3, bomb, 0)
				--temp_obj3.object[0] = temp_obj3.place_between_me_and(temp_obj3, covenant_bomb, 0)      -- Rabid changed. this will change the AA gun flak explosion to not be blinding.
				--temp_obj3.object[0] = temp_obj3.place_between_me_and(temp_obj3, capture_plate, 0)
				configure_projectile()
				temp_obj3.face_toward(AA_turret.t_target, 0,0,0)
				temp_obj3.lifespan = temp_obj3.get_distance_to(AA_turret.t_target)
				-- now deduct this projectile from the burst
				AA_turret.t_shots_in_burst += 1
				if AA_turret.t_shots_in_burst >= t_max_shots_in_burst then -- initiate cooldown procedure
					AA_turret.t_fire_ticks_interval = t_cooling_ticks
					AA_turret.t_target = no_object
				end
			end
      end
      -- find target
      if Scarab.s_target == no_object then
         temp_obj1 = no_object 
         temp_num1 = 32000 -- max range
         for each player do
            -- Rabid added final condition. Don't search for player targets after scarab distracted_timer has been exceeded   -- scrb_mover.time_till_retarget      <- gamergotten's alias for this.
            if current_player.team == SPARTANS and scrb_mover.time_till_retarget <= 210 then -- is a defender, thus a badguy
					-- territories aggressive
               if  not current_player.p_vehicle.is_of_type(falcon)  or c_goal.team == team[0] 
					and not current_player.p_vehicle.is_of_type(banshee) or c_goal.team == team[0] then -- and not temp_obj2.is_of_type(sabre) -- completely ignore areial vehicles except in aggressive mode
                  temp_obj0 = current_player.biped
                  temp_num2 = temp_obj0.get_distance_to(Scarab)
                  evalutate_target()
               end
            end
         end
         for each object with label "S_Objective" do
             -- if this objective is either the one we're targeting, or we aren't targeting one yet
            if c_goal == no_object or c_goal == current_object
            and current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] -- if its one of the valid teams
            and current_object.ob_status == 0 or current_object.ob_status == 1 then -- if this piece is a foundation piece & hasn't been destroyed yet
               temp_obj0 = current_object
               temp_num2 = temp_obj0.get_distance_to(Scarab)
					-- territories aggressive
					if c_goal.team != team[0] then -- take away all incentive to attack territories objective over players!!
						temp_num2 -= 100
					end
               evalutate_target()
            end
         end
         -- condition unneeded
         if temp_obj1 != no_object then -- we found a target
            Scarab.s_target = temp_obj1
            -- reset firing state
            if Scarab.firing_mode != f.cooling then
               reset_scarab_firing_state()
            end
            -- configure objective
            if Scarab.s_target.has_forge_label("S_Objective") then -- we just picked this one
               c_goal = Scarab.s_target -- ok lets set this as our objective then
               
					
					
					-- now lets configure this objective if it hasn't been configured yet
               if c_goal.ob_status == 0 then -- ok lets intiialize this guy
                  -- new objective
                  under_attack_timer = 0
                  --game.play_sound_for(all_players, announce_destination_moved, false)
                  c_goal.ob_status = 1 -- remember for later that this one is in progress
                  c_goal.set_shape_visibility(everyone)
                  -- configure waypoints
                  --setup_objective_marker_vis()
                  temp_obj0 = Scarab.s_target.place_between_me_and(Scarab.s_target, sound_emitter_alarm_1, 0)       -- hill_marker
                  temp_obj0.set_waypoint_priority(high)
                  temp_obj0.team = SPARTANS
                  temp_obj0.attach_to(c_goal, 0, 0, 0, relative) -- to allow it to auto clean up
						
                  c_goal.enemy_icon = temp_obj0
                  c_goal.enemy_icon.set_waypoint_visibility(everyone) -- enemies
                  c_goal.enemy_icon.set_waypoint_icon(ordnance)
   
                  --setup_objective_marker_vis()
                  --c_goal.ally_icon = temp_obj0
                  --c_goal.ally_icon.set_waypoint_visibility(allies)
                  --c_goal.ally_icon.set_waypoint_icon(defend)
                  -- Territory objectives
                  --access_point_announcement_delay.reset()         -- semi-redundant. this stops the dialogue announcement from playing late if the elites cap one too quickly (within 12 seconds). 
                  if c_goal.team == team[0] or c_goal.team == team[1] then -- its a territories objective
                     -- Consider having a one time voiceover announcement here for one of the occassions where there's a capture/territory objective.
                     access_point_announcement_delay.set_rate(-100%)
                     --game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
                     
							-- configure waypoints
                     c_goal.enemy_icon.set_waypoint_timer(0)
                     --c_goal.ally_icon.set_waypoint_timer(0)
                     c_goal.set_progress_bar(0, everyone)
                     -- setup sound emitter
                     --temp_obj0 = c_goal.place_at_me(sound_emitter_alarm_1, none,none,0,0,0,none)
                     --temp_obj0.attach_to(c_goal,0,0,0,relative)
							--for each player do
                        --if current_player.team == ELITES then
                           --script_widget[1].set_visibility(current_player, true)
                        --end
                     --end
                  end
                  -- ASSAULT COMMENTED
                  -- if c_goal.team == team[2] then -- its an assualt objective
                  --    c_bomb_spawn.set_waypoint_visibility(allies)
                  -- end
               end
            end  
         end
      end
      -- track target
      if Scarab.s_target != no_object then
		
			
         -- Rabid added. Scarab 
         Scarab.distracted_timer.set_rate(100%)
         --Scarab.set_waypoint_visibility(everyone)
         --Scarab.set_waypoint_timer(2)
         if Scarab.s_target != c_goal then
            Scarab.distracted_timer.set_rate(-125%)      -- 80 seconds spent chasing players
            if Scarab.distracted_timer.is_zero() and Scarab.firing_mode == f.cooling or Scarab.firing_mode == f.moving then
               Scarab.distracted_timer.reset()
               Scarab.s_target = c_goal
               scrb_mover.time_till_retarget = 1800   -- spend next 30 seconds ignoring players      -- scrb_mover.time_till_retarget      <- gamergotten's alias for this.
            end
         end
         --if Scarab.distracted_timer.is_zero()
      
      
         temp_obj0 = Scarab.s_target
         temp_player0 = temp_obj0.bp_owner
         for each player do 
            if temp_player0 != current_player or not Scarab.proximity.shape_contains(Scarab.s_target) then
               current_player.dickhead_timer.set_rate(50%) -- count back up for players who aren't targets at the moment
            end
         end
         -- determine movement required to get to target
         Scarab_interp_face_towards()
			
			-------- Rabid added. Scarab has a max amount of time it will chase any single player. currently 50 seconds. It will be much less if the player drives under the scarab due to previous dickhead_timer stuff.
         -- Rabid added.
         if temp_player0 != no_player then
            temp_player0.dickhead_timer.set_rate(-10%)
            if temp_player0.dickhead_timer.is_zero() then -- they are being a dickhead.  Or the scarab has been chasing them too long (up to 50 seconds)
               temp_player0.is_a_dickhead = dickhead_ticks      -- 25 second ignorance time.
               Scarab.s_target = no_object -- clear this target and wait till they behave. 
            end
         end
         --------
         if Scarab.proximity.shape_contains(Scarab.s_target) and Scarab.firing_mode < f.cooling then
            Scarab.backstep_ticks = rand(150) -- 2.5 seconds max backstep timer
            Scarab.backstep_ticks += 30 -- 0.5 seconds min stop backstepping
            reset_scarab_firing_state()
            if temp_player0 != no_player then
               temp_player0.dickhead_timer.set_rate(-100%) -- dickhead timer (they are intentionally sitting below the scarab).
               --if temp_player0.dickhead_timer.is_zero() then -- moved above. -- they are being a dickhead
                  --game.show_message_to(all_players, none, "%p is being a dickhead", temp_player0)
						--temp_player0.is_a_dickhead = dickhead_ticks
                  --temp_player0.dickhead_timer.reset()
						--Scarab.s_target = no_object -- clear this target and wait till they behave 
               --end
            end
         end
         temp_num1 = 0
         -- setup the visual gun of this gun, if not setup already
         temp_obj0 = Scarab.sight
         if temp_obj0.W_yaw == no_object then
            -- TOOD: optimize/functionize
            temp_obj0.W_pitch = temp_obj0.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
            --temp_obj0.W_visual = temp_obj0.place_between_me_and(temp_obj0, sound_emitter_alarm_2, 0) -- currently setup as ROLL, we will keep this rotation 
            --temp_obj1 = temp_obj0.W_visual
            --temp_obj1.team = team[2] --### change team to match scarab
            temp_obj0.W_yaw = temp_obj0.W_pitch.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
            -- now fixup the pitch
            temp_obj0.W_yaw.attach_to(temp_obj0, 0,0,0, relative)
            temp_obj0.W_yaw.detach()   
            -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
            -- attach the designated roll axis so it retains its roll offset
            --temp_obj0.W_visual.attach_to(temp_obj0.W_yaw, 0,0,0, relative)
            temp_obj0.W_yaw.face_toward(temp_obj0.W_yaw,0,-1,0)
            --temp_obj0.W_visual.detach()

            -- offset the pitch rotation from the roll, affecting the roll axis
            --temp_obj0.W_pitch.face_toward(temp_obj0.W_pitch,0,1,0)
            --temp_obj0.W_visual.attach_to(temp_obj0.W_pitch, 0,0,0,relative)
            --temp_obj0.W_pitch.face_toward(temp_obj0.W_pitch,0,-1,0)

            -- stack them up correctly
            temp_obj0.W_pitch.attach_to(temp_obj0.W_yaw, 0,0,0,relative)
            temp_obj0.W_yaw.attach_to(temp_obj0, 0,0,0,relative)
         end
         -- only shoot if not walking backwards
         if Scarab.backstep_ticks == 0 then
            -- target outside of the
            if not Scarab.sight.shape_contains(Scarab.s_target) and Scarab.firing_mode != f.firing then -- if target is not inside, or is currently firing
               if Scarab.firing_mode < f.cooling then -- begin locking on 
                  Scarab.firing_mode = f.moving
                  Scarab.firing_ticks = 2 -- so this will only run the next tick probably, which will be ignored cause we'll run this again
               end
            end
            --temp_obj0 = Scarab.sight
            -- target charging system 
            --if Scarab.sight.shape_contains(Scarab.s_target) or Scarab.firing_mode == f.firing then -- if number of active weapons is
               -- enum evaluation tree, this will make no sense, but be incredibly optimized
               Scarab.firing_ticks -= 1
               if Scarab.firing_ticks <= 0 then
                  Scarab.firing_mode += 1 -- yucky, but it probably works
                  if Scarab.firing_mode >= f.locking_on then
                     Scarab.firing_ticks = lock_on_ticks
                     if Scarab.firing_mode >= f.prefire then
                        Scarab.firing_ticks = charging_ticks
                        if Scarab.firing_mode >= f.firing then
                           Scarab.firing_ticks = firing_ticks
                           temp_obj0.burst_interval = 0
                           if Scarab.firing_mode >= f.cooling then
                              Scarab.firing_ticks = cooling_ticks
                              if Scarab.firing_mode > f.cooling then -- reset the loop
                                 reset_scarab_firing_state()
                                 if Scarab.sight.shape_contains(Scarab.s_target) then -- reenter prefire mode, as the target is still locked on
                                    Scarab.firing_mode = f.prefire
                                    Scarab.firing_ticks = charging_ticks
                                 end
                              end
                           end
                        end
                     end
                  end
               end
            --end
            -- firing logic, it doesn't require the target to be in the sight, except for the first firing tick
            -- also, it doesn't fire at objectives that are marked as NOT team[2] (red team) these objectives are territories & assault
            if Scarab.firing_mode == f.firing or Scarab.firing_mode == f.prefire and Scarab.s_target != c_goal or c_goal.team == team[2] then -- first part is just latching the visuals onto the target
               --Scarab_visual_face_towards_target()
					temp_obj1 = Scarab.s_target
					thingo_face_towards()
					temp_obj0.W_yaw.attach_to(temp_obj0, 0,0,0,relative)
					-- dont do this on local
               --temp_obj0.W_visual.set_shape_visibility(everyone)

               if Scarab.firing_mode == f.firing then
                  if temp_obj0.burst_interval >= ticks_between_burst_fire then
                     temp_num0 = temp_obj0.burst_ticks
                     temp_num0 %= ticks_between_burst_cluster
                     temp_obj0.burst_ticks -= 1
                     if temp_num0 == 0 then -- then this was the Nth tick, fire projectile
                        temp_obj3 = temp_obj0.W_pitch.place_at_me(light_green, "Projectile", none, 0,0,0,none) --### change team to match scarab
                        temp_obj3.attach_to(temp_obj0.W_pitch,0,0,0,relative)
                        --temp_obj3.p_mover = temp_obj3.place_between_me_and(temp_obj3, covenant_bomb, 0)
                        configure_projectile()
                        temp_obj3.lifespan = max_static_lifespan -- temp_obj3.get_distance_to(Scarab.s_target)
                        temp_obj3.is_building_shot = temp_obj1.spawn_sequence -- on players this will be 0, so it should work out, temp_obj1 is assigned in Scarab_visual_face_towards_target()
                     end
                     if temp_obj0.burst_ticks <= 0 then -- has completed this burst
                        temp_obj0.burst_interval = 0
                     end
                  end
                  if temp_obj0.burst_interval < ticks_between_burst_fire then -- needs to count up to until the next burst
                     temp_obj0.burst_interval += 1
                     temp_obj0.burst_ticks = burst_cluster_ticks
                     if temp_obj0.burst_interval == ticks_between_burst_fire then -- play the sound once
                        game.play_sound_for(all_players, boneyard_generator_power_down, true)
                     end   
                  end
               end
            end
         end 
         -- move forwards or backwards, but not while firing
         if temp_num3 < 1 or Scarab.backstep_ticks > 0 and Scarab.firing_mode < f.prefire then -- then the target is directly infront of us, move
            setup_scarab_mover_agent()
            if Scarab.backstep_ticks <= 0 then
               scrb_mover.attach_to(projectile_collision_test_agent, 1,0,0, relative)
            end
            if Scarab.backstep_ticks > 0 then
               Scarab.backstep_ticks -= 1
               scrb_mover.attach_to(projectile_collision_test_agent, -2,0,0, relative) -- double speed when moving backwards
            end
            move_scarab_attached_to_mover()
            -- now check if that movement put our dude out of bounds
            --if not Scarab.is_out_of_bounds() then -- if we didn't just go out of bounds, then we should be good to move onward
            -- -- move our mover to our scarab
            --   scrb_mover.attach_to(Scarab, 0,0,0,relative)
            --   scrb_mover.detach()
            --end
            -- reattach our base so it doesn't get garbo collected
            --Scarab.attach_to(scrb_mover, 0,0,0,relative)
         end
      end
   end 
end
if Scarab != no_object and Scarab.Setup == 0 then
   scrb_mover = Scarab.place_at_me(capture_plate, none, none, 0,0,0,none) -- this doesn't actually cast shadows if we attach to a shadow caster for some reason 
	host_scarab_rotation = Scarab.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   Scarab.Setup = 1
   -- place the sound emitter object
   temp_obj0 = Scarab.place_at_me(sound_emitter_alarm_1, none,none,0,0,0,none)
   temp_obj0.attach_to(Scarab, 0,0,0,relative)
   --basis = Scarab.place_between_me_and(Scarab, sound_emitter_alarm_2, 0)
   basis = Scarab
   for each object with label "B_Attach" do
      offset_attach_object()
		-- player squishing
		if current_object.team == team[2] then
			squish_boundary = current_object
		end
   end
	temp_obj5 = no_object -- literarlly the only temp that doesn't get used by offset attach function!!!
   for each object with label "B_Misc" do -- previously "B_Point"
      -- forward, boundary, backward
      if current_object.spawn_sequence >= 1 and current_object.spawn_sequence <= 5 or current_object.spawn_sequence >= 11 then
         offset_attach_object()
         if current_object.spawn_sequence > 1 then
            current_object.socket = yaw_obj.offset -- so we can detach/retach to measure distance correctly
            if current_object.spawn_sequence == 2 then -- previously "B_Sight"
               Scarab.sight = current_object
            end
         end
         if current_object.spawn_sequence == 1 then
            Scarab.proximity = current_object -- this is our proximity thingo - so we know when we're too close to our target
         end
      end
		-- find AA turret objects
		if current_object.spawn_sequence == 9 then
			AA_turret = current_object
		end
		if current_object.spawn_sequence == 10 then
			temp_obj5 = current_object
		end
		-- find cargo phys object
		if current_object.spawn_sequence == 11 then -- this also gets offset attached above!!
			scrb_phys = current_object
		end
   end
	-- setup AA turret
	-- rabbi AA health regen
	AA_turret.max_health *= seraph_health
	AA_turret.health = 100
	-- end of health stuff, more later in the script
	basis = temp_obj5
	setup_yaw_pitch_objects()
	pitch_obj.face_toward(pitch_obj, 0,1,0)
	yaw_obj.delete()

	AA_turret.W_yaw = basis
	AA_turret.W_pitch = pitch_obj
	AA_turret.W_pitch.attach_to(AA_turret.W_yaw, 0,0,0,relative)
	--AA_turret.face_toward(AA_turret, -1,0,0)
	AA_turret.attach_to(AA_turret.W_pitch, 4,-4,0,relative)
	
	--AA_turret.W_yaw.face_toward(AA_turret.W_yaw, -1,0,0)
	-- then attach our yaw
	basis = Scarab -- set this back to what it was (for the function just below i think??)
	temp_obj6 = AA_turret.W_yaw
	offset_attach_step2()
	AA_turret.t_socket = yaw_obj.offset
	--temp_obj1 = AA_turret.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
	--temp_obj1.set_waypoint_visibility(enemies)          -- Rabid removed. I feel like the AA gun waypoint visibility is unnecessary and a little confusing. Also game is more fun and cool when it's not destroyed.
	--temp_obj1.team = ELITES           -- maybe redundant
	--temp_obj1.attach_to(AA_turret,0,0,0,relative)
 
			
   --------------------------------------------------------
   --scrb_mover = Scarab.mover
   scrb_downed_timer = 0
   scrb_mover.r_prong = Scarab.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   scrb_mover.l_prong = Scarab.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
   for each object with label "L_Damage" do
      if current_object.team == neutral_team then -- if neutral team, then this objective is meant to belong to the chassis
         --_330_current_object()
         -- make sure its got the health it needs
         current_object.max_health = core_health
         current_object.max_health *= 25
         current_object.health = 100
         
         offset_attach_object()
         scrb_mover.B_core = current_object
         scrb_mover.B_core.set_invincibility(1)
      end
   end
   for each object with label "U_Joint" do 
      basis = Scarab
      offset_attach_object()
      current_object.socket = yaw_obj.offset -- we can retach whenever need be
      current_object.initialized = 1
      temp_obj5 = current_object
      for each object with label "L_Joint" do
         if current_object.team == temp_obj5.team and basis != no_object then -- also prevent this from allowing more than 1 lower leg (in the ungodly instance that someone tries that)
            -- reorient stuff so the leg is properly alligned
            temp_obj5.face_toward(current_object, 0,0,0) -- make sure our joint to chassis is actually pointing towards the knee

            basis = temp_obj5
            setup_yaw_pitch_objects()
            temp_obj5.pitch = pitch_obj
            yaw_obj.delete()
				
            -- make sure the pitch axis is lined up
            temp_obj5.pitch.face_toward(current_object, 0,0,0)
            basis = temp_obj5.pitch
            basis.team = temp_obj5.team
            for each object with label "U_Attach" do
               if current_object.team == temp_obj5.team then
                  offset_attach_object()
               end
            end
				


            -- NOW run the code for the lower leg
            -- find the lower half of the leg
            basis = temp_obj5.pitch
            -- once we find the lower leg portion, then run through and offset attach everything
            offset_attach_object()
            temp_obj5.knee = current_object
            current_object.socket = yaw_obj.offset

            yaw_obj = no_object 
            for each object with label "B_Misc" do -- previously "Foot"
               if current_object.spawn_sequence == 6 and current_object.team == temp_obj5.team then -- or L_Joint, they both have to have the same team anyway
                  yaw_obj = current_object
               end
            end
				
            -- we cant let these objects return the distance to their parents
            pitch_obj = temp_obj5.place_between_me_and(temp_obj5, sound_emitter_alarm_2, 0)
            lookat_obj = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            
            temp_obj5.UpperLenght = lookat_obj.get_distance_to(pitch_obj)

            current_object.detach()
            if yaw_obj != no_object then
               temp_obj5.foot = yaw_obj.place_at_me(bomb, none, never_garbage_collect, 0,0,0, none) -- yaw_obj.place_between_me_and(yaw_obj, bomb, 0)
               temp_obj5.foot.set_invincibility(1)
               temp_obj5.foot.set_pickup_permissions(no_one)
               -- reorient the lower leg towards the foot point
               current_object.face_toward(yaw_obj, 0,0,0)
               -- then calculate the distance between them
               pitch_obj.attach_to(yaw_obj, 0,0,0,relative)
               pitch_obj.detach()
               temp_num3 = lookat_obj.get_distance_to(pitch_obj)
					temp_num3 *= 100
               yaw_obj.delete() -- cleanup the foot marker, as we wont actually be using it for anything (maybe?)
					
					-- setup the new leg rotator objects -----------------------------------------------------------------
					-- basis = temp_obj5.pitch -- already set
					basis.R_pivot = basis.place_at_me(sound_emitter_alarm_2, none, never_garbage_collect, 0,0,0, none) -- this object goes at the foot
					
					basis.R_kneepoint = basis.place_at_me(sound_emitter_alarm_2, none, never_garbage_collect, 0,0,0, none) -- this object goes at the knee
					basis.R_kneepoint.attach_to(basis.R_pivot, 1,0,0, relative)
					basis.R_pivot.set_scale(temp_num3)
					basis.R_pivot.copy_rotation_from(basis, true)
					-- then slap it on
					basis.R_pivot.face_toward(basis.R_pivot, -1,0,0) -- turn it backwards, so its facing the opposite direction as the pitch is (its pointing towards the foot??)
					basis.R_pivot.attach_to(basis, 0,0,0, relative)
					
					
			-- if curr_pitch.R_has_scaled == 0 then
				-- curr_pitch.R_pivot.detach()
				-- temp_num3 = current_object.LowerLength
				-- temp_num3 *= 100
				-- curr_pitch.R_pivot.set_scale(temp_num3)
				-- curr_pitch.R_has_scaled = 1
				-- curr_pitch.R_pivot.attach_to(curr_pitch, 0,0,0, relative)
			-- end

               -- now we setup the foot 
               basis = temp_obj5.foot
               lookat_obj.delete()
               pitch_obj.delete()
               setup_yaw_pitch_objects()
               pitch_obj.p_y_helper = yaw_obj
               basis.pitch_helper = pitch_obj
               -- so many goddamn nested objects, nest the yaw helper to the pitch helper
               basis.pitch_helper.attach_to(pitch_obj.p_y_helper,0,0,0,relative)
               pitch_obj.p_y_helper.attach_to(basis,0,0,0,relative)
               -- configure stomp kill boundary (we're relying on regular ones, cause thats cheaper for us)
               --yaw_obj.set_shape_visibility(everyone)
               --yaw_obj.set_shape(cylinder, 13,13,13)
               for each object with label "B_Misc" do  -- previously "F_Point"
                  if current_object.team == temp_obj5.team then
                     if current_object.spawn_sequence == 3 then -- forward step object
                        basis.forward = current_object
                     end
                     if current_object.spawn_sequence == 4 then -- boundary object
                        basis.bounds = current_object
                     end
                     if current_object.spawn_sequence == 5 then -- backward step object
                        basis.backward = current_object
                     end
                  end
               end

            end
            -- now lets setup the temporary foot object

            -- now that we've completed the measurements, lets attach everything else
            basis = current_object
            for each object with label "L_Attach" do
               if current_object.team == temp_obj5.team then
                  offset_attach_object()
               end
            end
            for each object with label "L_Damage" do
               if current_object.team == temp_obj5.team then -- if on the same team, then this was intended to go on this leg
                  --_330_current_object()

                  offset_attach_object()
                  basis.D_cleanup = yaw_obj
                  basis.D_child = current_object
                  -- make sure its got the health it needs
                  current_object.max_health = leg_health
                  current_object.max_health *= 250
                  current_object.health = 100

                  temp_obj0 = current_object.place_at_me(sound_emitter_alarm_2, none,none,0,0,0,none)
                  temp_obj0.set_waypoint_visibility(enemies)
                  temp_obj0.team = ELITES
                  temp_obj0.attach_to(current_object, 0,0,40,relative)
                  --current_object.attach_to(current_object, 0,0,0,relative)
                  -- rabid added. for waypoint blinking on hit.
                  current_object.dam_waypoint = temp_obj0
                  --temp_obj0.dam_owner = current_object -- also doesn't have a use, and would never have a use
                  --temp_obj0.dam_health = 100 -- doesn't seem to have a purpose?? i guess you set this up prior to using the timer instead
               end
            end
            --current_object.visual_splode = current_object.place_between_me_and(current_object, bomb, 0)
            --current_object.visual_splode.attach_to(current_object, 0,0,0,relative)
            current_object.attach_to(current_object.socket, 0,0,0,relative)
            basis = no_object -- trigger the "do not run again for this leg" protocol
         end
      end
   end
end

-- damageable legs script, now hosted by our lower joints, to allow forge designated leg objects
for each object with label "L_Joint" do
   if current_object.D_cleanup != no_object and current_object.L_destoyed == 0 then -- wait till initialized?
      temp_num0 = current_object.D_child.health 
      temp_num0 -= 50
      --scarab_health_display += temp_num0
      if current_object.D_child == no_object or temp_num0 < 0 then -- if the leg component blew up, or is about to ignite, then notify the scarab of leg loss
         --game.show_message_to(all_players, none, "Leg Knocked Out!")
         --temp_obj0 = Scarab.mover
         scrb_downed_timer = max_downed_timer
         scrb_mover.legs_destroyed += 1
         game.show_message_to(all_players, none, "Leg %n Crippled!", scrb_mover.legs_destroyed)
         --current_object.visual_splode.detach()
         --current_object.visual_splode.kill(false)
         temp_obj0 = current_object.place_at_me(bomb, "Detonation", none, 0,0,0,none)
			-- given that this code was wrong, i'll just disable it
         --current_object.attach_to(current_object.socket, 0, 0, 0, relative)      -- I think/hope this is the L_atatch object. -- uhh that was not the right object (set to currobj.D_child), i changed to make it attach to its socket??
			current_object.D_cleanup.delete()
         current_object.L_destoyed = 1
			-- luxury. little success & failure message when 3 of the 4 legs have been knocked out
         if scrb_mover.legs_destroyed == 3 then
            --game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p1_win, false)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
            game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_loss, false)      -- Your failure here is troubling.     The fleetmaster will be displeased to hear of this failure.       This failure will NOT go unnoticed.
         end
         if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
            game.show_message_to(all_players, none, "The Scarab's core has been exposed!")
            --game.play_sound_for(ELITES, inv_spire_vo_covenant_p1_intro, false)      -- Hold fast, brothers. Do not let the humans pass!
            game.play_sound_for(ELITES, inv_spire_vo_covenant_p2_intro, false)      -- alt -- Return to the spire, brothers. The humans must not deactivate our shield!      -- fall back! we must protect the spire's shield from these fould humans!
            game.play_sound_for(SPARTANS, inv_spire_vo_spartan_p1_win, false)      -- Nice work, Spartans. Infiltrate their tower!
            game.play_sound_for(all_players, inv_cue_covenant_win_2, true)      -- Nice work, Spartans. Infiltrate their tower!
            scrb_mover.B_core.set_invincibility(0)
            --scrb_mover.B_core.set_waypoint_icon(bullseye)
				temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            --temp_obj0.set_waypoint_text("Core Exposed")
            temp_obj0.set_waypoint_visibility(everyone)
            --temp_obj0.set_waypoint_priority(high)
            temp_obj0.attach_to(scrb_mover.B_core, -10,0,5,relative)        -- -10, 0, 0  is really goo except when landing on front of scarab, looks like you should go down the ramp.
            --scrb_mover.B_core.set_waypoint_text("Core Exposed")
            --scrb_mover.B_core.set_waypoint_visibility(everyone)
            --scrb_mover.B_core.set_waypoint_priority(high)
            --temp_obj0 = scrb_mover.B_core
            temp_obj0.team = ELITES
            
            temp_obj1 = scrb_mover.B_core
            temp_obj1.dam_waypoint = temp_obj0      -- nest the waypointer so we can delete it after scarab explosion. 
				-- core blocker
            for each object with label "B_Misc" do
               if current_object.spawn_sequence == 12 then
                  current_object.delete()
               end
            end
         end
      end
   end
end


for each player do
   if current_player.is_a_dickhead > 0 then
      current_player.is_a_dickhead -= 1
      --if current_player.dickhead_timer.is_zero() then
         --current_player.is_a_dickhead = 0
         --current_player.dickhead_timer.reset()
         --game.show_message_to(all_players, none, "status cleared")
      --end
   end
end

-- 
--for each object with label "Detonation" do
--   current_object.countdown_ticks -= 1
--   if current_object.countdown_ticks == 0 then -- not less than or if has the potential to fire twice?
--      current_object.detach()
--      -- surely running this after wont have issues right lol -- ok it actually did have issues, who woulda guessed
--      --if current_object.ex_del1 != no_object then -- unneeded code
--         current_object.ex_del1.delete()
--      --end
--      current_object.kill(false)
--   end
--end

-- // /////////////////// //
-- // PROJECTILE SYSTEMS //
-- // ///////////////// //
function detonate_bomb_del_current()
   -- damage targeted building if in range, and not an AA flak projectile
   if current_object.is_building_shot != 0 and current_object.is_building_shot == c_goal.spawn_sequence and not current_object.is_of_type(light_blue) then 
      c_goal.theoretical_damage += 1
      call_attack_on_objective()
      
      -- removed to avoid expected overloading.
      -- rubble on hit.    Looks incredible, but surely waaaaaay too many objects and will cause overloading.
      temp_num0 = c_goal.theoretical_damage
      temp_num0 %= 12         -- using 6 instead of 7 means the rubble gets varying launch strength depending on when in the volley it spawns.      consider using 12 for half as frequent to lessen overloading.
      if temp_num0 == 0 then
         temp_obj0 = current_object.place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         --temp_obj0.attach_to(current_object, 0,0,0, relative)       -- Optional line. detaches further down. With this the rubble tends to launch less and more evenly.  however sometimes pings the covie bombs away.
         -- Without the attach line, rubble launches further and in a small angle, in some ways more realistic, but a bit repetitive. Also in some cases the barrier appears a long distance from the wall (which looks bad).
         temp_obj0.attach_to(current_object, -1,0,0, relative)         -- attaching 1 behind looks great, doesn't ping covie bombs as much, but launches a lot further than 0 distance.
      end
   end
   -- either way, detonate the bomb.
   --current_object.object[0].detach()
   --current_object.object[0].kill(false)
   --current_object.delete()
   -- Rabid: create bomb only at the moment of impact.
   temp_obj0 = current_object.place_at_me(covenant_bomb, "Detonation", none, 0,0,0, none)
   temp_obj0.attach_to(current_object.p_mover, 0,0,0,relative)
   temp_obj0.ex_del1 = current_object
end
-- attach bomb in front of AA flak projectile
-- projectile functionality script
for each object with label "Projectile" do
   current_object.lifespan -= 3
   -- movement script 
   --temp_obj3.p_mover.detach()
   if current_object.is_of_type(light_blue) then
      current_object.p_mover.attach_to(current_object, 4,0,0,relative)
      current_object.lifespan -= 1
   end
end
-- attach bomb in front of face cannon projectile (25% slower travel speed)
for each object with label "Projectile" do
   if not current_object.is_of_type(light_blue) then
      current_object.p_mover.attach_to(current_object, 3,0,0,relative)
   end
end
-- light then leap frogs its own bomb
for each object with label "Projectile" do
   --temp_obj3.detach()
   current_object.attach_to(current_object.p_mover, 0,0,0,relative)
   if current_object.p_mover == no_object then -- this would be an error, or somehow it blew up
      current_object.delete()
   end
end
-- projectile wall collision test. moves a single test test object (hill marker?) 4 in front, spawns a test bomb to see if offset (wall detected), then triggers explosion and optional vehicle damage in a function.
for each object with label "Projectile" do
   current_object.collision_check_ticks += 1
   if current_object.collision_check_ticks >= ticks_till_collision_check then
      current_object.collision_check_ticks = 0
      projectile_collision_test_agent.attach_to(current_object, 4,0,0, relative)
      projectile_collision_test_agent.detach()
      temp_obj0 = projectile_collision_test_agent.place_at_me(bomb, none, none, 0,0,0,none)
      temp_num0 = temp_obj0.get_distance_to(projectile_collision_test_agent)
      temp_obj0.delete()
      if temp_num0 > 1 then
         --game.show_message_to(all_players, none, "collision depth: %n", temp_num0)
         detonate_bomb_del_current()
      end
   end
end
for each object with label "Projectile" do
   -- check for the closest player, actually we dont really need this?
   temp_num0 = 999
   for each player do 
      if current_player.biped != no_object then
         temp_num1 = current_player.biped.get_distance_to(current_object)
         if temp_num1 < temp_num0 then
            temp_num0 = temp_num1
         end
      end
   end
   -- explode 8 (4) ticks early, cause it always shoots thru the ground and doesn't explode
   if current_object.lifespan <= 8 or temp_num0 < 9 then -- run death subroutine
      -- current_object.p_mover.detach()
      -- current_object.p_mover.kill(false)
      -- current_object.delete()
      detonate_bomb_del_current()
   end
end



-- // /////////////////////////// //
-- // SCARAB LEG MOVEMENT SYSTEM //
-- // ///////////////////////// //
-- INPUTS
-- temp_obj5 -- the object and their pitch helper
-- temp_obj0 -- the object to look at 
function interp_towards()
   temp_obj0.detach()
   -- attach the pitch to the base
   --temp_obj5.detach()
   -- face towards the step location
   temp_obj3.p_y_helper.face_toward(temp_obj0, 0,0,0)
   temp_obj5.pitch_helper.detach()
   temp_obj5.pitch_helper.face_toward(temp_obj0, 0,0,0)
   -- attach & offset
   temp_obj3.p_y_helper.attach_to(temp_obj5.pitch_helper, 1,0,0,relative)
   --temp_obj5.attach_to(temp_obj5.pitch_helper, 1,0,0, relative)

   temp_num0 = Scarab.L_Queued
   --temp_num0 *= 159
   temp_num0 *= 5
   temp_num0 += 142
   temp_obj5.pitch_helper.set_scale(temp_num0)
   temp_obj5.pitch_helper.copy_rotation_from(temp_obj5.pitch_helper, true)
   temp_obj3.p_y_helper.detach()
   -- reset the state of everything for the next tick
   temp_obj5.pitch_helper.set_scale(100)
   temp_obj5.pitch_helper.copy_rotation_from(temp_obj5.pitch_helper, true)
   temp_obj5.pitch_helper.attach_to(temp_obj3.p_y_helper, 0,0,0,relative)
   --temp_obj5.pitch_helper.detach() -- potentially unneeded
   --temp_obj5.attach_to(temp_obj5.pitch_helper, 0,0,0, relative)
   -- now check to see if the interpolation is complete
   temp_num0 = temp_obj5.get_distance_to(temp_obj0)
   -- reattach our thingo object, before the condition to save script space
   temp_obj0.attach_to(temp_obj0.socket, 0,0,0,relative)
   if temp_num0 < 12 then -- we've completed the step interpolation
      -- set it back to normal physics mode
      --Scarab.L_Active -= 1
      Scarab.L_Active = -30 -- 30 ticks before it can take another step

      temp_obj5.detach()
      temp_obj5.pitch_helper.attach_to(temp_obj3.p_y_helper, 0,0,0,relative)
      temp_obj3.p_y_helper.attach_to(temp_obj5,0,0,0,relative)
      -- now make sure we now in no interp mode
      temp_obj5.Interpolating = 0
   end
end

do
   temp_obj4 = no_object -- this is our "which leg is next" object
   temp_num2 = 0 -- this is our current lowest time thingo
   Scarab.L_Queued = 0
   -- the step cooldown, no more goofy walk
   if Scarab.L_Active < 0 then
      Scarab.L_Active += 1
      if Scarab.L_Queued > 30 then -- 30 ticks worth of legs being outta bounds
         Scarab.L_Active += 1
      end
   end
end
-- leg step checking script
for each object with label "U_Joint" do
   if current_object.initialized == 1 and current_object.foot != no_object then
      temp_obj5 = current_object.foot
      -- "kick" players who are in the way
      for each player do 
         if temp_obj5.shape_contains(current_player.biped) then
				current_player.biped.kill(false)
				if current_player.p_vehicle != no_object then
					current_player.p_vehicle.kill(false)
				end
         end
      end 
      -- now count how many legs are queued/active, and if active then 
      if temp_obj5.Interpolating == 0 then
         --temp_obj0 = temp_obj5.bounds
         --temp_obj0.detach()
         if temp_obj5.bounds.shape_contains(temp_obj5) then
            current_object.outta_bounds_for = 0
         end
         -- check whether this foot needs to take a step
         if not temp_obj5.bounds.shape_contains(temp_obj5) then
            --Scarab.L_Queued += 1
            current_object.outta_bounds_for += 1
            Scarab.L_Queued += current_object.outta_bounds_for
            -- only select a next-to-move leg if none are moving at the moment
            if Scarab.L_Active == 0 and current_object.outta_bounds_for > temp_num2 then -- this leg has been out of bounds for the longest, move this one
               temp_obj4 = current_object
               temp_num2 = current_object.outta_bounds_for
            end
         end
         --temp_obj0.attach_to(temp_obj0.socket, 0,0,0,relative)
      end
   end
end
if temp_obj4 != no_object then 
   temp_obj5 = temp_obj4.foot -- reasign the temp_obj5, because this is outside the loop
   temp_obj4.outta_bounds_for = 0 -- potentially unneeded?
   Scarab.L_Active += 1
   -- detach for accurate distances
   temp_obj1 = temp_obj5.forward
   temp_obj1.detach()
   temp_obj2 = temp_obj5.backward
   temp_obj2.detach()
   -- read actual distances
   temp_num0 = temp_obj5.get_distance_to(temp_obj1)
   temp_num1 = temp_obj5.get_distance_to(temp_obj2)
   -- reattach
   temp_obj1.attach_to(temp_obj1.socket, 0,0,0,relative)
   temp_obj2.attach_to(temp_obj2.socket, 0,0,0,relative)

   -- setup interp mode
   temp_obj3 = temp_obj5.pitch_helper
   temp_obj3.p_y_helper.detach()
   temp_obj5.attach_to(temp_obj3.p_y_helper,0,0,0,relative)

   if temp_num0 < temp_num1 then -- is closer to forward than backwards, so interp backwards
      temp_obj5.Interpolating = -1
   end
   if temp_obj5.Interpolating == 0 then -- else step forwards
      temp_obj5.Interpolating = 1
   end
end
-- foot position calculations script
for each object with label "U_Joint" do
   if current_object.initialized == 1 and current_object.foot != no_object then

      -- legs active isn't recounted, but increased/decreased when appropriate
      -- update/check the interpolation position of the foot
      temp_obj5 = current_object.foot
      if temp_obj5.pitch_helper != no_object and temp_obj5.forward != no_object and temp_obj5.backward != no_object and temp_obj5.bounds != no_object then -- unneeded extra conditions
         temp_obj3 = temp_obj5.pitch_helper
         if temp_obj5.Interpolating == 1 then -- interp forwards
            temp_obj0 = temp_obj5.forward
            interp_towards()
         end
         if temp_obj5.Interpolating == -1 then -- interp backwards
            temp_obj0 = temp_obj5.backward
            interp_towards()
         end
      end
   end
end


-- literally used just so the scarab can see whos a biped is
for each player do
   if current_player.biped != no_object then
      temp_obj0 = current_player.biped
      temp_obj0.bp_owner = current_player
   end
end


-- configure the bomb effects for the bomb objects
--for each object with label "S_Ob_Point" do
--   if current_object.team == team[3] and current_object.bomb_visual == no_object then
--      current_object.bomb_visual = current_object.place_at_me(bomb, none, none, 0,0,0,none)
--      current_object.bomb_visual.attach_to(current_object, 0,0,0,relative)
--   end
--end

-- // //////////////////////////////////// //
-- // building damage and destroyed logic //
-- // ////////////////////////////////// //
function test_structure_integrity() -- AND destroy the part doing the evaluation
   C_goal.ob_status = 2
   temp_num0 = 0 -- clear this
   -- check for any other pieces still holding this tower up
   for each object with label "S_Objective" do
      if current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.spawn_sequence == c_goal.spawn_sequence and current_object.ob_status == 0 or current_object.ob_status == 1 then
         temp_num0 += 1
      end
   end
 
   if temp_num0 == 0 then -- that was the last alive pillar; now destroyed
      game.show_message_to(all_players, none, "Structure %n destroyed!", c_goal.spawn_sequence)

      ELITES.score += 1
      -- Rabid: 1st building destroyed
      --team[0].number[1] += 1
      --if team[0].number[1] == 1 then
      -- Rabid tweak. Only announce territory captured if the final objective for this building was a scarab-shot objective, because territories now always announce this earlier (even if not final piece).
      if c_goal.team != team[0] then
         game.play_sound_for(SPARTANS, announce_territories_lost, false)
         game.play_sound_for(ELITES, announce_territories_captured, false)
         c_goal.place_at_me(bomb, "Detonation", none, 0,0,0,none)     -- Rabid added: final destructible automatically makes a bomb explosion. warning: might mess with debris falling directions / launch stuff.
         c_goal.place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         -- removed to reduce overloading
         --temp_obj0 = c_goal.place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         --temp_obj0.face_toward(temp_obj0, -1,0,0)      -- rotate 2nd barrier 180 so rubble flies in 2 opposite directions.
      end
      if ELITES.score == 1 then
         --game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
         game.play_sound_for(SPARTANS, inv_spire_vo_spartan_p1_loss, false)         -- Time for a backup plan... Fall back and regroup.
         game.play_sound_for(ELITES, inv_spire_vo_covenant_p2_win, false)      -- Well done, brothers. These humans are no match for the Covenant's might!
      end
      -- Rabid: 5th building     <-- this is correct for the final foreunner structure on moro's map
      --if team[0].number[1] == 5 then
      if ELITES.score == 4 then
         --game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
         game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p2_intro, false)     -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core.
         --game.play_sound_for(ELITES, inv_spire_vo_covenant_p1_win, false)         -- yes well done the humans are but dust in our vision! they will not forget this battle, we are victiorious!
         --inv_spire_vo_covenant_p1_win         -- alternative.         This one is also really very good, maybe better than p3. It's more demeaning.    This would be fine for a midpoint announcement.
         game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_win, false)      -- Well done. Push forward and crush the human defenses.
      end

      -- blow stuff up! + tell players to get bumped
      for each object with label "S_Ob_Point" do
         if current_object.spawn_sequence == c_goal.spawn_sequence then
            -- cleanup any spawns attached to this tower
            if current_object.team == team[2] then 
               temp_obj1 = current_object
               for each object with label "S_Ob_Point" do
                  if current_object.team == team[0] or current_object.team == team[1] and temp_obj1.shape_contains(current_object) then
                     current_object.delete()
                  end
               end
               -- bump players with push_upwards to wake their physics. Is that really needed? Players rarely stand still.     luxury/semi-redundnant.      <-- replaced with Flood wake physics on local.
               -- Note that this only occurs for structures with trait zones anyway.
               --for each player do
                  --if current_object.shape_contains(current_player.biped) then 
                     --current_player.number[2] += 1
                  --end
               --end
            end
				-- human bomb explosion
            -- I'm not sure why trait zones were (team[2]) were also included. They don't make bombs in Gamergotten's version. probably vestigial in Gamergotten's script.
            -- Ohhhhh I see now, it's just shared script to delete the trait zone.
            --if current_object.team == team[3] or current_object.team == team[2] then      
               --trigger_25()
            --end
            --if current_object.team == team[2] then
               --current_object.delete()
            --end
            if current_object.team == team[3] or current_object.team == team[2] then -- is a bump zone, if not then it'll *probably* ignore the two lower lines & cleanup
               if current_object.team == team[3] then
                  current_object.place_at_me(bomb, "Detonation", none, 0,0,0,none)
               end
               current_object.delete()    -- to save on object count.
            end
         end
      end
      -- ok, now blow up all of the related pieces
      for each object with label "S_Objective" do
         if current_object.team == neutral_team and current_object.spawn_sequence == c_goal.spawn_sequence then
            --temp_obj1 = current_object.place_between_me_and(current_object, skull, 0)
            temp_obj1 = current_object.place_at_me(frag_grenade, "falling_object", none,0,0,0,none)
            temp_obj1.f_o_attached_object = current_object
            temp_obj1.set_invincibility(1)
            --temp_obj1.set_pickup_permissions(no_one)
            --temp_obj1.set_scale(1)
            --temp_obj1.copy_rotation_from(temp_obj1, true)
            temp_obj1.attach_to(current_object, 0,0,0,relative)
            temp_obj1.detach()
            current_object.attach_to(temp_obj1, 0,0,0,relative)
            temp_obj1.push_upward()
            --temp_obj1.push_upward() -- too comical
            --temp_obj1.push_upward() -- thats TOO much force
         end
      end
   end
   c_goal.delete()
   -- test whether all the buildings are destroyed or not
   temp_num0 = 0 
   for each object with label "S_Objective" do
      if current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.ob_status == 0 or current_object.ob_status == 1 then
         temp_num0 += 1
      end   
	end
   -- Rabid: one building remaining
   if temp_num0 == 1 and last_building_announced == 0 then
      --game.play_sound_for(SPARTANS, inv_spire_vo_spartan_p1_extra, false)     -- you must maintain control of that platform spartans!
      --game.play_sound_for(ELITES, inv_spire_vo_covenant_p2_win, false)      -- Well done, brothers. These humans are no match for the Covenant's might!
      game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
      game.play_sound_for(ELITES, inv_spire_vo_covenant_p1_win, false)         -- yes well done the humans are but dust in our vision! they will not forget this battle, we are victiorious!
      last_building_announced = 1
   end
   if temp_num0 <= 0 and game_end_state == 0 then -- gameover
      game_end_state = -1
      game.play_sound_for(all_players, inv_cue_covenant_win_big, true)
      game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p3_loss, false)    -- Navigation core compromised; we lost it. Alert Command
      --game.play_sound_for(SPARTANS, inv_spire_vo_spartan_p3_loss, false)         -- No other assets available spartans. Get out of there and we'll regroup at area fox.    NOTE this is missing from Sopitive's documentation. Incorrectly listed above a different sound which isn't named.
      game.play_sound_for(ELITES, inv_spire_vo_covenant_p3_win, false)         -- Yes, brothers! Well done! The humans have learned a harsh lesson!
      --inv_spire_vo_covenant_p1_win         -- alternative.         This one is also really very good, maybe better than p3. It's more demeaning.    This would be fine for a midpoint announcement.
   end   
end

on object death: do
   -- clear target status on scarab if it just killed it
   if killed_object == Scarab.s_target then
      Scarab.s_target = no_object
      --temp_obj0 = Scarab.mover
      scrb_mover.time_till_retarget = 0
   end
   -- dont need this as we're moving away from the health based system
   -- if killed_object.has_forge_label("S_Objective") and killed_object.team == team[2] or killed_object.team == team[3] or killed_object.team == team[4] then -- is a structure foundation
   --    temp_obj0 = killed_object
   --    test_structure_integrity()
   -- end
end
-- attack objective code
if c_goal != no_object and c_goal.team == team[2] then 
   --c_goal.ally_icon.set_waypoint_priority(high)
   c_goal.enemy_icon.set_waypoint_priority(high)
   if not under_attack_timer.is_zero() then
      --c_goal.ally_icon.set_waypoint_priority(blink)
      c_goal.enemy_icon.set_waypoint_priority(blink)
   end
end
if c_goal != no_object then 
   if c_goal.theoretical_damage >= building_health then
      test_structure_integrity()
   end
end
-- for each object with label "S_Objective" do
--    if current_object.team == team[2] or current_object.team == team[3] or current_object.team == team[4] and current_object.ob_status == 0 or current_object.ob_status == 1 then -- is a structure foundation object -- aka destroy this to destroy the building
--       temp_num0 = current_object.health 
--       if temp_num0 <= 0 then -- this object died, but didn't run the object death event
--          temp_obj0 = current_object
--          test_structure_integrity()
--       end   
--    end
-- end
alias maximum_recover_time = script_option[1] -- 7
-- territories code
if c_goal != no_object then 
   if c_goal.team == team[0] or c_goal.team == team[1] then
      temp_num0 = 0
      for each player do 
         if c_goal.shape_contains(current_player.biped) then 
            if current_player.team == ELITES then
               temp_num0 += 1
            end
            if current_player.team == SPARTANS then
               temp_num0 |= 0b0100000000000000
            end
         end
      end
      -- NETTEST DEBUG
      --temp_obj0 = c_goal.ally_icon -- not sure why the code for this was still here, we dont have an ally icon anymore
      --temp_obj0.ob_cap_time = c_goal.ob_cap_time
      temp_obj0 = c_goal.enemy_icon
      temp_obj0.ob_cap_time = c_goal.ob_cap_time
      if temp_num0 == 0 or temp_num0 == 0b0100000000000000 then -- this has no spartans inside
         scenario_iterp_state = no_team
         --c_goal.ally_icon.set_waypoint_priority(high)
         c_goal.enemy_icon.set_waypoint_priority(high)
         c_goal.ob_cap_time.set_rate(100%)
         if c_goal.ob_cap_time >= maximum_recover_time then 
            c_goal.ob_cap_time.set_rate(0%)
         end
      end
      if temp_num0 != 0 and temp_num0 != 0b0100000000000000 then -- there are spartans in here
         scenario_iterp_state = team[0]
         --c_goal.ally_icon.set_waypoint_priority(blink)
         c_goal.enemy_icon.set_waypoint_priority(blink)
         c_goal.ob_cap_time.set_rate(0%) -- is contested
         if temp_num0 > 0 and temp_num0 < 0b0100000000000000 then -- if there are no elites in here
            c_goal.ob_cap_time.set_rate(-100%)
            call_attack_on_objective()
            if c_goal.ob_cap_time.is_zero() then 
               -- Rabid added. always announce territory captured if it's a territory objective, even if this isn't the final objective for the structure.
					game.play_sound_for(SPARTANS, announce_territories_lost, false)
					game.play_sound_for(ELITES, announce_territories_captured, false)
					test_structure_integrity()
            end
         end
      end
   end
end

-- // ////////////////////// //
-- // FALLING DEBRIS SCRIPT //
-- // //////////////////// //
-- debris clear from scarab interrior script
for each object with label "S_Objective" do
   if current_object.team == debris_static_indicator_team then -- is debris
      if Scarab.shape_contains(current_object) then
			-- debris flag stand issue
         current_object.delete()
      end
   end
end
-- heres our falling object -> turn static mode boundary stuff whatever
for each object with label "falling_object" do
   temp_num0 = current_object.get_speed()
   if temp_num0 < 5 then -- is moving too slow, or has landed on something not anticipated
      current_object.ticks_still += 1
   end
end
for each object with label "falling_object" do
   -- multi ground shapes
   temp_num0 = 0
   temp_obj0 = current_object
   for each object with label "B_Misc" do
      if current_object.spawn_sequence == 8 then -- this is obviously a ground hill marker boundary 2am 
         if current_object.shape_contains(temp_obj0) then
            temp_num0 = 1
         end
      end
   end
   if temp_num0 == 1 or current_object.ticks_still > max_ticks_still_before_staticifying then -- we are inside one of the static-ifier zones, so go static
      temp_obj0 = current_object.f_o_attached_object
      temp_obj0.team = debris_static_indicator_team
      temp_obj0.detach()
      current_object.delete()

		toggle ^= 1
      if toggle == 0 then -- this guy is gonna stick around, the next will not!!
         temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, flag_stand, 0)
         temp_obj0.attach_to(temp_obj1, 0,0,0,relative)
      end
   end
end


-- semi-redundant. Cargo physics widget
-- quickly go through and tell each player if they are or aren't supposed to be experiencing cargo physics
--for each player do
--   script_widget[1].set_visibility(current_player, false)
--   if current_player.biped != no_object and Scarab.shape_contains(current_player.biped) then
--      temp_obj0 = current_player.try_get_vehicle()
--      if temp_obj0 == no_object then
--         script_widget[1].set_visibility(current_player, true)
--      end
--   end
--end

-- // ////////////////////////////////// //
-- // prevent health regen on AA turret //
-- // //////////////////////////////// //
-- rabbi AA health regen
do
	temp_num0 = AA_turret.health
	if temp_num0 > AA_turret.t_last_health and temp_num0 < 99 then
		AA_turret.health = AA_turret.t_last_health
	end
end
do
   AA_turret.t_last_health = AA_turret.health
end

do
   host_indicator = 3621 -- set this to a high number that is not either 0 or 1
end 


on local: do 
   
	-- brute flag decoration
   for each object with label 14 do -- labelled just for labels sake
      if current_object.is_of_type(flag) then
         current_object.set_scale(20)
         --current_object.copy_rotation_from(current_object, false)    -- maybe redundant.
      end
      -- hide carried golf clubs (stowable turrets).
      --if current_object.is_of_type(golf_club) then
         --temp_player0 = current_object.try_get_carrier()
         --if temp_player0 != no_player then
         --current_object.set_scale(1)
      --end
   end

   -- Stowed machine gun visual.    
   -- Warning: might not work right in multiplayer. I seem to remember it being impossible to get this to work without attaching to armor ability. could try delaying by few ticks before attach.
   --for each player do
      
      --temp_obj6 = current_player.try_get_weapon(secondary)
      -- removed for space (and because won't work till Duck's attachment fix)
      --if temp_obj6.is_of_type(golf_club) then -- and global.number[6] != 3621 then         -- RE-ADD
         --temp_obj6.set_scale(1)
         -- Holstered machine_gun_turret
         -- Basically I'm only doing this on local in the hopes it'll work for this current bugged MCC update version till Duck makes a fix.
         --if temp_obj6.object[0] == no_object then	
            --temp_obj6.object[0] = temp_obj6.place_between_me_and(temp_obj6, detached_machine_gun_turret, 0)     -- troubleshooting
            --temp_obj6.object[0].copy_rotation_from(temp_obj6, true)
            --temp_obj6.object[0].set_scale(90)
            --temp_obj6.object[0].attach_to(temp_obj6, 1,0,1,relative)
         --end
      --end
   --end
   
   
   

   --scale label 
   for each object with label "scale" do
      if current_object.has_scaled == 0 and host_indicator <= -90 or host_indicator == 3621 then
         current_object.has_scaled = 1
         _330_current_object()
         -- yellow team logic to setup the wall collies to be perfectly flat
			-- wall collie fixup
         if current_object.team == team[5] then 
            temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            temp_obj1 = temp_obj0.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
            temp_obj0.face_toward(temp_obj0, 0,1,0)
            temp_obj0.attach_to(temp_obj1, 0,0,0,relative)
            temp_obj1.face_toward(temp_obj1, 0,1,0)
            temp_obj0.detach()
            current_object.copy_rotation_from(temp_obj0, true)
            temp_obj0.delete()
            temp_obj1.delete()
         end
         -- "purple" team logic, make the object phased & have infinite health, for the seraphs scaling
         -- we actually HAVE to do this on each client to workaround the attachment glitch
         if current_object.team == team[4] or current_object.team == team[3] then 
            --temp_obj0.set_scale(1)
            current_object.max_health *= 5000
            current_object.health = 100
            if current_object.team == team[4] then
               temp_obj0 = current_object.place_between_me_and(current_object, heavy_barrier, 0)
            end
            if current_object.team == team[3] then
               temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)  -- warning, I have a feeling sound emitter means it has no hitbox. use 1% flag stand instead if so.
            end
            current_object.detach()
            current_object.attach_to(temp_obj0, 0, 0, 0, relative)
         end
      end
   end
	
	-- reset AA_turret orientation when its no longer facing players script
	if AA_turret.W_yaw != no_object and AA_turret.W_pitch != no_object and scarab_ready_timer.is_zero() then
		AA_reset_orientation += 1
		if AA_reset_orientation == AA_reset_ticks then
			temp_obj0 = AA_turret
			temp_obj1 = AA_turret.t_socket.place_at_me(sound_emitter_alarm_2, none,none,-127,0,0,none) -- make it point backwards? thats funny
			thingo_face_towards()
			AA_turret.W_yaw.attach_to(AA_turret.t_socket, 0,0,0,relative)
			temp_obj1.delete()
		end
	end
	
	
   -- misc off-host only behavior
   if host_indicator <= 0  then
      
		-- local player finder -- i feel like not adjusting the position could be problematic?? IE. player is in text chat when they spawn, and then another player spawns and moves their thing out of the way (unlikely but it would be pretty funny)
		for each player do
			if _local_player == no_player and current_player.biped != no_object then
				if current_player.local_finder == no_object then
					current_player.local_finder = current_player.biped.place_at_me(elite, none, suppress_effect, 5, 0, 2, none)
					--current_player.local_finder.set_scale(1)
				end
				-- local finder failsafe
				current_player.local_finder.attach_to(current_player.biped, 5,0,2,relative)
				current_player.local_finder.detach()
				--
				temp_obj0 = current_player.get_crosshair_target()
				if temp_obj0 != no_object then
					_local_player = current_player
					for each player do
						current_player.local_finder.delete()
					end
				end
			end
		end
		-- AA turret lookat
		if AA_turret.t_target != no_object and AA_turret.W_yaw != no_object and AA_turret.W_pitch != no_object and scarab_ready_timer.is_zero() then
			if not Scarab.proximity.shape_contains(AA_turret.t_target) then
				turret_lookat() -- reset aa refresh number
			end
		end

      host_indicator -= 1 -- initial 1.5 seconds delay to let everything sync so we dont get hella unexplained issues
      if host_indicator <= -90 then -- then our guy has waited for the host to sync everything

			-- run an update once every 150 ticks | 2.5 seconds
			if host_indicator < -240 then 
				host_indicator = -90
				-- we're going to slap the scarab rotation syncing here too!! -- NOTE: we should sync this up with 'toggle' being 0, so any big rotation syncs immediately make the colliders update position too
				Scarab.detach()
				Scarab.face_toward(host_scarab_rotation, 0,0,0)
				Scarab.attach_to(scrb_mover, 0,0,0,relative)
				-- detach any debris objects that need detaching -- detaching something that isn't attached is not going to cause any lag i think, so we dont need to  restrict this to ONLY when it needs to run
				for each object with label "S_Objective" do
					if current_object.team == debris_static_indicator_team then
						current_object.detach()
					end
				end
			end
			
			toggle ^= 1 -- update collision every second tick to prevent quicksanding the scarab collision + it might slightly help with performance
			if toggle == 0 and _local_player.biped != no_object then
				for each object with label "B_Attach" do
					if current_object.team != team[7] then
						-- make sure the object is currently attached (hopefully this doesn't cause lag if its already attached to it!!)
						current_object.attach_to(current_object.offset, 0,0,0,relative)
						-- only update position if local player is inside scarab boundary!!
						if Scarab.proximity.shape_contains(_local_player.biped) then
							current_object.detach()
							current_object.copy_rotation_from(current_object.offset, true)
						end
					end
				end
			end
			
			-- GG TODO: put this somewhere where it doesn't have to run each tick!!
			-- hide propane tanks from clients
			for each object with label "L_Damage" do
				if current_object.team != neutral_team then 
					current_object.set_hidden(true)
				end
			end
			
         -- make the eyeball gun face towards the target player as it should do
			-- we run this after potentially after sync'ing scarab rotation because then it puts us closer to what the host is actually seeing right now? maybe???
         if Scarab.Setup == 1 and Scarab.s_target != no_object and Scarab.downed_state == 0 and scarab_ready_timer.is_zero() then
            Scarab_interp_face_towards()
         end
      end
   end
   
	
	--for each player do
      --if current_player.number[3] < current_player.number[2] then 
         --current_player.number[3] += 1
         --current_player.biped.push_upward()
      --end
   --end
   -- wake physics for each player whenever a structure is destroyed or captured.      +1 action (total)      + works even if structures have no trait zone or player is outside trait zones     - might be object intensive?
   -- Rabid rework: from flood wall climbing bump.
   --for each player do
      --if current_player.number[3] < global.team[1].score then 
         --current_player.number[3] = global.team[1].score
         --global.object[0] = current_player.biped.place_between_me_and(current_player.biped, monitor, 0)        -- bomb obejct type doesn't work.
         --global.object[0].delete()
      --end
   --end

   -- Rabid bump:    FIXED.   
   -- The above version causes clients to crash if a late joiner arrives after score > 0.    I'm not certain why, could be a few problems, so I'm rewriting this to address all potential problems.
   -- wake physics for each player whenever a structure is destroyed or captured.      +1 action (total)      + works even if structures have no trait zone or player is outside trait zones     - might be object intensive?
   -- Rabid rework: from flood wall climbing bump.
	-- player bumpcount script
   for each player do
      if current_player.CLIENT_bumpcount < ELITES.score and current_player.biped != no_object then
         current_player.CLIENT_bumpcount = ELITES.score
         temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, monitor, 0)        -- bomb obejct type doesn't work.
			if temp_obj0.is_of_type(monitor) then
            temp_obj0.delete()
         end
      end
   end

   -- update the position of the scarab legs, both host & non-host
   for each object with label "U_Joint" do
      if current_object.initialized == 1 and current_object.foot != no_object then
			
			alias curr_pitch = temp_obj3
			curr_pitch = current_object.pitch
         -- orient the leg to be facing the foot location, this should move all the attached joints too
         current_object.detach()
         current_object.face_toward(current_object.foot, 0,0,0)
			
         -- then orient the pitch to face directly at the foot (if the distance is too long, then this serves as a fallback to extend 100%)
         --current_object.pitch.detach()
         --current_object.pitch.face_toward(current_object.foot, 0,0,0)
			
			-- curr_pitch is out pitch rotator for our leg joint that is connected directly to the scarab
			-- curr_pitch.R_pivot is the pitch rotator on the foot bomb object thing
			-- curr_pitch.R_kneepoint is an object extended out to where the knee should be, but its attached to the foot object??
			
			-- detach & setup the pivot position
			curr_pitch.R_pivot.detach()
			curr_pitch.R_pivot.attach_to(current_object.foot, 0,0,0,relative)
			curr_pitch.R_pivot.detach()
			curr_pitch.R_pivot.face_toward(current_object.knee, 0,0,0)
			
			-- cascade the direction of upper joint
			curr_pitch.detach()
			curr_pitch.face_toward(curr_pitch.R_kneepoint, 0,0,0)
			-- fix for leg inversion -- this surely can't work right? 
			curr_pitch.face_toward(curr_pitch, 105,-1,0) -- rotate it slightly in the upwards facing direction so it never fully extends the leg
			
			-- then face our knee towards foot, simple as
			temp_obj1 = current_object.knee
			temp_obj1.detach()
			temp_obj1.face_toward(current_object.foot, 0,0,0)
			-- now that our leg has been calculated, lets reattach everything!
			temp_obj1.attach_to(temp_obj1.socket, 0,0,0,relative)
			curr_pitch.attach_to(current_object, 0,0,0,relative)
			-- pop the pivot back so host doesn't mess with it (it doesn't matter where we attach it to!!)
			curr_pitch.R_pivot.attach_to(curr_pitch, 0,0,0, relative) -- do this one first so it doesn't have to update scarab attachments yet
			
			current_object.attach_to(current_object.socket, 0,0,0,relative)
			
			-- potentially unneeded with the new system
         --c_UpperToDestinationLength = current_object.get_distance_to(current_object.foot)
         --temp_num5 = current_object.UpperLenght
         --temp_num5 += current_object.LowerLength
         --if temp_num5 > c_UpperToDestinationLength then 
         --   CalculateJointAngle()
         --end
			-- if the angle is invalid to calculate, then skip rotation and leave the joints just looking at it
			--if temp_num5 <= c_UpperToDestinationLength then
			--end
      end
   end


	-- new cargo physics (do after all scarab movement!!)
	scrb_phys.detach() -- we dont want to do this per player!! just once per tick then
	for each player do
		-- only commit cargo physics to players if our player is in the area?? GG TODO: reverse this after we find out that it doesn't look very good for people outside the scarab
		if current_player.biped != no_object and Scarab.proximity.shape_contains(_local_player.biped) or host_indicator == 3621 then
			temp_obj0 = current_player.try_get_vehicle() -- we cant use the p_vehicle var here because this is on the client
			-- limit cargo physics to only happen within its range!! so we dont trap players on the scarab (it pulls them back to as close as it can get)
			temp_num0 = current_player.biped.get_distance_to(scrb_phys)
			temp_num0 /= 2 -- we need to check if distance is greater than twice the cascade length, alternatively we check if half the distance is greater than a single cascade length
			temp_num0 += 5 -- just to be sure that we aren't just on the edge, and it kinda acts as like a wall so we cant get off the scarab
			if not Scarab.shape_contains(current_player.biped) or temp_obj0 != no_object or temp_num0 >= cascade_length then
				current_player.r_base.delete()
			end
			if Scarab.shape_contains(current_player.biped) and temp_obj0 == no_object and temp_num0 < cascade_length then
				if current_player.r_last == no_object then
					current_player.r_last = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
				end
				-- check if player already has an offset ready to go
				if current_player.r_base != no_object then
					-- first we generate our offset attach for the difference between our player and where they were tick (global position)
					cas_src = current_player.r_last
					cas_dst = current_player.biped
					cascade() -- no problems finding global tick offset
					temp_obj3 = cas_src
					-- then we stick that offset to our stored relative position, so the cas_foot of temp_obj3 is our new relative position
					temp_obj0 = current_player.r_base
					temp_obj3.attach_to(temp_obj0.cas_foot, 0,0,0, relative)
						
					-- then we create a new offset attach from the player to the new relative position
					cas_src = current_player.biped
					cas_dst = temp_obj3.cas_foot
					cascade() -- this is the cascade that fails somehow
					
					-- attach the offset to the player (its already at the player, just not attached)
					cas_src.attach_to(current_player.biped, 0,0,0, relative)
					-- complete the offset by attaching the player to the cas_foot of this, automaticallly detaching them & maintaining momentumn
					current_player.biped.attach_to(cas_src.cas_foot, 0,0,0, relative)
					-- cleanup
					cas_src.delete()
					--temp_obj3.delete() -- deleted just below
					current_player.r_base.delete()
				end
				-- update previous position
				current_player.r_last.attach_to(current_player.biped, 0,0,0, relative)
				current_player.r_last.detach()
				-- generate current relative position
				cas_src = scrb_phys
				cas_dst = current_player.biped
				cascade()
				cas_src.attach_to(scrb_phys, 0,0,0, relative)
				current_player.r_base = cas_src
				
				-- dumb system to fix the players not moving with the scarab on the height axis (9 actions!!) yeah this also breaks their momentumn, also i didn't bother optimizing the conditions here
				if Scarab != no_object and Scarab.Setup == 1 and scarab_ready_timer.is_zero() and Scarab.downed_state > 0 and Scarab.downed_state < interp_down_ticks or scrb_downed_timer <= 0 then
					-- dont push people who are on the ground!!
					-- player squishing
					-- multi ground shapes
					for each object with label "B_Misc" do
						if current_object.spawn_sequence == 8 then -- ground hill marker (usually used to detect the ground for debris pieces!!)
							if current_object.shape_contains(current_player.biped) then
								temp_num0 = -1 -- temp_num0 will always be a positive number becuase the last time its set is distance measurement
							end
						end
					end
					if temp_num0 != -1 then
						temp_obj0 = current_player.biped.place_between_me_and(current_player.biped, sound_emitter_alarm_2, 0)
						if scrb_downed_timer <= 0 then -- then we're packing up and almost good to go
							current_player.biped.attach_to(temp_obj0, 2,0,0, relative)
						end
						if scrb_downed_timer > 0 then -- we're parking
							current_player.biped.attach_to(temp_obj0, -2,0,0, relative)
						end
						temp_obj0.set_scale(22)
						temp_obj0.copy_rotation_from(temp_obj0, true)
						current_player.biped.detach()
						temp_obj0.delete()
					end
				end
				
			end
		end
	end
	scrb_phys.attach_to(scrb_phys.socket, 0,0,0,relative)
	
   -- scenario interpolator special sauce
   if scenario_iterp_state == no_team then -- turn it off -- free action if we remove this condition??
      set_scenario_interpolator_state(1, 0)
   end
   if scenario_iterp_state == team[0] then -- turm it on
      set_scenario_interpolator_state(1, 1)
   end
end -- end of local code section --

-- squish players beneath the scarab as its going down!!
-- player squishing
if Scarab != no_object and Scarab.Setup == 1 and scarab_ready_timer.is_zero() and Scarab.downed_state > 0 and Scarab.downed_state < interp_down_ticks and scrb_downed_timer > 0 then
	for each player do
		if current_player.biped != no_object then
			-- multi ground shapes
			temp_num0 = 0
			for each object with label "B_Misc" do
				if current_object.spawn_sequence == 8 then 
					if current_object.shape_contains(current_player.biped) then
						temp_num0 = 1
					end
				end
			end
			-- if shape contains player or their vehicle, and the player biped is touching the ground, or they're in a vehicle
			-- basically if the player is getting sandwiched between the ground and the scarab bottom, or if they're in and vehicle and inside the scarab
			if squish_boundary.shape_contains(current_player.biped) or squish_boundary.shape_contains(current_player.p_vehicle) and temp_num0 == 1 or current_player.p_vehicle != no_object then
				current_player.biped.kill(false)
				if current_player.p_vehicle != no_object then
					current_player.p_vehicle.kill(false)
				end
			end
		end
	end
end


for each player do
   --if current_player.team == ELITES then
   script_widget[1].set_visibility(current_player, false)
   script_widget[0].set_visibility(current_player, false)
   script_widget[2].set_visibility(current_player, false)
   --end
end

-- redundancy here. no need for titlecard stuff to be in its own block here, can be put anywhere that player team is specified.
for each player do
   if current_player.team == ELITES then 
      --current_player.set_objective_text("Behold, Greatness\nBURN ANY DEMON IN YOUR WAY\nMade by Gamergotten. V%n.%n", 1, 2)
      --current_player.set_objective_text("Behold Gamergotten's magnum opus\nCRUSH THE VERMIN INTO THE GROUND\nMade by Gamergotten. Revamped by Rabid MagicMan")
      --current_player.set_objective_text("CRUSH THE VERMIN INTO THE GROUND\nBehold Gamergotten's magnum opus!\nRevamped by Rabid MagicMan")
      current_player.set_objective_text("GRIND THE VERMIN INTO DUST\nBehold Gamergotten's magnum opus!\nRevamped by Rabid MagicMan")
      --current_player.set_objective_text("GRIND THE VERMIN INTO DUST\nCleanse these lands of their filthy constructs!\nRevamped by Rabid MagicMan")

      --current_player.set_objective_allegiance_name("Offense")
      --current_player.set_objective_allegiance_name("Covenant")
      current_player.set_objective_allegiance_name("Scarab  Escort")
      current_player.set_objective_allegiance_icon(crosshair)           -- attack
      --script_widget[0].set_visibility(current_player, false)
      -- keep wdigets hidden during loadout cam, and after either side has won / during outro.
      if global_tick_counter > 600 and global.number[11] == 0 and Scarab.Setup > 0 then
         script_widget[2].set_visibility(current_player, true)
         -- non-territory objectives: show the 'capture the territory' widget to elites.
         if current_player.team == ELITES and c_goal.team == team[0] or c_goal.team == team[1] then
            script_widget[1].set_visibility(current_player, true)
         end
      end
   end
end


for each player do
   if global_tick_counter == 300 then     -- 5 seconds
      send_incident(invasion_game_start, current_player, no_player)
      send_incident(juggernaut_game_start, current_player, no_player)
      game.show_message_to(current_player, none, "Join our server!   discord.gg/eT8YqtnwxT")
   end
end
      
--for each player do
   --if global_tick_counter == 480 then     -- 8 seconds
      --game.show_message_to(current_player, none, "Shoutout to: Rabid Magicman, CleanserOfNoobs & A1ex W for ideas")
   --end
--end
for each player do
   if global_tick_counter == 720 then     -- 12 seconds
   --if global_tick_counter == 600 then
   --if global_tick_counter == 660 then     -- 11 seconds
      game.play_sound_for(SPARTANS, inv_boneyard_vo_spartan_p1_intro, false)         -- Securing this position is priority one spartans, hold off any attack
      --game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
      game.play_sound_for(ELITES, inv_boneyard_vo_covenant_p1_win, false)      -- Well done. Push forward and crush the human defenses.
      game.show_message_to(current_player, none, "Thanks to Mr Dr Milk & DavidJCobb for helping to bring this beast to life!")
   --end
   end
end

for each player do
   --if global_tick_counter == 480 then     -- 8 seconds
   if global_tick_counter == 1020 then     -- 18 seconds
      game.show_message_to(current_player, none, "Shoutout to: Rabid Magicman, CleanserOfNoobs & A1ex W for ideas")
   end
end

for each player do
   --if global_tick_counter == 1020 then     -- 17 seconds
   if global_tick_counter == 1380 then     -- 12 seconds
   --if global_tick_counter == 1080 then     -- 18 seconds
      game.show_message_to(current_player, none, "Mod by Gamergotten.   Edits by Rabid MagicMan")
      --game.show_message_to(current_player, none, "Edits: Rabid MagicMan")
   end
end
for each player do
   if current_player.team == SPARTANS then
      --current_player.set_objective_text("Behold, Greatness\nDestroy the Scarab before it demolishes your base! \nMade by Gamergotten. V%n.%n", 1, 2)
      --current_player.set_objective_text("Behold Gamergotten's magnum opus\nDestroy the Scarab before it demolishes your base! \nMade by Gamergotten. Revamped by Rabid MagicMan")
      --current_player.set_objective_text("Destroy the Scarab before it\ndemolishes your entire base! \nMade by Gamergotten. Revamped by Rabid")
      --current_player.set_objective_text("Destroy the Scarab before it burns\nour base to ashen glass! \nMade by Gamergotten. Revamped by Rabid")
      
      --current_player.set_objective_text("DESTROY THE SCARAB BEFORE IT BURNS\nOUR BASE TO ASHEN GLASS. \nMade by Gamergotten. Revamped by Rabid")       -- this one is nice.
      
      --current_player.set_objective_text("DESTROY THE SCARAB before it burns\nour base to ashen glass! \nMade by Gamergotten. Revamped by Rabid")
      --current_player.set_objective_text("DESTROY THE SCARAB\nBefore it burns our base to ashen glass!\nMade by Gamergotten. Revamped by Rabid")
      current_player.set_objective_text("DESTROY THE SCARAB\nBefore it burns our base to ash & glass!\nMade by Gamergotten. Revamped by Rabid")

      --current_player.set_objective_allegiance_name("Defense")
      current_player.set_objective_allegiance_name("UNSC")
      current_player.set_objective_allegiance_icon(noble)     -- defend
      --script_widget[2].set_visibility(current_player, false)
      -- keep wdigets hidden during loadout cam, and after either side has won / during outro.
      if global_tick_counter > 600 and global.number[11] == 0 and Scarab.Setup > 0 then
         script_widget[0].set_visibility(current_player, true)
         --if global_tick_counter == 1560 then                      -- 26 seconds
         --if global_tick_counter == 1800 then                      -- 30 seconds
            --game.show_message_to(current_player, none, "Objective: Cripple all 4 legs to expose the Scarab's core\nOptional:Destroy the AA Turret")
            --game.show_message_to(current_player, none, "Objective: Cripple all 4 legs to expose the Scarab's core!")
         --end
      end
   end
end















alias spartan_traits = script_traits[0]
alias elite_traits = script_traits[1]
--alias minor_traits = script_traits[2]
alias ranger_traits = script_traits[2]
alias general_traits = script_traits[3]
alias zealot_traits = script_traits[4]
alias brute_traits = script_traits[9]
--alias minor_biped_index = 2
alias ranger_biped_index = 2
alias general_biped_index = 3
alias zealot_biped_index = 4
alias brute_biped_index = 5

alias buff200_traits = script_traits[5]
alias supplied_traits = script_traits[6]

alias no_vehicles_traits = script_traits[7]

-- invasion stuff whatever
-- setup elite species
for each player do
   current_player.set_co_op_spawning(true)
   if current_player.team == ELITES then 
      current_player.apply_traits(elite_traits)
      current_player.set_loadout_palette(elite_tier_1)
      if current_player.biped != no_object then
         temp_obj0 = current_player.biped
         if temp_obj0.bpd_initialized == 0 and current_player.p_vehicle == no_object then
            -- if temp_obj6 != no_object then
            --    current_player.force_into_vehicle(no_object)
            -- end
            temp_obj1 = current_player.get_weapon(primary)
            temp_obj2 = current_player.get_weapon(secondary)
            -- if temp_obj1.is_of_type(plasma_launcher) then -- is a demolitions elite
            --    temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,minor)
            --    temp_obj4.bpd_initialized = minor_biped_index
            -- end
            if temp_obj1.is_of_type(plasma_repeater) then -- is a ranger elite
               temp_obj5 = temp_obj0.place_between_me_and(temp_obj0, jetpack, 0) 
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,space)
               temp_obj4.bpd_initialized = ranger_biped_index
            end
            if temp_obj1.is_of_type(fuel_rod_gun) then -- is a flak elite
               temp_obj5 = temp_obj0.place_between_me_and(temp_obj0, sprint, 0) 
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,minor)
               temp_obj4.bpd_initialized = general_biped_index
            end
            if temp_obj1.is_of_type(energy_sword) then -- is a zealot elite
               temp_obj5 = temp_obj0.place_between_me_and(temp_obj0, evade, 0) 
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,zealot)
               temp_obj4.bpd_initialized = zealot_biped_index
            end
            if temp_obj2.is_of_type(gravity_hammer) then 
               temp_obj5 = temp_obj0.place_between_me_and(temp_obj0, sprint, 0)
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0, 0, 0, general)
               temp_obj4.bpd_initialized = brute_biped_index
					-- brute flag decoration
                              -------- Traxus brute flag. Occurs at biped swap.   cheaper.
               temp_obj3 = temp_obj4.place_at_me(flag_stand, none, none, 0, 0, 0, none)
               temp_obj3.set_scale(5)
			      temp_obj5 = temp_obj4.place_at_me(flag, none, none, 0, 0, 0, none)
			      temp_obj5.team = brute_team				-- red team flag for brute
               --global.object[9].set_scale(20)                -- doesn't sync -- dont use this object reference!!!
			      --temp_obj5.number[6] = 20               -- no local scale ID in this gametype, so I'm gonna hardcode all flags to be 20 scale on local.
               temp_obj5.set_hidden(true)             -- hide the full sized flag on host so players can't invisibly shoot it.      re-add.
               temp_obj5.attach_to(temp_obj3, 8, 0, 25, relative)
               temp_obj3.attach_to(temp_obj4, 0, 1, 5, relative)
					--
			      temp_obj4.set_scale(112)
               --------
            end
            if temp_obj4 != no_object then -- error prevention
               temp_obj0.remove_weapon(secondary, false)
               temp_obj0.remove_weapon(primary, false)
               temp_obj4.attach_to(temp_obj0, 0,0,0,relative)
               temp_obj4.detach()
               temp_obj4.copy_rotation_from(temp_obj0, true)
               temp_obj0.delete()
               -- configure new biped
               current_player.set_biped(temp_obj4)
               current_player.biped.remove_weapon(primary, true)
               current_player.add_weapon(temp_obj1)
               current_player.add_weapon(temp_obj2)           -- fixed. gamergotten has this wrong order.
               current_player.frag_grenades = 0
					
               if not temp_obj1.is_of_type(fuel_rod_gun) then
						current_player.plasma_grenades = 2
               end
            end
         end
      end
   end
end
for each player do
   -- trait heirarchy, we'll probably have to revert it, but thats 4 free actions while its like this, or 3 i think
   temp_obj4 = current_player.biped 
   temp_obj0 = current_player.try_get_weapon(primary)
   if temp_obj4.bpd_initialized >= ranger_biped_index then 
      current_player.apply_traits(ranger_traits)
      if temp_obj4.bpd_initialized >= general_biped_index then 
         current_player.apply_traits(general_traits)
         if temp_obj4.bpd_initialized >= zealot_biped_index then 
            current_player.apply_traits(zealot_traits)
            if temp_obj4.bpd_initialized >= brute_biped_index then 
               current_player.apply_traits(brute_traits)
               -- infinite ammo for brutes holding concussion_rifle, just becuase they run out so fast on these big maps.
               if temp_obj0.is_of_type(concussion_rifle) then
                  current_player.apply_traits(supplied_traits)
               end
            end
         end
      end
   end
end
for each player do
   if current_player.team == SPARTANS then -- spartans are defending
      current_player.set_loadout_palette(spartan_tier_1)
      current_player.apply_traits(spartan_traits)
   end
end   
-- buff player plasma repeater traits
for each player do
   temp_obj0 = current_player.get_weapon(primary)
   if temp_obj0.is_of_type(plasma_repeater) then -- they gun needs a buff
      current_player.apply_traits(buff200_traits)
   end
end



-- brospawning stuff
for each object with label "S_Ob_Point" do
   if current_object.spawn_sequence == 0 or current_object.spawn_sequence == c_goal.spawn_sequence and current_object.team == team[0] or current_object.team == team[1] then
      current_object.set_spawn_location_permissions(allies)
   end   
end
for each object with label "S_Ob_Point" do
   if current_object.spawn_sequence != 0 and current_object.spawn_sequence != c_goal.spawn_sequence and current_object.team == team[0] or current_object.team == team[1] then
      current_object.set_spawn_location_permissions(no_one)
   end   
end

alias scarab_health_widget = script_widget[2]
alias objective_widget = script_widget[3]
alias scarab_status_widget = script_widget[0]
do
   --script_widget[1].set_value_text("Cargo Physics: you will experience jitter while inside")
   script_widget[1].set_text("Capture the human territory to advance")    -- Sieze
   --script_widget[2].set_text("Scarab Health")
   --script_widget[2].set_meter_params(timer, global.timer[2])
   script_widget[3].set_text("Fortified: Infinite Ammo")
   --script_widget[0].set_text("legs destroyed %n/%n\n (Core Locked)", scrb_mover.legs_destroyed, 4)
   --script_widget[0].set_text("Legs crippled %n/%n\n (Core Locked)", scrb_mover.legs_destroyed, 4)
   --script_widget[0].set_text("Cripple the Scarab's legs %n/%n", scrb_mover.legs_destroyed, 4)
   script_widget[0].set_value_text("Cripple the Scarab's legs %n/%n", scrb_mover.legs_destroyed, 4)
   --script_widget[2].set_text("Defend the Scarab & capture objectives %n/%n", scrb_mover.legs_destroyed, 4)
   --script_widget[2].set_text("Defend the Scarab's legs from ranged attacks %n/%n", scrb_mover.legs_destroyed, 4)
   --script_widget[2].set_text("Defend the Scarab's legs from ranged attacks", scrb_mover.legs_destroyed, 4)
   
      --script_widget[2].set_text("Defend our holy weapon from ranged attacks\nLegs weakened %n/%n", scrb_mover.legs_destroyed, 4)
      --script_widget[2].set_text("Defend our holy weapon from\nranged attacks. Legs harmed: %n", scrb_mover.legs_destroyed)
      --script_widget[2].set_text("Defend our holy weapon from\nranged attacks. Legs crippled: %n", scrb_mover.legs_destroyed)
      script_widget[2].set_value_text("Defend our holy weapon from\nranged attacks. Legs crippled: %n", scrb_mover.legs_destroyed)

      --script_widget[2].set_text("Clear the path for our holy weapon\nLegs weakened %n/%n", scrb_mover.legs_destroyed, 4)
      --script_widget[2].set_text("Keep the rats from harming our holy weapon on its righteous path", scrb_mover.legs_destroyed, 4)
   
   
   --script_widget[2].set_text("Defend the Scarab from ranged attacks. Legs crippled: %n/%n", scrb_mover.legs_destroyed, 4)
   --script_widget[2].set_text("Defend the Scarab from ranged attacks. Legs crippled: %n/%n", scrb_mover.legs_destroyed, 4)
   --script_widget[2].set_text("Keep the filth ", scrb_mover.legs_destroyed, 4)
	if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
      script_widget[0].set_value_text("Board the Scarab and destroy its core!")
      script_widget[2].set_value_text("Defend the Scarab's core from boarders!")
   end
end
for each player do 
   objective_widget.set_visibility(current_player, false)
   if current_player.p_vehicle == no_object then
      for each object with label "S_Ob_Point" do
         if current_object.team == team[2] and current_object.shape_contains(current_player.biped) then
            objective_widget.set_visibility(current_player, true)
            current_player.apply_traits(supplied_traits)
         end
      end
   end
end
for each player do
	if current_player.biped != no_object then
		temp_num0 = AA_turret.get_distance_to(current_player.biped)
		if temp_num0 == 0 then
			current_player.biped.detach()
		end
	end
end

-- HERE
-- if game.round_time_limit > 0 and game.round_timer.is_zero() and game_end_state == 0 then 
--    UNSC_WIN()
-- end

alias ticks_till_game_end_after_destroy = -600
if game_end_state < 0 then 
   game_end_state -= 1
   if game_end_state < ticks_till_game_end_after_destroy then         -- change outro period duration here. originally 5 seconds.    -300
      game.end_round()
   end
end



-- Species specific vehicles
for each player do
   if current_player.is_elite() and current_player.p_vehicle.is_of_type(scorpion) or current_player.p_vehicle.is_of_type(falcon) or current_player.p_vehicle.is_of_type(warthog) or current_player.p_vehicle.is_of_type(sabre) then
      current_player.apply_traits(no_vehicles_traits)
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
   if current_player.is_spartan() and current_player.p_vehicle.is_of_type(banshee)then
      current_player.apply_traits(no_vehicles_traits)
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
end

-- Species specific weapons.  luxury.
for each player do
   temp_obj0 = current_player.try_get_weapon(primary)
   if current_player.is_elite() and temp_obj0.is_of_type(rocket_launcher) or temp_obj0.is_of_type(grenade_launcher) or temp_obj0.is_of_type(sniper_rifle) or temp_obj0.is_of_type(DMR) or temp_obj0.is_of_type(shotgun) or temp_obj0.is_of_type(assault_rifle) or temp_obj0.is_of_type(magnum) then
      current_player.biped.remove_weapon(primary, false)
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
   -- stowable turrets
   --if temp_obj0.is_of_type(golf_club) then
      --if current_player.is_elite() then
         --current_object.set
      --end
   --end
end


--- test
--for each object with label "L_Damage" do
   --temp_num0 = current_object.health
   --current_object.object[0].set_waypoint_visibility(everyone)
   --current_object.object[0].set_waypoint_icon(bomb)
   --current_object.object[1].set_waypoint_visibility(everyone)
   --current_object.object[1].set_waypoint_icon(bullseye)
--end


alias previous_health = object.number[5]

-- leg waypoint blinking
for each object with label "L_Damage" do
   temp_obj0 = current_object.dam_waypoint
   temp_obj0.fadeaway_ticks += 1
   --if current_object.team != team[2] then 
	temp_num0 = current_object.health      
	-- legs die at 50 health, core dies at 0 health, so this section normalises the waypoint to 100 units for legs only.
	if scrb_mover.legs_destroyed < 4 then
		temp_num0 -= 49
		temp_num0 *= 2
		-- what da heellllll
		--temp_num0 /= 2
		--temp_num1 = 100
		--temp_num1 -= temp_num0
		--temp_num1 *= 2
		--temp_num0 = 100
		--temp_num0 -= temp_num1
		--temp_num0 += 2      -- this stops the waypoint ever showing '0', but means the waypoint won't initially show till hp has been reduced to 96%.
	end
	if temp_num0 < temp_obj0.display_health then -- and temp_num0 < 99 then 
		temp_obj0.display_health = temp_num0
		temp_obj0.set_waypoint_priority(blink)
		temp_obj0.fadeaway_ticks = -180
		temp_obj0.set_waypoint_timer(1)
	end
	if temp_obj0.fadeaway_ticks > 0 then
		temp_obj0.set_waypoint_priority(low)        -- normal
		temp_obj0.set_waypoint_timer(none)
		if scrb_mover.legs_destroyed >= 4 then
			temp_obj0.set_waypoint_text("Core")
		end
	end
   --end
end


--if scrb_mover.legs_destroyed >= 4 then














-- CHECK ALIASES -- (this ones on you mr rabbit)
for each player do
   --temp_obj2 = current_player.biped
   --temp_obj0 = current_player.try_get_vehicle()
   temp_obj5 = current_player.try_get_weapon(primary)
   temp_obj6 = current_player.try_get_weapon(secondary)
   temp_obj4 = current_player.try_get_armor_ability()
   -- infinite unlimited sprint
   if temp_obj4.is_of_type(sprint) then 
      current_player.apply_traits(script_traits[8])
   end
   -- back mounted machine gun
   if temp_obj4.is_of_type(drop_shield) and current_player.is_spartan() then
      -- remove back weapon when in vehicles
      --if temp_obj0 != no_object and temp_obj5.is_of_type(spiker) then
         --temp_obj5.delete()
      --end
      --if temp_obj0 == no_object then
         --if temp_obj6 == no_object then
            --temp_obj2.add_weapon(spiker, force)
         --end
		if not temp_obj5.is_of_type(detached_machine_gun_turret) and not temp_obj5.is_of_type(assault_rifle) then -- and not temp_obj5 == no_object and temp_obj4.object[0] == no_object then  		-- redundancy test		-- be careful not to do this to a leftover temp_obj6
         temp_obj6.set_scale(1)
         --temp_obj4.set_scale(10)
         temp_obj4.object[1].set_scale(90)
-- machine gun from SvS invasion portable turret
         -- visual luxury
         if temp_obj4.object[1] == no_object and temp_obj4 != no_object then			-- second condition is a failsafe. Otherwise no players without AA will spawn gun every tick & overload map.
            temp_obj3 = temp_obj4.place_between_me_and(temp_obj4, flag_stand, 0)
            temp_obj4.object[1] = temp_obj6.place_between_me_and(temp_obj6, detached_machine_gun_turret, 0)      -- using temp_obj3 so that it just drops off map for clients until Duck's attach bug hotfix.
            temp_obj4.object[1].set_scale(90)
            --temp_obj4.object[1].copy_rotation_from(temp_obj6, true)
            temp_obj4.object[1].attach_to(temp_obj3, -25,-12,15,relative)          -- -20,-10,10       was very nearly right.        -20,-10,20, slightly too oneside.d
            temp_obj3.set_scale(5)
            temp_obj3.copy_rotation_from(temp_obj6, true)
            temp_obj3.attach_to(temp_obj4, 0,0,0,relative)
         end
		end
      if temp_obj5 != no_object and not temp_obj5.is_of_type(detached_machine_gun_turret) and temp_obj6 == no_object and temp_obj4.object[0] == no_object then      -- temp_obj5.is_of_type(shotgun) and temp_obj4.number[1] < 2 and
       --temp_obj5.object[0].delete() 			-- delete attached machine gun visual. This could be moved out of the IFs if desired, since no primary weapon should have an attached turret.
         temp_obj4.object[1].set_scale(1)
         --current_player.biped.add_weapon(shotgun, force)
         --current_player.biped.add_weapon(assault_rifle, force)
         current_player.biped.add_weapon(assault_rifle, secondary)
      end
      if temp_obj5.is_of_type(assault_rifle) then 
         current_player.biped.remove_weapon(primary, true)
         --current_player.biped.add_weapon(needler, force)
         current_player.biped.add_weapon(detached_machine_gun_turret, force)
         --if temp_obj0 != no_object then      -- Note: for completeness you can uncomment the condition so it doesn't hide visual machine gun while in vehicle passenger. luxury. 
            temp_obj4.object[1].set_scale(1)
         --end
      end
    -- marking droppables for later deletion
      if temp_obj5.is_of_type(detached_machine_gun_turret) then  -- or temp_obj5.is_of_type(bomb) then 
         temp_obj4.object[0] = temp_obj5
      end
    -- delete dropped bomb or machine gun. could expand this to delete dropped assault rifles if you also say "!= temp_obj6"
      if temp_obj4.object[0] != temp_obj5 then 
         temp_obj4.object[0].delete()
      end
   end
end




-- CHECK ALIASES -- (this ones on you mr rabbit)
-- NEW AA shade, and respawnable warthog turrets!        -- search "old AA shade removed"  to find script parts to delete if copying into another gametype.
---- re-add
-- NEW AA shade, and respawnable warthog turrets!        -- search "old AA shade removed"  to find script parts to delete if copying into another gametype.
for each object with label "create" do
   if current_object.spawn_sequence >= 4 and current_object.spawn_sequence <= 8 then -- or current_object.spawn_sequence == 40 then   -- current_object.spawn_sequence == 31 or current_object.spawn_sequence == 32  then
      --team_phase_indicator()
      if current_object.number[0] != 5 then
         current_object.number[0] = 5
         -- Spirit drop ship respawn zone
         --if current_object.spawn_sequence == 40 and not current_object.team == team[3] then
				-- dont use global.object[8] if uncommenting
            --global.object[8] = current_object.place_at_me(hill_marker, "inv_res_zone",none, 0,0,50,none)
            --global.object[8].team = team[1]
            --global.object[8].number[7] = 43       -- ID for drop pods      council's hand respawn zone ID (for pseudopod)
            --global.object[8].set_shape(cylinder, 35, 35, 100)       -- bigger radius than needed. Some elites weren't getting pseudopod in multiplayers, lets find out if this is why.
            --current_object.object[3] = global.object[8]           -- nest for constant attach-detaching
         --end
         -------
         if current_object.spawn_sequence == 4 then 
            current_object.object[0] = current_object.place_at_me(warthog_turret, none, none, 0, 0, 0, none)
		   end
         ------ Scarab V4 removed for space
         --if current_object.spawn_sequence == 6 then 
            --current_object.object[0] = current_object.place_at_me(warthog_turret_rocket, none, none, 0, 0, 0, none)
			--end
         --if current_object.spawn_sequence == 5 then 
            --current_object.object[0] = current_object.place_at_me(shade, none, none, 0, 0, 0, auto)
         --end
         ---------- All created objects
         --if not current_object.spawn_sequence == 40 and not current_object.spawn_sequence == 8 then
            --current_object.object[0].copy_rotation_from(current_object, true)			-- semi redundant. Tilt doesn't work for warthog turrets anyway, so no gameplay reason to copy rotation.
		   	current_object.object[0].attach_to(current_object, 0, 0, 0, relative)		-- also semi-redundant. I don't think turret spawning is put off by objects (remembering from engineer)
            current_object.object[0].detach()
            --current_object.attach_to(temp_obj3, 0,0,0,relative)
         --end
      end
   end
end
-- respawn time for warthog turrets and AA shades 
for each object with label "create" do
   if current_object.spawn_sequence >= 4 and current_object.spawn_sequence <= 6 then
      if current_object.object[0] == no_object and current_object.number[0] == 5 then
         current_object.delete()
      end
   end
end


for each object with label "Detonation" do
   current_object.detach()
   current_object.ex_del1.delete()
   current_object.set_scale(1)
end



-- to multiplayer test:

-- 1) fireteam spawning into vehicles as the sentry class
-- 2) 





