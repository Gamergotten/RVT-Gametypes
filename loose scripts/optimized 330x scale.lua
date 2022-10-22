
alias obj_scale = object.number[0]
alias temp_num0 = global.number[0]
alias temp_num1 = global.number[1]
alias temp_num2 = global.number[2]

alias recursions = temp_num0
-- original section
function optimized_330x()
   if recursions > 0 then 
      recursions -= 1
      temp_num2 = current_object.obj_scale
      temp_num2 /= 33
      temp_num1 = current_object.obj_scale
      temp_num1 /= 228
      current_object.obj_scale += temp_num2
      current_object.obj_scale += temp_num1
      optimized_330x()
   end
end
for each object with label "scale" do
   if current_object.obj_scale == 0 then 
      current_object.obj_scale = 100
      recursions = current_object.spawn_sequence
      if current_object.spawn_sequence < 0 then 
         recursions *= 5
         current_object.obj_scale += recursions
         if current_object.spawn_sequence <= -20 then 
            recursions = current_object.spawn_sequence
            recursions += 201
            if current_object.spawn_sequence == -20 then 
               current_object.obj_scale = 1
            end
         end
      end
      if current_object.spawn_sequence < -20 or current_object.spawn_sequence > 0 then 
         current_object.obj_scale = 100
         optimized_330x()
      end
      current_object.set_scale(current_object.obj_scale)
      current_object.copy_rotation_from(current_object, false)
   end
end

-- testing version
alias recursions = temp_num0
-- temp_num1
-- temp_num2
-- temp_num3

function _330x_recurs()
   if recursions > 0 then 
      recursions -= 1
      temp_num2 = temp_num3
      temp_num2 /= 33
      temp_num1 = temp_num3
      temp_num1 /= 228
      temp_num3 += temp_num2
      temp_num3 += temp_num1
      _330x_recurs()
   end
end
function _330x()
   if lookat_obj.spawn_sequence != 0 then
      temp_num3 = 100
      recursions = lookat_obj.spawn_sequence
      if lookat_obj.spawn_sequence < 0 then 
         recursions *= 5
         temp_num3 += recursions
         if lookat_obj.spawn_sequence <= -20 then 
            recursions = lookat_obj.spawn_sequence
            recursions += 201
            if lookat_obj.spawn_sequence == -20 then 
               temp_num3 = 1
            end
         end
      end
      if lookat_obj.spawn_sequence < -20 or lookat_obj.spawn_sequence > 0 then 
         temp_num3 = 100
         _330x_recurs()
      end
      lookat_obj.set_scale(temp_num3)
      lookat_obj.copy_rotation_from(lookat_obj, false)
   end
end