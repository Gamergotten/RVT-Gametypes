

alias temp_num0 = global.number[0]
declare temp_num0 with network priority local -- temp number

--47x Scale
if current_object.number[1] == 0 then 
   temp_num0 = 100 -- +1 action
   current_object.number[1] = current_object.spawn_sequence
   -- this first condition adds 1 if spawn sequence is -10, it then takes it back if the number is smaller than that
   -- this saves us from having to nest a condition further down, which in total saves a trigger 
   if current_object.spawn_sequence < -9 then -- +1 condition
      temp_num0 += 1 -- +1 action
      if current_object.spawn_sequence < -10 then 
         temp_num0 -= 1 -- +1 action
         current_object.number[1] += 101
         current_object.number[1] *= 2
         temp_num0 += 1000 -- +1 action
         if current_object.spawn_sequence > -71 then 
            current_object.number[1] *= 2
            temp_num0 += -600 -- +1 action
            if current_object.spawn_sequence > -41 then 
               current_object.number[1] *= 3
               current_object.number[1] /= 2
               temp_num0 += -1200 -- +1 action
            end
         end
      end
   end
   current_object.number[1] *= 10
   --current_object.number[1] += 100 -- -1 action
   current_object.number[1] += temp_num0 -- +1 action

   -- if current_object.spawn_sequence < -10 then -- -1 action, trigger, condition
   --     current_object.number[1] += 1000 -- -1 action
   --     if current_object.spawn_sequence > -71 then -- -1 condition
   --         current_object.number[1] += -600 -- -1 action
   --         if current_object.spawn_sequence > -41 then -- -1 condition
   --             current_object.number[1] += -1200 -- -1 action
   --         end
   --     end
   -- end
   --if current_object.spawn_sequence == -10 then -- -1 action, -1 trigger, -1 condition
   --    current_object.number[1] = 1 -- -1 action
   --end

