-- nukeohios hill boundary vis script

alias temp_obj0 = global.object[0]

alias distance = object.number[0]
alias order = object.number[1]

alias max_visible_shapes = 32

for each object with label "Visual_Hill" do
   if current_object.spawn_sequence > 0 then -- make this hill visible
      current_object.order = 1 -- is highest render priority
      current_object.distance = 0
   end
   if current_object.spawn_sequence <= 0 then -- calculate the shape vis
      current_object.distance = -1
      current_object.order = -1
   end
end

for each player do
   if current_player.biped != no_object then
      for each object with label "Visual_Hill" do
         if current_object.spawn_sequence <= 0 then -- calculate the shape vis
            current_object.distance = current_object.get_distance_to(current_player.biped)
            temp_obj0 = current_object
            current_object.order = 1
         end -- exit the cond here so it automatically adjusts highest priority ones to be in order
         for each object with label "Visual_Hill" do
            if current_object != temp_obj0 and current_object.distance > -1 and current_object.order > -1 then
               if current_object.distance <= temp_obj0.distance then -- temp_obj0 is further away
                  temp_obj0.order += 1
               end
               if current_object.distance > temp_obj0.distance then -- current_object is further away
                  current_object.order += 1
               end
            end
         end
      end
      for each object with label "Visual_Hill" do
         if current_object.order < max_visible_shapes then
            current_object.set_shape_visibility(everyone)
            --current_object.set_shape_visibility(mod_player, current_player, 1)
            current_object.set_waypoint_visibility(everyone)
            current_object.set_waypoint_text("%n", hud_target_object.order)
            current_object.set_waypoint_range(0,5)
         end
         if current_object.order >= max_visible_shapes then
            current_object.set_shape_visibility(no_one)
            --current_object.set_shape_visibility(mod_player, current_player, 0)
            current_object.set_waypoint_visibility(no_one)
         end
      end
   end
end