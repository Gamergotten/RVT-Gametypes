
alias verion_prefix = 1
alias version_vers  = 01
-- eg 0.8

-- i hate invasion teams, why doesn't it JUST work
declare global.team[0] with network priority local = team[0]
declare global.team[1] with network priority local = team[1]
alias ATTACKERS = global.team[1]
alias DEFENDERS = global.team[0]

on pregame: do -- is this needed?
   game.symmetry = 0
end
-- timers & stuff
declare global.team[2] with network priority high = no_team
alias scenario_iterp_state = global.team[2]

declare global.timer[0] = 5
alias scarab_ready_timer = global.timer[0]
declare global.timer[1] = 8 
alias under_attack_timer = global.timer[1]

declare global.timer[2] = 250
alias scarab_health_display = global.timer[2]

do 
   scarab_ready_timer.set_rate(-100%)
   under_attack_timer.set_rate(-100%)
   scarab_health_display = 0
end
function call_attack_on_objective()
   if under_attack_timer.is_zero() then
      game.play_sound_for(DEFENDERS, announce_a_under_attack, true)
   end
   under_attack_timer.reset()
end
--- variable stuff + aliases
-- on init: do -- flip the teams if neccessary
   --    global.number[0] = game.current_round
   --    global.number[0] %= 2
   --    if global.number[0] == 1 then -- is the second round
   --       ATTACKERS = team[0]
   --       DEFENDERS = team[1]
   --       for each object with label "S_Ob_Point" do
   --          global.number[0] = 0
   --          if current_object.team == team[0] then
   --             global.number[0] = 1
   --             current_object.team = team[1]
   --          end
   --          if current_object.team == team[1] and global.number[0] == 0 then
   --             current_object.team = team[0]
   --          end
   --       end
   --    end
   -- end

declare global.object[0] with network priority local
declare global.object[1] with network priority local
declare global.object[2] with network priority local
declare global.object[4] with network priority local
declare global.object[5] with network priority local
declare global.object[6] with network priority local
declare global.object[7] with network priority local
declare global.object[8] with network priority local
declare global.object[9] with network priority local
declare global.object[15] with network priority local 

declare global.object[10] with network priority high
alias Scarab = global.object[10]

declare global.object[11] with network priority local 
alias c_goal = global.object[11]

-- declare global.object[12] with network priority local
-- alias c_objective = global.object[12]

-- declare global.object[13] with network priority local
-- alias c_bomb_spawn = global.object[13]

declare global.object[14] with network priority local 
alias projectile_collision_test_agent = global.object[14]

declare global.object[13] with network priority low
alias scrb_mover = global.object[13]

declare global.object[3] with network priority local -- shield object

declare global.number[0] with network priority local
declare global.number[1] with network priority local
declare global.number[2] with network priority local
declare global.number[3] with network priority local
declare global.number[4] with network priority local
declare global.number[5] with network priority local

declare global.number[6] with network priority local -- host indicator
declare global.number[7] with network priority local -- host indicator2
declare global.number[8] with network priority low   -- host "update debris" calls count
declare global.number[9] with network priority local -- client "update debris" current amount
alias UpdateDebris_HOST = global.number[8]
alias UpdateDebris_CLIENT = global.number[9]

declare global.number[10] with network priority local -- can be merged with host indicator, used to toggle through debris to cement every second one
alias perma_debris_toggle = global.number[10]

declare global.number[11] with network priority local -- game end state, we set this when either the scarab blows up, or all the buildings collapse
alias game_end_state = global.number[11]

declare object.number[0] with network priority low
declare object.number[1] with network priority local
declare object.number[2] with network priority low
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
alias temp_obj6 = global.object[7] -- completely unused? nice, saves me some effort
alias temp_obj7 = global.object[15]

alias mover_agent1 = global.object[8]
alias mover_agent2 = global.object[9]

alias temp_num0 = global.number[0] -- is returned by "X_to_Short()" & "acos_int_int_max_megalo_half()"
alias temp_num1 = global.number[1]
alias temp_num2 = global.number[2]
alias temp_num3 = global.number[3]
alias temp_num4 = global.number[4]
alias temp_num5 = global.number[5]

alias host_indicator = global.number[6]
alias temp_poopoo = global.number[7]
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
-- AI mover stuff (technically also Base, but we overflowed to this object for more room)
alias l_prong = object.object[0]
alias r_prong = object.object[1]
alias B_core = object.object[3]
alias rotation_ticks = object.number[1]
alias legs_destroyed = object.number[2] -- sync this number
alias legs_destroyed_to_perma_down = 4

alias time_till_retarget = object.number[5]
alias min_retarget_time = 60
alias rand_retarget_time = 150
alias downed_timer = object.number[6]
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

-- joint rotation stuff (Upper)
alias initialized = object.number[0]
alias UpperLenght = object.number[2]
alias LowerLength = object.number[3]
alias outta_bounds_for = object.number[5]
alias socket = object.object[0] 
alias pitch = object.object[1]
alias knee = object.object[2]
alias foot = object.object[3]
-- joion rotation stuff (Lower, tracking leg damage) 
--alias socket = object.object[0] -- already declared
alias L_destoyed = object.number[1] -- used to determine if this leg has been destroyed already
alias D_child = object.object[1] -- used to tell if the child has been destroyed -- send a message to parent to be disabled
alias D_cleanup = object.object[2]
alias visual_splode = object.object[3] -- bomb explosion
alias core_health = script_option[2] -- this will be assigned to the object labelled "L_Damage" with team nuetral
alias leg_health  = script_option[3] --0 this will be assigned to the object labelled "L_Damage" not on neutral team


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
alias r_base = player.object[0]
alias r_offset = player.object[1]
alias r_last = player.object[2]


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

-- -- turret stuff
-- alias t_socket = object.object[0]
-- alias t_turret = object.object[1]
-- alias t_initialized = object.number[1]
-- -- operator station stuff
-- alias turret_object = object.object[0]
-- alias turret_biped = object.object[1] -- scale to 1 and set invincible
-- alias operator_biped = object.object[2]

-- alias use_cooldown_ticks = object.number[1]

-- alias last_operator = object.player[0]
alias bp_owner = object.player[1]

-- alias turret_enter_cooldown = 180

-- objective aliases
alias ob_status = object.number[1]
-- alias health_configured = object.number[5]
-- for each object with label "S_Objective" do -- setup the objective object's health
--    if current_object.team == team[2] or current_object.team == team[3] or current_object.team == team[4] 
--    and current_object.health_configured == 0 then 
--       current_object.health_configured = 1
--       current_object.max_health = building_health
--       setting_objective_max_health()
--    end
-- end
-- '0': uninitialized
-- '1': in progress 
-- '2': completed
alias enemy_icon = object.object[0]
alias ally_icon = object.object[1]

declare object.timer[0] = script_option[0] -- 15
alias ob_cap_time = object.timer[0] -- time to capture zone
alias theoretical_damage = object.number[4]

--declare object.timer[1] = 8
--declare object.timer[2] = 15
--declare object.timer[3] = 7
--alias ob_arm_time = object.timer[1] -- time to arm bomb
--alias ob_countdown_time = object.timer[2] -- time for it to go off
--alias ob_disarm_time = object.timer[3] -- time to disarm

--alias is_planted = object.number[4]

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

-- used only in the first segment
alias numerator = temp_num1
alias denominator = temp_num2
-- used in X calculations
alias shield_object = global.object[3]
--alias c_sign = temp_num4
alias _X_numerator = object.number[6]
alias _X_denominator = object.number[7]
alias another_temp = temp_num3

-- not used yet
alias a = object.number[1]
alias b = object.number[4]
alias c = object.number[5]
alias R_a = temp_num1
alias R_b = temp_num2

--alias ant_sign = temp_num5

alias rotation_object = current_object.pitch
-- we probably dont use negative numbers, so i've commented that out
function X_to_Short()
   -- move X into reable range (however, i dont think we need thse)
   shield_object.shields *= 10000
   shield_object.shields *= 10000

   temp_num0 = shield_object.shields -- read the first 3 digits, 
   shield_object.shields -= temp_num0 -- scrape off the first 3 digits
   shield_object.shields *= 10000 -- move the next two digits forward
   temp_num0 *= 100 -- move the digits read so far, forward as well, to make room for the next digits to be read
   another_temp = shield_object.shields
   temp_num0 += another_temp
   --temp_num0 *= c_sign -- so it becomes negative if the sign is negative
end
function _X()
   -- c_sign = 1 -- reset sign
   -- if shield_object._X_numerator < 0 then
   --    shield_object._X_numerator *= -1
   --    c_sign ^= 1
   -- end
   -- package SHORT into parsable values of less than 400
   another_temp = shield_object._X_numerator
   another_temp /= 100 -- this is the first 3 digits
   temp_num0 = another_temp
   temp_num0 *= 100 -- this is the first 3 digits in their respective slots
   shield_object._X_numerator -= temp_num0 -- this is the last 2 digits in their respective slots
   -- initialize object shield value 
   -- add lower two digits and move it back, so we can assign the upper 3 digits
   shield_object.shields = shield_object._X_numerator
   shield_object.shields /= 10000
   shield_object.shields += another_temp
   -- move decimal back further, so we have room to divide incorrectly
   shield_object.shields /= 10000
   shield_object.shields /= 10000
   -- complete division, now that the values are correctly configured
   -- handle the denominator and check whether it needs un-negitivifying
   -- if shield_object._X_denominator < 0 then
   --    shield_object._X_denominator *= -1
   --    c_sign ^= 1
   -- end
   shield_object.shields /= shield_object._X_denominator
   -- if either were negative then the sign is negative, otherwise if both or none were negative, then its positive
   -- if c_sign != 1 then
   --    c_sign = -1
   -- end
end

function assign_is_valid_to_caclulate_values()
   shield_object.c = temp_num0
   temp_num0 = 0 -- clean this value
end

alias c_UpperToDestinationLength = temp_num4 -- 24
function CalculateJointAngle() 
   denominator = current_object.UpperLenght -- upper line length (line A)
   denominator *= denominator
   temp_num0 = current_object.LowerLength -- lower line length (line B)
   temp_num0 *= temp_num0
   numerator = c_UpperToDestinationLength -- other line lenth (line C)
   numerator *= numerator
   -- assemble numerator
   numerator += denominator
   numerator -= temp_num0
   -- find denominator
   denominator = 2
   denominator *= c_UpperToDestinationLength
   denominator *= current_object.UpperLenght
   shield_object._X_numerator = numerator
   shield_object._X_denominator = denominator
   -- run the thingo function
   -- now we have the value or something
      _X()
         shield_object.shields *= 10000
      X_to_Short()
      R_a = 0 -- just to make sure we dont let anything slip through
      --ant_sign = 0
      -- if temp_num0 < 0 then
      --    temp_num0 *= -1
      --    ant_sign = 18000
      -- end
      if temp_num0 >= 0 and temp_num0 < 6000 then -- is in the body section
         shield_object.a = 0
         shield_object.b = 6000
         -- 90 - 53.1301
         R_a = 9000
         R_b = 5313
         assign_is_valid_to_caclulate_values()
      end
      if temp_num0 >= 6000 and temp_num0 < 8400 then -- is in the mid section
         shield_object.a = 6000
         shield_object.b = 8400
         -- 53.1301 - 32.85988
         R_a = 5313
         R_b = 3286
         assign_is_valid_to_caclulate_values()
      end
      if temp_num0 >= 8400 and temp_num0 < 9600 then -- is in the head section
         shield_object.a = 8400
         shield_object.b = 9600
         -- 32.85988 - 16.2602
         R_a = 3286
         R_b = 1626
         assign_is_valid_to_caclulate_values()
      end
      if temp_num0 >= 9600 and temp_num0 < 10000 then -- is in the tip section
         shield_object.a = 9600
         shield_object.b = 10000
         -- 16.2602 - 0 
         R_a = 1626
         R_b =    0
         assign_is_valid_to_caclulate_values()
      end
      if temp_num0 == 0 then -- then we managed to find an angle
         shield_object._X_denominator = shield_object.b -- is now free
         shield_object._X_denominator -= shield_object.a
         shield_object._X_numerator = 10000
         _X()
            shield_object.c -= shield_object.a
            shield_object.shields /= 10000
            shield_object.shields *= shield_object.c
            shield_object.c = R_a
            shield_object.c -= R_b
            --shield_object.shields /= 10000
            shield_object.shields *= shield_object.c
         X_to_Short()
         R_a -= temp_num0
         -- if ant_sign == 18000 then -- it was in the negatives, so do some quick maths
         --    game.show_message_to(all_players, none, "impossible negative angle detected %n", R_a)
         --    ant_sign -= R_a
         --    R_a = ant_sign
         -- end
      end
   -- resolve the angle via rotation table
      if R_a >= 9000 then -- 90 degrees 
         rotation_object.face_toward(rotation_object, 0, -1, 0 ) -- 90 degrees rotation
         R_a -= 9000
      end
      if R_a >= 4500 then -- 45 degrees 
         rotation_object.face_toward(rotation_object, 1, -1, 0 )
         R_a -= 4500
      end
      if R_a >= 2250 then -- 22.5 degrees 
         rotation_object.face_toward(rotation_object, 70, -29, 0 )
         R_a -= 2250
      end
      if R_a >= 1125 then -- 11.25 degrees 
         rotation_object.face_toward(rotation_object, 126, -25, 0 )
         R_a -= 1125
      end
      if R_a >= 562 then -- 5.625 degrees 
         rotation_object.face_toward(rotation_object, 71, -7, 0 )
         R_a -= 562
      end
      if R_a >= 281 then -- 2.8125 degrees 
         rotation_object.face_toward(rotation_object, 122, -6, 0 )
         R_a -= 281
      end
      if R_a >= 140 then -- 1.40625 degrees 
         rotation_object.face_toward(rotation_object, 122, -3, 0 )
         R_a -= 140
      end
      if R_a >= 70 then -- 0.703125 degrees 
         rotation_object.face_toward(rotation_object, 81, -8, 0 )
         R_a -= 70
      end
      if R_a >= 45 then -- 0.45113 degrees 
         rotation_object.face_toward(rotation_object, 127, -1, 0 )
         R_a -= 45
      end
end


-- //// INPUTS ////
alias lookat_obj = temp_obj2
alias basis = temp_obj3
alias offset_scale = temp_num0
-- //// OUTPUTS ////
alias yaw_obj = temp_obj0
alias pitch_obj = temp_obj1 -- this actually gets deleted, and not outputed
alias offset_obj = temp_obj1
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
   offset_obj = yaw_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
   offset_obj.copy_rotation_from(current_object, true)
   offset_obj.attach_to(yaw_obj, 100,0,0, relative)
   -- now we just do the attaching forward
   -- set scale of yaw obj, thus scaling the attachment offset of offset_obj
   yaw_obj.set_scale(offset_scale)
   yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
end
function config_thingo()
   pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
   basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
end

-- function x47_optimized()
   --    if lookat_obj.spawn_sequence != 0 then
   --       temp_num0 = 100 -- +1 action
   --       temp_num1 = lookat_obj.spawn_sequence
   --       -- this first condition adds 1 if spawn sequence is -10, it then takes it back if the number is smaller than that
   --       -- this saves us from having to nest a condition further down, which in total saves a trigger 
   --       if lookat_obj.spawn_sequence < -9 then -- +1 condition
   --          temp_num0 += 1 -- +1 action
   --          if lookat_obj.spawn_sequence < -10 then 
   --             temp_num0 -= 1 -- +1 action
   --             temp_num1 += 101
   --             temp_num1 *= 2
   --             temp_num0 += 1000 -- +1 action
   --             if lookat_obj.spawn_sequence > -71 then 
   --                temp_num1 *= 2
   --                temp_num0 += -600 -- +1 action
   --                if lookat_obj.spawn_sequence > -41 then 
   --                   temp_num1 *= 3
   --                   temp_num1 /= 2
   --                   temp_num0 += -1200 -- +1 action
   --                end
   --             end
   --          end
   --       end
   --       temp_num1 *= 10
   --       --temp_num1 += 100 -- -1 action
   --       temp_num1 += temp_num0 -- +1 action

   --       lookat_obj.set_scale(temp_num1)
   --       lookat_obj.copy_rotation_from(lookat_obj, true)
   --    end
   -- end
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

function offset_attach_actual()
   lookat_obj = temp_obj6.place_between_me_and(temp_obj6, sound_emitter_alarm_2, 0)
   offset_scale = lookat_obj.get_distance_to(pitch_obj)
   basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   yaw_obj.designated_scale = offset_scale
   lookat_obj.delete()
   lookat_obj = temp_obj6
   if lookat_obj.has_forge_label("B_Attach") or lookat_obj.has_forge_label("U_Attach") 
   or lookat_obj.has_forge_label("L_Attach") or lookat_obj.has_forge_label("L_Damage") then -- only scale objects that are marked to support scaling
      _330x()
   end
   temp_obj6.attach_to(offset_obj, 0,0,0,relative)
   yaw_obj.attach_to(basis, 0,0,0,relative)
   yaw_obj.parent = basis
   yaw_obj.offset = offset_obj
   yaw_obj.block = temp_obj6
   yaw_obj.has_scaled = 1
   yaw_obj.team = temp_obj6.team
end
function offset_attach_step2()
   -- place pitch and yaw objects
   pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, "configure_scale", none, 0,0,0, none)
   offset_attach_actual()
end
function offset_attach_object()
   temp_obj6 = current_object
   offset_attach_step2()
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

alias ticks_till_first_explosion = -130
alias ticks_till_second_explosion = -190
alias ticks_till_third_explosion = -230

alias ticks_till_sim_physics = -300
alias ticks_till_sim_physics_end = -450

alias ticks_till_legs_detach = -330

alias ticks_till_meltdown = -395
alias ticks_till_meltdown_end = -1000

alias ticks_till_game_end_scarab_destroyed = -280

function setup_bomb()
   temp_obj0 = temp_obj1.place_at_me(covenant_bomb, "Detonation", none, 0,0,0,none)
   --temp_obj0.countdown_ticks = rand(rand_countdownticks)
   --temp_obj0.countdown_ticks += min_countdownticks
   temp_obj0.countdown_ticks = 40
   temp_obj0.attach_to(temp_obj1,0,0,0,relative)
end
function splode_leg_joint()
   current_object.detach()
   temp_obj0 = current_object.place_between_me_and(current_object, dice, 0)
   temp_obj1 = current_object.place_at_me(landmine,none,none,-3,0,0,none)
   temp_obj1.kill(true)
   current_object.attach_to(temp_obj0,0,0,0,relative)
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
if Scarab != no_object and Scarab.Setup < 0 then
   -- simulate physics effect (use Scarab.sight as a placeholder)
   if Scarab.Setup == ticks_till_sim_physics then
      Scarab.sight = Scarab.place_between_me_and(Scarab, dice, 0)
      Scarab.sight.copy_rotation_from(Scarab, true)
      -- Scarab.detach() -- unneeded
      Scarab.attach_to(Scarab.sight, 0,0,0,relative)
   end
end
if Scarab != no_object and Scarab.Setup < 0 then
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
if Scarab != no_object and Scarab.Setup < 0 then
   -- end physics simulation
   if Scarab.Setup == ticks_till_sim_physics_end then
      Scarab.detach()
      Scarab.sight.delete()
   end
end
if Scarab != no_object and Scarab.Setup < 0 then
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
if Scarab != no_object and Scarab.Setup < 0 then
   if Scarab.Setup == ticks_till_game_end_scarab_destroyed then
      game_end_state = -1
      game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
      game.play_sound_for(DEFENDERS, inv_boneyard_vo_spartan_p1_win, true) -- unsc
      game.play_sound_for(ATTACKERS, inv_boneyard_vo_covenant_p3_loss, true) -- covenant
   end
end

-- temp_obj7: boundary that the player has be in
function evalutate_target()
   if temp_obj0 != no_object and not Scarab.shape_contains(temp_obj0)  then
      if temp_num2 != 0 then -- is not on the turrets of the scarab
         if Scarab.sight.shape_contains(temp_obj0) then -- favour players in sightline
            temp_num2 /= 4 -- make it prioritize players who are in its sightlines, opposed to players who aren't
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
   Scarab.detach()
   projectile_collision_test_agent.set_scale(100)
   projectile_collision_test_agent.copy_rotation_from(projectile_collision_test_agent, true)
end
function reset_scarab_firing_state()
   Scarab.firing_mode = f.moving
   Scarab.firing_ticks = 0
end
function setup_objective_marker_vis()
   temp_obj0 = Scarab.s_target.place_between_me_and(Scarab.s_target, hill_marker, 0)
   temp_obj0.set_waypoint_priority(high)
   temp_obj0.team = DEFENDERS
   temp_obj0.attach_to(c_goal, 0,0,0,relative)
end
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
   temp_num0 = temp_obj0.W_yaw.get_distance_to(temp_obj1)
   -- reattach
   temp_obj0.W_pitch.attach_to(temp_obj0.W_yaw, 0,0,0,relative)
end

function Scarab_visual_face_towards_target()
   -- orientate turret to face towards
   temp_obj1 = Scarab.s_target
   thingo_face_towards()
   temp_obj0.W_yaw.attach_to(temp_obj0, 0,0,0,relative)
   -- configure guns
   --temp_obj0.W_visual.set_shape(cylinder, 3, temp_num0, 1)
end
function configure_projectile()
   temp_obj3.detach()
   temp_obj3.p_mover.set_scale(1)
   temp_obj3.copy_rotation_from(temp_obj0.W_pitch, true)
   --temp_obj3.p_mover.copy_rotation_from(temp_obj3, true)
   --temp_obj3.p_mover.attach_to(temp_obj3,0,0,0,relative)
end
function setup_yaw_pitch_objects()
   pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   attach_rotate_basis()
   yaw_obj.copy_rotation_from(basis, true)
   pitch_obj.detach()
end
function Scarab_interp_face_towards()
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
   end
end
-- B_turret stuff
alias t_socket = object.object[0]
alias t_target = object.object[3]
alias t_fire_ticks_interval = object.number[4]
alias t_max_fire_ticks_interval = 30
alias t_retarget_interval = object.number[5]
alias t_max_retarget_interval = 280
alias t_shots_in_burst = object.number[6]
alias t_max_shots_in_burst = 7
alias t_cooling_ticks = 900
--alias max_aa_shoot_range = 950
alias t_is_attached = object.number[7]
alias t_last_health = object.number[7] -- cheeky

alias seraph_health = script_option[5]

function turret_lookat()
   temp_obj0 = current_object
   temp_obj1 = current_object.t_target -- already set, conincidently -- nevermind
   thingo_face_towards()
   current_object.W_yaw.attach_to(current_object.t_socket, 0,0,0,relative)
end
function setup_scarab_mover_agent()
   Scarab.detach() 
   projectile_collision_test_agent.copy_rotation_from(Scarab, true)
   projectile_collision_test_agent.attach_to(Scarab,0,0,0,relative)
   projectile_collision_test_agent.detach()
end

if Scarab != no_object and Scarab.Setup == 1 and scarab_ready_timer.is_zero() then -- has been initialized
   --temp_obj0 = Scarab.sight
   --temp_obj0.W_visual.set_shape_visibility(no_one)

   --scrb_mover = Scarab.mover
   temp_num0 = scrb_mover.B_core.health
   -- if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
   --    scrb_mover.downed_timer = max_downed_timer
   -- end
   if scrb_mover.B_core == no_object or temp_num0 <= 0 then
      scenario_iterp_state = team[0]
      game.show_message_to(all_players, none, "Scarab DESTROYED!!!")
      Scarab.Setup = -1 -- disable the scarab AI
      Scarab.downed_state = -1
      Scarab.sight.delete()
      Scarab.proximity.delete()
      Scarab.detach()
      scrb_mover.attach_to(Scarab, 0,0,0,relative)
      --scrb_mover.delete()
   end
   temp_num0 /= 2
   scarab_health_display += temp_num0
   -- if the scarab has been downed, play the downed script
   if Scarab.downed_state > 0 then
      -- clear values from turret
      for each object with label "B_Turret" do
         if current_object.team != team[2] then
            current_object.t_target = no_object
         end
      end
      -- end visibility for turret thing
      scrb_mover.downed_timer -= 1 -- counting down, including the time it took to 
      if Scarab.downed_state < interp_down_ticks or scrb_mover.downed_timer <= 0 then -- should be interpolating atm
         setup_scarab_mover_agent()
         if scrb_mover.downed_timer <= 0 then -- then we're packing up and almost good to go
            Scarab.attach_to(projectile_collision_test_agent, 0,0, 2, relative)
            Scarab.downed_state -= 1
         end
         if scrb_mover.downed_timer > 0 then -- we're parking
            Scarab.attach_to(projectile_collision_test_agent, 0,0,-2, relative) -- double speed when moving backwards
            Scarab.downed_state += 1
            scenario_iterp_state = team[0]
         end
         move_scarab_attached_to_mover()

         scrb_mover.attach_to(Scarab, 0,0,0,relative)
         scrb_mover.detach()

         Scarab.attach_to(scrb_mover, 0,0,0,relative)
      end
   end
   -- if the scarab is not downed, then work properly
   if Scarab.downed_state == 0 then

      if c_goal.team != team[0] and c_goal.team != team[1] then -- if its a territories objective, we should let the territory control the sound emitter
         scenario_iterp_state = no_team
      end
      if scrb_mover.downed_timer > 0 then
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
      for each object with label "B_Turret" do
         if current_object.team != team[2] then
            current_object.t_retarget_interval -= 1
            if current_object.t_retarget_interval <= 0 and current_object.t_fire_ticks_interval > t_max_fire_ticks_interval or current_object.t_target == no_object then
               current_object.t_target = no_object 
               current_object.t_retarget_interval = t_max_retarget_interval
            end
            if current_object.t_target == no_object then
               current_object.W_yaw.detach() -- detach so we can measure distance from the turret itself
               temp_num1 = 32000 -- max range
               for each player do
                  if current_player.team == DEFENDERS 
                  and current_player.biped != no_object 
                  and not Scarab.proximity.shape_contains(current_player.biped) 
                  and current_object.W_yaw.shape_contains(current_player.biped) then -- is a defender, thus a badguy
                     temp_num2 = current_player.biped.get_distance_to(current_object.W_yaw)
                     if temp_num2 != 0 then -- is not apart of the scarab either
                        if temp_num2 < temp_num1  then -- is in range, and player isn't being stupid
                           temp_num1 = temp_num2 -- new closest player
                           current_object.t_target = current_player.biped
                           --current_object.t_fire_ticks_interval += 30 -- 0.5 seconds before it shoots at the new target
                           current_object.t_shots_in_burst = 0
                        end
                     end
                  end
               end
               current_object.W_yaw.attach_to(current_object.t_socket, 0,0,0,relative)
            end
            current_object.t_fire_ticks_interval -= 1
            if current_object.t_target != no_object then
               if not Scarab.proximity.shape_contains(current_object.t_target) then
                  turret_lookat()
                  if current_object.t_fire_ticks_interval <= 0  then -- fire at the target
                     current_object.t_fire_ticks_interval = t_max_fire_ticks_interval
                     temp_obj3 = current_object.W_pitch.place_at_me(light_blue, "Projectile", none, 0,0,0,none) --### change team to match scarab
                     temp_obj3.attach_to(current_object,-30,0,8,relative)
                     temp_obj3.p_mover = temp_obj3.place_between_me_and(temp_obj3, bomb, 0)
                     configure_projectile()
                     temp_obj3.face_toward(current_object.t_target, 0,0,0)
                     temp_obj3.lifespan = temp_obj3.get_distance_to(current_object.t_target)
                     -- now deduct this projectile from the burst
                     current_object.t_shots_in_burst += 1
                     if current_object.t_shots_in_burst >= t_max_shots_in_burst then -- initiate cooldown procedure
                        current_object.t_shots_in_burst = 0
                        current_object.t_fire_ticks_interval = t_cooling_ticks
                     end
                  end
               end
            end
         end
      end
      -- find target
      if Scarab.s_target == no_object then
         temp_obj1 = no_object 
         temp_num1 = 32000 -- max range
         for each player do
            if current_player.team == DEFENDERS then -- is a defender, thus a badguy
               temp_obj2 = current_player.try_get_vehicle()
               if not temp_obj2.is_of_type(falcon) and not temp_obj2.is_of_type(banshee) then -- completely ignore areial vehicles
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
               temp_num2 -= 100 -- is this fine??
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
                  game.play_sound_for(all_players, announce_destination_moved, false)
                  c_goal.ob_status = 1 -- remember for later that this one is in progress
                  c_goal.set_shape_visibility(everyone)
                  -- configure waypoints
                  setup_objective_marker_vis()
                  c_goal.enemy_icon = temp_obj0
                  c_goal.enemy_icon.set_waypoint_visibility(enemies)
                  c_goal.enemy_icon.set_waypoint_icon(ordnance)
   
                  setup_objective_marker_vis()
                  c_goal.ally_icon = temp_obj0
                  c_goal.ally_icon.set_waypoint_visibility(allies)
                  c_goal.ally_icon.set_waypoint_icon(defend)
                  if c_goal.team == team[0] or c_goal.team == team[1] then -- its a territories objective
                     -- configure waypoints
                     c_goal.enemy_icon.set_waypoint_timer(0)
                     c_goal.ally_icon.set_waypoint_timer(0)
                     c_goal.set_progress_bar(0, everyone)
                     -- setup sound emitter
                     temp_obj0 = c_goal.place_at_me(sound_emitter_alarm_1, none,none,0,0,0,none)
                     temp_obj0.attach_to(c_goal,0,0,0,relative)
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
         temp_obj0 = Scarab.s_target
         temp_player0 = temp_obj0.bp_owner
         for each player do 
            if temp_player0 != current_player or not Scarab.proximity.shape_contains(Scarab.s_target) then
               current_player.dickhead_timer.set_rate(50%) -- count back up for players who aren't targets at the moment
            end
         end
         -- determine movement required to get to target
         Scarab_interp_face_towards()
         if Scarab.proximity.shape_contains(Scarab.s_target) and Scarab.firing_mode < f.cooling then
            Scarab.backstep_ticks = rand(150) -- 2.5 seconds max backstep timer
            Scarab.backstep_ticks += 30 -- 0.5 seconds min stop backstepping
            reset_scarab_firing_state()
            if temp_player0 != no_player then
               temp_player0.dickhead_timer.set_rate(-100%)
               if temp_player0.dickhead_timer.is_zero() then -- they are being a dickhead
                  --game.show_message_to(all_players, none, "%p is being a dickhead", temp_player0)
                  temp_player0.is_a_dickhead = dickhead_ticks
                  --temp_player0.dickhead_timer.reset()
                  Scarab.s_target = no_object -- clear this target and wait till they behave 
               end
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
               Scarab_visual_face_towards_target()
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
                        temp_obj3.p_mover = temp_obj3.place_between_me_and(temp_obj3, covenant_bomb, 0)
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
               Scarab.attach_to(projectile_collision_test_agent, 1,0,0, relative)
            end
            if Scarab.backstep_ticks > 0 then
               Scarab.backstep_ticks -= 1
               Scarab.attach_to(projectile_collision_test_agent, -2,0,0, relative) -- double speed when moving backwards
            end
            move_scarab_attached_to_mover()
            -- now check if that movement put our dude out of bounds
            if not Scarab.is_out_of_bounds() then -- if we didn't just go out of bounds, then we should be good to move onward
            -- move our mover to our scarab
               scrb_mover.attach_to(Scarab, 0,0,0,relative)
               scrb_mover.detach()
            end
            -- reattach our base so it doesn't get garbo collected
            Scarab.attach_to(scrb_mover, 0,0,0,relative)
         end
      end
   end 
end
if Scarab != no_object and Scarab.Setup == 0 then
   scrb_mover = Scarab.place_at_me(capture_plate, none, none, 0,0,0,none) -- this doesn't actually cast shadows if we attach to a shadow caster for some reason 

   Scarab.Setup = 1
   -- place the sound emitter object
   temp_obj0 = Scarab.place_at_me(sound_emitter_alarm_1, none,none,0,0,0,none)
   temp_obj0.attach_to(Scarab, 0,0,0,relative)
   --basis = Scarab.place_between_me_and(Scarab, sound_emitter_alarm_2, 0)
   basis = Scarab
   --temp_obj4 = Scarab
   for each object with label "B_Attach" do
      if current_object.team != team[6] then
         offset_attach_object()
      end
      -- no more brown team teleporters
      -- if current_object.team == team[6] then
      --    -- place pitch and yaw objects
      --    pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
      --    yaw_obj = pitch_obj.place_at_me(hill_marker, "configure_scale", none, 0,0,0, none)
      --    offset_attach_actual()
      -- end
   end
   for each object with label "B_Misc" do -- previously "B_Point"
      -- forward, boundary, backward
      if current_object.spawn_sequence >= 1 and current_object.spawn_sequence <= 5 or current_object.spawn_sequence == 9 then
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
   end
   -- COMMENTED OUT ASSAULT
      -- for each object with label "B_Misc" do -- previously "bomb spawn"
      --    if current_object.spawn_sequence == 9 then
      --       offset_attach_object()
      --       c_bomb_spawn = current_object -- this is our proximity thingo - so we know when we're too close to our target
      --       c_bomb_spawn.set_waypoint_priority(high)
      --       c_bomb_spawn.set_waypoint_icon(bomb)
      --    end
      -- end
   -- B_Turret COMMENTED
      -- for each object with label "B_Turret" do
      --    offset_attach_object()
      --    if current_object.spawn_sequence > 0 then -- if its the actual turret itself, and not the station
      --       current_object.t_socket = yaw_obj.offset
      --    end
      --    -- i dont think we need to store the socket of this object, as we're not going to be attaching/detaching anything from the turret
      -- end
   -- COVENANT VERSION -------------------------------------
   for each object with label "B_Turret" do
      if current_object.spawn_sequence == 0 and current_object.team != team[2] then -- this is the seraph
         temp_obj0 = current_object
         basis = no_object 
         for each object with label "B_Turret" do
            if current_object.team == team[2] and current_object.spawn_sequence == temp_obj0.spawn_sequence then -- this is pivot point
               basis = current_object
            end
         end
         if basis != no_object then -- we found our pivot point
            current_object.max_health *= seraph_health
            current_object.health = 100
            -- code pre-functionization
               -- pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_2, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
               -- yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
               -- -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
               -- yaw_obj.attach_to(basis, 0,0,0, relative)
               -- yaw_obj.detach()   
               -- -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
               -- yaw_obj.face_toward(yaw_obj,0,-1,0)
               -- -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
               -- pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
               -- yaw_obj.copy_rotation_from(basis, true)
               -- pitch_obj.detach()
            setup_yaw_pitch_objects()
            pitch_obj.face_toward(pitch_obj, 0,1,0)
            yaw_obj.delete()

            current_object.W_yaw = basis
            current_object.W_pitch = pitch_obj
            current_object.W_pitch.attach_to(current_object.W_yaw, 0,0,0,relative)
            --current_object.face_toward(current_object, -1,0,0)
            current_object.attach_to(current_object.W_pitch, 4,-4,0,relative)
            --current_object.W_yaw.face_toward(current_object.W_yaw, -1,0,0)
            -- then attach our yaw
            basis = Scarab -- set this back to what it was
            temp_obj6 = current_object.W_yaw
            offset_attach_step2()
            current_object.t_socket = yaw_obj.offset
            temp_obj1 = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
            temp_obj1.set_waypoint_visibility(enemies)
            temp_obj1.team = ATTACKERS
            temp_obj1.attach_to(current_object,0,0,0,relative)
         end
      end
   end
   --------------------------------------------------------
   --scrb_mover = Scarab.mover
   scrb_mover.downed_timer = 0
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
               temp_obj5.LowerLength = lookat_obj.get_distance_to(pitch_obj)
               yaw_obj.delete() -- cleanup the foot marker, as we wont actually be using it for anything (maybe?)

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
                  temp_obj0.team = ATTACKERS
                  temp_obj0.attach_to(current_object, 0,0,40,relative)
                  --current_object.attach_to(current_object, 0,0,0,relative)
               end
            end
            current_object.visual_splode = current_object.place_between_me_and(current_object, bomb, 0)
            current_object.visual_splode.attach_to(current_object, 0,0,0,relative)
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
      scarab_health_display += temp_num0
      if current_object.D_child == no_object or temp_num0 < 0 then -- if the leg component blew up, or is about to ignite, then notify the scarab of leg loss
         game.show_message_to(all_players, none, "Leg Knocked Out!")
         --temp_obj0 = Scarab.mover
         scrb_mover.downed_timer = max_downed_timer
         scrb_mover.legs_destroyed += 1
         current_object.visual_splode.detach()
         current_object.visual_splode.kill(false)
         current_object.D_cleanup.delete()
         current_object.L_destoyed = 1
         if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
            game.show_message_to(all_players, none, "The Scarab Core has Been Exposed!")
            scrb_mover.B_core.set_invincibility(0)
            scrb_mover.B_core.set_waypoint_icon(bullseye)
            scrb_mover.B_core.set_waypoint_visibility(everyone)
            scrb_mover.B_core.set_waypoint_priority(high)
            temp_obj0 = scrb_mover.B_core
            temp_obj0.team = ATTACKERS
            for each object with label "B_Misc" do
               if current_object.spawn_sequence == 9 then
                  current_object.delete()
               end
            end
         end
      end
   end
end
-- NOTE: leg will blow up at 50% health
-- debug health of leg
   -- for each object with label "L_Joint" do
   --    if current_object.D_child != no_object then 
   --       -- temp_obj0 = current_object.D_child
   --       -- temp_obj0.number[0] = temp_obj0.health
   --       -- temp_obj0.set_waypoint_text("%n", hud_target_object.number[0])
   --       -- temp_obj0.set_waypoint_visibility(everyone)

   --       -- current_object.D_child.copy_rotation_from(current_object, true)
   --       -- current_object.D_child.attach_to(current_object, 0,0,0,relative)
   --       -- current_object.D_child.detach()
   --    end
   -- end

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
for each object with label "Detonation" do
   current_object.countdown_ticks -= 1
   if current_object.countdown_ticks == 0 then -- not less than or if has the potential to fire twice?
      current_object.detach()
      -- surely running this after wont have issues right lol -- ok it actually did have issues, who woulda guessed
      --if current_object.ex_del1 != no_object then -- unneeded code
         current_object.ex_del1.delete()
      --end
      current_object.kill(false)
   end
end

function detonate_bomb_del_current()
   if current_object.is_building_shot == c_goal.spawn_sequence and not current_object.is_of_type(light_blue) then
      c_goal.theoretical_damage += 1
      call_attack_on_objective()
   end
   current_object.p_mover.detach()
   current_object.p_mover.kill(false)
   current_object.delete()
end
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
for each object with label "Projectile" do
   if not current_object.is_of_type(light_blue) then
      current_object.p_mover.attach_to(current_object, 3,0,0,relative)
   end
end
for each object with label "Projectile" do
   --temp_obj3.detach()
   current_object.attach_to(current_object.p_mover, 0,0,0,relative)
   if current_object.p_mover == no_object then -- this would be an error, or somehow it blew up
      current_object.delete()
   end
end
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
            temp_obj0 = current_player.try_get_vehicle()
            if temp_obj0 != no_object then
               temp_obj0.kill(false)
            end
            if temp_obj0 == no_object then
               current_player.biped.kill(false)
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


-- leg position calculations script
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

-- scarab manned turrert script
-- B_Turret COMMENTED
   -- for each object with label "B_Turret" do
   --    if current_object.spawn_sequence < 0 then -- is the sender of a turret
   --       if current_object.use_cooldown_ticks > 0 then -- do this so we dont count down under the int16 maximum (bad)
   --          current_object.use_cooldown_ticks -= 1
   --       end
   --       if current_object.turret_object != no_object then
   --          -- do this outside of the loop, so the player can walk out and back in quickly
   --          if current_object.operator_biped == no_object and current_object.last_operator != no_player then
   --             -- if the last player is not inside the boundary anymore, then we dont care about that player anymore
   --             if not current_object.shape_contains(current_object.last_operator.biped) then 
   --                current_object.last_operator = no_player 
   --                --game.show_message_to(all_players, none, "last op cleared")
   --             end
   --          end
   --          if current_object.use_cooldown_ticks <= 0 then
   --             if current_object.operator_biped != no_object and current_object.last_operator.biped != no_object then -- then theres someone on it
   --                current_object.set_shape_visibility(no_one) -- indicate that this seat is NOT vacant
   --                -- can't be bothered putting it on local, so here it lies
   --                current_object.operator_biped.detach()
   --                current_object.operator_biped.attach_to(current_object,0,0,0,relative)
   --                temp_num0 = 0
   --                for each player do
   --                   if current_player == current_object.last_operator then
   --                      temp_num0 = 1 -- ok phew, they are still in the game
   --                   end
   --                end
   --                if temp_num0 == 0 then -- wow, thanks for leaving while in the turret loser
   --                   --game.show_message_to(all_players, none, "player quit, forcing turret exit")
   --                   -- for safety protocols, lets delete the biped they were possessing, just in case they left any germs
   --                   current_object.turret_biped.delete()
   --                   current_object.last_operator = no_player
   --                   -- return the operator to their biped
   --                   current_object.operator_biped.detach()
   --                   current_object.operator_biped.kill(false)
   --                   current_object.operator_biped = no_object
   --                   -- then disable functionality for a whole second
   --                   current_object.use_cooldown_ticks = turret_enter_cooldown
   --                end
   --             end
   --             -- repeated conditions, but thats because the above can clear the need to do this one aswell
   --             if current_object.operator_biped != no_object and current_object.last_operator.biped != no_object then -- then theres someone on it
   --                temp_num0 = current_object.turret_biped.get_distance_to(current_object.turret_object)
   --                if temp_num0 != 0 then -- then they hopped out, returning to their normal body
   --                   --game.show_message_to(all_players, none, "manual turret exit")
   --                   -- pop the dude back into the turret
   --                   current_object.last_operator.force_into_vehicle(current_object.turret_object)
   --                   -- return the operator to their biped
   --                   current_object.last_operator.set_biped(current_object.operator_biped)
   --                   current_object.operator_biped.detach()
   --                   current_object.operator_biped = no_object
   --                   -- then disable functionality for a whole second
   --                   current_object.use_cooldown_ticks = turret_enter_cooldown
   --                end
   --             end
   --             if current_object.operator_biped == no_object then -- clearly no one's in it
   --                -- look for suitable players to occupy turret
   --                current_object.set_shape_visibility(everyone) -- indicate that this seat is vacant
   --                for each player do
   --                   if current_object.last_operator != current_player and current_object.shape_contains(current_player.biped) and current_object.operator_biped == no_object then
   --                      -- criteria met, then this player will occupy the turret
   --                      current_object.last_operator = current_player
   --                      current_object.operator_biped = current_player.biped
   --                      current_player.biped.attach_to(current_object,0,0,0,relative)
   --                      temp_obj0 = current_object.operator_biped
   --                      -- commented as this is now done elsewhere
   --                      --temp_obj0.bp_owner = current_player -- store the owner on their old biped, so we can figure out who's it was when it died, or actually we dont need this, just do some other crosschecks
   --                      if current_object.turret_biped != no_object then -- then simply just set their biped to the one in the turret 
   --                         current_player.set_biped(current_object.turret_biped)
   --                         --game.show_message_to(all_players, none, "entered prewarmed turret")
   --                      end
   --                      if current_object.turret_biped == no_object then 
   --                         current_object.turret_biped = current_object.place_at_me(spartan, none, none, 0,0,0,none)
   --                         current_object.turret_biped.set_invincibility(1)
   --                         current_object.turret_biped.set_scale(1)
   --                         current_object.turret_biped.copy_rotation_from(current_object.turret_biped, true)
   --                         -- now setup the biped into the vehicle for the first time
   --                         current_player.set_biped(current_object.turret_biped)
   --                         current_object.turret_biped.remove_weapon(primary, true) -- take the DMR out of their hands
   --                         current_player.force_into_vehicle(current_object.turret_object)
   --                         --game.show_message_to(all_players, none, "entered fresh turret")
   --                      end
   --                   end
   --                end
   --             end
   --          end
   --       end
   --    end
   -- end
   -- here we check for objects that are the actual turrets
   -- for each object with label "B_Turret" do
   --    if current_object.spawn_sequence > 0 then -- is the actual turret itself
   --       if current_object.t_turret == no_object then
   --          -- TODO: add more weapon possibilities
   --          --if current_object.team == team[0] then 
   --             current_object.t_turret = current_object.place_at_me(warthog_turret_rocket, none, none, 0,0,0,none)
   --          --end
   --          current_object.t_turret.set_invincibility(1)
   --          temp_obj0 = current_object
   --          temp_num0 = current_object.spawn_sequence
   --          temp_num0 *= -1
   --          -- tell our parent, that we've acquired our brand new turret object
   --          for each object with label "B_Turret" do
   --             if current_object.spawn_sequence == temp_num0 then
   --                current_object.turret_object = temp_obj0.t_turret
   --             end
   --          end
   --       end
   --    end
   -- end
for each player do
   if current_player.biped != no_object then
      temp_obj0 = current_player.biped
      temp_obj0.bp_owner = current_player
   end
end


-- configure the bomb effects for the bomb objects
for each object with label "S_Ob_Point" do
   if current_object.team == team[3] and current_object.bomb_visual == no_object then
      current_object.bomb_visual = current_object.place_at_me(bomb, none, none, 0,0,0,none)
      current_object.bomb_visual.attach_to(current_object, 0,0,0,relative)
   end
end
function test_structure_integrity() -- AND destroy the part doing the evaluation
   C_goal.ob_status = 2
   temp_num0 = 0 -- clear this
   -- check for any other pieces still holding this tower up
   for each object with label "S_Objective" do
      if current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.spawn_sequence == c_goal.spawn_sequence and current_object.ob_status == 0 or current_object.ob_status == 1 then
         temp_num0 += 1
      end
   end
   -- if temp_num0 > 0 then
   --    game.show_message_to(all_players, none, "Tower Pillar destroyed %n remain", temp_num0)
   -- end
   if temp_num0 == 0 then -- that was the last alive pillar; now destroyed
      game.show_message_to(all_players, none, "Tower %n destroyed!", c_goal.spawn_sequence)
      game.play_sound_for(DEFENDERS, announce_territories_lost, false)
      game.play_sound_for(ATTACKERS, announce_territories_captured, false)
      
      ATTACKERS.score += 1
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
               for each player do
                  if current_object.shape_contains(current_player.biped) then
                     current_player.HOST_bumpcount += 1
                  end
               end
            end
            if current_object.team == team[3] or current_object.team == team[2] then -- is a bump zone, if not then it'll *probably* ignore the two lower lines & cleanup
               -- current_object.bomb_visual.detach()
               -- current_object.bomb_visual.kill(false)
               -- current_object.delete()
               detonate_bomb_del_current()
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
   if temp_num0 <= 0 and game_end_state == 0 then -- gameover
      game_end_state = -1
      game.play_sound_for(all_players, inv_cue_covenant_win_big, true)
      game.play_sound_for(DEFENDERS, inv_spire_vo_spartan_p1_loss, false)
      game.play_sound_for(ATTACKERS, inv_spire_vo_covenant_p3_win, false)
   end   
end

on object death: do
   -- B_Turret COMMENTED
      -- if killed_object.bp_owner != no_player then
      --    if killed_object.bp_owner.biped != killed_object and killed_object.bp_owner.biped != no_object then -- this player was possessing another biped, we better kill them out of it
      --       temp_obj0 = killed_object
      --       for each object with label "B_Turret" do
      --          if current_object.last_operator == temp_obj0.bp_owner then -- this player was on the turret
      --             -- ragdoll the corpse
      --             current_object.operator_biped.detach()
      --             -- then disable turret functionality for a whole second
      --             current_object.use_cooldown_ticks = turret_enter_cooldown
      --          end
      --       end   
      --       game.show_message_to(all_players, none, "player OG biped died, forcing out of turret")
      --       -- now give them a new biped and kill them out of it, to cause a regular death
      --       temp_obj0 = killed_object.place_at_me(monitor, none,none,0,0,0,none)
      --       killed_object.bp_owner.set_biped(temp_obj0)
      --       temp_obj0.kill(false)
      --    end
      -- end
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
   c_goal.ally_icon.set_waypoint_priority(high)
   c_goal.enemy_icon.set_waypoint_priority(high)
   if not under_attack_timer.is_zero() then
      c_goal.ally_icon.set_waypoint_priority(blink)
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
            if current_player.team == ATTACKERS then -- is an attacking player
               temp_num0 += 1
            end
            if current_player.team == DEFENDERS then -- is a defending player
               --temp_num0 -= -9999 -- this will make it not true
               temp_num0 |= 0b0100000000000000
            end
         end
      end
      -- NETTEST DEBUG
      temp_obj0 = c_goal.ally_icon
      temp_obj0.ob_cap_time = c_goal.ob_cap_time
      temp_obj0 = c_goal.enemy_icon
      temp_obj0.ob_cap_time = c_goal.ob_cap_time
      if temp_num0 == 0 or temp_num0 == 0b0100000000000000 then -- this has no one in it
         scenario_iterp_state = no_team
         c_goal.ally_icon.set_waypoint_priority(high)
         c_goal.enemy_icon.set_waypoint_priority(high)
         c_goal.ob_cap_time.set_rate(100%)
         if c_goal.ob_cap_time >= maximum_recover_time then 
            c_goal.ob_cap_time.set_rate(0%)
         end
      end
      if temp_num0 != 0 and temp_num0 != 0b0100000000000000 then -- there are attackers & no defenders inside
         scenario_iterp_state = team[0]
         c_goal.ally_icon.set_waypoint_priority(blink)
         c_goal.enemy_icon.set_waypoint_priority(blink)
         c_goal.ob_cap_time.set_rate(0%) -- is contested
         if temp_num0 > 0 and temp_num0 < 0b0100000000000000 then -- isn't contested
            c_goal.ob_cap_time.set_rate(-100%)
            call_attack_on_objective()
            if c_goal.ob_cap_time.is_zero() then 
               test_structure_integrity()
            end
         end
      end
   end
end
-- condition purely so i can hide this section
   -- ASSAULT COMMENTED
   --  -- assualt code
   -- if c_goal != no_object then 
   --    if c_goal.team == team[2] then
   --       if c_objective == no_object then 
   --          c_bomb_spawn.set_waypoint_visibility(allies)
   --          for each player do
   --             if c_bomb_spawn.shape_contains(current_player.biped) and c_objective == no_object then 
   --                c_objective = c_bomb_spawn.place_at_me(covenant_bomb, none,none,0,0,0,none)
   --                c_objective.set_waypoint_icon(bomb)
   --                c_objective.set_waypoint_visibility(allies)
   --                c_objective.team = team[0]
   --                current_player.add_weapon(c_objective)
   --             end
   --          end
   --       end
   --       if c_objective != no_object then 
   --          c_bomb_spawn.set_waypoint_visibility(no_one) -- hide the bomb spawn because we've just spawned in the bomb
   --          temp_player0 = c_objective.get_carrier()
   --          if c_goal.is_planted == 0 then
   --             if c_goal.shape_contains(c_objective) then 
   --                c_goal.ob_arm_time.reset()
   --             end
   --             if c_goal.shape_contains(c_objective) then 
   --                c_goal.ob_arm_time.set_rate(-100%)
   --                c_goal.set_progress_bar(1, mod_player, temp_player0, 1)
   --                if c_goal.ob_arm_time.is_zero() then -- plant the bomb
   --                   c_goal.is_planted = 1
   --                   -- do incident here
   --                   c_objective.detach()
   --                   c_objective.attach_to(c_goal, 0,0,1,relative)
   --                   send_incident(bomb_planted, all_players, no_player)
   --                end
   --             end
   --          end
   --          if c_goal.is_planted == 1 then 
   --             temp_num0 = 0
   --             c_goal.ob_countdown_time.set_rate(-100%)
   --             c_goal.set_waypoint_timer(2)
   --             c_goal.set_progress_bar(1, no_one)
   --             for each player do 
   --                if c_goal.shape_contains(current_player.biped) then 
   --                   if current_player.team == team[1] then -- is a defending player
   --                      temp_num0 = -9999 -- this will make it not true
   --                      c_goal.set_progress_bar(3, mod_player, current_player, 1)
   --                   end
   --                end
   --             end
   --             if temp_num0 >= 0 then -- stop disarming 
   --                c_goal.ally_icon.set_waypoint_priority(high)
   --                c_goal.enemy_icon.set_waypoint_priority(high)
   --                c_goal.ob_disarm_time.reset()
   --             end
   --             if temp_num0 < 0 then -- commence disarming
   --                c_goal.ally_icon.set_waypoint_priority(blink)
   --                c_goal.enemy_icon.set_waypoint_priority(blink)
   --                c_goal.ob_disarm_time.set_rate(-100%)
   --                if c_goal.ob_disarm_time.is_zero() then
   --                   send_incident(bomb_disarmed, all_players, all_players)
   --                   c_objective.delete()
   --                   c_goal.is_planted = 0
   --                   c_goal.set_waypoint_timer(-1)
   --                   c_goal.ally_icon.set_waypoint_priority(high)
   --                   c_goal.enemy_icon.set_waypoint_priority(high)
   --                end
   --             end
   --             if c_goal.ob_countdown_time.is_zero() then -- bomb successfully planted, will explode
   --                c_objective.detach()
   --                c_objective.kill(false)

   --                temp_obj0 = c_goal
   --                test_structure_integrity()
   --                c_goal.ally_icon.delete()
   --                c_goal.enemy_icon.delete()
   --                send_incident(bomb_disarmed, team[0], team[1])
   --                c_goal.delete()
   --             end
   --          end
   --       end
   --    end
   -- end
   -- for each player do 
   --    temp_obj0 = current_player.get_weapon(primary)
   --    if temp_obj0 == c_objective then
   --       current_player.biped.set_waypoint_icon(bomb)
   --    end
   --    if temp_obj0 != c_objective then
   --       current_player.biped.set_waypoint_icon(none)
   --    end
   -- end
-- debris clear from scarab interrior script
for each object with label "S_Objective" do
   if current_object.team == debris_static_indicator_team then -- is debris
      if Scarab.shape_contains(current_object) then
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

      perma_debris_toggle ^= 1
      if perma_debris_toggle == 0 then -- this guy is gonna stick around
         UpdateDebris_HOST += 1 -- notify clients that the function is needed to be called
         temp_obj1 = temp_obj0.place_between_me_and(temp_obj0, flag_stand, 0)
         temp_obj0.attach_to(temp_obj1, 0,0,0,relative)
      end
   end
end


-- quickly go through and tell each player if they are or aren't supposed to be experiencing cargo physics
for each player do
   script_widget[1].set_visibility(current_player, false)
   if current_player.biped != no_object and Scarab.shape_contains(current_player.biped) then
      temp_obj0 = current_player.try_get_vehicle()
      if temp_obj0 == no_object then
         script_widget[1].set_visibility(current_player, true)
      end
   end
end

-- decoration explosion stuff
   -- brown team stuff (instant explode) -- unused
   -- for each object with label "self_destruct" do
   --    if current_object.team == neutral_team then -- red team, instantly explode
   --       current_object.kill(true)
   --    end
   -- end
   -- seraph script
   -- alias kill_timer = object.number[1]
   -- alias ser_has_scaled = object.number[4]
   -- for each object with label "self_destruct" do
   --    if current_object.team == team[3] then -- blue team, explode after 2-5 seconds of existing
   --       if current_object.kill_timer == 0 then -- setup this thing
   --          current_object.kill_timer = rand(180)
   --          current_object.kill_timer += 120 -- rand 2-5 seconds
   --       end
   --    end
   -- end
   -- for each object with label "self_destruct" do
   --    if current_object.team == team[3] then --  blue team, explode after life has expired
   --       current_object.kill_timer -= 1
   --       if current_object.kill_timer == 1 then -- setup this thing
   --          current_object.kill(true)
   --       end
   --    end
   -- end
   -- alias br_spawn_interval = object.number[1]
   -- alias ticks_bomb_spawn_interval = 15
   -- alias br_spawned_count = object.number[4]
   -- chain explosions script
   -- for each object with label "self_destruct" do
   --    if current_object.team == team[4] or current_object.team == team[2] then -- red team, instantly explode
   --       if current_object.br_spawned_count > current_object.spawn_sequence then
   --          current_object.delete()
   --       end
   --    end
   -- end
   -- for each object with label "self_destruct" do
   --    if current_object.team == team[4] or current_object.team == team[2] then -- glassing beam teams, spawn a trail of bombs & blow up
   --       current_object.br_spawn_interval += 1
   --       if current_object.br_spawn_interval > ticks_bomb_spawn_interval then
   --          current_object.br_spawn_interval = 0
   --          current_object.br_spawned_count += 1
   --          if current_object.team == team[4] then -- covenant bomb
   --             temp_obj0 = current_object.place_at_me(covenant_bomb, "Detonation", none, 0,0,0,none)
   --          end
   --          if current_object.team == team[2] then -- UNSC bomb
   --             temp_obj0 = current_object.place_at_me(bomb, "Detonation", none, 0,0,0,none)
   --          end
   --          temp_obj0.countdown_ticks = 40
   --       end
   --    end
   -- end
-- function recurs_grid_spawn()
--    if temp_num0 > 0 then
--       temp_obj0 = current_object.place_between_me_and(current_object, grid, 0)
--       temp_obj0.copy_rotation_from(current_object, true)
--       -- offset marker for the placement of the next object (we have to use scaling cause attachments can only go 12.7 units, wheres the grid is 30.0 units)
--       current_object.attach_to(temp_obj0, 30,0,0,relative)
--       temp_obj0.set_scale(1000)
--       temp_obj0.copy_rotation_from(temp_obj0, true)
--       current_object.detach()

--       temp_obj0.set_scale(100)
--       temp_obj0.copy_rotation_from(temp_obj0, true)
--       temp_num0 -= 1
--       recurs_grid_spawn()
--    end
-- end
-- -- grid generator
   -- for each object with label "self_destruct" do
   --    if current_object.team == team[3] then -- orange team, spawn grids 
   --       temp_num0 = current_object.spawn_sequence
   --       recurs_grid_spawn()
   --       current_object.delete()
   --    end
   -- end

-- prevent health regen on AA turret
for each object with label "B_Turret" do
   if current_object.team != team[2] then
      temp_num0 = current_object.health
      if temp_num0 > current_object.t_last_health and temp_num0 < 99 then
         current_object.health = current_object.t_last_health
      end
   end
end
for each object with label "B_Turret" do
   if current_object.team != team[2] then
      current_object.t_last_health = current_object.health
   end
end

do
   host_indicator = 3621 -- set this to a hgih number that is not either 0 or 1
end 
function cleanup_tempobj_4_5()
   temp_obj4.delete()
   temp_obj5.delete()
end

alias object_count = temp_num2
alias megalo_object_count = temp_num1
on local: do 
   -- scenario interpolator special sauce
   if scenario_iterp_state == no_team then -- turn it off
      set_scenario_interpolator_state(1, 0)
   end
   if scenario_iterp_state == team[0] then -- turm it on
      set_scenario_interpolator_state(1, 1)
   end

   -- make seraph projectiles mini
      -- for each object with label "self_destruct" do
      --    if current_object.team == team[3] then --  red team, scale to 1% so no one can see it
      --       if current_object.ser_has_scaled == 0 then
      --          current_object.ser_has_scaled = 1
      --          current_object.set_scale(1)
      --          current_object.copy_rotation_from(current_object, true)
      --       end
      --    end
      -- end
   --scale label 
   for each object with label "scale" do
      if current_object.has_scaled == 0 and host_indicator <= -90 or host_indicator == 3621 then
         current_object.has_scaled = 1
         _330_current_object()
         -- yellow team logic to setup the wall collies to be perfectly flat
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
               temp_obj0 = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            end
            current_object.detach()
            current_object.attach_to(temp_obj0, 0, 0, 0, relative)
         end
      end
   end

   -- STAPLE the turret to its stand & scale correctly
      -- B_Turret COMMENTED
      -- for each object with label "B_Turret" do
      --    if current_object.spawn_sequence > 0  -- is the actual turret itself
      --    and current_object.t_initialized == 0
      --    and current_object.t_socket != no_object
      --    and current_object.t_turret != no_object then
      --       current_object.t_initialized = 1
      --       current_object.detach()
      --       current_object.set_scale(1)
      --       current_object.copy_rotation_from(current_object, true)
      --       current_object.attach_to(current_object.t_socket, 0,0,0,relative)
      --       current_object.t_turret.detach()
      --       current_object.t_turret.set_scale(1)
      --       current_object.t_turret.copy_rotation_from(current_object, true)
      --       current_object.t_turret.attach_to(current_object, 0,0,0,relative)
      --    end
      -- end

   -- runs once every 4 ticks; updates players relative locations (cargo physics), do this to 
   temp_poopoo -= 1
   if temp_poopoo <= 0 then 
      temp_poopoo = 4
      -- relative velocity thing
      for each player do
         current_player.relatives = 0
      end
      -- we're leaving these as is, because who knows, it might not sync in time or whatever
      -- ok, we've now changed it (to 'Scarab' opposed to the previous 'current_object')
      for each player do
         if current_player.biped != no_object then
            if Scarab.shape_contains(current_player.biped) then
               current_player.relatives += 1
               global.object[0] = current_player.try_get_vehicle()
               if global.object[0] != no_object then 
                  current_player.relatives += 100 -- give them a really high number to prevent this script from running while in vehicle
               end
            end
         end
      end
      -- a bit lazy, but we'll spawn in the mover agents here, as there have to be attach_base's for things to get moved (probably)
      if mover_agent1 == no_object then 
         mover_agent1 = Scarab.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
      end
      if mover_agent2 == no_object then 
         mover_agent2 = Scarab.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none)
      end
      if Scarab.shape_contains(Scarab) then -- this object has a shape
         for each player do
            if current_player.relatives != 1 then -- inside either too many or too little vehicles
               if current_player.r_offset != no_object then
                  current_player.r_offset.delete()
               end
               if current_player.r_base != no_object then
                  current_player.r_base.delete()
               end
            end
            if current_player.biped != no_object and current_player.relatives == 1 and Scarab.shape_contains(current_player.biped) then
               if current_player.r_base != no_object then
                  -- find the offset that this player actually moved this tick
                  -- if current_player.r_last == no_object then
                  --    game.show_message_to(all_players, none, "last failed")
                  -- end
                  -- if current_player.r_offset == no_object then
                  --    game.show_message_to(all_players, none, "offset failed")
                  -- end
                  -- TODO: investigate script overflowing data and deleting temp_obj4 assigned in some above script
                  temp_obj4 = no_object 
                  temp_obj5 = no_object

                  basis = current_player.r_last
                  lookat_obj = mover_agent1
                  lookat_obj.attach_to(current_player.biped,0,0,0,relative)
                  lookat_obj.detach()

                  offset_scale = lookat_obj.get_distance_to(basis)
                  temp_num1 = offset_scale
                  if offset_scale > 0 then
                     config_thingo()
                     temp_obj4 = offset_obj.place_between_me_and(offset_obj, sound_emitter_alarm_2, 0)
                     temp_obj5 = yaw_obj.place_between_me_and(yaw_obj, sound_emitter_alarm_2, 0)
                     offset_scale = temp_obj5.get_distance_to(temp_obj4) -- reuse number again
                     cleanup_tempobj_4_5()

                     temp_obj4 = offset_obj
                     temp_obj5 = yaw_obj
                     -- atomic check
                     if offset_scale <= 0 then
                        temp_num1 = -1
                        -- cleanup objects due to atomic error
                        offset_obj.delete()
                        yaw_obj.delete()
                     end
                  end
                  -- if the player is not going atomic, then we are allowed to continue the subroutine
                  if temp_num1 != -1 then -- added to try to prevent the teleporting glitch that would happen when you have 0 distance to the scarab
                     -- now see how far away the player is from where their relative position on the vehicle
                     basis = current_player.biped.place_between_me_and(current_player.biped, sound_emitter_alarm_2, 0)
                     lookat_obj = current_player.r_offset.place_between_me_and(current_player.r_offset, sound_emitter_alarm_2, 0)
                     
                     offset_scale = basis.get_distance_to(lookat_obj)
                     if offset_scale <= 0 then -- neither player nor vehicle have moved
                        -- make sure we dont run the player movement code
                        temp_num1 = -1
                        cleanup_tempobj_4_5()
                        basis.delete()
                        lookat_obj.delete()
                     end
                     if offset_scale > 0 then
                        --game.show_message_to(current_player, none, "distance_relative %n", offset_scale)
                        config_thingo()
                        basis.delete()
                        lookat_obj.delete()
                        -- then we check for atomic errors
                        mover_agent1.attach_to(offset_obj,0,0,0,relative)
                        mover_agent1.detach()
                        mover_agent2.attach_to(yaw_obj,0,0,0,relative)
                        mover_agent2.detach()
                        offset_scale = mover_agent2.get_distance_to(mover_agent1)

                        if offset_scale <= 0 then
                           -- cleanup objects that would exist on the movement basis
                           if temp_num1 > 0 then
                              cleanup_tempobj_4_5()
                           end
                           temp_num1 = -1 -- atomic error
                        end
                        if temp_num1 != -1 then -- apply transform if correct
                           yaw_obj.attach_to(current_player.biped, 0,0,0,relative)
                           current_player.biped.attach_to(offset_obj, 0,0,0,relative)
                        end
                        offset_obj.delete()
                        yaw_obj.delete()
                     end
                     
                     -- attach this after, so the speeds aren't amplified
                     if temp_num1 > 0 then
                        temp_obj5.attach_to(current_player.biped, 0,0,0,relative)
                        current_player.biped.attach_to(temp_obj4, 0,0,0,relative) -- oddly, only temp_obj4 gets detached from the player i think
                        cleanup_tempobj_4_5()
                     end
                  end
                  -- apply movement after relocation
                  current_player.r_offset.delete()
                  current_player.r_base.delete()
               end
               -- if the player is still within the boundary, then recalculate the relative position
               if Scarab.shape_contains(current_player.biped) then
                  -- record new location relative to the vehicle
                  basis = mover_agent1
                  basis.attach_to(Scarab,0,0,0,relative)
                  basis.detach()
                  lookat_obj = mover_agent2
                  lookat_obj.attach_to(current_player.biped,0,0,0,relative)
                  lookat_obj.detach()
                  offset_scale = basis.get_distance_to(lookat_obj)
                  config_thingo()

                  yaw_obj.attach_to(Scarab, 0,0,0,relative)
                  -- remember these objects, as they now tell us the relative location of the player on this vehicle
                  current_player.r_offset = offset_obj
                  current_player.r_base = yaw_obj
               end
            end
         end
      end
      for each player do
         if current_player.biped != no_object then
            if current_player.r_last == no_object then
               current_player.r_last = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0,none) -- we should change this to something that doesn't emitt sound
            end
            current_player.r_last.attach_to(current_player.biped, 0,0,0,relative)
            current_player.r_last.detach()
         end
      end
   end

   -- misc off-host only behavior
   if host_indicator <= 0  then
      for each object with label "B_Turret" do
         if current_object.team != team[2] then
            if current_object.W_yaw != no_object and current_object.t_is_attached == 0 then
               current_object.t_is_attached = 1
               current_object.detach()
               current_object.attach_to(current_object.W_pitch, 4,-4,0,relative)
            end
            if current_object.t_target != no_object and current_object.W_yaw != no_object and current_object.W_pitch != no_object and scarab_ready_timer.is_zero() then
               if not Scarab.proximity.shape_contains(current_object.t_target) then
                  turret_lookat()
               end
            end
         end
      end
      if host_indicator > -90 then -- 1.5 seconds
         host_indicator -= 1
      end
      if host_indicator <= -90 then -- then our guy has waited for the host to sync everything
         -- Scarab.detach()
         -- Scarab.copy_rotation_from(Scarab.mover, true)
         -- Scarab.attach_to(Scarab.mover, 0,0,0,relative)

         if UpdateDebris_CLIENT != UpdateDebris_HOST then -- we need to call debris update
            -- yes we're using host indicator cause i couldn't be bothered using another variable
            host_indicator -= 1 -- now 30 ticks to recheck
            if host_indicator < -120 then -- quarter of a second later, to let the teams to sync, incase its priority is too much lower than the recieved variable
               host_indicator = -90
               UpdateDebris_CLIENT = UpdateDebris_HOST
               for each object with label "S_Objective" do
                  if current_object.team == debris_static_indicator_team then
                     current_object.detach()
                  end
               end
            end
         end
         -- make the eyeball gun face towards the target player as it should do
         if Scarab.Setup == 1 and Scarab.s_target != no_object and Scarab.downed_state == 0 then
            Scarab_interp_face_towards()
            temp_obj0 = Scarab.sight
            if temp_obj0.W_yaw != no_object
            and temp_obj0.W_pitch != no_object then
            --and temp_obj0.W_visual != no_object then
               Scarab_visual_face_towards_target()
            end
         end
         -- configure the scale of configre_scale objects
         for each object with label "configure_scale" do
            if current_object.designated_scale != 0 then
               if current_object.block.has_forge_label("B_Attach") and current_object.team != team[7] and current_object.team != team[6] then
                  current_object.block.copy_rotation_from(current_object.offset, true)
                  current_object.block.attach_to(current_object.offset, 0,0,0,relative)
                  current_object.block.detach()
               end
               if current_object.has_scaled == 0 then
                  --game.show_message_to(all_players, none, "scaling glue obj") -- no objects appeared to run this outside of the inital tick, which is perfect 
                  current_object.has_scaled = 1
                  current_object.detach()
                  current_object.set_scale(current_object.designated_scale)
                  current_object.copy_rotation_from(current_object, true) -- update yaw_obj's scale
                  -- NOTE: this object reference can be replaced with a loop to find the parent (there should only ever be one possible parent)
                  current_object.attach_to(current_object.parent, 0,0,0,relative) 
                  -- also, we have to scale the blocks for non-hosts
                  lookat_obj = current_object.block
                  lookat_obj.detach()
                  if lookat_obj.has_forge_label("B_Attach") or lookat_obj.has_forge_label("U_Attach") or lookat_obj.has_forge_label("L_Attach") then -- only scale b_attach objects
                     _330x()
                  end
                  -- hide the propane tanks
                  if lookat_obj.has_forge_label("L_Damage") and lookat_obj.team != neutral_team then -- this is one of the propane tank thingos
                     lookat_obj.set_scale(1)
                     lookat_obj.copy_rotation_from(lookat_obj, true)
                  end
                  lookat_obj.attach_to(current_object.offset, 0,0,0,relative)
               end
            end
         end
      end
   end
   -- player bumpcount script
   for each player do
      if current_player.CLIENT_bumpcount < current_player.HOST_bumpcount then
         current_player.CLIENT_bumpcount += 1
         current_player.biped.push_upward()
      end
   end

   -- update the position of the scarab legs, both host & non-host
      -- used variables
      -- temp_num0
      -- temp_num3
      -- temp_num4
      -- temp_num5
      -- shield_object
      -- current_object.socket
      -- current_object.pitch
      -- current_object.foot
      -- current_object.UpperLenght
      -- current_object.LowerLength
      -- current_object.knee
      --    temp_obj1.socket
   for each object with label "U_Joint" do
      if current_object.initialized == 1 and current_object.foot != no_object then
         if shield_object == no_object then
            shield_object = current_object.place_at_me(monitor, none,none,0,0,15,none)
            shield_object.max_shields = 32000
            shield_object.shields = 100
         end
         -- orient the leg to be facing the foot location, this should move all the attached joints too
         current_object.detach()
         current_object.face_toward(current_object.foot, 0,0,0)
         -- then orient the pitch to face directly at the foot (if the distance is too long, then this serves as a fallback to extend 100%)
         current_object.pitch.detach()
         current_object.pitch.face_toward(current_object.foot, 0,0,0)
   
   
         c_UpperToDestinationLength = current_object.get_distance_to(current_object.foot)
   
         temp_num5 = current_object.UpperLenght
         temp_num5 += current_object.LowerLength
         --if temp_num5 <= c_UpperToDestinationLength then 
         --   temp_num0 = 3621
         --end
         if temp_num5 > c_UpperToDestinationLength then -- if the angle is invalid to calculate, then skip rotation and leave the joints just looking at it
            CalculateJointAngle()
         end
   
         temp_obj1 = current_object.knee
         temp_obj1.detach()
         temp_obj1.face_toward(current_object.foot, 0,0,0)
   
         -- now that our leg has been calculated, lets reattach everything!
         temp_obj1.attach_to(temp_obj1.socket, 0,0,0,relative)
         current_object.pitch.attach_to(current_object, 0,0,0,relative)
         current_object.attach_to(current_object.socket, 0,0,0,relative)
      end
   end
-- object counter script 
   -- object_count = 0 -- set this to a hgih number that is not either 0 or 1
   -- megalo_object_count = 0
   -- for each object do 
   --    object_count += 1
   --    if current_object.number[0] != 0 
   --    or current_object.number[1] != 0 
   --    or current_object.number[2] != 0 
   --    or current_object.number[3] != 0 
   --    or current_object.number[4] != 0 
   --    or current_object.number[5] != 0 
   --    or current_object.number[6] != 0 
   --    or current_object.number[7] != 0 
   --    or current_object.object[0] != no_object 
   --    or current_object.object[1] != no_object 
   --    or current_object.object[2] != no_object 
   --    or current_object.object[3] != no_object then
   --       megalo_object_count += 1
   --    end
   -- end
end

-- player intro stuff
-- into message
for each player do
   if current_player.p_initilized <= 901 then -- max out to 900
      current_player.p_initilized += 1
      if current_player.p_initilized == 450 then
         send_incident(juggernaut_game_start, current_player, no_player)
         game.show_message_to(current_player, none, "Thanks to: Mr Dr Milk, & DavidJCobb for helping make this beast come to life!!")
      end
   end
end
for each player do
   if current_player.p_initilized == 500 then
      game.show_message_to(current_player, none, "Shoutout to: Rabid Magicman, Cleanser Of Noobs & A1ex W for the ideas")
   end
end
for each player do
   if current_player.p_initilized == 800 and current_player.team == DEFENDERS then
      game.show_message_to(current_player, none, "Objective: Destroy ALL 4 legs to expose the Core\r\nOptional:Destroy the AA Turret")
   end
end
for each player do
   if current_player.p_initilized == 250 then
      game.play_sound_for(current_player, inv_cue_spartan_win_1, true)
   end
end
-- title card
for each player do
   if current_player.team == DEFENDERS then -- banished version: Set a fire in your heart spartan
      current_player.set_round_card_title("Behold, Greatness\r\nDefend the city & assault the scarab \r\nMade by Gamergotten. V%n.%n", verion_prefix, version_vers)
      current_player.set_round_card_text("Defense")
      current_player.set_round_card_icon(defend)
      if current_player.p_initilized == 450 then
         send_incident(team_defense, current_player, no_player)
      end
   end
end
for each player do
   if current_player.team == ATTACKERS then
      current_player.set_round_card_title("Behold, Greatness\r\nBRUN THE CITY TO THE GROUND\r\nMade by Gamergotten. V%n.%n", verion_prefix, version_vers)
      current_player.set_round_card_text("Offense")
      current_player.set_round_card_icon(attack)
      if current_player.p_initilized == 450 then
         send_incident(team_offense, current_player, no_player)
      end
   end
end


alias spartan_traits = script_traits[0]
alias elite_traits = script_traits[1]
--alias minor_traits = script_traits[2]
alias ranger_traits = script_traits[2]
alias general_traits = script_traits[3]
alias zealot_traits = script_traits[4]
--alias minor_biped_index = 2
alias ranger_biped_index = 2
alias general_biped_index = 3
alias zealot_biped_index = 4

alias buff200_traits = script_traits[5]
alias supplied_traits = script_traits[6]

-- invasion stuff whatever
-- setup elite species
for each player do
   current_player.set_co_op_spawning(true)
   if current_player.team == ATTACKERS then -- attackers are elites
      current_player.apply_traits(elite_traits)
      current_player.set_loadout_palette(elite_tier_1)
      if current_player.biped != no_object then
         temp_obj0 = current_player.biped
         temp_obj6 = current_player.try_get_vehicle()
         if temp_obj0.bpd_initialized == 0 and temp_obj6 == no_object then
            -- if temp_obj6 != no_object then
            --    current_player.force_into_vehicle(no_object)
            -- end
            temp_obj4 = no_object -- incase of invalid cases
            temp_obj5 = no_object 
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
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,general)
               temp_obj4.bpd_initialized = general_biped_index
            end
            if temp_obj1.is_of_type(energy_sword) then -- is a zealot elite
               temp_obj5 = temp_obj0.place_between_me_and(temp_obj0, evade, 0) 
               temp_obj4 = temp_obj0.place_at_me(elite, none, none, 0,0,0,zealot)
               temp_obj4.bpd_initialized = zealot_biped_index
            end
            -- if temp_obj4 == no_object then -- error prevention
            --    game.show_message_to(all_players, none, "Failed to spawn elite biped.")
            -- end
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
               current_player.add_weapon(temp_obj2)
               current_player.add_weapon(temp_obj1)
               current_player.frag_grenades = 0
               current_player.plasma_grenades = 2
               -- if temp_obj6 != no_object then
               --    current_player.force_into_vehicle(temp_obj6)
               -- end
            end
         end
      end
   end
end
for each player do
   -- trait heirarchy, we'll probably have to revert it, but thats 4 free actions while its like this, or 3 i think
   temp_obj4 = current_player.biped 
   if temp_obj4.bpd_initialized >= ranger_biped_index then 
      current_player.apply_traits(ranger_traits)
      if temp_obj4.bpd_initialized >= general_biped_index then 
         current_player.apply_traits(general_traits)
         if temp_obj4.bpd_initialized >= zealot_biped_index then 
            current_player.apply_traits(zealot_traits)
         end
      end
   end
end
for each player do
   if current_player.team == DEFENDERS then -- spartans are defending
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
   script_widget[1].set_value_text("Cargo Physics: you will experience jitter while inside")
   --script_widget[0].set_value_text("%n objects %n megalo", object_count, megalo_object_count)
   scarab_health_widget.set_text("Scarab Health")
   scarab_health_widget.set_meter_params(timer, scarab_health_display)
   objective_widget.set_text("Fortified")

   scarab_status_widget.set_text("legs destroyed %n/%n\r\n (Core Locked)", scrb_mover.legs_destroyed, legs_destroyed_to_perma_down)
   if scrb_mover.legs_destroyed >= legs_destroyed_to_perma_down then
      scarab_status_widget.set_text("Core Exposed")
   end
end
for each player do 
   objective_widget.set_visibility(current_player, false)
   temp_obj0 = current_player.try_get_vehicle()
   if temp_obj0 == no_object then
      for each object with label "S_Ob_Point" do
         if current_object.team == team[2] and current_object.shape_contains(current_player.biped) then
            objective_widget.set_visibility(current_player, true)
            current_player.apply_traits(supplied_traits)
         end
      end
   end
   -- if temp_obj0 != no_object and temp_obj0.has_forge_label("B_Turret") or temp_obj0.has_forge_label("scale") then
   --    current_player.force_into_vehicle(no_object)
   -- end
end
for each object with label "B_Turret" do
   for each player do
      if current_player.biped != no_object then
         temp_num0 = current_object.get_distance_to(current_player.biped)
         if temp_num0 == 0 then
            current_player.biped.detach()
         end
      end
   end
end
-- if game.round_time_limit > 0 and game.round_timer.is_zero() and game_end_state == 0 then 
--    UNSC_WIN()
-- end

alias ticks_till_game_end_after_destroy = -300
if game_end_state < 0 then 
   game_end_state -= 1
   if game_end_state < ticks_till_game_end_after_destroy then
      game.end_round()
   end
end

-- alias max_object_dead_ticks = 300
-- -- debris early cleanup script
-- for each object do 
--    temp_num0 = current_object.health 
--    if temp_num0 <= 0 then
--       current_object.number[7] += 1
--       if current_object.number[7] > max_object_dead_ticks then
--          current_object.delete()
--          game.show_message_to(all_players, none, "cleaned up")
--       end
--    end   
-- end