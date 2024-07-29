






alias has_init = object.number[0]
alias stand = object.object[0]

alias yaw = global.object[0]
alias temp_obj0 = global.object[1]
alias pitch = global.object[2]


alias temp_num0 = global.number[0]
alias button_down = global.number[1] 
alias global_ticker = global.number[2]
do
    global_ticker += 1
    button_down = 0
    temp_num0 = player[0].get_button_time(melee)
    if temp_num0 > 0 then
        temp_num0 = global_ticker
        temp_num0 %= 15
        if temp_num0 == 0 then
            button_down = 1
        end
    end
    temp_num0 = player[0].get_button_time(jump)
    if temp_num0 > 0 then
        temp_num0 = global_ticker
        temp_num0 %= 2
        if temp_num0 == 0 then
            button_down = 1
        end
    end
    
    temp_num0 = player[0].get_button_time(context_primary)
    if temp_num0 > 0 then
        temp_num0 = global_ticker
        temp_num0 %= 15
        if temp_num0 == 0 then
            button_down = 2
        end
    end

    script_widget[0].set_value_text("poopy %n", button_down)
end


if player[0].biped != no_object then
    -- setup pitch & yaw
    if yaw == no_object  then 
        pitch = player[0].biped.place_between_me_and(player[0].biped, sound_emitter_alarm_2, 0)
        yaw = pitch.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
        yaw.face_toward(yaw, -90, 21, 0)
        pitch.face_toward(yaw, 15, 54, 0)
        pitch.attach_to(yaw, 0, 0, 0, relative)
    end
    -- rotate pitch & yaw every tick
    if button_down == 1 then
        yaw.face_toward(yaw, 12, -6, 0)       
        pitch.detach()
        pitch.face_toward(pitch, 87, 1, 0)
        pitch.attach_to(yaw, 0, 0, 0, relative)
    end
end
for each object with label "test" do
    if current_object.stand == no_object then
        -- damange the object so it has flame effects
        current_object.health = 20
        temp_obj0 = current_object.place_between_me_and(current_object, machine_gun_turret, 0)
        temp_obj0.kill(false)
        -- put the object onto its stand
        current_object.stand = current_object.place_at_me(capture_plate, none,none, 0,0,0,none)
        current_object.attach_to(current_object.stand, 0,0,0,relative)
    end
end

for each object with label "test" do
    if button_down == 1 and player[0].biped != no_object then
        -- create the pusher object and give it a rotation
        temp_obj0 = current_object.stand.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
        temp_obj0.copy_rotation_from(pitch, true)
        -- velocity bug thing
        temp_obj0.attach_to(current_object.stand, 0, 0, 0, relative)
        temp_obj0.detach()
        current_object.stand.attach_to(temp_obj0, 0, 0, 0, relative)
        current_object.stand.detach()
        -- cleanup
        temp_obj0.delete()
    end
    if button_down == 2 and player[0].biped != no_object then
        temp_obj0 = current_object.stand.place_at_me(sound_emitter_alarm_2, none, none, 0, 0, 0, none)
        temp_obj0.attach_to(current_object.stand, 1, 0, 0, relative)
        current_object.stand.attach_to(temp_obj0, 0, 0, 0, relative)
        temp_obj0.delete()
    end
end
