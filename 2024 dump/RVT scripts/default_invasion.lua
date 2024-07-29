
alias objective_contested  = global.number[0]
alias inv_phase            = global.number[1]
alias temp_num0            = global.number[2]
declare objective_contested   with network priority high
declare inv_phase             with network priority local = 1
declare temp_num0             with network priority local

alias inv_core = global.object[0]
declare inv_core with network priority local

alias flag_carrier = global.player[0]
alias last_carrier = global.player[1]
alias temp_player0 = global.player[2]
declare flag_carrier with network priority local
declare last_carrier with network priority local
declare temp_player0 with network priority local

alias sudden_death_announce_interval   = global.timer[0]
alias game_end_delay                   = global.timer[1]
alias announce_a_attack_timer          = global.timer[2]
alias core_holder_announce_interval    = global.timer[3]
declare sudden_death_announce_interval = 35
declare game_end_delay                 = 5
declare announce_a_attack_timer        = 11
declare core_holder_announce_interval  = 3

alias temp_team0 = global.team[0]

alias phase_duration = 240
alias territory_regen = 7

alias has_moved    = object.number[0]
declare object.has_moved with network priority local

alias cap_timer    = object.timer[0]
alias reset_timer  = object.timer[1]
declare object.cap_timer = 20
declare object.reset_timer = 45

alias sounder = object.object[0]
declare object.sounder with network priority local

alias team_num0 = team.number[0]
declare team.team_num0 with network priority local


alias init_ticks = player.number[0]
declare player.init_ticks with network priority local

alias SPARTANS = team[0]
alias ELITES = team[1] 

alias flag_traits = script_traits[0]
alias under_attack_widget = script_widget[0]


on pregame: do
   game.symmetry = 0
end

do
   objective_contested = 0
   announce_a_attack_timer.set_rate(-100%)
   sudden_death_announce_interval.set_rate(-100%)
   core_holder_announce_interval.set_rate(-100%)
   game.grace_period_timer.set_rate(-100%)
   under_attack_widget.set_text("Your objective is under attack!")
end

-------------------------------
-- PLAYER INTRO AND LOADOUTS --
-------------------------------
for each player do
   current_player.init_ticks += 1
   under_attack_widget.set_visibility(current_player, false)
   if current_player.init_ticks == 300 then -- 5 seconds
      send_incident(invasion_game_start_c, current_player, no_player)
      if current_player.team == ELITES then 
         send_incident(team_defense, current_player, no_player)
      end
   end
end
-- re run logic to not have to nest the spartan check condition
for each player do 
   if current_player.init_ticks == 300 and current_player.team == SPARTANS then 
      send_incident(team_offense, current_player, no_player)
   end
end
-- title cards team things
for each player do
   current_player.biped.set_waypoint_visibility(allies)
   current_player.biped.set_waypoint_priority(normal)
   current_player.set_objective_allegiance_icon(covenant)
   current_player.set_objective_allegiance_name("Elite")
   if current_player.team == SPARTANS then 
      current_player.set_objective_allegiance_icon(noble)
      current_player.set_objective_allegiance_name("Spartan")
   end
end
-- title card objective text + loadouts
for each player do
   if inv_phase == 1 then 
      current_player.set_loadout_palette(spartan_tier_1)
      current_player.set_objective_text("CAPTURE THE OBJECTIVE")
      if current_player.team == ELITES then 
         current_player.set_loadout_palette(elite_tier_1)
         current_player.set_objective_text("DEFEND THE OBJECTIVE")
      end
   end
end
for each player do
   if inv_phase == 2 then 
      current_player.set_loadout_palette(spartan_tier_2)
      current_player.set_objective_text("CAPTURE ALL OBJECTIVES")
      if current_player.team == ELITES then 
         current_player.set_loadout_palette(elite_tier_2)
         current_player.set_objective_text("DEFEND ALL OBJECTIVES")
      end
   end
end
for each player do
   if inv_phase == 3 then 
      current_player.set_loadout_palette(spartan_tier_3)
      current_player.set_objective_text("CAPTURE THE CORE")
      if current_player.team == ELITES then 
         current_player.set_loadout_palette(elite_tier_3)
         current_player.set_objective_text("DEFEND THE CORE")
      end
   end
end
-- END OF SECTION --------------------------------------------------------------------




-----------------------
-- TERRITORIES LOGIC --
-----------------------
for each object with label "inv_objective" do
   if current_object.spawn_sequence < inv_phase then 
      current_object.delete()
   end
end
for each object with label "inv_objective" do
   if current_object.spawn_sequence == inv_phase then 
      current_object.set_waypoint_visibility(everyone)
      current_object.set_waypoint_icon(ordnance)
      current_object.set_waypoint_priority(high)
      current_object.set_shape_visibility(everyone)
      current_object.set_progress_bar(0, enemies)
      if current_object.sounder == no_object then -- store as object reference just so its only run once!!
         current_object.sounder = current_object.place_at_me(sound_emitter_alarm_1, none, never_garbage_collect | suppress_effect, 0, 0, 0, none)
         current_object.sounder.attach_to(current_object, 0,0,5,relative) -- so its deleted when this is deleted
      end
   end
end
for each object with label "inv_objective" do
   current_object.cap_timer.set_rate(0%)
   if current_object.spawn_sequence == inv_phase and inv_phase <= 2 then 
      -- count players in hill
      SPARTANS.team_num0 = 0
      ELITES.team_num0 = 0
      for each player do
         if current_object.shape_contains(current_player.biped) then 
            temp_team0 = current_player.team
            temp_team0.team_num0 += 1
         end
      end
      -- if controlled by spartans, blink and allow sudden death
      if SPARTANS.team_num0 > 0 then 
         objective_contested = 1
         current_object.set_waypoint_priority(blink)
         if ELITES.team_num0 == 0 then -- contest if elites
            current_object.cap_timer.set_rate(-100%)
         end
      end
      -- regenerate timer if no spartans
      if SPARTANS.team_num0 == 0 and current_object.cap_timer < territory_regen then 
         current_object.cap_timer.set_rate(100%)
      end
   end
end
for each object with label "inv_objective" do
   if current_object.cap_timer.is_zero() then 
      current_object.delete() -- clear current objective
      if inv_phase == 1 then -- phase 1 we only need to cap a single objective
         for each object with label "inv_objective" do
            if current_object.spawn_sequence == 1 then
               current_object.delete()
            end
         end
      end
   end
end
for each player do
   if objective_contested == 1 and inv_phase <= 2 and current_player.team == ELITES then 
      under_attack_widget.set_visibility(current_player, true)
   end
end
if objective_contested == 1 and inv_phase <= 2 and announce_a_attack_timer.is_zero() then
   game.play_sound_for(ELITES, announce_a_under_attack, true)
   announce_a_attack_timer.reset()
end
-- END OF SECTION --------------------------------------------------------------------


---------------------
-- CTF PHASE LOGIC --
---------------------
-- reset core
if inv_core.is_out_of_bounds() or inv_core.reset_timer.is_zero() then 
   inv_core.delete()
   send_incident(inv_core_reset, all_players, all_players)
end
-- spawn core
flag_carrier = inv_core.get_carrier()
for each object with label "inv_objective" do
   if current_object.spawn_sequence == 5 and inv_phase == 3 then 
      if inv_core == no_object then 
         inv_core = current_object.place_at_me(covenant_power_core, none, never_garbage_collect, 0, 0, 3, none)
         inv_core.team = ELITES
         inv_core.set_pickup_permissions(enemies)
         inv_core.set_weapon_pickup_priority(high)
         inv_core.set_shape(sphere, 10)
      end
   end
end
-- update core icons
if flag_carrier == no_player and inv_core != no_object then 
   inv_core.set_waypoint_icon(flag)
   inv_core.set_waypoint_visibility(everyone)
   inv_core.set_waypoint_priority(high)
   inv_core.set_progress_bar(object.reset_timer, allies)
end
if flag_carrier != no_player and inv_core != no_object then 
   inv_core.has_moved = 1
   flag_carrier.apply_traits(flag_traits)
   flag_carrier.biped.set_waypoint_icon(flag)
   inv_core.set_waypoint_visibility(no_one)
   inv_core.set_progress_bar(object.reset_timer, no_one)
   objective_contested = 1
   for each object with label "inv_objective" do
      if current_object.spawn_sequence == inv_phase and current_object.shape_contains(flag_carrier.biped) then 
         inv_core.delete()
         current_object.delete()
         send_incident(inv_core_captured, flag_carrier, all_players)
      end
   end
end
-- determine whether core is being reset or not
if inv_core != no_object and inv_core.has_moved == 1 and flag_carrier == no_player then 
   inv_core.reset_timer.set_rate(100%)
   -- 2 free actions for a whole buncha conditions
   for each player do
      if current_player.team == ELITES and inv_core.shape_contains(current_player.biped) then 
         inv_core.reset_timer.set_rate(-100%)
         inv_core.set_waypoint_priority(blink)
      end
   end
   for each player do
      if current_player.team == SPARTANS and inv_core.shape_contains(current_player.biped) then 
         inv_core.reset_timer.set_rate(0%)
      end
   end
end
-- announce players picking up or dropping the flag
if inv_phase == 3 and core_holder_announce_interval.is_zero() then 
   if last_carrier != flag_carrier then
      -- 2 free actions if you want to use the crazy amount of conditions
      if last_carrier == no_player then 
         send_incident(inv_core_grabbed, flag_carrier, all_players)
      end
      if last_carrier != no_player then 
         send_incident(inv_core_dropped, flag_carrier, all_players)
      end
      core_holder_announce_interval.reset()
      last_carrier = flag_carrier
   end
end
-- announce flag carrier kill
for each player do
   if inv_phase == 3 and flag_carrier.killer_type_is(kill) then 
      temp_player0 = flag_carrier.try_get_killer()
      send_incident(flagcarrier_kill, temp_player0, flag_carrier)
   end
end
-- END OF SECTION --------------------------------------------------------------------


-----------------------------
-- PHASE PROGRESSION LOGIC --
-----------------------------
do
   temp_num0 = 0
end
for each object with label "inv_objective" do
   if current_object.spawn_sequence == inv_phase then
      temp_num0 += 1
   end
end
if inv_phase < 4 and temp_num0 == 0 then
   inv_phase += 1
   game.round_timer = phase_duration -- by default its 4 minutes
   game.sudden_death_timer.reset()
   SPARTANS.score += 1
   -- phase 1 complete
   if inv_phase == 2 then 
      game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
   end
   -- phase 2 complete
   if inv_phase == 3 then 
      game.play_sound_for(all_players, inv_cue_spartan_win_2, true)
   end
   -- phase 3 complete
   if inv_phase == 4 then 
      game.play_sound_for(all_players, inv_cue_spartan_win_big, true)
      send_incident(inv_spartan_win, all_players, no_player)
   end
end
-- END OF SECTION --------------------------------------------------------------------

---------------------
-- GANE OVER LOGIC --
---------------------
if inv_phase == 4 then 
   game_end_delay.set_rate(-100%)
   if game_end_delay.is_zero() then 
      game.end_round()
   end
end
if not game.round_timer.is_zero() then 
   game.grace_period_timer = 0
end
if game.round_timer.is_zero() then 
   if objective_contested == 1 then 
      game.sudden_death_timer.set_rate(-100%)
      game.grace_period_timer.reset()
      if game.sudden_death_time > 0 and game.grace_period_timer > game.sudden_death_timer then 
         game.grace_period_timer = game.sudden_death_timer
      end
   end
end
if game.round_timer.is_zero() then 
   if objective_contested == 1 then 
      if sudden_death_announce_interval.is_zero() then 
         sudden_death_announce_interval.reset()
         send_incident(sudden_death, all_players, all_players)
      end
   end
end
if game.round_timer.is_zero() and objective_contested == 0 or game.sudden_death_timer.is_zero() then 
   if game.grace_period_timer.is_zero() or game.sudden_death_timer.is_zero() then 
      -- this is supposed to be called the next tick but whatever
      game.end_round()
      if SPARTANS.score == 0 then 
         send_incident(inv_elites_win_rd1, all_players, no_player)
      end
      if SPARTANS.score != 0 then 
         send_incident(inv_elite_win, all_players, no_player)
      end
   end
end
-- END OF SECTION --------------------------------------------------------------------

on local: do
   set_scenario_interpolator_state(1, objective_contested)
end