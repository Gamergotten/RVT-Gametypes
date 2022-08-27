
declare global.number[0] with network priority low
declare global.object[0] with network priority low
declare global.object[1] with network priority low
declare global.player[0] with network priority low
declare object.number[0] with network priority low
declare object.number[1] with network priority low
declare object.number[2] with network priority low
declare object.number[3] with network priority low
declare object.object[0] with network priority low
declare object.object[1] with network priority low
declare object.object[2] with network priority low

for each player do
   current_player.frag_grenades += 1
   current_player.plasma_grenades += 1
end

for each object with label 0 do
   if current_object.number[0] == 0 then 
      global.object[0] = current_object
      global.number[0] = 0
      for each object do
         if current_object == global.object[0] then 
            global.number[0] = 1
         end
      end
      if global.number[0] == 0 then 
         current_object.number[0] = 1
         global.object[1] = current_object.place_at_me(respawn_zone_weak_anti, "poop", none, 0, 0, 0, none)
         global.object[1].object[0] = current_object
         current_object.set_invincibility(1)
      end
   end
end

for each object with label "poop" do
   if current_object.object[0] == no_object then 
      game.show_message_to(all_players, none, "ticks elapsed %n, bounce ticks %n", current_object.number[0], current_object.number[1])
      current_object.delete()
   end
   if current_object.object[0] != no_object then 
      current_object.number[0] += 1
      current_object.set_waypoint_visibility(everyone)
      current_object.set_waypoint_text("t:%n d:%n", hud_target_object.number[0], hud_target_object.number[1])
      current_object.set_waypoint_priority(high)
      
      global.number[0] = 0
      for each player do
         if current_player.biped != no_object then
            global.number[1] = current_object.object[0].get_distance_to(current_player.biped)
            if global.number[1] == 0 then
               global.number[0] = 1
            end
         end
      end
      if global.number[0] == 0 then
         current_object.attach_to(current_object.object[0], 0, 0, 0, relative)
         current_object.detach()
      end
      if current_object.number[2] == 1 then -- has collided
         current_object.number[1] += 1
         if current_object.number[1] >= 35 and current_object.number[0] >= 82 then -- if 35 ticks after bounce AND has existed for at least 82 ticks
            current_object.object[1].detach()
            current_object.object[0].delete()
            current_object.delete()
         end
      end
      if current_object.number[2] == 0 then -- hasn't collided yet
         if global.number[0] == 1 then -- keep it attached to our tracker so it builds up gravity, while waiting for frag to throw
            current_object.object[2].attach_to(current_object, 0,0,0,relative)
            current_object.object[2].detach()
         end
         if current_object.object[2] == no_object then 
            current_object.object[2] = current_object.place_at_me(plasma_grenade, none, none, 0, 0, 0, none)
         end
         if global.number[0] == 0 then 
            global.number[0] = current_object.object[2].get_speed()
            current_object.object[2].attach_to(current_object, 0, 0, 0, relative)
            if global.number[0] < current_object.number[1] then 
               current_object.number[1] = 0
               global.number[0] = 0 -- so the lower action doesn't mess up the above action
               current_object.object[2].delete()
               game.show_message_to(all_players, none, "grenade floor collision")
               current_object.number[2] = 1
               current_object.object[1] = current_object.place_at_me(frag_grenade, none, none, 0, 0, 0, none)
               current_object.object[1].attach_to(current_object.object[0], 0, 0, 0, relative)
            end
            current_object.number[1] = global.number[0]
            current_object.object[2].detach()
         end
      end
   end
end
