alias local_player = global.player[1] -- local player reference, according to the machine its stored on
declare local_player with network priority local -- must be local as this is this machines player; we dont want the host to sync their local player over the clients's

alias host_indicator = global.number[2] -- used in figuring out which machine running 'local' is the host machine
declare host_indicator with network priority local -- must be local as we require the clients to not see the variable we set on host, 
                                                   -- this allows us to differentiate clients from host within the on local: trigger

alias temp_obj0 = global.object[0]
declare temp_obj0 with network priority local -- set to local as we're using this to briefly store object references on each machine

alias host_existance_check = global.timer[0]
declare host_existance_check = 11 -- just 1 second more than it takes for players to spawn in

alias local_test_obj = object.object[0] 
declare object.local_test_obj with network priority local -- must be local as we store object references to locally created objects per machine

alias attach_obj = object.object[1] 
declare object.attach_obj with network priority local -- for now this has to be local as we dont wont to wait for the host to spawn it for us

alias server_debug_widget = script_widget[0] -- ## OPTIONAL
alias speed_debug_widget = script_widget[1] -- ## OPTIONAL

alias still_timer = player.timer[0]
declare player.still_timer = 3

alias speed = player.number[0]
declare player.speed with network priority high

alias aaing = player.number[1]
declare player.aaing with network priority high

-- code for host to execute
do
   host_indicator = 1
   -- host_indicator is set to local priority, so it will be set to 0 for clients
   host_existance_check.set_rate(-100%)
end
-- ## OPTIONAL FOR DEBUGGING
if host_existance_check.is_zero() and local_player == no_player then
   -- it must be hosted on the CGB, as the host has failed to find their player
   host_indicator = 2 -- this number is for debugging purposes, so we can tell whether we should run CGB logic, or local customs logic
   server_debug_widget.set_value_text("Dedicated Server ")
end
if local_player != no_player then -- it must be locally hosted if the host has found their own player
   server_debug_widget.set_value_text("Locally Hosted ")
end
-- THIS CAUSES ISSUES FOR LATE JOINERS
for each player do
   if host_existance_check.is_zero() then
      temp_obj0 = current_player.get_weapon(primary)
      temp_obj0.delete()
      temp_obj0 = current_player.get_weapon(secondary)
      temp_obj0.delete()
   end
   temp_obj0 = current_player.get_vehicle()
   if temp_obj0 == no_object then
      current_player.biped.set_scale(100)
   end
end

alias p_biped = temp_obj0 -- temp object to store player's biped
on local: do
   -- /////////////////////////////////
   -- // LOCAL PLAYER FINDING SCRIPT //
   -- /////////////////////////////////
   if local_player == no_player and host_indicator == 0 or not host_existance_check.is_zero() then 
      -- a bit complicated, but only run this code if: 
      -- 1. this machine has not found their local player yet
      -- 2. this machine is not the host, OR they are the host and it hasn't been ~10 seconds yet
      -- this is to prevent the CGB server host from having bipeds in front of clients the entire session
      for each player do  
         p_biped = current_player.biped
         -- spawn and postion a crosshair triggering target
         if p_biped.local_test_obj == no_object then 
            if host_indicator == 1 then -- if host
               p_biped.local_test_obj = p_biped.place_at_me(spartan, "hosttarget", none, 0, 0, 0, none)
            end
            if host_indicator == 0 then -- if client
               p_biped.local_test_obj = p_biped.place_at_me(spartan, "clienttarget", none, 0, 0, 0, none)
            end
            -- elite players' crosshairs do not pickup spartans as the spartans are shorter
            p_biped.local_test_obj.set_scale(160) 
            p_biped.local_test_obj.copy_rotation_from(p_biped.local_test_obj, true)
         end
         -- make sure the target is directly in their way, may require tweaking
         p_biped.local_test_obj.attach_to(p_biped, 5, 0, 0, relative)
         p_biped.local_test_obj.detach() -- detach so player can see the bipod; player cant see it if its attached to them
         -- this action is only capable of finding the crosshair target on the player that this machine currently owns
         temp_obj0 = current_player.get_crosshair_target()
         if temp_obj0 != no_object then 
            -- if an object was found, this means we found the player whos crosshair works, this player can ONLY be our player
            local_player = current_player
         end
      end
   end
   -- run this cleanup seperate, as we want this to work with the CGB server as a host
   -- meaning we need it to cleanup the hosttargets regardless or not if it managed to find our local player
   if host_indicator > 0 and local_player != no_player or host_existance_check.is_zero() then 
      for each object with label "hosttarget" do
         current_object.delete()
      end
   end
   -- here we check to see if we've found the local player yet, host & clients
   if local_player != no_player then 
      -- we can now clean up each biped created while searching for their local player, since these are only created on clients, we can just delete all of them here
      if host_indicator == 0 then 
         for each object with label "clienttarget" do
            current_object.delete()
         end
		end
      -- /////////////////////////////////
      -- // LOCAL PLAYER CODE EXECUTION //
      -- /////////////////////////////////
      -- local_player is our local player, have fun
      -- note, this will run for each client (this includes the host)

      -- client force first person vehicle bug
      if local_player.biped != no_object and host_indicator == 0 then
         temp_obj0 = local_player.get_vehicle()
         if temp_obj0 != no_object then
            -- attach our base object, so attaching offsets from this wont get the player caught on the steering wheel or anything
            if temp_obj0.attach_obj == no_object then
               temp_obj0.attach_obj = temp_obj0.place_at_me(flag_stand,none,none, 0,0,0, none)
               temp_obj0.attach_obj.attach_to(temp_obj0, 0,0,0, relative)
            end
            local_player.biped.detach()
            if temp_obj0.is_of_type(warthog) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -1,1,7, relative)
            end
            if temp_obj0.is_of_type(ghost) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -4,0,6, relative)
            end
            if temp_obj0.is_of_type(scorpion) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 2,2,9, relative)
               -- RUN SPECIAL SCRIPT HERE TO ATTACH TO THE TURRET
            end
            if temp_obj0.is_of_type(wraith) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -3,0,12, relative)
            end
            if temp_obj0.is_of_type(banshee) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 6,0,2, relative)
            end
            if temp_obj0.is_of_type(mongoose) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -1,0,7, relative)
            end
            if temp_obj0.is_of_type(falcon) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 10,0,6, relative)
            end
            if temp_obj0.is_of_type(sabre) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 26,0,12, relative)
            end
            if temp_obj0.is_of_type(revenant) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -4,2,8, relative)
            end
            if temp_obj0.is_of_type(pickup_truck) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 0,1,7, relative)
            end
            if temp_obj0.is_of_type(semi_truck) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 7,2,12, relative)
            end
            if temp_obj0.is_of_type(electric_cart) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -4,2,8, relative)
            end
            if temp_obj0.is_of_type(forklift) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 0,0,8, relative)
            end
            if temp_obj0.is_of_type(oni_van) then
               local_player.biped.attach_to(temp_obj0.attach_obj, 8,2,11, relative)
            end

            -- stationary vehicles
            if temp_obj0.is_of_type(machine_gun_turret) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -3,0,6, relative)
            end
            if temp_obj0.is_of_type(plasma_cannon) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -3,0,6, relative)
            end
            if temp_obj0.is_of_type(shade) then
               local_player.biped.attach_to(temp_obj0.attach_obj, -1,0,8, relative)
            end

            -- shrink the player so their camera is locked to that exact pivot point
            local_player.biped.set_scale(1)
            local_player.biped.copy_rotation_from(local_player.biped, true)
         end
      end




      
	end
end

for each player do
   temp_obj0 = current_player.get_armor_ability()
   current_player.aaing = 0
   if temp_obj0.is_in_use() then
      current_player.aaing = 1
   end
end

do
   speed_debug_widget.set_value_text("Speed: %n", hud_player.speed)
   speed_debug_widget.set_meter_params(timer, hud_player.still_timer)
   script_widget[2].set_value_text("Ability inuse?: %n", hud_player.aaing)
end
alias min_speed = 5
for each player do
   if current_player.biped != no_object then
      current_player.speed = current_player.biped.get_speed()
      if current_player.speed < min_speed then
         current_player.still_timer.set_rate(-100%)
         if current_player.still_timer.is_zero() then
            current_player.biped.detach()
            current_player.still_timer.reset()
            game.show_message_to(current_player, none, "still for too long, (stuck??) exiting.")
            -- make sure we fix their scale for clients
            current_player.biped.set_scale(100)
            current_player.biped.copy_rotation_from(current_player.biped, true)
         end
      end
      if current_player.speed >= min_speed then
         current_player.still_timer.reset()
      end
   end
end