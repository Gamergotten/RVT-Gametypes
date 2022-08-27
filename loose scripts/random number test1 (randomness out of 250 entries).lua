-- random nubmer generation tests

alias data_objs_max = 250


alias result = object.number[0] -- this is their random number
alias result_matched = object.number[1] -- number of objects who got the same number


function setup_data_obj() 
   if global.number[1] < data_objs_max then
      global.number[1] += 1
      global.object[0] = player[0].biped.place_at_me(hill_marker, "data_obj", none, 0,0,0,none)
      setup_data_obj()
   end
end

if player[0].biped != no_object then -- we have someone to spawn our objects at
   -- update every X ticks
   global.number[0] += 1
   if global.number[0] >= 200 then
      global.number[0] = 0

      -- count amount of data objects and make sure its the right amount
      global.number[1] = 0
      for each object with label "data_obj" do 
         global.number[1] += 1
      end
      setup_data_obj()
      -- give them their random numbers
      for each object with label "data_obj" do 
         current_object.result = rand(8)
      end

      for each object with label "data_obj" do
         current_object.result_matched = 0
      end
      for each object with label "data_obj" do 
         global.object[0] = current_object
         for each object with label "data_obj" do 
            if global.object[0].result == current_object.result and global.object[0] != current_object then
               global.object[0].result_matched += 1
            end
         end
      end



      global.object[1] = no_object
      global.object[2] = no_object
      global.object[3] = no_object
      global.object[4] = no_object
      global.object[5] = no_object
      global.object[6] = no_object
      global.object[7] = no_object
      global.object[8] = no_object

      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] then -- is the highest one
            global.object[1] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] 
         and current_object.result != global.object[1].result then -- is the highest one
            global.object[2] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result then -- is the highest one
            global.object[3] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] and current_object != global.object[3] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result and current_object.result != global.object[3].result then -- is the highest one
            global.object[4] = current_object 
            global.number[2] = current_object.result_matched
         end
      end

      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] and current_object != global.object[3] and current_object != global.object[4] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result and current_object.result != global.object[3].result and current_object.result != global.object[4].result then -- is the highest one
            global.object[5] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] and current_object != global.object[3] and current_object != global.object[4] and current_object != global.object[5] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result and current_object.result != global.object[3].result and current_object.result != global.object[4].result and current_object.result != global.object[5].result then -- is the highest one
            global.object[6] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] and current_object != global.object[3] and current_object != global.object[4] and current_object != global.object[5] and current_object != global.object[6] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result and current_object.result != global.object[3].result and current_object.result != global.object[4].result and current_object.result != global.object[5].result and current_object.result != global.object[6].result then -- is the highest one
            global.object[7] = current_object 
            global.number[2] = current_object.result_matched
         end
      end
      global.number[2] = 0
      for each object with label "data_obj" do 
         if current_object.result_matched > global.number[2] and current_object != global.object[1] and current_object != global.object[2] and current_object != global.object[3] and current_object != global.object[4] and current_object != global.object[5] and current_object != global.object[6] and current_object != global.object[7] 
         and current_object.result != global.object[1].result and current_object.result != global.object[2].result and current_object.result != global.object[3].result and current_object.result != global.object[4].result and current_object.result != global.object[5].result and current_object.result != global.object[6].result and current_object.result != global.object[7].result then -- is the highest one
            global.object[8] = current_object 
            global.number[2] = current_object.result_matched
         end
      end

            script_widget[0].set_text("number(%n) occurred (%n) times", global.object[1].result, global.object[1].result_matched)
      script_widget[0].set_value_text("number(%n) occurred (%n) times", global.object[2].result, global.object[2].result_matched)
            script_widget[1].set_text("number(%n) occurred (%n) times", global.object[3].result, global.object[3].result_matched)
      script_widget[1].set_value_text("number(%n) occurred (%n) times", global.object[4].result, global.object[4].result_matched)
            script_widget[2].set_text("number(%n) occurred (%n) times", global.object[5].result, global.object[5].result_matched)
      script_widget[2].set_value_text("number(%n) occurred (%n) times", global.object[6].result, global.object[6].result_matched)
            script_widget[3].set_text("number(%n) occurred (%n) times", global.object[7].result, global.object[7].result_matched)
      script_widget[3].set_value_text("number(%n) occurred (%n) times", global.object[8].result, global.object[8].result_matched)
   end
end
