

-- cargo_object objects detach when a player enters their boundary 
-- all weapons are detached and their tether is cleaned up when picked up
-- attach_object with team[7] stays attached and does not have collision


declare global.number[0] with network priority local
declare global.number[1] with network priority local
declare global.number[2] with network priority local
declare global.number[3] with network priority local


declare global.object[0] with network priority local
declare global.object[1] with network priority local
declare global.object[2] with network priority local
declare global.object[3] with network priority local
declare global.object[4] with network priority local
declare global.object[5] with network priority local
declare global.object[8] with network priority local

declare global.object[6] with network priority local -- mover agent, this is so we dont have so spawn objects whenever we want to measure distance
declare global.object[7] with network priority local -- mover agent, this is so we dont have so spawn objects whenever we want to measure distance


alias temp_num0 = global.number[0]
alias temp_num1 = global.number[3]

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_obj2 = global.object[2]
alias temp_obj3 = global.object[3]

alias temp_obj4 = global.object[4]
alias temp_obj5 = global.object[5]
alias temp_obj6 = global.object[8]

alias mover_agent1 = global.object[6]
alias mover_agent2 = global.object[7]


declare object.number[0] with network priority high 
declare object.number[1] with network priority local
declare object.number[2] with network priority high 

declare object.object[0] with network priority high
declare object.object[1] with network priority high
declare object.object[2] with network priority high


alias parent = object.object[0]
alias offset = object.object[1] 
alias block = object.object[2]
alias designated_scale = object.number[0]
alias has_scaled = object.number[1]

declare player.object[0] with network priority local
declare player.object[1] with network priority local
declare player.object[2] with network priority local
alias r_base = player.object[0]
alias r_offset = player.object[1]
alias r_last = player.object[2]

declare player.number[2] with network priority local
alias relatives = player.number[2]


-- TODO
-- - remove the creation of all those objects
-- - only move local player

-- - figure out what was causing critical lag issues
-- - add auto moving object support
-- - figure out how to not cancel spawns
-- - reduce label usage 
-- - reduce scripted object count




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
function basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
   -- make sure the yaw object is at the center of our object, pitch already is because we used place_between(on self) for it
   yaw_obj.attach_to(basis, 0,0,0, relative)
   yaw_obj.detach()   
   -- convert roll to pitch by rotating yaw 90 degrees, altering the relative roll to relative pitch
   yaw_obj.face_toward(yaw_obj,0,-1,0)
   -- rotate the pitch to be relative to direction (as in so its pointing towards our lookat_obj)
   pitch_obj.attach_to(yaw_obj, 0,0,0, relative)
   yaw_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.detach()
   -- apply the relative pitch rotation to our yaw axis
   yaw_obj.attach_to(pitch_obj, 0,0,0, relative) 
   pitch_obj.face_toward(lookat_obj,0,0,0)
   pitch_obj.face_toward(pitch_obj,0,-1,0)
   yaw_obj.detach()
   -- setup offset object & attach-offset it in the forward direction
   pitch_obj.delete()
   offset_obj = yaw_obj.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0, none)
   offset_obj.copy_rotation_from(current_object, true)
   offset_obj.attach_to(yaw_obj, 100,0,0, relative)
   -- now we just do the attaching forward
   -- set scale of yaw obj, thus scaling the attachment offset of offset_obj
   yaw_obj.set_scale(offset_scale)
   yaw_obj.copy_rotation_from(yaw_obj, true) -- update yaw_obj's scale
end
function config_thingo()
   pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_1, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
   yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0, none)
   basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
end
-- you will have to cleanup (delete pitch, yaw & offset objects after you're done with them)

-- truck_cab dismember trailer script
for each object with label 3 do 
   if current_object.team == neutral_team and current_object.number[7] == 0 then
      current_object.number[7] = 1
      temp_obj0 = current_object
      temp_num0 = -1
      for each object do 
         if temp_num0 == 0 then
            current_object.delete()
            temp_num0 += 1
         end
         if current_object == temp_obj0 then
            temp_num0 = 0
         end
      end
   end
end
function offset_attach_object()
   if current_object.spawn_sequence == temp_obj4.spawn_sequence then
      lookat_obj = current_object.place_between_me_and(current_object, sound_emitter_alarm_1, 0)
      offset_scale = lookat_obj.get_distance_to(basis)
      -- place pitch and yaw objects
      pitch_obj = basis.place_between_me_and(basis, sound_emitter_alarm_1, 0) -- currently setup as ROLL, opposed to pitch, a correction we will make in a moment
      yaw_obj = pitch_obj.place_at_me(sound_emitter_alarm_1, "configure_scale", none, 0,0,0, none)
      basis_toward_lookat_dist__return_yaw_pitch_offset_obj()
      current_object.attach_to(offset_obj, 0,0,0,relative)
      lookat_obj.delete()
      yaw_obj.attach_to(temp_obj4, 0,0,0,relative)
      yaw_obj.parent = temp_obj4
      yaw_obj.offset = offset_obj
      yaw_obj.block = current_object
      yaw_obj.designated_scale = offset_scale
      yaw_obj.has_scaled = 1
      yaw_obj.team = current_object.team
   end
end
-- configure attchment offsets script
for each object with label "attach_base" do
   if current_object.number[0] == 0 then
      current_object.number[0] = 1
      basis = current_object.place_between_me_and(current_object, sound_emitter_alarm_1, 0)
      -- temp_obj4 was the current_object, however, clients face an interesting issue where its possible for attachments to rotate
      temp_obj4 = current_object
      for each object with label "attach_offset" do
         offset_attach_object()
      end
      for each object with label "attach_cargo" do 
         offset_attach_object()
      end
      basis.delete()
      temp_obj4 = no_object
   end
end
-- detach any vehicles/weapons when they're picked up
function cleaup_scaled_offset_attachment()
   temp_obj0.detach()
   temp_obj0.number[0] = 3621
   for each object with label "configure_scale" do
      if current_object.block == temp_obj0 then
         current_object.delete()
      end
   end
end
-- detach & untether attached objects script
for each player do
   for each object with label "attach_cargo" do 
      temp_obj0 = current_object
      if temp_obj0.number[0] != 3621 then
         for each player do 
            if temp_obj0.shape_contains(current_player.biped) then
               cleaup_scaled_offset_attachment()
            end
         end
      end
   end
   temp_obj0 = current_player.get_weapon(primary)
   if temp_obj0.has_forge_label("attach_offset") and temp_obj0.number[0] != 3621 then
      cleaup_scaled_offset_attachment()
   end
end
-- set our host indicator, so we know to ignore logic 
do
   global.number[1] = 3621 -- set this to a hgih number that is not either 0 or 1
end 

function get_active_controlled_object()
   temp_obj6 = current_player.biped 
   temp_obj0 = current_player.get_vehicle()
   if temp_obj0 != no_object then
      if not temp_obj0.has_forge_label("attach_base") and not temp_obj0.has_forge_label("attach_offset") and not temp_obj0.has_forge_label("attach_cargo") then
         temp_obj6 = temp_obj0
      end
      if temp_obj0.has_forge_label("attach_cargo") and temp_obj0.number[0] == 3621 then
         temp_obj6 = temp_obj0
      end
   end
end

on local: do
   global.number[1] ^= 1
   if global.number[1] == 0 then 

      -- runs once every 4 ticks; updates players relative locations
      -- TODO: optimize this into a single global.number with |=
      global.number[2] += 1
      if global.number[2] == 2 then
         global.number[2] = 0

         -- relative velocity thing
         for each player do
            current_player.relatives = 0
         end
         for each object with label "attach_base" do
            for each player do
               if current_player.biped != no_object and current_object.shape_contains(current_player.biped) then
                  current_player.relatives += 1
               end
            end
            -- a bit lazy, but we'll spawn in the mover agents here, as there have to be attach_base's for things to get moved (probably)
            if mover_agent1 == no_object then 
               mover_agent1 = current_object.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0,none)
            end
            if mover_agent2 == no_object then 
               mover_agent2 = current_object.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0,none)
            end
         end
         for each object with label "attach_base" do
            if current_object.shape_contains(current_object) then
               for each player do
                  if current_player.relatives != 1 then -- inside either too many or too little vehicles
                     if current_player.r_offset != no_object then
                        current_player.r_offset.delete()
                     end
                     if current_player.r_base != no_object then
                        current_player.r_base.delete()
                     end
                  end
                  get_active_controlled_object()
                  if temp_obj6 != no_object and current_player.relatives == 1 and current_object.shape_contains(temp_obj6) then
                     if current_player.r_base != no_object then
                        -- find the offset that this player actually moved this tick
                        if current_player.r_last == no_object then
                           game.show_message_to(all_players, none, "last failed")
                        end
                        if current_player.r_offset == no_object then
                           game.show_message_to(all_players, none, "offset failed")
                        end
                        basis = current_player.r_last
                        lookat_obj = mover_agent1
                        lookat_obj.attach_to(temp_obj6,0,0,0,relative)
                        lookat_obj.detach()

                        offset_scale = lookat_obj.get_distance_to(basis)
                        temp_num1 = offset_scale
                        if offset_scale > 0 then
                           config_thingo()
                           temp_obj4 = offset_obj.place_between_me_and(offset_obj, sound_emitter_alarm_1, 0)
                           temp_obj5 = yaw_obj.place_between_me_and(yaw_obj, sound_emitter_alarm_1, 0)
                           offset_scale = temp_obj5.get_distance_to(temp_obj4) -- reuse number again
                           temp_obj4.delete()
                           temp_obj5.delete()

                           temp_obj4 = offset_obj
                           temp_obj5 = yaw_obj
                           -- atomic check
                           --mover_agent1.attach_to(offset_obj,0,0,0,relative)
                           --mover_agent1.detach()
                           --mover_agent2.attach_to(yaw_obj,0,0,0,relative)
                           --mover_agent2.detach()
                           --offset_scale = mover_agent1.get_distance_to(mover_agent2) -- reuse number again
                           --
                           if offset_scale <= 0 then
                              temp_num1 = -1
                              -- cleanup objects due to atomic error
                              offset_obj.delete()
                              yaw_obj.delete()
                           end
                        end
                        -- if the player is not going atomic, then we are allowed to continue the subroutine
                        if temp_num1 != -1 then 
                           -- now see how far away the player is from where their relative position on the vehicle
                           basis = temp_obj6.place_between_me_and(temp_obj6, sound_emitter_alarm_1, 0)
                           lookat_obj = current_player.r_offset.place_between_me_and(current_player.r_offset, sound_emitter_alarm_1, 0)
                           -- basis = mover_agent2
                           -- basis.attach_to(temp_obj6,0,0,0,relative)
                           -- basis.detach()
                           -- lookat_obj = mover_agent1
                           -- lookat_obj.attach_to(current_player.r_offset,0,0,0,relative)
                           -- lookat_obj.detach()
                           
                           offset_scale = basis.get_distance_to(lookat_obj)
                           if offset_scale <= 0 then -- neither player nor vehicle have moved
                              -- make sure we dont run the player movement code
                              temp_num1 = -1
                              temp_obj4.delete()
                              temp_obj5.delete()
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
                                    temp_obj4.delete()
                                    temp_obj5.delete()
                                 end
                                 temp_num1 = -1 -- atomic error
                              end
                              if temp_num1 != -1 then -- apply transform if correct
                                 yaw_obj.attach_to(temp_obj6, 0,0,0,relative)
                                 temp_obj6.attach_to(offset_obj, 0,0,0,relative)
                              end
                              offset_obj.delete()
                              yaw_obj.delete()
                           end
                           
                           -- attach this after, so the speeds aren't amplified
                           if temp_num1 > 0 then
                              temp_obj5.attach_to(temp_obj6, 0,0,0,relative)
                              temp_obj6.attach_to(temp_obj4, 0,0,0,relative) -- oddly, only temp_obj4 gets detached from the player i think
                              temp_obj4.delete()
                              temp_obj5.delete()
                           end
                        end
                        -- apply movement after relocation
                        current_player.r_offset.delete()
                        current_player.r_base.delete()
                     end
                     -- if the player is still within the boundary, then recalculate the relative position
                     if current_object.shape_contains(temp_obj6) then
                        -- record new location relative to the vehicle
                        basis = mover_agent1
                        basis.attach_to(current_object,0,0,0,relative)
                        basis.detach()
                        lookat_obj = mover_agent2
                        lookat_obj.attach_to(temp_obj6,0,0,0,relative)
                        lookat_obj.detach()
                        offset_scale = basis.get_distance_to(lookat_obj)
                        config_thingo()

                        yaw_obj.attach_to(current_object, 0,0,0,relative)
                        -- remember these objects, as they now tell us the relative location of the player on this vehicle
                        current_player.r_offset = offset_obj
                        current_player.r_base = yaw_obj
                     end
                  end
               end
            end
         end
         for each player do
            get_active_controlled_object()
            if temp_obj6 != no_object then
               if current_player.r_last == no_object then
                  current_player.r_last = temp_obj6.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0,none)
               end
               current_player.r_last.attach_to(temp_obj6, 0,0,0,relative)
               current_player.r_last.detach()
            end
         end
      end

      -- attachment code
      -- this will apply the correct scale for all clients
      -- it also manages the constant detaching (or if team[7] then dont detach)
      for each object with label "configure_scale" do
         if current_object.designated_scale != 0 
         and current_object.parent != no_object and current_object.offset != no_object and current_object.block != no_object then
            if current_object.team != team[7] then
               current_object.block.copy_rotation_from(current_object.offset, true)
               current_object.block.attach_to(current_object.offset, 0,0,0,relative)
               current_object.block.detach()
            end
            if current_object.has_scaled == 0 then
               current_object.has_scaled = 1
               current_object.detach()
               current_object.set_scale(current_object.designated_scale)
               current_object.copy_rotation_from(current_object, true) -- update yaw_obj's scale
               -- NOTE: this object reference can be replaced with a loop to find the parent (there should only ever be one possible parent)
               current_object.attach_to(current_object.parent, 0,0,0,relative) 
            end
         end
      end
   end
end