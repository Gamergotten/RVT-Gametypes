
declare global.number[0] with network priority local
declare global.number[1] with network priority local
declare global.number[2] with network priority local
declare global.number[3] with network priority local
declare global.number[4] with network priority local
declare global.number[5] with network priority local
declare global.number[6] with network priority local
declare global.number[7] with network priority local
declare global.number[8] with network priority low
declare global.number[9] with network priority local
declare global.number[10] with network priority local
declare global.number[11] with network priority local
declare global.object[0] with network priority local
declare global.object[1] with network priority local
declare global.object[2] with network priority local
declare global.object[3] with network priority local
declare global.object[4] with network priority local
declare global.object[5] with network priority local
declare global.object[6] with network priority local
declare global.object[7] with network priority local
declare global.object[8] with network priority local
declare global.object[9] with network priority local
declare global.object[10] with network priority high
declare global.object[11] with network priority local
declare global.object[12] with network priority low
declare global.object[13] with network priority low
declare global.object[14] with network priority local
declare global.object[15] with network priority local
declare global.player[0] with network priority local
declare global.team[0] with network priority local = team[0]
declare global.team[1] with network priority local = team[1]
declare global.team[2] with network priority high
declare global.team[4] with network priority local = team[0]      -- brute flag (always red)
declare global.timer[0] = 5
declare global.timer[1] = 8
declare global.timer[2] = 250
declare global.timer[3] = 12        -- Rabid access announcement delay
declare player.number[0] with network priority local
declare player.number[1] with network priority local
declare player.number[2] with network priority low
declare player.number[3] with network priority local
declare player.number[4] with network priority local
declare player.object[0] with network priority local
declare player.object[1] with network priority local
declare player.object[2] with network priority local
declare player.object[3] with network priority local
declare player.timer[1] = 5
declare object.number[0] with network priority low
declare object.number[1] with network priority local
declare object.number[2] with network priority low
declare object.number[3] with network priority low
declare object.number[4] with network priority local
declare object.number[5] with network priority local
declare object.number[6] with network priority local
declare object.number[7] with network priority local
declare object.object[0] with network priority low
declare object.object[1] with network priority low
declare object.object[2] with network priority low
declare object.object[3] with network priority low
declare object.player[0] with network priority local
declare object.player[1] with network priority low
declare object.timer[0] = script_option[0]
declare object.timer[2] = 100    -- leg health waypoint.    scarab distracted_timer.

alias distracted_timer = object.timer[2] 
alias c_goal = global.object[11]
alias Scarab = global.object[10]
alias s_target = object.object[1]


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


-- Rabid added
alias access_point_announcement_delay = global.timer[3]
if access_point_announcement_delay.is_zero() and global.object[10].number[0] >= 0 then
   access_point_announcement_delay.reset()
   game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
   game.play_sound_for(global.team[0], inv_spire_vo_spartan_p1_extra, false)     -- you must maintain control of that platform spartans!
end 

function trigger_0()
   if global.timer[1].is_zero() then 
      game.play_sound_for(global.team[0], announce_a_under_attack, true)
   end
   global.timer[1].reset()
end

function trigger_1()
   global.object[0].attach_to(global.object[4], 0, 0, 0, relative)
   global.object[0].detach()
   global.object[0].face_toward(global.object[0], 0, -1, 0)
   global.object[1].attach_to(global.object[0], 0, 0, 0, relative)
end

function trigger_2()
   trigger_1()
   global.object[0].face_toward(global.object[2], 0, 0, 0)
   global.object[1].detach()
   global.object[0].attach_to(global.object[1], 0, 0, 0, relative)
   global.object[1].face_toward(global.object[2], 0, 0, 0)
   global.object[1].face_toward(global.object[1], 0, -1, 0)
   global.object[0].detach()
   global.object[1].delete()
   global.object[1] = global.object[0].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
   global.object[1].copy_rotation_from(current_object, true)
   global.object[1].attach_to(global.object[0], 100, 0, 0, relative)
   global.object[0].set_scale(global.number[0])
   global.object[0].copy_rotation_from(global.object[0], true)
end

function trigger_3()
   global.object[1] = global.object[4].place_between_me_and(global.object[4], sound_emitter_alarm_2, 0)
   global.object[0] = global.object[1].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
   trigger_2()
end

function trigger_4()
   if global.number[0] > 0 then 
      global.number[0] -= 1
      global.number[2] = global.number[3]
      global.number[2] /= 33
      global.number[1] = global.number[3]
      global.number[1] /= 228
      global.number[3] += global.number[2]
      global.number[3] += global.number[1]
      trigger_4()
   end
end

function trigger_5()
   if global.object[2].spawn_sequence != 0 then 
      global.number[3] = 100     
      global.number[0] = global.object[2].spawn_sequence
       if global.object[2].spawn_sequence < 0 then 
         global.number[0] *= 5
         global.number[3] += global.number[0]
         if global.object[2].spawn_sequence <= -20 then 
            global.number[0] = global.object[2].spawn_sequence
            global.number[0] += 201
            if global.object[2].spawn_sequence == -20 then 
               global.number[3] = 1
            end
         end
      end
       if global.object[2].spawn_sequence < -20 or global.object[2].spawn_sequence > 0 then 
         global.number[3] = 100
         -- cosmic scale.     2nd condition exempts scarab's front right leg ODST pods from scaling up.
         if global.object[2].team == team[0] and global.object[2].has_forge_label("scale") then       -- and not global.object[2].has_forge_label("L_Attach")
            global.number[3] = 32732
         end
         trigger_4()
      end
      global.object[2].set_scale(global.number[3])
      global.object[2].copy_rotation_from(global.object[2], false)
   end
end

function trigger_7()
   global.object[1] = global.object[4].place_between_me_and(global.object[4], sound_emitter_alarm_2, 0)
   global.object[0] = global.object[1].place_at_me(sound_emitter_alarm_2, "configure_scale", none, 0, 0, 0, none)
   do
      global.object[2] = global.object[7].place_between_me_and(global.object[7], sound_emitter_alarm_2, 0)
      global.number[0] = global.object[2].get_distance_to(global.object[1])
      trigger_2()
      global.object[0].number[0] = global.number[0]
      global.object[2].delete()
      global.object[2] = global.object[7]
       if global.object[2].has_forge_label("B_Attach") or global.object[2].has_forge_label("U_Attach") or global.object[2].has_forge_label("L_Attach") or global.object[2].has_forge_label("L_Damage") then 
         trigger_5()
      end
      global.object[7].attach_to(global.object[1], 0, 0, 0, relative)
      global.object[0].attach_to(global.object[4], 0, 0, 0, relative)
      global.object[0].object[0] = global.object[4]
      global.object[0].object[1] = global.object[1]
      global.object[0].object[2] = global.object[7]
      global.object[0].number[1] = 1
      global.object[0].team = global.object[7].team
   end
end

function trigger_9()
   global.object[7] = current_object
   trigger_7()
end

function trigger_10()
   --global.object[0] = global.object[1].place_at_me(covenant_bomb, "Detonation", none, 0, 0, 0, none)
   global.object[0] = global.object[1].place_at_me(phantom, "Detonation", none, 0, 0, 0, none)
   --global.object[0].number[4] = 40
   --global.object[0].set_scale(1)
   
   -- only 1 in 4 chance of phantom explosion during final meltdown chain reaction explosions (otherwise too much phantom debris, causing floor grids to delete).
   if global.object[10].number[0] <= -435 then
      -- do exactly 3 phantom explosions in final meltdown.
      if global.object[10].number[0] != -436 and global.object[10].number[0] != -446 and global.object[10].number[0] != -456 then
         --global.number[1] = rand(4)
         --if global.number[1] != 0 then
            global.object[0].delete()
            global.object[0] = global.object[1].place_at_me(covenant_bomb, "Detonation", none, 0, 0, 0, none)
         --end
      end
   end
   global.object[0].attach_to(global.object[1], 0, 0, 0, relative)
end

function trigger_11()
   current_object.detach()
   global.object[0] = current_object.place_between_me_and(current_object, dice, 0)
   global.object[0].set_scale(1)    -- Rabid added
   global.object[1] = current_object.place_at_me(landmine, "Detonation", none, -3, 0, 0, none)
   --global.object[1].kill(true)
   --global.object[0].push_upward()
   --global.object[0].push_upward()
   current_object.attach_to(global.object[0], 0, 0, 0, relative)
   
   --global.object[1] = current_object.place_at_me(fusion_coil, none, none, -3, 0, 0, none)
   --global.number[1] = rand(100)
   --global.object[1].health = global.number[1]
end

--for each object do
   --if current_object.is_of_type(fusion_coil) then
      --current_object.set_scale(1)
      --current_object.health -= 1
   --end
--end



function trigger_12()
   if global.object[0] != no_object and not global.object[10].shape_contains(global.object[0]) and global.number[2] != 0 then 
       if global.object[10].object[3].shape_contains(global.object[0]) then 
         global.number[2] /= 4
      end
       if global.object[10].object[2].shape_contains(global.object[0]) then 
         global.number[2] += 150
      end
      if global.number[2] < global.number[1] and current_player.number[1] == 0 then 
         global.number[1] = global.number[2]
         global.object[1] = global.object[0]
      end
   end
end

function trigger_13()
   global.object[14].set_scale(22)
   global.object[14].copy_rotation_from(global.object[14], true)
   global.object[10].detach()
   global.object[14].set_scale(100)
   global.object[14].copy_rotation_from(global.object[14], true)
end

function trigger_14()
   global.object[10].number[5] = 0
   global.object[10].number[4] = 0
end

--function trigger_15()
   --global.object[0] = global.object[10].object[1].place_between_me_and(global.object[10].object[1], hill_marker, 0)
   --global.object[0].set_waypoint_priority(high)
   --global.object[0].team = global.team[0]
   --global.object[0].attach_to(global.object[11], 0, 0, 0, relative)
--end

function trigger_16()
   global.number[3] = 1
   global.number[3] &= global.object[10].number[6]
    if global.number[3] == global.number[4] then 
      global.object[10].number[6] &= 1
   end
    if global.number[3] != global.number[4] then 
      global.object[10].number[6] += 2
      global.number[3] = 6
      global.number[3] &= global.object[10].number[6]
      if global.number[3] > 4 then 
         global.object[10].number[6] |= 320
      end
   end
   global.number[3] = 1
end

function trigger_18()
   global.object[0].object[1].detach()
   global.object[0].object[1].face_toward(global.object[1], 0, 0, 0)
   global.object[0].object[2].detach()
   global.object[0].object[2].face_toward(global.object[1], 0, 0, 0)
   global.number[0] = global.object[0].object[1].get_distance_to(global.object[1])
   global.object[0].object[2].attach_to(global.object[0].object[1], 0, 0, 0, relative)
end

function trigger_19()
   global.object[1] = global.object[10].object[1]
   trigger_18()
   global.object[0].object[1].attach_to(global.object[0], 0, 0, 0, relative)
end

function trigger_20()
   global.object[4].object[0] = global.object[4].place_between_me_and(global.object[4], sound_emitter_alarm_2, 0)         -- capture_plate (test)
   global.object[4].detach()
   --global.object[4].object[0].set_scale(1)      -- this doesn't scale for clients
   global.object[4].copy_rotation_from(global.object[0].object[2], true)
end

function trigger_21()
   global.object[1] = global.object[4].place_between_me_and(global.object[4], sound_emitter_alarm_2, 0)
   global.object[0] = global.object[1].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
   trigger_1()
   global.object[0].copy_rotation_from(global.object[4], true)
   global.object[1].detach()
end

function trigger_22()
   global.number[3] = 0
   if not global.object[10].object[2].shape_contains(global.object[10].object[1]) and global.object[10].number[3] == 0 then 
      global.object[13].object[0].detach()
      global.object[13].object[1].detach()
      global.number[0] = global.object[13].object[0].get_distance_to(global.object[10].object[1])
      global.number[1] = global.object[13].object[1].get_distance_to(global.object[10].object[1])
      global.number[2] = global.object[10].get_distance_to(global.object[10].object[1])
      global.object[13].object[1].attach_to(global.object[10], 2, 2, 0, relative)
      global.object[13].object[0].attach_to(global.object[10], 2, -2, 0, relative)
      global.object[10].detach()
       if global.object[10].number[6] >= 16 then 
         global.object[10].number[6] -= 16
         global.number[3] = -1
      end
       if global.number[3] == 0 and global.number[2] < global.number[0] and global.number[2] < global.number[1] then 
         global.object[10].face_toward(global.object[10], 127, 1, 0)
         global.number[3] = 1
      end
       if global.number[3] == 0 and global.number[0] < global.number[1] then 
         global.number[4] = 1
         trigger_16()
         global.object[10].number[6] |= global.number[4]
         global.object[10].face_toward(global.object[10], 127, -1, 0)
      end
       if global.number[3] == 0 and global.number[0] > global.number[1] then 
         global.number[4] = 0
         trigger_16()
         global.object[10].number[6] &= -2
         global.object[10].face_toward(global.object[10], 127, 1, 0)
      end
      global.object[10].attach_to(global.object[13], 0, 0, 0, relative)
   end
end

function trigger_23()
   global.object[0] = current_object
   global.object[1] = current_object.object[3]
   trigger_18()
   current_object.object[1].attach_to(current_object.object[0], 0, 0, 0, relative)
end

function trigger_24()
   global.object[10].detach()
   global.object[14].copy_rotation_from(global.object[10], true)
   global.object[14].attach_to(global.object[10], 0, 0, 0, relative)
   global.object[14].detach()
end

function trigger_25()
   -- damage targeted building if in range, and not an AA flak projectile
   if current_object.number[5] == global.object[11].spawn_sequence and not current_object.is_of_type(light_blue) then 
      global.object[11].number[4] += 1
      trigger_0()
      
      -- removed to avoid expected overloading.
      -- rubble on hit.    Looks incredible, but surely waaaaaay too many objects and will cause overloading.
      global.number[0] = global.object[11].number[4]
      global.number[0] %= 12         -- using 6 instead of 7 means the rubble gets varying launch strength depending on when in the volley it spawns.      consider using 12 for half as frequent to lessen overloading.
      if global.number[0] == 0 then
         global.object[0] = current_object.place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         --global.object[0].attach_to(current_object, 0,0,0, relative)       -- Optional line. detaches further down. With this the rubble tends to launch less and more evenly.  however sometimes pings the covie bombs away.
         -- Without the attach line, rubble launches further and in a small angle, in some ways more realistic, but a bit repetitive. Also in some cases the barrier appears a long distance from the wall (which looks bad).
         global.object[0].attach_to(current_object, -1,0,0, relative)         -- attaching 1 behind looks great, doesn't ping covie bombs as much, but launches a lot further than 0 distance.
      end
   end
   -- either way, detonate the bomb.
   --current_object.object[0].detach()
   --current_object.object[0].kill(false)
   --current_object.delete()
   -- Rabid: create bomb only at the moment of impact.
   global.object[0] = current_object.place_at_me(covenant_bomb, "Detonation", none, 0,0,0, none)
   global.object[0].attach_to(current_object.object[0], 0,0,0,relative)
   global.object[0].object[0] = current_object
end

function trigger_26()
   global.object[0].detach()
   global.object[4].object[0].face_toward(global.object[0], 0, 0, 0)
   global.object[6].object[0].detach()
   global.object[6].object[0].face_toward(global.object[0], 0, 0, 0)
   global.object[4].object[0].attach_to(global.object[6].object[0], 1, 0, 0, relative)
   global.number[0] = global.object[10].number[1]
   global.number[0] *= 5
   global.number[0] += 142
   global.object[6].object[0].set_scale(global.number[0])
   global.object[6].object[0].copy_rotation_from(global.object[6].object[0], true)
   global.object[4].object[0].detach()
   global.object[6].object[0].set_scale(100)
   global.object[6].object[0].copy_rotation_from(global.object[6].object[0], true)
   global.object[6].object[0].attach_to(global.object[4].object[0], 0, 0, 0, relative)
   global.number[0] = global.object[6].get_distance_to(global.object[0])
   global.object[0].attach_to(global.object[0].object[0], 0, 0, 0, relative)
   if global.number[0] < 12 then 
      global.object[10].number[7] = -30
      global.object[6].detach()
      global.object[6].object[0].attach_to(global.object[4].object[0], 0, 0, 0, relative)
      global.object[4].object[0].attach_to(global.object[6], 0, 0, 0, relative)
      global.object[6].number[1] = 0
   end
end

function trigger_27()
   global.object[11].number[1] = 2
   global.number[0] = 0
   for each object with label "S_Objective" do
      if current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.spawn_sequence == global.object[11].spawn_sequence and current_object.number[1] == 0 or current_object.number[1] == 1 then 
         global.number[0] += 1
      end
   end
   if global.number[0] == 0 then 
      --game.show_message_to(all_players, none, "Tower %n destroyed!", global.object[11].spawn_sequence)
      game.show_message_to(all_players, none, "Structure %n destroyed!", global.object[11].spawn_sequence)

      global.team[1].score += 1
      -- Rabid: 1st building destroyed
      --team[0].number[1] += 1
      --if team[0].number[1] == 1 then
      -- Rabid tweak. Only announce territory captured if the final objective for this building was a scarab-shot objective, because territories now always announce this earlier (even if not final piece).
      if global.object[11].team != team[0] then
         game.play_sound_for(global.team[0], announce_territories_lost, false)
         game.play_sound_for(global.team[1], announce_territories_captured, false)
         global.object[11].place_at_me(bomb, "Detonation", none, 0,0,0,none)     -- Rabid added: final destructible automatically makes a bomb explosion. warning: might mess with debris falling directions / launch stuff.
         global.object[11].place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         -- removed to reduce overloading
         --global.object[0] = global.object[11].place_at_me(heavy_barrier, "Detonation", none, 0,0,0,none)     -- Rubble   warning: will probably overload maps due to extra objects.
         --global.object[0].face_toward(global.object[0], -1,0,0)      -- rotate 2nd barrier 180 so rubble flies in 2 opposite directions.
      end
      if global.team[1].score == 1 then
         --game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
         game.play_sound_for(global.team[0], inv_spire_vo_spartan_p1_loss, false)         -- Time for a backup plan... Fall back and regroup.
         game.play_sound_for(global.team[1], inv_spire_vo_covenant_p2_win, false)      -- Well done, brothers. These humans are no match for the Covenant's might!
      end
      -- Rabid: 5th building     <-- this is correct for the final foreunner structure on moro's map
      --if team[0].number[1] == 5 then
      if global.team[1].score == 4 then
         --game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
         game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p2_intro, false)     -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core.
         --game.play_sound_for(global.team[1], inv_spire_vo_covenant_p1_win, false)         -- yes well done the humans are but dust in our vision! they will not forget this battle, we are victiorious!
         --inv_spire_vo_covenant_p1_win         -- alternative.         This one is also really very good, maybe better than p3. It's more demeaning.    This would be fine for a midpoint announcement.
         game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_win, false)      -- Well done. Push forward and crush the human defenses.
      end

      
      
      for each object with label "S_Ob_Point" do
         if current_object.spawn_sequence == global.object[11].spawn_sequence then 
            if current_object.team == team[2] then 
               global.object[1] = current_object
               for each object with label "S_Ob_Point" do
                  if current_object.team == team[0] or current_object.team == team[1] and global.object[1].shape_contains(current_object) then 
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
            if current_object.team == team[3] or current_object.team == team[2] then
               if current_object.team == team[3] then
                  current_object.place_at_me(bomb, "Detonation", none, 0,0,0,none)
               end
               current_object.delete()    -- to save on object count.
            end
         end
      end
      for each object with label "S_Objective" do
         if current_object.team == neutral_team and current_object.spawn_sequence == global.object[11].spawn_sequence then 
            global.object[1] = current_object.place_at_me(frag_grenade, "falling_object", none, 0, 0, 0, none)
            global.object[1].object[0] = current_object
            global.object[1].set_invincibility(1)
            global.object[1].attach_to(current_object, 0, 0, 0, relative)
            global.object[1].detach()
            current_object.attach_to(global.object[1], 0, 0, 0, relative)
            global.object[1].push_upward()
         end
      end
   end
   global.object[11].delete()
   -- count remaining objectives
   global.number[0] = 0
   for each object with label "S_Objective" do
      if current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.number[1] == 0 or current_object.number[1] == 1 then 
         global.number[0] += 1
      end
   end
   -- Rabid: one building remaining
   if global.number[0] == 1 and team[0].number[0] == 0 then
      --game.play_sound_for(global.team[0], inv_spire_vo_spartan_p1_extra, false)     -- you must maintain control of that platform spartans!
      --game.play_sound_for(global.team[1], inv_spire_vo_covenant_p2_win, false)      -- Well done, brothers. These humans are no match for the Covenant's might!
      game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p2_intro, false)   -- Fall back, to the refinery! Don't let the Covenant get hold of the navigation core
      game.play_sound_for(global.team[1], inv_spire_vo_covenant_p1_win, false)         -- yes well done the humans are but dust in our vision! they will not forget this battle, we are victiorious!
      team[0].number[0] = 1
   end 
   if global.number[0] <= 0 and global.number[11] == 0 then 
      global.number[11] = -1
      game.play_sound_for(all_players, inv_cue_covenant_win_big, true)
      game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p3_loss, false)    -- Navigation core compromised; we lost it. Alert Command
      --game.play_sound_for(global.team[0], inv_spire_vo_spartan_p3_loss, false)         -- No other assets available spartans. Get out of there and we'll regroup at area fox.    NOTE this is missing from Sopitive's documentation. Incorrectly listed above a different sound which isn't named.
      game.play_sound_for(global.team[1], inv_spire_vo_covenant_p3_win, false)         -- Yes, brothers! Well done! The humans have learned a harsh lesson!
      --inv_spire_vo_covenant_p1_win         -- alternative.         This one is also really very good, maybe better than p3. It's more demeaning.    This would be fine for a midpoint announcement.

   end
end

function trigger_34()
   global.object[5].delete()
   global.object[6].delete()
end

on pregame: do
   game.symmetry = 0
end


on init: do
	  -- team colour tracking, for brute flag colour.
	   global.number[0] = game.current_round
      global.number[0] %= 2
      --global.team[4] = team[0]       -- declared
      if global.number[0] != 0 then 
         global.team[4] = team[1]
      end
end

-- Rabid added
for each object with label "Detonation" do
   current_object.kill(false)
end






do
   global.timer[0].set_rate(-100%)
   global.timer[1].set_rate(-100%)
   --global.timer[2] = 0
end

if global.object[10] == no_object then 
   for each object with label "B_Misc" do
      if current_object.spawn_sequence == 0 then 
         global.object[10] = current_object
      end
   end
end

if global.object[14] == no_object and global.object[10] != no_object then 
   global.object[14] = global.object[10].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
end

if global.object[10] != no_object and global.object[10].number[0] < 0 then 
   global.object[10].number[0] -= 1
   --if global.object[10].number[0] == -130 or global.object[10].number[0] == -190 or global.object[10].number[0] == -230 then 
   if global.object[10].number[0] == -170 or global.object[10].number[0] == -230 or global.object[10].number[0] == -270 then
      global.object[1] = get_random_object("B_Attach", no_object)
      trigger_10()
   end
end

if global.object[10] != no_object and global.object[10].number[0] == -300 then        -- and global.object[10].number[0] < 0
   global.object[10].object[3] = global.object[10].place_between_me_and(global.object[10], dice, 0)
   global.object[10].object[3].copy_rotation_from(global.object[10], true)
   global.object[10].attach_to(global.object[10].object[3], 0, 0, 0, relative)
end

--if global.object[10] != no_object and global.object[10].number[0] < 0 and global.object[10].number[0] == -435 then
-- I tried to make the legs detach at the same time as the final meltdown, but it spazzes out due to the main body trying to drop/fall at an earlier time point.    <-- the block immediately above this.
if global.object[10] != no_object and global.object[10].number[0] == -330 then        -- and global.object[10].number[0] < 0
   for each object with label "U_Joint" do
      current_object.number[0] = -1
      trigger_11()
   end
   for each object with label "L_Joint" do
      trigger_11()
   end
end

if global.object[10] != no_object and global.object[10].number[0] == -450 then           -- and global.object[10].number[0] < 0
   global.object[10].detach()
   global.object[10].object[3].delete()
end

--if global.object[10] != no_object and global.object[10].number[0] < 0 and global.object[10].number[0] <= -395 and global.object[10].number[0] >= -1000 then
if global.object[10] != no_object and global.object[10].number[0] <= -435 and global.object[10].number[0] >= -1000 then         -- and global.object[10].number[0] < 0
   global.number[0] = global.object[10].number[0]
   global.number[0] %= 2
   if global.number[0] == 0 then 
      global.object[1] = no_object
      for each object with label "B_Attach" do
         if current_object.spawn_sequence != 0 and current_object.number[7] == 0 then 
            global.object[1] = current_object
         end
      end
      if global.object[1] != no_object then 
         global.object[1].number[7] = 1
         trigger_10()
         global.object[0].object[0] = global.object[1]
         --global.object[1].delete()
      end
   end
end

if global.object[10] != no_object and global.object[10].number[0] == -280 then   -- and global.object[10].number[0] < 0
   global.number[11] = -1
   game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
   --game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p1_win, true)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
   --game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_loss, true)      -- Your failure here is troubling.     The fleetmaster will be displeased to hear of this failure.       This failure will NOT go unnoticed.
   game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p3_win, true)        -- Outstanding spartans! air surpport will clean up the mess.
   game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p3_loss, true)      -- No! The humans deny us our rightful victory!     The humans defeat us this time. But SOON, they will fall.    So close, and yet the filth deny us our victory.
end

if global.object[10] != no_object and global.object[10].number[0] == 1 and global.timer[0].is_zero() then 
   global.number[0] = global.object[13].object[3].health
    if global.object[13].object[3] == no_object or global.number[0] <= 0 then 
      global.team[2] = team[0]
      game.show_message_to(all_players, none, "Scarab DESTROYED!!!")
      game.play_sound_for(global.team[1], inv_spire_vo_covenant_loss, true)      -- Our power core is lost to the humans. You shall never outlive this shame.   You've lost the power core! A thousand torments upon you!   You've lost the power core. this will not go unpunished.
      game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p1_win, true)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
      global.object[10].number[0] = -1
      global.object[10].number[2] = -1
      global.object[10].object[3].delete()
      global.object[10].object[2].delete()
      global.object[10].detach()
      global.object[13].attach_to(global.object[10], 0, 0, 0, relative)
      -- delete core waypoint
      for each object with label "L_Damage" do
         current_object.object[0].delete()
      end
   end
   --global.number[0] /= 2
   --global.timer[2] += global.number[0]
    if global.object[10].number[2] > 0 then 
      for each object with label "B_Turret" do
         if current_object.team != team[2] then 
            current_object.object[3] = no_object
         end
      end
      global.object[13].number[6] -= 1
      if global.object[10].number[2] < 86 or global.object[13].number[6] <= 0 then 
         trigger_24()
          if global.object[13].number[6] <= 0 then 
            global.object[10].attach_to(global.object[14], 0, 0, 2, relative)
            global.object[10].number[2] -= 1
         end
          if global.object[13].number[6] > 0 then 
            global.object[10].attach_to(global.object[14], 0, 0, -2, relative)
            global.object[10].number[2] += 1
            global.team[2] = team[0]
         end
         trigger_13()
         global.object[13].attach_to(global.object[10], 0, 0, 0, relative)
         global.object[13].detach()
         global.object[10].attach_to(global.object[13], 0, 0, 0, relative)
      end
   end
   if global.object[10].number[2] == 0 then 
       if global.object[11].team != team[0] and global.object[11].team != team[1] then 
         global.team[2] = no_team
      end
       if global.object[13].number[6] > 0 then 
         global.object[10].number[2] = 1
      end
      global.object[13].number[5] -= 1
       if global.object[13].number[5] <= 0 and global.object[10].number[5] == 4 or global.object[10].number[5] == 0 then 
         global.object[10].object[1] = no_object
         global.object[13].number[5] = rand(150)
         global.object[13].number[5] += 60
         --game.show_message_to(all_players, none, "B_Turret")
      end
      for each object with label "B_Turret" do
         if current_object.team != team[2] then 
            current_object.number[5] -= 1
             if current_object.number[5] <= 0 and current_object.number[4] > 30 or current_object.object[3] == no_object then 
               current_object.object[3] = no_object
               current_object.number[5] = 280
            end
             if current_object.object[3] == no_object then 
               current_object.object[1].detach()
               global.number[1] = 32000
               for each player do
                  if current_player.team == global.team[0] and current_player.biped != no_object and not global.object[10].object[2].shape_contains(current_player.biped) and current_object.object[1].shape_contains(current_player.biped) then 
                     global.number[2] = current_player.biped.get_distance_to(current_object.object[1])
                     if global.number[2] != 0 and global.number[2] < global.number[1] then 
                        global.number[1] = global.number[2]
                        current_object.object[3] = current_player.biped
                        current_object.number[6] = 0
                     end
                  end
               end
               current_object.object[1].attach_to(current_object.object[0], 0, 0, 0, relative)
            end
            current_object.number[4] -= 1
            if current_object.object[3] != no_object and not global.object[10].object[2].shape_contains(current_object.object[3]) then 
               trigger_23()
               if current_object.number[4] <= 0 then 
                  current_object.number[4] = 30
                  global.object[4] = current_object.object[2].place_at_me(light_blue, "Projectile", none, 0, 0, 0, none)
                  global.object[4].attach_to(current_object, -30, 0, 8, relative)
                  
                  --global.object[0] = global.object[4].place_at_me(monitor, "Detonation", none, 0,0,0,none)      -- AA gun firing aesthetic
                  global.object[1] = current_object.place_at_me(monitor, "Detonation", none, 0,0,0,none)      -- AA gun firing aesthetic              -- landmine. nice and loud, but very firey.
                  global.object[1].attach_to(current_object, -35, 0, 7, relative)


                  --global.object[4].object[0] = global.object[4].place_between_me_and(global.object[4], bomb, 0)
                  --global.object[4].object[0] = global.object[4].place_between_me_and(global.object[4], covenant_bomb, 0)      -- Rabid changed. this will change the AA gun flak explosion to not be blinding.
                  --global.object[4].object[0] = global.object[4].place_between_me_and(global.object[4], capture_plate, 0)
                  trigger_20()
                  global.object[4].face_toward(current_object.object[3], 0, 0, 0)
                  global.object[4].number[1] = global.object[4].get_distance_to(current_object.object[3])
                  current_object.number[6] += 1
                  if current_object.number[6] >= 7 then 
                     current_object.number[6] = 0
                     current_object.number[4] = 900
                  end
               end
            end
         end
      end
       if global.object[10].object[1] == no_object then 
         global.object[1] = no_object
         global.number[1] = 32000
         for each player do
            -- Rabid added final condition. Don't search for player targets after scarab distracted_timer has been exceeded   -- scrb_mover.time_till_retarget      <- gamergotten's alias for this.
            if current_player.team == global.team[0] and global.object[13].number[5] <= 210 then
               global.object[2] = current_player.get_vehicle()
               if not global.object[2].is_of_type(falcon) and not global.object[2].is_of_type(banshee) then       -- and not global.object[2].is_of_type(sabre)
                  global.object[0] = current_player.biped
                  global.number[2] = global.object[0].get_distance_to(global.object[10])
                  trigger_12()
               end
            end
         end
         for each object with label "S_Objective" do
            if global.object[11] == no_object or global.object[11] == current_object and current_object.team == team[2] or current_object.team == team[0] or current_object.team == team[1] or current_object.team == team[4] and current_object.number[1] == 0 or current_object.number[1] == 1 then 
               global.object[0] = current_object
               global.number[2] = global.object[0].get_distance_to(global.object[10])
               global.number[2] -= 100
               trigger_12()
            end
         end
         if global.object[1] != no_object then 
            global.object[10].object[1] = global.object[1]
             if global.object[10].number[5] != 4 then 
               trigger_14()
            end
            if global.object[10].object[1].has_forge_label("S_Objective") then 
               global.object[11] = global.object[10].object[1]
               
               
               
               if global.object[11].number[1] == 0 then 
                  global.timer[1] = 0
                  --game.play_sound_for(all_players, announce_destination_moved, false)
                  global.object[11].number[1] = 1
                  global.object[11].set_shape_visibility(everyone)
                  --trigger_15()
                  global.object[0] = global.object[10].object[1].place_between_me_and(global.object[10].object[1], sound_emitter_alarm_1, 0)       -- hill_marker
                  global.object[0].set_waypoint_priority(high)
                  global.object[0].team = global.team[0]
                  global.object[0].attach_to(global.object[11], 0, 0, 0, relative)
                  
                  global.object[11].object[0] = global.object[0]
                  global.object[11].object[0].set_waypoint_visibility(everyone)         -- enemies
                  global.object[11].object[0].set_waypoint_icon(ordnance)
                  --trigger_15()
                  --global.object[11].object[1] = global.object[0]
                  --global.object[11].object[1].set_waypoint_visibility(allies)
                  --global.object[11].object[1].set_waypoint_icon(defend)
                  -- Territory objectives
                  --access_point_announcement_delay.reset()         -- semi-redundant. this stops the dialogue announcement from playing late if the elites cap one too quickly (within 12 seconds). 
                  if global.object[11].team == team[0] or global.object[11].team == team[1] then
                     -- Consider having a one time voiceover announcement here for one of the occassions where there's a capture/territory objective.
                     access_point_announcement_delay.set_rate(-100%)
                     --game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
                     global.object[11].object[0].set_waypoint_timer(0)
                     --global.object[11].object[1].set_waypoint_timer(0)
                     global.object[11].set_progress_bar(0, everyone)
                     --global.object[0] = global.object[11].place_at_me(sound_emitter_alarm_1, none, none, 0, 0, 0, none)
                     --global.object[0].attach_to(global.object[11], 0, 0, 0, relative)
                     --for each player do
                        --if current_player.team == global.team[1] then
                           --script_widget[1].set_visibility(current_player, true)
                        --end
                     --end
                  end
               end
            end
         end
      end
      if global.object[10].object[1] != no_object then
         
         -- Rabid added. Scarab 
         Scarab.distracted_timer.set_rate(100%)
         --Scarab.set_waypoint_visibility(everyone)
         --Scarab.set_waypoint_timer(2)
         if Scarab.s_target != c_goal then
            Scarab.distracted_timer.set_rate(-125%)      -- 80 seconds spent chasing players
            if Scarab.distracted_timer.is_zero() and Scarab.firing_mode == f.cooling or Scarab.firing_mode == f.moving then
               Scarab.distracted_timer.reset()
               Scarab.s_target = c_goal
               global.object[13].number[5] = 1800   -- spend next 30 seconds ignoring players      -- scrb_mover.time_till_retarget      <- gamergotten's alias for this.
            end
         end
         --if Scarab.distracted_timer.is_zero()
      
      
         global.object[0] = global.object[10].object[1]
         global.player[0] = global.object[0].player[1]
         for each player do
            if global.player[0] != current_player or not global.object[10].object[2].shape_contains(global.object[10].object[1]) then 
               current_player.timer[1].set_rate(50%)
            end
         end
         trigger_22()
         
         -------- Rabid added. Scarab has a max amount of time it will chase any single player. currently 50 seconds. It will be much less if the player drives under the scarab due to previous dickhead_timer stuff.
         -- Rabid added. aliased version.
         --if temp_player0 != no_player then
            --temp_player0.dickhead_timer.set_rate(-10%)
            --if temp_player0.dickhead_timer.is_zero() then -- they are being a dickhead
               --temp_player0.is_a_dickhead = dickhead_ticks
               --Scarab.s_target = no_object -- clear this target and wait till they behave 
            --end
         --end
         -- Rabid added. unaliased
         if global.player[0] != no_player then
            global.player[0].timer[1].set_rate(-10%)
            if global.player[0].timer[1].is_zero() then -- they are being a dickhead.  Or the scarab has been chasing them too long (up to 50 seconds)
               global.player[0].number[1] = 1500      -- 25 second ignorance time.
               Scarab.s_target = no_object -- clear this target and wait till they behave. 
            end
         end
         --------
         if global.object[10].object[2].shape_contains(global.object[10].object[1]) and global.object[10].number[5] < 4 then 
            global.object[10].number[3] = rand(150)
            global.object[10].number[3] += 30
            trigger_14()
            if global.player[0] != no_player then 
               global.player[0].timer[1].set_rate(-100%)       -- dickhead timer (they are intentionally sitting below the scarab).
               --if global.player[0].timer[1].is_zero() then         -- moved above.
                  --global.player[0].number[1] = 1500
                  --global.object[10].object[1] = no_object
               --end
            end
         end
         global.number[1] = 0
         global.object[0] = global.object[10].object[3]
          if global.object[0].object[1] == no_object then 
            global.object[0].object[2] = global.object[0].place_between_me_and(global.object[0], sound_emitter_alarm_2, 0)
            global.object[0].object[1] = global.object[0].object[2].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
            global.object[0].object[1].attach_to(global.object[0], 0, 0, 0, relative)
            global.object[0].object[1].detach()
            global.object[0].object[1].face_toward(global.object[0].object[1], 0, -1, 0)
            global.object[0].object[2].attach_to(global.object[0].object[1], 0, 0, 0, relative)
            global.object[0].object[1].attach_to(global.object[0], 0, 0, 0, relative)
         end
          if global.object[10].number[3] == 0 then 
             if not global.object[10].object[3].shape_contains(global.object[10].object[1]) and global.object[10].number[5] != 3 then 
               if global.object[10].number[5] < 4 then 
                  global.object[10].number[5] = 0
                  global.object[10].number[4] = 2
               end
            end
            global.object[10].number[4] -= 1
             if global.object[10].number[4] <= 0 then 
               global.object[10].number[5] += 1
               if global.object[10].number[5] >= 1 then 
                  global.object[10].number[4] = 60
                  if global.object[10].number[5] >= 2 then 
                     global.object[10].number[4] = 90
                     if global.object[10].number[5] >= 3 then 
                        global.object[10].number[4] = 255
                        global.object[0].number[4] = 0
                        if global.object[10].number[5] >= 4 then 
                           global.object[10].number[4] = 190
                           if global.object[10].number[5] > 4 then 
                              trigger_14()
                              if global.object[10].object[3].shape_contains(global.object[10].object[1]) then 
                                 global.object[10].number[5] = 2
                                 global.object[10].number[4] = 90
                              end
                           end
                        end
                     end
                  end
               end
            end
            if global.object[10].number[5] == 3 or global.object[10].number[5] == 2 and global.object[10].object[1] != global.object[11] or global.object[11].team == team[2] then 
               trigger_19()
               if global.object[10].number[5] == 3 then 
                   if global.object[0].number[4] >= 95 then 
                     global.number[0] = global.object[0].number[1]
                     global.number[0] %= 5
                     global.object[0].number[1] -= 1
                      if global.number[0] == 0 then 
                        global.object[4] = global.object[0].object[2].place_at_me(light_green, "Projectile", none, 0, 0, 0, none)
                        global.object[4].attach_to(global.object[0].object[2], 0, 0, 0, relative)
                        --global.object[4].object[0] = global.object[4].place_between_me_and(global.object[4], covenant_bomb, 0)
                        trigger_20()
                        global.object[4].number[1] = 500
                        global.object[4].number[5] = global.object[1].spawn_sequence
                     end
                     if global.object[0].number[1] <= 0 then 
                        global.object[0].number[4] = 0
                     end
                  end
                  if global.object[0].number[4] < 95 then 
                     global.object[0].number[4] += 1
                     global.object[0].number[1] = 35
                     if global.object[0].number[4] == 95 then 
                        game.play_sound_for(all_players, boneyard_generator_power_down, true)
                     end
                  end
               end
            end
         end
         if global.number[3] < 1 or global.object[10].number[3] > 0 and global.object[10].number[5] < 2 then 
            trigger_24()
             if global.object[10].number[3] <= 0 then 
               global.object[10].attach_to(global.object[14], 1, 0, 0, relative)
            end
             if global.object[10].number[3] > 0 then 
               global.object[10].number[3] -= 1
               global.object[10].attach_to(global.object[14], -2, 0, 0, relative)
            end
            trigger_13()
             if not global.object[10].is_out_of_bounds() then 
               global.object[13].attach_to(global.object[10], 0, 0, 0, relative)
               global.object[13].detach()
            end
            global.object[10].attach_to(global.object[13], 0, 0, 0, relative)
         end
      end
   end
end

if global.object[10] != no_object and global.object[10].number[0] == 0 then 
   global.object[13] = global.object[10].place_at_me(capture_plate, none, none, 0, 0, 0, none)
   global.object[10].number[0] = 1
   global.object[0] = global.object[10].place_at_me(sound_emitter_alarm_1, none, none, 0, 0, 0, none)
   global.object[0].attach_to(global.object[10], 0, 0, 0, relative)
   global.object[4] = global.object[10]
   for each object with label "B_Attach" do
      if current_object.team != team[6] then 
         trigger_9()
      end
   end
   for each object with label "B_Misc" do
      if current_object.spawn_sequence >= 1 and current_object.spawn_sequence <= 5 or current_object.spawn_sequence == 9 then 
         trigger_9()
          if current_object.spawn_sequence > 1 then 
            current_object.object[0] = global.object[0].object[1]
            if current_object.spawn_sequence == 2 then 
               global.object[10].object[3] = current_object
            end
         end
         if current_object.spawn_sequence == 1 then 
            global.object[10].object[2] = current_object
         end
      end
   end
   for each object with label "B_Turret" do
      if current_object.spawn_sequence == 0 and current_object.team != team[2] then 
         global.object[0] = current_object
         global.object[4] = no_object
         for each object with label "B_Turret" do
            if current_object.team == team[2] and current_object.spawn_sequence == global.object[0].spawn_sequence then 
               global.object[4] = current_object
            end
         end
         if global.object[4] != no_object then 
            current_object.max_health *= script_option[5]
            current_object.health = 100
            trigger_21()
            global.object[1].face_toward(global.object[1], 0, 1, 0)
            global.object[0].delete()
            current_object.object[1] = global.object[4]
            current_object.object[2] = global.object[1]
            current_object.object[2].attach_to(current_object.object[1], 0, 0, 0, relative)
            current_object.attach_to(current_object.object[2], 4, -4, 0, relative)
            global.object[4] = global.object[10]
            global.object[7] = current_object.object[1]
            trigger_7()
            current_object.object[0] = global.object[0].object[1]
            --global.object[1] = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
            --global.object[1].set_waypoint_visibility(enemies)         -- Rabid removed. I feel like the AA gun waypoint visibility is unnecessary and a little confusing. Also game is more fun and cool when it's not destroyed.
            --global.object[1].team = global.team[1]          -- maybe redundant
            --global.object[1].attach_to(current_object, 0, 0, 0, relative)
         end
      end
   end
   global.object[13].number[6] = 0
   global.object[13].object[1] = global.object[10].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
   global.object[13].object[0] = global.object[10].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
   for each object with label "L_Damage" do
      if current_object.team == neutral_team then 
         current_object.max_health = script_option[2]
         current_object.max_health *= 25
         current_object.health = 100
         trigger_9()
         global.object[13].object[3] = current_object
         global.object[13].object[3].set_invincibility(1)
      end
   end
   for each object with label "U_Joint" do
      global.object[4] = global.object[10]
      trigger_9()
      current_object.object[0] = global.object[0].object[1]
      current_object.number[0] = 1
      global.object[6] = current_object
      for each object with label "L_Joint" do
         if current_object.team == global.object[6].team and global.object[4] != no_object then 
            global.object[6].face_toward(current_object, 0, 0, 0)
            global.object[4] = global.object[6]
            trigger_21()
            global.object[6].object[1] = global.object[1]
            global.object[0].delete()
            global.object[6].object[1].face_toward(current_object, 0, 0, 0)
            global.object[4] = global.object[6].object[1]
            global.object[4].team = global.object[6].team
            for each object with label "U_Attach" do
               if current_object.team == global.object[6].team then 
                  trigger_9()
               end
            end
            global.object[4] = global.object[6].object[1]
            trigger_9()
            global.object[6].object[2] = current_object
            current_object.object[0] = global.object[0].object[1]
            global.object[0] = no_object
            for each object with label "B_Misc" do
               if current_object.spawn_sequence == 6 and current_object.team == global.object[6].team then 
                  global.object[0] = current_object
               end
            end
            global.object[1] = global.object[6].place_between_me_and(global.object[6], sound_emitter_alarm_2, 0)
            global.object[2] = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            global.object[6].number[2] = global.object[2].get_distance_to(global.object[1])
            current_object.detach()
             if global.object[0] != no_object then 
               global.object[6].object[3] = global.object[0].place_at_me(bomb, none, never_garbage_collect, 0, 0, 0, none)
               global.object[6].object[3].set_invincibility(1)
               global.object[6].object[3].set_pickup_permissions(no_one)
               current_object.face_toward(global.object[0], 0, 0, 0)
               global.object[1].attach_to(global.object[0], 0, 0, 0, relative)
               global.object[1].detach()
               global.object[6].number[3] = global.object[2].get_distance_to(global.object[1])
               global.object[0].delete()
               global.object[4].object[3] = global.object[4].place_at_me(sound_emitter_alarm_2, none, never_garbage_collect, 0, 0, 0, none)
               global.object[4].object[3].copy_rotation_from(global.object[4], true)
               global.object[4].object[2] = global.object[4].place_at_me(sound_emitter_alarm_2, none, never_garbage_collect, 0, 0, 0, none)
               global.object[4].object[2].attach_to(global.object[4].object[3], 1, 0, 0, relative)
               global.object[4].object[3].face_toward(global.object[4].object[3], -1, 0, 0)
               global.object[4].object[3].attach_to(global.object[4], 0, 0, 0, relative)
               global.object[4] = global.object[6].object[3]
               global.object[2].delete()
               global.object[1].delete()
               trigger_21()
               global.object[1].object[0] = global.object[0]
               global.object[4].object[0] = global.object[1]
               global.object[4].object[0].attach_to(global.object[1].object[0], 0, 0, 0, relative)
               global.object[1].object[0].attach_to(global.object[4], 0, 0, 0, relative)
               for each object with label "B_Misc" do
                  if current_object.team == global.object[6].team then 
                      if current_object.spawn_sequence == 3 then 
                        global.object[4].object[1] = current_object
                     end
                      if current_object.spawn_sequence == 4 then 
                        global.object[4].object[3] = current_object
                     end
                     if current_object.spawn_sequence == 5 then 
                        global.object[4].object[2] = current_object
                     end
                  end
               end
            end
            global.object[4] = current_object
            for each object with label "L_Attach" do
               if current_object.team == global.object[6].team then 
                  trigger_9()
               end
            end
            for each object with label "L_Damage" do
               if current_object.team == global.object[6].team then 
                  trigger_9()
                  global.object[4].object[2] = global.object[0]
                  global.object[4].object[1] = current_object
                  current_object.max_health = script_option[3]
                  current_object.max_health *= 250
                  current_object.health = 100
                  global.object[0] = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
                  global.object[0].set_waypoint_visibility(enemies)
                  global.object[0].team = global.team[1]
                  global.object[0].attach_to(current_object, 0, 0, 40, relative)
                  -- rabid added. for waypoint blinking on hit.
                  current_object.object[0] = global.object[0]
                  global.object[0].object[0] = current_object
                  global.object[0].number[7] = 100
               end
            end
            --current_object.object[3] = current_object.place_between_me_and(current_object, bomb, 0)
            --current_object.object[3].attach_to(current_object, 0, 0, 0, relative)
            current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
            global.object[4] = no_object
         end
      end
   end
end

for each object with label "L_Joint" do
   if current_object.object[2] != no_object and current_object.number[1] == 0 then 
      global.number[0] = current_object.object[1].health
      global.number[0] -= 50
      --global.timer[2] += global.number[0]
      if current_object.object[1] == no_object or global.number[0] < 0 then 
         --game.show_message_to(all_players, none, "Leg Knocked Out!")
         global.object[13].number[6] = 1800
         global.object[13].number[2] += 1
         game.show_message_to(all_players, none, "Leg %n Crippled!", global.object[13].number[2])
         --current_object.object[3].detach()
         --current_object.object[3].kill(false)
         global.object[0] = current_object.place_at_me(bomb, "Detonation", none, 0,0,0,none)
         current_object.attach_to(current_object.object[1], 0, 0, 0, relative)      -- I think/hope this is the L_atatch object.
         current_object.object[2].delete()
         current_object.number[1] = 1
         -- luxury. little success & failure message when 3 of the 4 legs have been knocked out
         if global.object[13].number[2] == 3 then
            --game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p1_win, false)        -- Nice work, Spartans. They know their place.      outstanding spartans. position is secure.    excellent work spartans, you stopped em cold.
            game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_loss, false)      -- Your failure here is troubling.     The fleetmaster will be displeased to hear of this failure.       This failure will NOT go unnoticed.
         end
         if global.object[13].number[2] >= 4 then 
            game.show_message_to(all_players, none, "The Scarab's core has been exposed!")
            --game.play_sound_for(global.team[1], inv_spire_vo_covenant_p1_intro, false)      -- Hold fast, brothers. Do not let the humans pass!
            game.play_sound_for(global.team[1], inv_spire_vo_covenant_p2_intro, false)      -- alt -- Return to the spire, brothers. The humans must not deactivate our shield!      -- fall back! we must protect the spire's shield from these fould humans!
            game.play_sound_for(global.team[0], inv_spire_vo_spartan_p1_win, false)      -- Nice work, Spartans. Infiltrate their tower!
            game.play_sound_for(all_players, inv_cue_covenant_win_2, true)      -- Nice work, Spartans. Infiltrate their tower!
            global.object[13].object[3].set_invincibility(0)
            --global.object[13].object[3].set_waypoint_icon(bullseye)
            global.object[0] = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            --global.object[0].set_waypoint_text("Core Exposed")
            global.object[0].set_waypoint_visibility(everyone)
            --global.object[0].set_waypoint_priority(high)
            global.object[0].attach_to(global.object[13].object[3], -10,0,5,relative)        -- -10, 0, 0  is really goo except when landing on front of scarab, looks like you should go down the ramp.
            --global.object[13].object[3].set_waypoint_text("Core Exposed")
            --global.object[13].object[3].set_waypoint_visibility(everyone)
            --global.object[13].object[3].set_waypoint_priority(high)
            --global.object[0] = global.object[13].object[3]
            global.object[0].team = global.team[1]
            
            global.object[1] = global.object[13].object[3]
            global.object[1].object[0] = global.object[0]      -- nest the waypointer so we can delete it after scarab explosion.
            for each object with label "B_Misc" do
               if current_object.spawn_sequence == 9 then 
                  current_object.delete()
               end
            end
         end
      end
   end
end

for each player do
   if current_player.number[1] > 0 then 
      current_player.number[1] -= 1
   end
end

--for each object with label "Detonation" do
   --current_object.number[4] -= 1
   --if current_object.number[4] == 0 then 
      --current_object.detach()
      --current_object.object[0].delete()
      --current_object.kill(false)
   --end
--end

-- attach bomb in front of AA flak projectile
for each object with label "Projectile" do
   current_object.number[1] -= 3
   if current_object.is_of_type(light_blue) then 
      current_object.object[0].attach_to(current_object, 4, 0, 0, relative)
      current_object.number[1] -= 1
   end
end

-- attach bomb in front of face cannon projectile (25% slower travel speed)
for each object with label "Projectile" do
   if not current_object.is_of_type(light_blue) then 
      current_object.object[0].attach_to(current_object, 3, 0, 0, relative)
   end
end

-- light then leap frogs its own bomb
for each object with label "Projectile" do
   current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
   if current_object.object[0] == no_object then 
      current_object.delete()
   end
end

-- projectile wall collision test. moves a single test test object (hill marker?) 4 in front, spawns a test bomb to see if offset (wall detected), then triggers explosion and optional vehicle damage in a function.
for each object with label "Projectile" do
   current_object.number[4] += 1
   if current_object.number[4] >= 2 then 
      current_object.number[4] = 0
      global.object[14].attach_to(current_object, 4, 0, 0, relative)
      global.object[14].detach()
      global.object[0] = global.object[14].place_at_me(bomb, none, none, 0, 0, 0, none)
      global.number[0] = global.object[0].get_distance_to(global.object[14])
      global.object[0].delete()
      if global.number[0] > 1 then 
         trigger_25()
      end
   end
end

for each object with label "Projectile" do
   global.number[0] = 999
   for each player do
      if current_player.biped != no_object then 
         global.number[1] = current_player.biped.get_distance_to(current_object)
         if global.number[1] < global.number[0] then 
            global.number[0] = global.number[1]
         end
      end
   end
   if current_object.number[1] <= 8 or global.number[0] < 9 then 
      trigger_25()
   end
end

do
   global.object[5] = no_object
   global.number[2] = 0
   global.object[10].number[1] = 0
   if global.object[10].number[7] < 0 then 
      global.object[10].number[7] += 1
      if global.object[10].number[1] > 30 then 
         global.object[10].number[7] += 1
      end
   end
end

for each object with label "U_Joint" do
   if current_object.number[0] == 1 and current_object.object[3] != no_object then 
      global.object[6] = current_object.object[3]
      for each player do
         if global.object[6].shape_contains(current_player.biped) then 
            global.object[0] = current_player.get_vehicle()
             if global.object[0] != no_object then 
               global.object[0].kill(false)
            end
            if global.object[0] == no_object then 
               current_player.biped.kill(false)
            end
         end
      end
      if global.object[6].number[1] == 0 then 
          if global.object[6].object[3].shape_contains(global.object[6]) then 
            current_object.number[5] = 0
         end
         if not global.object[6].object[3].shape_contains(global.object[6]) then 
            current_object.number[5] += 1
            global.object[10].number[1] += current_object.number[5]
            if global.object[10].number[7] == 0 and current_object.number[5] > global.number[2] then 
               global.object[5] = current_object
               global.number[2] = current_object.number[5]
            end
         end
      end
   end
end

if global.object[5] != no_object then 
   global.object[6] = global.object[5].object[3]
   global.object[5].number[5] = 0
   global.object[10].number[7] += 1
   global.object[1] = global.object[6].object[1]
   global.object[1].detach()
   global.object[2] = global.object[6].object[2]
   global.object[2].detach()
   global.number[0] = global.object[6].get_distance_to(global.object[1])
   global.number[1] = global.object[6].get_distance_to(global.object[2])
   global.object[1].attach_to(global.object[1].object[0], 0, 0, 0, relative)
   global.object[2].attach_to(global.object[2].object[0], 0, 0, 0, relative)
   global.object[4] = global.object[6].object[0]
   global.object[4].object[0].detach()
   global.object[6].attach_to(global.object[4].object[0], 0, 0, 0, relative)
    if global.number[0] < global.number[1] then 
      global.object[6].number[1] = -1
   end
   if global.object[6].number[1] == 0 then 
      global.object[6].number[1] = 1
   end
end

for each object with label "U_Joint" do
   if current_object.number[0] == 1 and current_object.object[3] != no_object then 
      global.object[6] = current_object.object[3]
      if global.object[6].object[0] != no_object and global.object[6].object[1] != no_object and global.object[6].object[2] != no_object and global.object[6].object[3] != no_object then 
         global.object[4] = global.object[6].object[0]
          if global.object[6].number[1] == 1 then 
            global.object[0] = global.object[6].object[1]
            trigger_26()
         end
         if global.object[6].number[1] == -1 then 
            global.object[0] = global.object[6].object[2]
            trigger_26()
         end
      end
   end
end

for each player do
   if current_player.biped != no_object then 
      global.object[0] = current_player.biped
      global.object[0].player[1] = current_player
   end
end

--for each object with label "S_Ob_Point" do
   --if current_object.team == team[3] and current_object.object[0] == no_object then 
      --current_object.object[0] = current_object.place_at_me(bomb, none, none, 0, 0, 0, none)
      --current_object.object[0].attach_to(current_object, 0, 0, 0, relative)
   --end
--end

on object death: if killed_object == global.object[10].object[1] then 
   global.object[10].object[1] = no_object
   global.object[13].number[5] = 0
end

if global.object[11] != no_object and global.object[11].team == team[2] then 
   --global.object[11].object[1].set_waypoint_priority(high)
   global.object[11].object[0].set_waypoint_priority(high)
   if not global.timer[1].is_zero() then 
      --global.object[11].object[1].set_waypoint_priority(blink)
      global.object[11].object[0].set_waypoint_priority(blink)
   end
end

if global.object[11] != no_object and global.object[11].number[4] >= script_option[4] then 
   trigger_27()
end

if global.object[11] != no_object and global.object[11].team == team[0] or global.object[11].team == team[1] then 
   global.number[0] = 0
   for each player do
      if global.object[11].shape_contains(current_player.biped) then 
          if current_player.team == global.team[1] then 
            global.number[0] += 1
         end
         if current_player.team == global.team[0] then 
            global.number[0] |= 16384
         end
      end
   end
   global.object[0] = global.object[11].object[1]
   global.object[0].timer[0] = global.object[11].timer[0]
   global.object[0] = global.object[11].object[0]
   global.object[0].timer[0] = global.object[11].timer[0]
    if global.number[0] == 0 or global.number[0] == 16384 then 
      global.team[2] = no_team
      --global.object[11].object[1].set_waypoint_priority(high)
      global.object[11].object[0].set_waypoint_priority(high)
      global.object[11].timer[0].set_rate(100%)
      if global.object[11].timer[0] >= script_option[1] then 
         global.object[11].timer[0].set_rate(0%)
      end
   end
   if global.number[0] != 0 and global.number[0] != 16384 then 
      global.team[2] = team[0]
      --global.object[11].object[1].set_waypoint_priority(blink)
      global.object[11].object[0].set_waypoint_priority(blink)
      global.object[11].timer[0].set_rate(0%)
      if global.number[0] > 0 and global.number[0] < 16384 then 
         global.object[11].timer[0].set_rate(-100%)
         trigger_0()
         if global.object[11].timer[0].is_zero() then
            -- Rabid added. always announce territory captured if it's a territory objective, even if this isn't the final objective for the structure.
            game.play_sound_for(global.team[0], announce_territories_lost, false)
            game.play_sound_for(global.team[1], announce_territories_captured, false)
            trigger_27()
         end
      end
   end
end

for each object with label "S_Objective" do
   if current_object.team == team[7] and global.object[10].shape_contains(current_object) then 
      current_object.delete()
   end
end

for each object with label "falling_object" do
   global.number[0] = current_object.get_speed()
   if global.number[0] < 5 then 
      current_object.number[4] += 1
   end
end

for each object with label "falling_object" do
   global.number[0] = 0
   global.object[0] = current_object
   for each object with label "B_Misc" do
      if current_object.spawn_sequence == 8 and current_object.shape_contains(global.object[0]) then 
         global.number[0] = 1
      end
   end
   if global.number[0] == 1 or current_object.number[4] > 30 then 
      global.object[0] = current_object.object[0]
      global.object[0].team = team[7]
      global.object[0].detach()
      current_object.delete()
      global.number[10] ^= 1
      if global.number[10] == 0 then 
         global.number[8] += 1
         global.object[1] = global.object[0].place_between_me_and(global.object[0], flag_stand, 0)
         global.object[0].attach_to(global.object[1], 0, 0, 0, relative)
      end
   end
end

-- semi-redundant. Cargo physics widget
--for each player do
   --script_widget[1].set_visibility(current_player, false)
   --if current_player.biped != no_object and global.object[10].shape_contains(current_player.biped) then 
      --global.object[0] = current_player.get_vehicle()
      --if global.object[0] == no_object then 
         --script_widget[1].set_visibility(current_player, true)
      --end
   --end
--end

for each object with label "B_Turret" do
   if current_object.team != team[2] then 
      global.number[0] = current_object.health
      if global.number[0] > current_object.number[7] and global.number[0] < 99 then 
         current_object.health = current_object.number[7]
      end
   end
end

for each object with label "B_Turret" do
   if current_object.team != team[2] then 
      current_object.number[7] = current_object.health
   end
end

do
   global.number[6] = 3621
end

on local: do

   -- brute flag.    
   for each object do
      if current_object.is_of_type(flag) then
         current_object.set_scale(20)
         --current_object.copy_rotation_from(current_object, false)    -- maybe redundant.
      end
      -- hide carried golf clubs (stowable turrets).
      --if current_object.is_of_type(golf_club) then
         --global.player[0] = current_object.try_get_carrier()
         --if global.player[0] != no_player then
         --current_object.set_scale(1)
      --end
   end

   -- Stowed machine gun visual.    
   -- Warning: might not work right in multiplayer. I seem to remember it being impossible to get this to work without attaching to armor ability. could try delaying by few ticks before attach.
   --for each player do
      
      --global.object[7] = current_player.try_get_weapon(secondary)
      -- removed for space (and because won't work till Duck's attachment fix)
      --if global.object[7].is_of_type(golf_club) then -- and global.number[6] != 3621 then         -- RE-ADD
         --global.object[7].set_scale(1)
         -- Holstered machine_gun_turret
         -- Basically I'm only doing this on local in the hopes it'll work for this current bugged MCC update version till Duck makes a fix.
         --if global.object[7].object[0] == no_object then	
            --global.object[7].object[0] = global.object[7].place_between_me_and(global.object[7], detached_machine_gun_turret, 0)     -- troubleshooting
            --global.object[7].object[0].copy_rotation_from(global.object[7], true)
            --global.object[7].object[0].set_scale(90)
            --global.object[7].object[0].attach_to(global.object[7], 1,0,1,relative)
         --end
      --end
   --end
   
   
   

    if global.team[2] == no_team then 
      set_scenario_interpolator_state(1, 0)
   end
    if global.team[2] == team[0] then 
      set_scenario_interpolator_state(1, 1)
   end
   for each object with label "scale" do
      if current_object.number[1] == 0 and global.number[6] <= -90 or global.number[6] == 3621 then 
         current_object.number[1] = 1
         do
            global.object[2] = current_object
            trigger_5()
         end
          if current_object.team == team[5] then 
            global.object[0] = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)
            global.object[1] = global.object[0].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
            global.object[0].face_toward(global.object[0], 0, 1, 0)
            global.object[0].attach_to(global.object[1], 0, 0, 0, relative)
            global.object[1].face_toward(global.object[1], 0, 1, 0)
            global.object[0].detach()
            current_object.copy_rotation_from(global.object[0], true)
            global.object[0].delete()
            global.object[1].delete()
         end
         if current_object.team == team[4] or current_object.team == team[3] then 
            current_object.max_health *= 5000
            current_object.health = 100
             if current_object.team == team[4] then 
               global.object[0] = current_object.place_between_me_and(current_object, heavy_barrier, 0)
            end
             if current_object.team == team[3] then 
               global.object[0] = current_object.place_between_me_and(current_object, sound_emitter_alarm_2, 0)  -- warning, I have a feeling sound emitter means it has no hitbox. use 1% flag stand instead if so.
            end
            current_object.detach()
            current_object.attach_to(global.object[0], 0, 0, 0, relative)
         end
      end
   end
   global.number[7] -= 1
    if global.number[7] <= 0 then 
      global.number[7] = 4
      for each player do
         current_player.number[0] = 0
      end
      for each player do
         if current_player.biped != no_object and global.object[10].shape_contains(current_player.biped) then 
            current_player.number[0] += 1
            global.object[0] = current_player.get_vehicle()
            if global.object[0] != no_object then 
               current_player.number[0] += 100
            end
         end
      end
       if global.object[8] == no_object then 
         global.object[8] = global.object[10].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
      end
       if global.object[9] == no_object then 
         global.object[9] = global.object[10].place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
      end
       if global.object[10].shape_contains(global.object[10]) then 
         for each player do
             if current_player.number[0] != 1 then 
                if current_player.object[1] != no_object then 
                  current_player.object[1].delete()
               end
               if current_player.object[0] != no_object then 
                  current_player.object[0].delete()
               end
            end
            if current_player.biped != no_object and current_player.number[0] == 1 and global.object[10].shape_contains(current_player.biped) then 
                if current_player.object[0] != no_object then 
                  global.object[5] = no_object
                  global.object[6] = no_object
                  global.object[4] = current_player.object[2]
                  global.object[2] = global.object[8]
                  global.object[2].attach_to(current_player.biped, 0, 0, 0, relative)
                  global.object[2].detach()
                  global.number[0] = global.object[2].get_distance_to(global.object[4])
                  global.number[1] = global.number[0]
                   if global.number[0] > 0 then 
                     trigger_3()
                     global.object[5] = global.object[1].place_between_me_and(global.object[1], sound_emitter_alarm_2, 0)
                     global.object[6] = global.object[0].place_between_me_and(global.object[0], sound_emitter_alarm_2, 0)
                     global.number[0] = global.object[6].get_distance_to(global.object[5])
                     trigger_34()
                     global.object[5] = global.object[1]
                     global.object[6] = global.object[0]
                     if global.number[0] <= 0 then 
                        global.number[1] = -1
                        global.object[1].delete()
                        global.object[0].delete()
                     end
                  end
                   if global.number[1] != -1 then 
                     global.object[4] = current_player.biped.place_between_me_and(current_player.biped, sound_emitter_alarm_2, 0)
                     global.object[2] = current_player.object[1].place_between_me_and(current_player.object[1], sound_emitter_alarm_2, 0)
                     global.number[0] = global.object[4].get_distance_to(global.object[2])
                      if global.number[0] <= 0 then 
                        global.number[1] = -1
                        trigger_34()
                        global.object[4].delete()
                        global.object[2].delete()
                     end
                      if global.number[0] > 0 then 
                        trigger_3()
                        global.object[4].delete()
                        global.object[2].delete()
                        global.object[8].attach_to(global.object[1], 0, 0, 0, relative)
                        global.object[8].detach()
                        global.object[9].attach_to(global.object[0], 0, 0, 0, relative)
                        global.object[9].detach()
                        global.number[0] = global.object[9].get_distance_to(global.object[8])
                         if global.number[0] <= 0 then 
                            if global.number[1] > 0 then 
                              trigger_34()
                           end
                           global.number[1] = -1
                        end
                         if global.number[1] != -1 then 
                           global.object[0].attach_to(current_player.biped, 0, 0, 0, relative)
                           current_player.biped.attach_to(global.object[1], 0, 0, 0, relative)
                        end
                        global.object[1].delete()
                        global.object[0].delete()
                     end
                     if global.number[1] > 0 then 
                        global.object[6].attach_to(current_player.biped, 0, 0, 0, relative)
                        current_player.biped.attach_to(global.object[5], 0, 0, 0, relative)
                        trigger_34()
                     end
                  end
                  current_player.object[1].delete()
                  current_player.object[0].delete()
               end
               if global.object[10].shape_contains(current_player.biped) then 
                  global.object[4] = global.object[8]
                  global.object[4].attach_to(global.object[10], 0, 0, 0, relative)
                  global.object[4].detach()
                  global.object[2] = global.object[9]
                  global.object[2].attach_to(current_player.biped, 0, 0, 0, relative)
                  global.object[2].detach()
                  global.number[0] = global.object[4].get_distance_to(global.object[2])
                  trigger_3()
                  global.object[0].attach_to(global.object[10], 0, 0, 0, relative)
                  current_player.object[1] = global.object[1]
                  current_player.object[0] = global.object[0]
               end
            end
         end
      end
      for each player do
         if current_player.biped != no_object then 
             if current_player.object[2] == no_object then 
               current_player.object[2] = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
            end
            current_player.object[2].attach_to(current_player.biped, 0, 0, 0, relative)
            current_player.object[2].detach()
         end
      end
   end
    if global.number[6] <= 0 then 
      for each object with label "B_Turret" do
         if current_object.team != team[2] then 
             if current_object.object[1] != no_object and current_object.number[7] == 0 then 
               current_object.number[7] = 1
               current_object.detach()
               current_object.attach_to(current_object.object[2], 4, -4, 0, relative)
            end
            if current_object.object[3] != no_object and current_object.object[1] != no_object and current_object.object[2] != no_object and global.timer[0].is_zero() and not global.object[10].object[2].shape_contains(current_object.object[3]) then 
               trigger_23()
            end
         end
      end
       if global.number[6] > -90 then 
         global.number[6] -= 1
      end
      if global.number[6] <= -90 then 
          if global.number[9] != global.number[8] then 
            global.number[6] -= 1
            if global.number[6] < -120 then 
               global.number[6] = -90
               global.number[9] = global.number[8]
               for each object with label "S_Objective" do
                  if current_object.team == team[7] then 
                     current_object.detach()
                  end
               end
            end
         end
          if global.object[10].number[0] == 1 and global.object[10].object[1] != no_object and global.object[10].number[2] == 0 then 
            trigger_22()
            global.object[0] = global.object[10].object[3]
            if global.object[0].object[1] != no_object and global.object[0].object[2] != no_object then 
               trigger_19()
            end
         end
         for each object with label "configure_scale" do
            if current_object.number[0] != 0 then 
                if current_object.object[2].has_forge_label("B_Attach") and current_object.team != team[7] and current_object.team != team[6] then 
                  current_object.object[2].copy_rotation_from(current_object.object[1], true)
                  current_object.object[2].attach_to(current_object.object[1], 0, 0, 0, relative)
                  current_object.object[2].detach()
               end
               if current_object.number[1] == 0 then 
                  current_object.number[1] = 1
                  current_object.detach()
                  current_object.set_scale(current_object.number[0])
                  current_object.copy_rotation_from(current_object, true)
                  current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
                  global.object[2] = current_object.object[2]
                  global.object[2].detach()
                   if global.object[2].has_forge_label("B_Attach") or global.object[2].has_forge_label("U_Attach") or global.object[2].has_forge_label("L_Attach") then 
                     trigger_5()
                  end
                   if global.object[2].has_forge_label("L_Damage") and global.object[2].team != neutral_team then 
                     global.object[2].set_scale(1)
                     global.object[2].copy_rotation_from(global.object[2], true)
                  end
                  global.object[2].attach_to(current_object.object[1], 0, 0, 0, relative)
               end
            end
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
   for each player do
      if current_player.number[3] < team[1].score and current_player.biped != no_object then 
         current_player.number[3] = global.team[1].score
         global.object[0] = current_player.biped.place_between_me_and(current_player.biped, monitor, 0)        -- bomb obejct type doesn't work.
         if global.object[0].is_of_type(monitor) then
            global.object[0].delete()
         end
      end
   end
   
   for each object with label "U_Joint" do
      if current_object.number[0] == 1 and current_object.object[3] != no_object and current_object.number[3] != 0 then 
         global.object[4] = current_object.object[1]
          if global.object[4].number[5] == 0 then 
            global.object[4].object[3].detach()
            global.number[3] = current_object.number[3]
            global.number[3] *= 100
            global.object[4].object[3].set_scale(global.number[3])
            global.object[4].number[5] = 1
            global.object[4].object[3].attach_to(global.object[4], 0, 0, 0, relative)
         end
         current_object.detach()
         current_object.face_toward(current_object.object[3], 0, 0, 0)
         global.object[4].object[3].detach()
         global.object[4].object[3].attach_to(current_object.object[3], 0, 0, 0, relative)
         global.object[4].object[3].detach()
         global.object[4].object[3].face_toward(current_object.object[2], 0, 0, 0)
         global.object[4].detach()
         global.object[4].face_toward(global.object[4].object[2], 0, 0, 0)
         global.object[1] = current_object.object[2]
         global.object[1].detach()
         global.object[1].face_toward(current_object.object[3], 0, 0, 0)
         global.object[1].attach_to(global.object[1].object[0], 0, 0, 0, relative)
         global.object[4].attach_to(current_object, 0, 0, 0, relative)
         current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
         global.object[4].object[3].attach_to(global.object[4], 0, 0, 0, relative)
      end
   end
end


alias global_tick_counter = team[0].number[3]
global_tick_counter += 1

for each player do
   --if current_player.team == global.team[1] then
   script_widget[1].set_visibility(current_player, false)
   script_widget[0].set_visibility(current_player, false)
   script_widget[2].set_visibility(current_player, false)
   --end
end

-- redundancy here. no need for titlecard stuff to be in its own block here, can be put anywhere that player team is specified.
for each player do
   if current_player.team == global.team[1] then 
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
      if global_tick_counter > 600 and global.number[11] == 0 and global.object[10].number[0] > 0 then
         script_widget[2].set_visibility(current_player, true)
         -- non-territory objectives: show the 'capture the territory' widget to elites.
         if current_player.team == global.team[1] and global.object[11].team == team[0] or global.object[11].team == team[1] then
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
      game.play_sound_for(global.team[0], inv_boneyard_vo_spartan_p1_intro, false)         -- Securing this position is priority one spartans, hold off any attack
      --game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_intro, false)         -- Take the access points, then we will infiltrate the human stronghold
      game.play_sound_for(global.team[1], inv_boneyard_vo_covenant_p1_win, false)      -- Well done. Push forward and crush the human defenses.
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
   if current_player.team == global.team[0] then
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
      if global_tick_counter > 600 and global.number[11] == 0 and global.object[10].number[0] > 0 then
         script_widget[0].set_visibility(current_player, true)
         --if global_tick_counter == 1560 then                      -- 26 seconds
         --if global_tick_counter == 1800 then                      -- 30 seconds
            --game.show_message_to(current_player, none, "Objective: Cripple all 4 legs to expose the Scarab's core\nOptional:Destroy the AA Turret")
            --game.show_message_to(current_player, none, "Objective: Cripple all 4 legs to expose the Scarab's core!")
         --end
      end
   end
end













for each player do
   current_player.set_co_op_spawning(true)
   if current_player.team == global.team[1] then 
      current_player.apply_traits(script_traits[1])
      current_player.set_loadout_palette(elite_tier_1)
      if current_player.biped != no_object then 
         global.object[0] = current_player.biped
         global.object[7] = current_player.try_get_vehicle()
         if global.object[0].number[6] == 0 and global.object[7] == no_object then 
            --global.object[5] = no_object
            --global.object[6] = no_object
            global.object[1] = current_player.try_get_weapon(primary)
            global.object[2] = current_player.try_get_weapon(secondary)
             if global.object[1].is_of_type(plasma_repeater) then 
               global.object[6] = global.object[0].place_between_me_and(global.object[0], jetpack, 0)
               global.object[5] = global.object[0].place_at_me(elite, none, none, 0, 0, 0, space)
               global.object[5].number[6] = 2
            end
             if global.object[1].is_of_type(fuel_rod_gun) then 
               global.object[6] = global.object[0].place_between_me_and(global.object[0], sprint, 0)
               global.object[5] = global.object[0].place_at_me(elite, none, none, 0, 0, 0, minor)
               global.object[5].number[6] = 3
            end
             if global.object[1].is_of_type(energy_sword) then 
               global.object[6] = global.object[0].place_between_me_and(global.object[0], evade, 0)
               global.object[5] = global.object[0].place_at_me(elite, none, none, 0, 0, 0, zealot)
               global.object[5].number[6] = 4
            end
             if global.object[2].is_of_type(gravity_hammer) then 
               global.object[6] = global.object[0].place_between_me_and(global.object[0], sprint, 0)
               global.object[5] = global.object[0].place_at_me(elite, none, none, 0, 0, 0, general)
               global.object[5].number[6] = 9
                              -------- Traxus brute flag. Occurs at biped swap.   cheaper.
               global.object[4] = global.object[5].place_at_me(flag_stand, none, none, 0, 0, 0, none)
               global.object[4].set_scale(5)
			      global.object[3] = global.object[5].place_at_me(flag, none, none, 0, 0, 0, none)
			      global.object[3].team = global.team[4]				-- red team flag for brute
               --global.object[9].set_scale(20)                -- doesn't sync
			      --global.object[3].number[6] = 20               -- no local scale ID in this gametype, so I'm gonna hardcode all flags to be 20 scale on local.
               global.object[3].set_hidden(true)             -- hide the full sized flag on host so players can't invisibly shoot it.      re-add.
               global.object[3].attach_to(global.object[4], 8, 0, 25, relative)
               global.object[4].attach_to(global.object[5], 0, 1, 5, relative)
			      global.object[5].set_scale(112)
               --------
            end
            if global.object[5] != no_object then
               global.object[0].remove_weapon(secondary, false)
               global.object[0].remove_weapon(primary, false)
               global.object[5].attach_to(global.object[0], 0, 0, 0, relative)
               global.object[5].detach()
               global.object[5].copy_rotation_from(global.object[0], true)
               global.object[0].delete()
               current_player.set_biped(global.object[5])
               current_player.biped.remove_weapon(primary, true)
               current_player.add_weapon(global.object[1])
               current_player.add_weapon(global.object[2])           -- fixed. gamergotten has this wrong order.
               current_player.frag_grenades = 0
               if not global.object[1].is_of_type(fuel_rod_gun) then
                  current_player.plasma_grenades = 2
               end
            end
         end
      end
   end
end

for each player do
   global.object[5] = current_player.biped
   global.object[6] = current_player.try_get_weapon(primary)
   if global.object[5].number[6] >= 2 then 
      current_player.apply_traits(script_traits[2])
      if global.object[5].number[6] >= 3 then 
         current_player.apply_traits(script_traits[3])
         if global.object[5].number[6] >= 4 then 
            current_player.apply_traits(script_traits[4])
            if global.object[5].number[6] >= 9 then 
               current_player.apply_traits(script_traits[9])
               -- infinite ammo for brutes holding concussion_rifle, just becuase they run out so fast on these big maps.
               if global.object[6].is_of_type(concussion_rifle) then
                  current_player.apply_traits(script_traits[6])
               end
            end
         end
      end
   end
end

for each player do
   if current_player.team == global.team[0] then 
      current_player.set_loadout_palette(spartan_tier_1)
      current_player.apply_traits(script_traits[0])
   end
end

for each player do
   global.object[0] = current_player.get_weapon(primary)
   if global.object[0].is_of_type(plasma_repeater) then 
      current_player.apply_traits(script_traits[5])
   end
end



for each object with label "S_Ob_Point" do
   if current_object.spawn_sequence == 0 or current_object.spawn_sequence == global.object[11].spawn_sequence and current_object.team == team[0] or current_object.team == team[1] then 
      current_object.set_spawn_location_permissions(allies)
   end
end

for each object with label "S_Ob_Point" do
   if current_object.spawn_sequence != 0 and current_object.spawn_sequence != global.object[11].spawn_sequence and current_object.team == team[0] or current_object.team == team[1] then 
      current_object.set_spawn_location_permissions(no_one)
   end
end

do
   --script_widget[1].set_value_text("Cargo Physics: you will experience jitter while inside")
   script_widget[1].set_text("Capture the human territory to advance")    -- Sieze
   --script_widget[2].set_text("Scarab Health")
   --script_widget[2].set_meter_params(timer, global.timer[2])
   script_widget[3].set_text("Fortified: Infinite Ammo")
   --script_widget[0].set_text("legs destroyed %n/%n\n (Core Locked)", global.object[13].number[2], 4)
   --script_widget[0].set_text("Legs crippled %n/%n\n (Core Locked)", global.object[13].number[2], 4)
   --script_widget[0].set_text("Cripple the Scarab's legs %n/%n", global.object[13].number[2], 4)
   script_widget[0].set_value_text("Cripple the Scarab's legs %n/%n", global.object[13].number[2], 4)
   --script_widget[2].set_text("Defend the Scarab & capture objectives %n/%n", global.object[13].number[2], 4)
   --script_widget[2].set_text("Defend the Scarab's legs from ranged attacks %n/%n", global.object[13].number[2], 4)
   --script_widget[2].set_text("Defend the Scarab's legs from ranged attacks", global.object[13].number[2], 4)
   
      --script_widget[2].set_text("Defend our holy weapon from ranged attacks\nLegs weakened %n/%n", global.object[13].number[2], 4)
      --script_widget[2].set_text("Defend our holy weapon from\nranged attacks. Legs harmed: %n", global.object[13].number[2])
      --script_widget[2].set_text("Defend our holy weapon from\nranged attacks. Legs crippled: %n", global.object[13].number[2])
      script_widget[2].set_value_text("Defend our holy weapon from\nranged attacks. Legs crippled: %n", global.object[13].number[2])

      --script_widget[2].set_text("Clear the path for our holy weapon\nLegs weakened %n/%n", global.object[13].number[2], 4)
      --script_widget[2].set_text("Keep the rats from harming our holy weapon on its righteous path", global.object[13].number[2], 4)
   
   
   --script_widget[2].set_text("Defend the Scarab from ranged attacks. Legs crippled: %n/%n", global.object[13].number[2], 4)
   --script_widget[2].set_text("Defend the Scarab from ranged attacks. Legs crippled: %n/%n", global.object[13].number[2], 4)
   --script_widget[2].set_text("Keep the filth ", global.object[13].number[2], 4)

   if global.object[13].number[2] >= 4 then 
      script_widget[0].set_value_text("Board the Scarab and destroy its core!")
      script_widget[2].set_value_text("Defend the Scarab's core from boarders!")
   end
end

for each player do
   script_widget[3].set_visibility(current_player, false)
   global.object[0] = current_player.try_get_vehicle()
   if global.object[0] == no_object then 
      for each object with label "S_Ob_Point" do
         if current_object.team == team[2] and current_object.shape_contains(current_player.biped) then 
            script_widget[3].set_visibility(current_player, true)
            current_player.apply_traits(script_traits[6])
         end
      end
   end
end

for each object with label "B_Turret" do
   for each player do
      if current_player.biped != no_object then 
         global.number[0] = current_object.get_distance_to(current_player.biped)
         if global.number[0] == 0 then 
            current_player.biped.detach()
         end
      end
   end
end

if global.number[11] < 0 then 
   global.number[11] -= 1
   if global.number[11] < -600 then          -- change outro period duration here. originally 5 seconds.    -300
      game.end_round()
   end
end


-- Species specific vehicles
for each player do
   global.object[0] = current_player.try_get_vehicle()
   if current_player.is_elite() and global.object[0].is_of_type(scorpion) or global.object[0].is_of_type(falcon) or global.object[0].is_of_type(warthog) or global.object[0].is_of_type(sabre) then
      current_player.apply_traits(script_traits[7])
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
   if current_player.is_spartan() and global.object[0].is_of_type(banshee)then
      current_player.apply_traits(script_traits[7])
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
end

-- Species specific weapons.  luxury.
for each player do
   global.object[0] = current_player.try_get_weapon(primary)
   if current_player.is_elite() and global.object[0].is_of_type(rocket_launcher) or global.object[0].is_of_type(grenade_launcher) or global.object[0].is_of_type(sniper_rifle) or global.object[0].is_of_type(DMR) or global.object[0].is_of_type(shotgun) or global.object[0].is_of_type(assault_rifle) or global.object[0].is_of_type(magnum) then
      current_player.biped.remove_weapon(primary, false)
      game.show_message_to(current_player, none, "Your species can't use this.")
   end
   -- stowable turrets
   --if global.object[0].is_of_type(golf_club) then
      --if current_player.is_elite() then
         --current_object.set
      --end
   --end
end


--- test
--for each object with label "L_Damage" do
   --global.number[0] = current_object.health
   --current_object.object[0].set_waypoint_visibility(everyone)
   --current_object.object[0].set_waypoint_icon(bomb)
   --current_object.object[1].set_waypoint_visibility(everyone)
   --current_object.object[1].set_waypoint_icon(bullseye)
--end


alias previous_health = object.number[5]

-- leg waypoint blinking
for each object with label "L_Damage" do
   global.object[0] = current_object.object[0]
   global.object[0].number[6] += 1
   --if current_object.team != team[2] then 
      global.number[0] = current_object.health      
      -- legs die at 50 health, core dies at 0 health, so this section normalises the waypoint to 100 units for legs only.
      if global.object[13].number[2] < 4 then
         --global.number[0] /= 2
         global.number[1] = 100
         global.number[1] -= global.number[0]
         global.number[1] *= 2
         global.number[0] = 100
         global.number[0] -= global.number[1]
         global.number[0] += 2      -- this stops the waypoint ever showing '0', but means the waypoint won't initially show till hp has been reduced to 96%.
      end
      if global.number[0] < global.object[0].timer[2] then -- and global.number[0] < 99 then 
         global.object[0].timer[2] = global.number[0]
         global.object[0].set_waypoint_priority(blink)
         global.object[0].number[6] = -180
         global.object[0].set_waypoint_timer(2)
      end
      if global.object[0].number[6] > 0 then
         global.object[0].set_waypoint_priority(low)        -- normal
         global.object[0].set_waypoint_timer(none)
         if global.object[13].number[2] >= 4 then
            global.object[0].set_waypoint_text("Core")
         end
      end
   --end
end


--if global.object[13].number[2] >= 4 then














for each player do
   --global.object[2] = current_player.biped
   --global.object[3] = current_player.try_get_vehicle()
   global.object[6] = current_player.try_get_weapon(primary)
   global.object[7] = current_player.try_get_weapon(secondary)
   global.object[5] = current_player.try_get_armor_ability()
   -- infinite unlimited sprint
   if global.object[5].is_of_type(sprint) then 
      current_player.apply_traits(script_traits[8])
   end
   -- back mounted machine gun
   if global.object[5].is_of_type(drop_shield) and current_player.is_spartan() then
      -- remove back weapon when in vehicles
      --if global.object[3] != no_object and global.object[6].is_of_type(spiker) then
         --global.object[6].delete()
      --end
      --if global.object[3] == no_object then
         --if global.object[7] == no_object then
            --global.object[2].add_weapon(spiker, force)
         --end
		if not global.object[6].is_of_type(detached_machine_gun_turret) and not global.object[6].is_of_type(assault_rifle) then -- and not global.object[6] == no_object and global.object[5].object[0] == no_object then  		-- redundancy test		-- be careful not to do this to a leftover global.object[7]
         global.object[7].set_scale(1)
         --global.object[5].set_scale(10)
         global.object[5].object[1].set_scale(90)
-- machine gun from SvS invasion portable turret
         -- visual luxury
         if global.object[5].object[1] == no_object and global.object[5] != no_object then			-- second condition is a failsafe. Otherwise no players without AA will spawn gun every tick & overload map.
            global.object[4] = global.object[5].place_between_me_and(global.object[5], flag_stand, 0)
            global.object[5].object[1] = global.object[7].place_between_me_and(global.object[7], detached_machine_gun_turret, 0)      -- using global.object[4] so that it just drops off map for clients until Duck's attach bug hotfix.
            global.object[5].object[1].set_scale(90)
            --global.object[5].object[1].copy_rotation_from(global.object[7], true)
            global.object[5].object[1].attach_to(global.object[4], -25,-12,15,relative)          -- -20,-10,10       was very nearly right.        -20,-10,20, slightly too oneside.d
            global.object[4].set_scale(5)
            global.object[4].copy_rotation_from(global.object[7], true)
            global.object[4].attach_to(global.object[5], 0,0,0,relative)
         end
		end
      if global.object[6] != no_object and not global.object[6].is_of_type(detached_machine_gun_turret) and global.object[7] == no_object and global.object[5].object[0] == no_object then      -- global.object[6].is_of_type(shotgun) and global.object[5].number[1] < 2 and
       --global.object[6].object[0].delete() 			-- delete attached machine gun visual. This could be moved out of the IFs if desired, since no primary weapon should have an attached turret.
         global.object[5].object[1].set_scale(1)
         --current_player.biped.add_weapon(shotgun, force)
         --current_player.biped.add_weapon(assault_rifle, force)
         current_player.biped.add_weapon(assault_rifle, secondary)
      end
      if global.object[6].is_of_type(assault_rifle) then 
         current_player.biped.remove_weapon(primary, true)
         --current_player.biped.add_weapon(needler, force)
         current_player.biped.add_weapon(detached_machine_gun_turret, force)
         --if global.object[3] != no_object then      -- Note: for completeness you can uncomment the condition so it doesn't hide visual machine gun while in vehicle passenger. luxury. 
            global.object[5].object[1].set_scale(1)
         --end
      end
    -- marking droppables for later deletion
      if global.object[6].is_of_type(detached_machine_gun_turret) then  -- or global.object[6].is_of_type(bomb) then 
         global.object[5].object[0] = global.object[6]
      end
    -- delete dropped bomb or machine gun. could expand this to delete dropped assault rifles if you also say "!= global.object[7]"
      if global.object[5].object[0] != global.object[6] then 
         global.object[5].object[0].delete()
      end
   end
end




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
            --current_object.attach_to(global.object[4], 0,0,0,relative)
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
   current_object.object[0].delete()
   current_object.set_scale(1)
end



-- to multiplayer test:

-- 1) fireteam spawning into vehicles as the sentry class
-- 2) 