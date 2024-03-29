alias local_player = global.player[1] -- local player reference, according to the machine its stored on
declare local_player with network priority local -- must be local as this is this machines player; we dont want the host to sync their local player over the clients's

alias host_indicator = global.number[2] -- used in figuring out which machine running 'local' is the host machine
declare host_indicator with network priority local -- must be local as we require the clients to not see the variable we set on host, 
                                                   -- this allows us to differentiate clients from host within the on local: trigger

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
-- set to local as we're using this to briefly store object references on each machine
declare temp_obj0 with network priority local
declare temp_obj1 with network priority local


alias temp_num0 = global.number[0]
declare temp_num0 with network priority local -- set to local as we're using this as a temp var

alias host_existance_check = global.timer[0]
declare host_existance_check = 11 -- just 1 second more than it takes for players to spawn in

alias local_test_obj = object.object[0] 
declare object.local_test_obj with network priority local -- must be local as we store object references to locally created objects per machine

alias server_debug_widget = script_widget[0] -- ## OPTIONAL


-- player collision stuff
alias tracker = player.object[0] 
declare player.tracker with network priority high

alias bped = player.object[1]
declare player.bped with network priority high

alias vehi = player.object[2]
declare player.vehi with network priority high

alias local_vehi = player.object[3]
declare player.local_vehi with network priority local

for each player do
   if current_player.biped != no_object then
      current_player.bped = current_player.biped -- only set when valid so we can detach on local clients, -- this does not need to be done on host, and infact i'll probably move this to local
      if current_player.tracker == no_object then
         current_player.tracker = current_player.biped.place_at_me(flag_stand, none, none, 0,0,0, none)
      end
      -- test whether we need to be attaching to their vehicle or their biped
      current_player.vehi = current_player.get_vehicle()
      if current_player.vehi == no_object then
         current_player.tracker.attach_to(current_player.biped, 0,0,0,relative)
         current_player.tracker.detach()
      end
      if current_player.vehi != no_object then
         current_player.tracker.attach_to(current_player.vehi, 0,0,0,relative)
         current_player.tracker.detach()
      end
   end
end

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
--

alias p_biped = temp_obj0 -- temp object to store player's biped
on local: do
   for each player do
      if current_player.tracker != no_object then
         current_player.tracker.set_scale(1)
         current_player.tracker.copy_rotation_from(current_player.tracker, true)
      end
   end   
   -- fix that issue where you see a biped for the first 1 second AND ALWAYS ASK "waht was that biped for????"
   if host_indicator == 0 then
      for each object with label "hosttarget" do
         current_object.set_scale(1)
      end
   end
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

      -- only run this stuff on non-hosts
      if host_indicator == 0 then
         temp_obj1 = local_player.get_vehicle()
         for each player do
            if current_player != local_player then
               -- detach their biped if they died
               if current_player.biped == no_object and current_player.bped != no_object then
                  current_player.bped.detach()
               end
               -- disable their collision if alive
               if current_player.biped != no_object and current_player.tracker != no_object then
                  temp_obj0 = current_player.get_vehicle() -- extra precaution to wait until both host and client have exited the vehicle
                  if temp_obj0 == no_object and current_player.vehi == no_object then
                     -- check to see if they just got out a vehicle, if so then detach it from this players flagstand
                     if current_player.local_vehi != no_object then
                        current_player.local_vehi.detach()
                        current_player.local_vehi = no_object
                     end
                     -- run normal player collision disabling script
                     current_player.biped.detach() -- detach constantly
                     if local_player.biped != no_object then
                        temp_num0 = current_player.biped.get_distance_to(local_player.biped)
                        if temp_num0 < 8 then -- if this player is this close to our local player, then disable collision
                           current_player.biped.attach_to(current_player.tracker, 0,0,0, relative)
                        end
                     end
                  end
                  if current_player.vehi != no_object then
                     -- run vehicle collision disabling script
                     current_player.vehi.detach()
                     if local_player.biped != no_object and current_player.vehi != temp_obj1 then
                        temp_num0 = current_player.vehi.get_distance_to(local_player.biped)
                        if temp_num0 < 22 then -- extended distance check to account for significantly larger objects
                           current_player.vehi.attach_to(current_player.tracker, 0,0,0, relative)
                        end
                     end
                     current_player.local_vehi = current_player.vehi -- last recorded vehicle that they're in, we store this so we can detach this object when the player exits the vehicle
                  end
               end
            end
         end
      end

	end
end