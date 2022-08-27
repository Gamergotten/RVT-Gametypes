

alias is_dead = player.number[0] -- HOOK THIS WITH YOUR DEAD BODY POSSESSING SCRIPT
declare player.is_dead with network priority high

alias host_position = player.object[0]
declare player.host_position with network priority high

alias temp_num0 = global.number[0]
declare temp_num0 with network priority local

alias host_indicator = global.number[1]
declare host_indicator with network priority local


-- script to tells clients where the host sees their bipeds
for each player do
   if current_player.biped != no_object then -- only spawn our tracker when the player has actually spawned in
      if current_player.host_position == no_object then
         current_player.host_position = current_player.biped.place_at_me(bomb, none, none, 0,0,0, none) -- this may not need to be a bomb, it might work as a phased object
      end
      -- get rid of the interact prompt
      current_player.host_position.set_pickup_permissions(no_one)
      -- move our object to where the host sees it
      current_player.host_position.attach_to(current_player.biped, 0,0,0,relative)
      current_player.host_position.detach()
      current_player.host_position.copy_rotation_from(current_player.biped, true)
   end
end

do
   host_indicator = 1
end
on local: do
   if host_indicator == 0 then -- do this so we dont attempt to correct bipeds on host (they're already correct)
      for each player do 
         if current_player.is_dead == 1 then -- only do biped corrections when player "is_dead", you will need to write a script to set this yourself
            -- do a distance check to see if the bipeds position needs updating, this is so we dont contiunously attach/detach them into the ground, causing the body to stretch
            temp_num0 = current_player.host_position.get_distance_to(current_player.biped)
            if temp_num0 > 5 then
               -- this action here assings the position AND velocity (or close to) from the host_position, which we copy the position & velocity the the body on host
               current_player.biped.attach_to(current_player.host_position, 0,0,0, relative)
               current_player.biped.detach()
            end
         end
      end         
   end
   -- shrink the host position bombs
   for each player do
      if current_player.host_position != no_object then 
         current_player.host_position.set_scale(1)
         current_player.host_position.copy_rotation_from(current_player.host_position, true)
      end
   end
end

