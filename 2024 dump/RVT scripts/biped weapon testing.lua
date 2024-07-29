alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias index = object.number[0]

alias swap_timer = global.timer[0]
declare swap_timer = 2

alias toggle    = global.number[0]

alias temp_num0 = global.number[1]
alias temp_num1 = global.number[2]
alias temp_num2 = global.number[3]
alias temp_num3 = global.number[4]
alias temp_num4 = global.number[5]
alias temp_num5 = global.number[6]
alias temp_num6 = global.number[7]


-- elites use golf club animation
-- elites use plasma pistol animation

function get_biped_weapon()
   temp_obj0 = current_object
   temp_obj2 = no_object
   for each object do
      if temp_obj0 != current_object then
         temp_num0 = current_object.get_distance_to(temp_obj0)
         if temp_num0 == 0 then
            if current_object.team == team[0] then -- weapons naturally exist on red team???????
               temp_obj2 = current_object
            end
         end
      end
   end
end

swap_timer.set_rate(-125%)
if swap_timer.is_zero() then 
   swap_timer.reset()
   toggle ^= 1
   for each object with label "pooper" do
      current_object.team = team[1]
      
      current_object.remove_weapon(secondary, true)
      current_object.remove_weapon(primary, true)
      if toggle == 0 then --restore energy swords
         current_object.add_weapon(energy_sword, primary)
      end
      if toggle == 1 then -- give index weapon
         if current_object.index ==  0 then current_object.add_weapon(assault_rifle, primary) end
         if current_object.index ==  1 then current_object.add_weapon(dmr, primary) end
         if current_object.index ==  2 then current_object.add_weapon(grenade_launcher, primary) end
         if current_object.index ==  3 then current_object.add_weapon(magnum, primary) end
         if current_object.index ==  4 then current_object.add_weapon(rocket_launcher, primary) end
         if current_object.index ==  5 then current_object.add_weapon(shotgun, primary) end
         if current_object.index ==  6 then current_object.add_weapon(sniper_rifle, primary) end
         if current_object.index ==  7 then current_object.add_weapon(spartan_laser, primary) end
         if current_object.index ==  8 then current_object.add_weapon(detached_machine_gun_turret, primary) end
         if current_object.index ==  9 then current_object.add_weapon(concussion_rifle, primary) end
         if current_object.index == 10 then current_object.add_weapon(fuel_rod_gun, primary) end
         if current_object.index == 11 then current_object.add_weapon(gravity_hammer, primary) end
         if current_object.index == 12 then current_object.add_weapon(focus_rifle, primary) end
         if current_object.index == 13 then current_object.add_weapon(needle_rifle, primary) end
         if current_object.index == 14 then current_object.add_weapon(needler, primary) end
         if current_object.index == 15 then current_object.add_weapon(plasma_launcher, primary) end
         if current_object.index == 16 then current_object.add_weapon(plasma_pistol, primary) end
         if current_object.index == 17 then current_object.add_weapon(plasma_repeater, primary) end
         if current_object.index == 18 then current_object.add_weapon(plasma_rifle, primary) end
         if current_object.index == 19 then current_object.add_weapon(spiker, primary) end
         if current_object.index == 20 then current_object.add_weapon(detached_plasma_cannon, primary) end
         if current_object.index == 21 then current_object.add_weapon(target_locator, primary) end
         if current_object.index == 22 then current_object.add_weapon(golf_club, primary) end
         --if current_object.index == 23 then current_object.add_weapon(energy_sword, primary) end
         --temp_obj2.set_hidden(true)
      end
   end
end

alias last_placeholder_weapon = object.object[0]

on local: do
   for each object with label "pooper" do
      get_biped_weapon()
      if current_object.last_placeholder_weapon != temp_obj2 then
         current_object.last_placeholder_weapon = temp_obj2
         if current_object.last_placeholder_weapon != no_object and not current_object.last_placeholder_weapon.is_of_type(energy_sword) then
            temp_obj2.set_scale(1)
            temp_obj1 = temp_obj2.place_at_me(energy_sword, none, suppress_effect, 0,0,0,none)
            temp_obj1.copy_rotation_from(temp_obj2, true)
            temp_obj1.attach_to(temp_obj2, 0,0,0,relative)
         end
      end
   end
end


for each player do 
   if current_player.biped != no_object and current_player.number[0] == 0 then 
      current_player.number[0] = 1

      --temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-50,0,none) temp_obj0.index = 0
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-50,0,none) temp_obj0.index = 0
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-45,0,none) temp_obj0.index = 1
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-40,0,none) temp_obj0.index = 2
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-35,0,none) temp_obj0.index = 3
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-30,0,none) temp_obj0.index = 4
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-25,0,none) temp_obj0.index = 5
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-20,0,none) temp_obj0.index = 6
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-15,0,none) temp_obj0.index = 7
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-10,0,none) temp_obj0.index = 8
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, -5,0,none) temp_obj0.index = 9
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,  0,0,none) temp_obj0.index = 10
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,  5,0,none) temp_obj0.index = 11
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 10,0,none) temp_obj0.index = 12
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 15,0,none) temp_obj0.index = 13
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 20,0,none) temp_obj0.index = 14
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 25,0,none) temp_obj0.index = 15
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 30,0,none) temp_obj0.index = 16
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 35,0,none) temp_obj0.index = 17
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 40,0,none) temp_obj0.index = 18
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 45,0,none) temp_obj0.index = 19
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 50,0,none) temp_obj0.index = 20
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 55,0,none) temp_obj0.index = 21
      temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10, 60,0,none) temp_obj0.index = 22
      --temp_obj0 = current_player.biped.place_at_me(elite, "pooper", none, 10,-55,0,none) temp_obj0.index = 23
   end
end