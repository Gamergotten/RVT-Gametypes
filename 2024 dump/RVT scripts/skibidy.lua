
declare global.number[0] with network priority low
declare global.number[1] with network priority local
declare global.number[2] with network priority low
declare global.number[3] with network priority local
declare global.number[4] with network priority local
declare global.number[5] with network priority local -- temp
declare global.number[6] with network priority local -- temp
declare global.number[7] with network priority local -- temp
declare global.number[8] with network priority local -- temp
declare global.number[9] with network priority local -- temp
declare global.object[0] with network priority low
declare global.object[1] with network priority local
declare global.object[2] with network priority local -- temp
declare global.object[3] with network priority local -- temp
declare global.object[4] with network priority local -- temp
declare global.object[5] with network priority local -- temp
declare global.object[6] with network priority local -- temp
declare global.object[7] with network priority local -- temp
declare global.object[8] with network priority local -- temp
declare global.player[0] with network priority local
declare global.player[1] with network priority local
declare global.timer[0] = script_option[3]
declare global.timer[1] = 10
declare player.number[0] with network priority low
declare player.number[1] with network priority low
declare player.number[2] with network priority low = 1
declare player.number[3] with network priority low
declare player.timer[0] = 1
declare player.timer[1] = 5
declare player.timer[2] = 1
declare object.number[0] with network priority low
declare object.number[1] with network priority local
declare object.timer[0] = script_option[3]

for each player do
   if current_player.number[0] != 1 then 
      if current_player.is_elite() then 
         current_player.set_loadout_palette(elite_tier_1)
      end
      if not current_player.is_elite() then 
         current_player.set_loadout_palette(spartan_tier_1)
      end
   end
   if current_player.number[0] == 1 then 
      if current_player.is_elite() then 
         current_player.set_loadout_palette(elite_tier_2)
      end
      if not current_player.is_elite() then 
         current_player.set_loadout_palette(spartan_tier_2)
      end
   end
end

do
   global.number[3] = 0
   global.number[4] = -1
   for each player do
      global.number[4] += 1
      if current_player.number[0] == 1 then 
         global.number[3] += 1
      end
   end
   for each player randomly do
      if global.number[3] < script_option[0] and global.number[3] < global.number[4] and current_player.number[1] != 1 and current_player.number[0] != 1 then 
         current_player.number[0] = 1
         global.number[3] += 1
      end
   end
   for each player do
      if current_player.number[0] == 1 and current_player.team != team[1] then 
         send_incident(inf_new_zombie, current_player, no_player)
         current_player.team = team[1]
         current_player.apply_traits(script_traits[0])
         current_player.biped.kill(true)
      end
   end
end

function _330x_recurs()
   if global.number[5] > 0 then 
      global.number[5] -= 1
      global.number[7] = global.number[9]
      global.number[7] /= 33
      global.number[8] = global.number[9]
      global.number[8] /= 228
      global.number[9] += global.number[7]
      global.number[9] += global.number[8]
      _330x_recurs()
   end
end
function _330x()
   if global.number[6] != 0 then
      global.number[9] = 100
      global.number[5] = global.number[6]
      if global.number[6] < 0 then 
         global.number[5] *= 5
         global.number[9] += global.number[5]
         if global.number[6] <= -20 then 
            global.number[5] = global.number[6]
            global.number[5] += 201
            if global.number[6] == -20 then 
               global.number[9] = 1
            end
         end
      end
      if global.number[6] < -20 or global.number[6] > 0 then 
         global.number[9] = 100
         _330x_recurs()
      end
      global.object[3].set_scale(global.number[9])
      --global.object[3].copy_rotation_from(global.object[2], true)
      global.object[3].copy_rotation_from(global.object[6], true) -- use rotation from previous object
      global.object[6] = global.object[3]
   end
end

for each player do
    if current_player.biped != no_object and current_player.team == team[1] then
        global.object[2] = current_player.biped
        global.object[2].number[1] += 1
        if global.object[2].number[1] == 5 then
            -- init skibidy
            alias base = global.object[2]
            alias yaw = global.object[7]
            alias pitch = global.object[5]
            alias roll = global.object[4]

            global.object[8] = current_player.get_armor_ability()
            if global.object[8] == no_object then
                global.object[8] = current_player.biped
            end

            base = current_player.biped.place_at_me(flag_stand, none, none, 0,0,0,none)
            -- create rotation pieces
            roll = base.place_between_me_and(base, flag_stand, 0)
            pitch = base.place_between_me_and(base, flag_stand, 0)
            yaw = pitch.place_at_me(flag_stand, none, none, 0,0,0,none)
            --  perserve roll piece rotation
            roll.attach_to(yaw, 0,0,0,relative)
            yaw.face_toward(yaw,0,-1,0) -- offsets so our pitch is relative pitch
            -- stick the pitch on
            pitch.attach_to(yaw, 0,0,0,relative)
            -- make it all relative
            yaw.copy_rotation_from(base, true)
            roll.detach()
            pitch.detach()

            -- start adding health pack pieces --

            -- water tank (no rotation required)
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 24
            global.object[6] = global.object[3] -- just as an optimization
            _330x()
            -- rotate to the left on yaw
            global.object[3].face_toward(global.object[3], 0, -1, 0)
            -- rotate 90 degrees on pitch
            global.object[3].attach_to(pitch, 0,0,0,relative) 
            pitch.face_toward(pitch, 0, 1, 0)
            global.object[3].detach()
            -- complete & store rotation
            global.object[3].attach_to(base, -3,0,1,relative)


            -- raised toilet seat
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 24
            _330x()
            -- rotate backwards on yaw
            global.object[3].attach_to(yaw, 0,0,0,relative) 
            yaw.face_toward(yaw, -1, 0, 0)
            global.object[3].detach()
            -- rotate 90 degree on roll
            global.object[3].attach_to(roll, 0,0,0,relative) 
            roll.face_toward(roll, 0, -1, 0)
            global.object[3].detach()
            -- complete & store rotation
            global.object[3].attach_to(base, -1,0,1,relative)


            -- bowl top
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 24
            _330x()
            -- rotate 90 degrees pitch
            global.object[3].attach_to(pitch, 0,0,0,relative) 
            pitch.face_toward(pitch, 0, -1, 0)
            global.object[3].detach()
            -- complete & store rotation
            global.object[3].attach_to(base, 0,0,0,relative)


            -- neck part
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 6
            _330x()
            global.object[3].attach_to(base, 0,0,-2,relative)

            -- base
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 17
            _330x()
            global.object[3].attach_to(base, 0,0,-3,relative)
            

            -- under bowl
            global.object[3] = base.place_at_me(health_pack, none, none, 0,0,0,none)
            global.number[6] = 20
            _330x()
            -- rotate upside down on pitch
            global.object[3].attach_to(pitch, 0,0,0,relative) 
            pitch.face_toward(pitch, -1, 0, 0)
            global.object[3].detach()
            -- complete
            global.object[3].attach_to(base, 0,0,-2,relative)

            roll.delete()
            pitch.delete()
            yaw.delete()
            
            -- then attach to our players armor ability
            game.show_message_to(current_player, none, "its SKIBIDI time")

            -- setup new pitch rotate
            pitch = base.place_between_me_and(base, flag_stand, 0)
            yaw = pitch.place_at_me(flag_stand, none, none, 0,0,0,none)
            yaw.face_toward(yaw,0,-1,0) -- offsets so our pitch is relative pitch
            pitch.attach_to(yaw, 0,0,0,relative)
            -- make it all relative
            yaw.copy_rotation_from(global.object[8], true)
            pitch.detach()
            base.copy_rotation_from(global.object[8], true)
            -- perform relative pitch rotation
            base.attach_to(pitch, 0,0,0,relative)
            pitch.face_toward(pitch, 0,1,0)
            base.detach()

            -- cleanup again
            pitch.delete()
            yaw.delete()

            -- then complete skibidi attachment
            base.attach_to(global.object[8], 0,0,-1,relative)
            --base.detach()
        end
    end
end

for each player do
   script_widget[0].set_text("Safe Haven - %s", global.timer[0])
   script_widget[0].set_visibility(current_player, false)
end

for each player do
   current_player.timer[1].set_rate(-100%)
   for each player do
      if current_player.team == team[0] then 
         current_player.set_objective_text("Defend yourself from the zombie horde!")
      end
   end
   for each player do
      if current_player.team == team[1] then 
         current_player.set_objective_text("Braaaaaains...")
      end
   end
end

for each player do
   if current_player.number[3] == 0 and current_player.timer[1].is_zero() then 
      send_incident(infection_game_start, current_player, no_player)
      current_player.number[3] = 1
   end
end

for each player do
   current_player.team = team[0]
   if current_player.number[0] == 1 then 
      current_player.team = team[1]
      current_player.apply_traits(script_traits[0])
   end
end

for each player do
   if current_player.killer_type_is(guardians | suicide | kill | betrayal | quit) then 
      current_player.number[1] = 0
      global.player[0] = current_player
      global.player[1] = no_player
      global.player[1] = current_player.try_get_killer()
      if current_player.killer_type_is(kill) and global.player[0].number[0] == 1 and global.player[0].number[0] != global.player[1].number[0] then 
         global.player[1].score += script_option[7]
         send_incident(zombie_kill_kill, global.player[1], global.player[0])
      end
      if current_player.killer_type_is(kill) and script_option[2] == 1 and global.player[0].number[0] == 1 and global.player[0].number[0] != global.player[1].number[0] and global.player[1].number[2] == 1 then 
         global.player[1].score += script_option[6]
      end
      if current_player.killer_type_is(kill) and not global.player[1] == no_player and global.player[0].number[0] == 0 then 
         global.player[0].number[0] = 1
         send_incident(inf_new_infection, global.player[1], global.player[0])
         send_incident(infection_kill, global.player[1], global.player[0])
         global.player[1].score += script_option[10]
         global.player[1].script_stat[1] += 1
      end
      if current_player.killer_type_is(suicide) then 
         global.player[1].score += script_option[8]
         if script_option[12] == 1 then 
            global.player[0].number[0] = 1
         end
      end
      if current_player.killer_type_is(betrayal) and global.player[0].number[0] == global.player[1].number[0] then 
         global.player[1].score += script_option[9]
      end
   end
end

if script_option[2] == 1 and global.object[0] == no_object then 
   global.object[0] = get_random_object("inf_haven", global.object[1])
   if global.number[1] == 1 then 
      send_incident(hill_moved, all_players, all_players)
   end
   global.number[1] = 1
end

if script_option[2] == 1 and global.timer[0].is_zero() then 
   global.timer[0].set_rate(0%)
   global.timer[0] = script_option[3]
   global.object[0].set_waypoint_visibility(no_one)
   global.object[0].set_shape_visibility(no_one)
   global.object[0].set_waypoint_timer(none)
   global.object[0].number[0] = 0
   global.object[1] = global.object[0]
   global.object[0] = no_object
   global.object[0] = get_random_object("inf_haven", global.object[1])
end

do
   global.object[0].set_waypoint_visibility(everyone)
   global.object[0].set_waypoint_icon(crown)
   global.object[0].set_shape_visibility(everyone)
   global.object[0].set_waypoint_priority(high)
end

if script_option[2] == 1 then 
   for each player do
      if global.object[0].shape_contains(current_player.biped) and current_player.number[0] == 0 and global.object[0].number[0] == 0 then 
         global.timer[0].set_rate(-100%)
         global.object[0].number[0] = 1
      end
   end
   if global.object[0].number[0] == 1 then 
      global.object[0].timer[0] = global.timer[0]
      global.object[0].set_waypoint_timer(0)
      if global.object[0].timer[0] < 6 then 
         global.object[0].set_waypoint_priority(blink)
      end
   end
end

if script_option[1] == 1 then 
   global.number[3] = 0
   if global.number[0] == 0 then 
      for each player do
         if not current_player.number[0] == 1 then 
            global.number[3] += 1
         end
      end
      if global.number[3] == 1 then 
         for each player do
            if not current_player.number[0] == 1 then 
               current_player.apply_traits(script_traits[1])
               current_player.biped.set_waypoint_icon(skull)
               current_player.biped.set_waypoint_priority(high)
               current_player.number[1] = 1
               current_player.score += script_option[11]
               send_incident(inf_last_man, current_player, all_players)
            end
         end
         global.number[0] = 1
      end
   end
end

for each player do
   if current_player.number[1] == 1 then 
      current_player.apply_traits(script_traits[1])
   end
end

for each player do
   script_widget[0].set_visibility(current_player, false)
   current_player.number[2] = 0
   if script_option[2] == 1 and global.object[0].shape_contains(current_player.biped) and current_player.number[0] == 0 then 
      current_player.number[2] = 1
      current_player.apply_traits(script_traits[2])
      script_widget[0].set_visibility(current_player, true)
   end
end

do
   global.timer[1].set_rate(-100%)
   if global.timer[1].is_zero() then 
      global.number[3] = 0
      for each player do
         if current_player.number[0] == 0 then 
            global.number[3] += 1
         end
      end
      for each player do
         if global.number[3] == 1 and current_player.number[0] == 0 and current_player.killer_type_is(suicide) then 
            global.number[3] = 0
         end
      end
      if global.number[3] == 0 then 
         send_incident(infection_zombie_win, all_players, all_players)
         for each player do
            if current_player.number[1] != 1 and current_player.number[0] == 1 then 
               current_player.score += script_option[4]
            end
         end
         game.end_round()
      end
   end
end

if game.round_timer.is_zero() and game.round_time_limit > 0 then 
   global.number[3] = 0
   for each player do
      if current_player.number[0] == 0 then 
         global.number[3] += 1
      end
   end
   if not global.number[3] == 0 then 
      send_incident(infection_survivor_win, all_players, all_players)
      for each player do
         if current_player.number[0] == 0 then 
            current_player.score += script_option[5]
         end
      end
      game.end_round()
   end
end

for each player do
   if current_player.number[0] == 0 then 
      current_player.timer[2].set_rate(-100%)
      if current_player.timer[2].is_zero() then 
         current_player.script_stat[0] += 1
         current_player.timer[2].reset()
      end
   end
end
