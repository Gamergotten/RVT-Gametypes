alias is_interpretted = object.number[0]

---------------
-- TEMP VARS --
---------------
alias binary_index = global.number[0]
alias outnum = global.number[1]
alias temp_num0 = global.number[2]

alias scaler_object = global.object[0]
alias distance_object = global.object[1]
alias boundary_check_object = global.object[2]

function extract_distance_from_boundary()
   -- bitshift current binary_index down one
   binary_index /=2
   -- calculate distance to check for this bit (we are doing this bit by bit, so we just right bitshift 1)
   temp_num0 = binary_index
   -- add the previous bits to the distance so we're essentially splitting the unknown distance in half, until we reach 
   temp_num0 += outnum
   -- convert forge units to 10ths of a scale units, this mulitplies with the 10 or 5 set from the attachment distance earlier
   temp_num0 *= 10
   temp_num0 -= 5 -- subtract 0.5 forge units so its inside the boundary and not at the exact contour location
   -- apply offset to distance_object via scaling
   scaler_object.set_scale(temp_num0)
   scaler_object.copy_rotation_from(scaler_object, true)
   -- create an object at this location, so we don't have to detach our distance_object (saving a ton of code)
   boundary_check_object = distance_object.place_between_me_and(distance_object, respawn_zone_weak_anti, 0)
   -- check whether this bit is inside or outside the boundary
   -- if outside; no action needed, as this bit is already 0
   -- if inside; assign 1 to current bit
   if current_object.shape_contains(boundary_check_object) then -- inside contour
      outnum |= binary_index -- assign '1' to the current bit
   end
   boundary_check_object.delete()
   -- if we're at the 10th bit, we can clean up our objects, we do this before the recursion condition because we dont want to delete the same objects 10 times
   if binary_index == 1 then -- cleanup objects, as recursion has ended
      scaler_object.delete()
      distance_object.delete()
   end
   -- 1:512, 2:256, 3:128, 4:64, 5:32, 6:16, 7:8, 8:4, 9:2, 10:1 --10 is the last bit
   if binary_index > 1 then -- stop recursion of bits after we have no bits left to check
      extract_distance_from_boundary() -- check the next bit
   end
end

function prep_objects_and_numbers()
   -- set vars
   binary_index = 1024 -- 0000-0010 0000-0000
   outnum = 0
   -- set objects
   scaler_object = current_object.place_between_me_and(current_object, respawn_zone_weak_anti, 0)
   scaler_object.copy_rotation_from(current_object, true)
   distance_object = scaler_object.place_at_me(respawn_zone_weak_anti, none,none,0,0,0,none)
end

-- for each object with label "read_me" do
--    if current_object.is_interpretted == 0 then
--       current_object.is_interpretted = 1
--    end
-- end

function get_boundary_shape()
      -- ##FORWARD
      prep_objects_and_numbers()
      -- select direction to check
      distance_object.attach_to(scaler_object, 5,0,0, relative)
      extract_distance_from_boundary()
      current_object.number[1] = outnum -- out result

      -- ##TOP
      prep_objects_and_numbers()
      -- select direction to check
      distance_object.attach_to(scaler_object, 0,0,10, relative)
      extract_distance_from_boundary()
      current_object.number[2] = outnum -- out result

      -- ##BOTTOM
      prep_objects_and_numbers()
      -- select direction to check
      distance_object.attach_to(scaler_object, 0,0,-10, relative)
      extract_distance_from_boundary()
      current_object.number[3] = outnum -- out result

      -- ##SIDE
      prep_objects_and_numbers()
      -- select direction to check
      distance_object.attach_to(scaler_object, 0,5,0, relative)
      extract_distance_from_boundary()
      current_object.number[4] = outnum -- out result
end 


-- DEBUG DISPLAYING

declare global.timer[0] = 5
alias display_toggle = global.number[3]
do
   global.timer[0].set_rate(-100%)
   if global.timer[0].is_zero() then
      global.timer[0].reset()
      display_toggle ^= 1
   end
end

declare object.number[5] with network priority local = 1 -- width
declare object.number[6] with network priority local = 1 -- length
declare object.number[7] with network priority local = 1 -- top
declare object.number[0] with network priority local = 1 -- bottom

alias errors = global.number[4] 
alias debug_obj = global.object[3]

alias repeat_count = global.number[5]
alias runs_completed = global.number[6]

function repeat_alot()
   --current_object.number[5] += 1
   -- if current_object.number[5] >= 1010 then
   --    current_object.number[5] = 1
   --    current_object.number[6] += 1
   -- end
   -- if current_object.number[6] >= 1010 then
   --    current_object.number[6] = 1
   --    current_object.number[7] += 1
   -- end
   -- if current_object.number[7] >= 1010 then
   --    current_object.number[7] = 1
   --    current_object.number[0] += 1
   -- end
   current_object.number[5] = rand(1022)
   current_object.number[5] += 1 
   current_object.number[6] = rand(1022)
   current_object.number[6] += 1 
   current_object.number[7] = rand(1022)
   current_object.number[7] += 1 
   current_object.number[0] = rand(1022)
   current_object.number[0] += 1

   --if current_object.number[0] < 1010 then
      current_object.set_shape(box, current_object.number[5], current_object.number[6], current_object.number[7], current_object.number[0])
      get_boundary_shape()
      if current_object.number[5] != current_object.number[1] -- width
      or current_object.number[6] != current_object.number[4] -- length 
      or current_object.number[7] != current_object.number[2] -- top
      or current_object.number[0] != current_object.number[3] -- bottom
      then
         errors += 1
      end
   --end
   runs_completed += 1
   repeat_count += 1
   if repeat_count <= 5 then
      repeat_alot()
   end
end

for each object with label "read_me" do
   -- increase boundary shape thing
   repeat_count = 0
   repeat_alot()
end

-- split for convenience
for each object with label "read_me" do
   debug_obj = current_object
   current_object.set_shape_visibility(everyone)
   current_object.set_waypoint_visibility(everyone)
   if display_toggle == 0 then
      current_object.set_waypoint_text("frt%n sde%n", hud_target_object.number[1], hud_target_object.number[4])
   end
   if display_toggle == 1 then
      current_object.set_waypoint_text("top%n bot%n", hud_target_object.number[2], hud_target_object.number[3])
   end
end

do 
   script_widget[0].set_value_text("%n fails (%n runs)", errors, runs_completed)
   -- blue is detected boundary shape, white is the actual boundary shape
   script_widget[1].set_value_text("width:%n length:%n", debug_obj.number[5], debug_obj.number[6])
   script_widget[1].set_text("width:%n length:%n", debug_obj.number[1], debug_obj.number[4]) 

   script_widget[2].set_value_text("top:%n bottom:%n", debug_obj.number[7], debug_obj.number[0])
   script_widget[2].set_text("top:%n bottom:%n", debug_obj.number[2], debug_obj.number[3]) 
end