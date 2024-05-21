-- // /////////////// //
-- // SCRIPT OPTIONS //
-- // ///////////// //
alias movement_speed       = script_option[0]
alias initial_game_time    = script_option[1]
alias checkpoint1_cap_time = script_option[2]
alias checkpoint1_bonus    = script_option[3]
alias checkpoint1_min_cap  = script_option[4]
alias checkpoint2_cap_time = script_option[5]
alias checkpoint2_bonus    = script_option[6]
alias payload_shape_size   = script_option[7]
on init: do
    game.round_timer = initial_game_time
end

declare object.object[0] with network priority local
declare object.object[1] with network priority local
declare object.object[2] with network priority high
declare object.object[3] with network priority high

declare object.number[0] with network priority local 
declare object.number[1] with network priority local 
declare object.number[2] with network priority local 
declare object.number[3] with network priority local 
declare object.timer[0] = checkpoint1_cap_time -- checkpoint 1 capture timer
declare object.timer[1] = checkpoint2_cap_time -- checkpoint 2 capture timer

declare player.object[0] with network priority local -- cargo phys
declare player.object[1] with network priority local -- cargo phys
declare player.timer[0] = 1 -- dropshield ability checking
declare player.timer[1] = 5 -- load in game announce delay
declare player.number[0] with network priority local -- ticks stuck
declare player.number[1] with network priority local -- has_init'd
declare player.number[2] with network priority local -- has spawned in for the first time

declare global.number[0] with network priority local -- is host
declare global.number[1] with network priority high  -- is payload moving
declare global.number[2] with network priority local -- collision ticker
declare global.number[3] with network priority high  -- total path distance (this needs to sync so other players can see the progress??)
declare global.number[4] with network priority local -- temp0
declare global.number[5] with network priority local -- temp1
declare global.number[6] with network priority local -- temp2
declare global.number[7] with network priority local -- temp3
declare global.number[9] with network priority local -- current game phase
declare global.number[11] with network priority local -- SCALE TICKS
-- declare global.number[8] with network priority local -- FREE
-- declare global.number[10] with network priority local -- FREE

declare global.object[0] with network priority high  -- mover yaw
declare global.object[1] with network priority high  -- mover pitch
declare global.object[2] with network priority high  -- mover orient
declare global.object[3] with network priority local -- client mover
declare global.object[4] with network priority high  -- host mover position marker
declare global.object[5] with network priority high  -- current node
declare global.object[6] with network priority local -- temp0
declare global.object[7] with network priority local -- temp1
declare global.object[8] with network priority local -- temp2
declare global.object[9] with network priority local -- temp3
declare global.object[10] with network priority local -- checkpoint1
declare global.object[11] with network priority local -- checkpoint2
declare global.object[12] with network priority local -- explodo bomb
-- 13,14,15

declare global.player[0] with network priority local -- temp0

declare global.team[0]   with network priority local -- temp0
declare global.team[1]   with network priority local -- last payload state
declare global.team[2]   with network priority local -- has made sudden death announcement
declare global.team[3]   with network priority high  -- are alarms going
declare global.team[4]   with network priority local -- game over state

declare global.timer[0] = 3 -- hill contest announce update interval
declare global.timer[1] = 2 -- final bomb explode thing
declare global.timer[2] = 1 -- tick speed thing



-- // ///////////////// //
-- // GLOBAL VARIABLES //
-- // /////////////// //
alias defending_team = team[0] -- defending payload
alias attacking_team = team[1] -- attacking payload
alias is_host = global.number[0]

alias checkpoint1 = global.object[10]
alias checkpoint1_timer = checkpoint1.timer[0]
alias checkpoint2 = global.object[11]
alias checkpoint2_timer = checkpoint2.timer[1]
alias phase = global.number[9]
-- 0: capture hill
-- 1: move payload to checkpoint(2)
-- 2: wait at checkpoint
-- 3: get payload to the end goal

alias begin_announce_delay = current_player.timer[1]
alias has_player_init = current_player.number[1]
alias has_spawned = player.number[2]

alias scale_ticks = global.number[11] -- just a simple counter so we only scale objects for the first 30 ticks or something
alias has_announced_sudden_death = global.team[2]

alias sirens_sounding = global.team[3]
-- game over state
alias gameover_bomb = global.object[12]
alias is_game_over = global.team[4]
alias bomb_timer = global.timer[1]
alias nearing_end_alert_timer = global.timer[2]

-- // ////////////////// //
-- // PAYLOAD VARIABLES //
-- // //////////////// //
alias turn_factor = 70 -- [0-127]
alias payload_moving = global.number[1] -- true/false

alias mover_yaw    = global.object[0] -- also the base payload object
alias mover_pitch  = global.object[1]
alias mover_orient = global.object[2] -- acts as the base for all attachments that require payload pitch rotation
alias client_mover = global.object[3] -- only exists on client, to ignore all positional input from host
alias mover_host_pos = global.object[4] -- used so we can determine where the host wants the payload to be

alias prong_left = mover_yaw.object[2]
alias prong_right = mover_yaw.object[3]
alias prong_up = mover_pitch.object[2]
alias prong_down = mover_pitch.object[3]
-- TODO: condense these into less numbers
alias horz_rot_paused_ticks = mover_yaw.number[0]
alias vert_rot_paused_ticks = mover_yaw.number[1]
alias horz_last_direction = mover_yaw.number[2]
alias vert_last_direction = mover_yaw.number[3]
-- icon display stuff
alias payload_waypoint = mover_host_pos
-- random collision fixup stuff
alias coll_eject_speed = 20 -- this controls the speed that players are ejected from virtual boundaries
alias collider = object.object[0] -- used separately on clients
alias host_collider = object.object[2] -- used on host, displaced on client
alias has_local_fixedup = object.number[0] -- used to get rid of the host's pieces onc
alias collision_tick = global.number[2]
alias coll_tick_interval = 6 -- nth tick that collision pieces will update
-- announce control state
alias payload_last_team = global.team[1]
alias payload_announce_timer = global.timer[0]

-- // ///////////////////////// //
-- // DROP SHIELD ATTACH STUFF //
-- // /////////////////////// //
alias bubble_already_attached = object.number[0] -- true/false for if bubble shield has already been attached
-- used for '_bubble_tracker's, so we can cleanup after it despawns
alias bubble = object.object[0]
alias attach_cluster = object.object[1]

-- // //////////////////// //
-- // PATH NODE VARIABLES //
-- // ////////////////// //
alias next_node = object.object[0]
alias cum_dist = object.number[0] -- *cumulative* distance

alias curr_node = global.object[5]
alias total_distance = global.number[3]

-- // /////////////// //
-- // TEMP VARIABLES //
-- // ///////////// //
alias temp_num0 = global.number[4]
alias temp_num1 = global.number[5]
alias temp_num2 = global.number[6]
alias temp_num3 = global.number[7]

alias temp_obj0 = global.object[6]
alias temp_obj1 = global.object[7]
alias temp_obj2 = global.object[8]
alias temp_obj3 = global.object[9]

alias temp_player0 = global.player[0]
alias temp_team0 = global.team[0]

-- // ///////////////// //
-- // PLAYER VARIABLES //
-- // /////////////// //
-- cargo phys stuff
alias global_pos = player.object[0] -- single, unattached object
alias relative_pos = player.object[1] -- cascade attach cluster (object is src, contains .obj[0]: knee, .obj[1]: foot)
alias bubble_cooloff = player.timer[0]
alias ticks_stuck = player.number[0]

-- // ///////////// //
-- // UI VARIABLES //
-- // /////////// //
alias progress_widget = script_widget[0]

-- END OF DECLARATIONS SECTION --



-- // //////////////////////// //
-- // INVASION CONFIGURATIONS //
-- // ////////////////////// //
for each player do
    if current_player.is_elite() then 
       current_player.set_loadout_palette(elite_tier_1)
    end
    if not current_player.is_elite() then 
       current_player.set_loadout_palette(spartan_tier_1)
    end
end
-- // //////////////// //
-- // SPAWNING SYSTEM //
-- // ////////////// //
for each player do
    if current_player.has_spawned == 1 then -- wait till first spawn to start setting co_op_spawning
        current_player.set_co_op_spawning(true)
        for each object with label "phase1" do
            current_object.set_spawn_location_permissions(mod_player, current_player, 0)
            if phase < 2 and current_object.team == current_player.team then
                current_object.set_spawn_location_permissions(mod_player, current_player, 1)
            end
        end
        for each object with label "phase2" do
            current_object.set_spawn_location_permissions(mod_player, current_player, 0)
            if phase >= 2 and current_object.team == current_player.team then
                current_object.set_spawn_location_permissions(mod_player, current_player, 1)
            end
        end
    end
end
for each player do
    if current_player.has_spawned == 0 and current_player.biped != no_object then
        current_player.has_spawned = 1
    end
end

-- // //////////////////// //
-- // CARGO PHYSICS STUFF //
-- // ////////////////// //
-- cargo phys aliases
alias knee = object.object[0] -- used as 'tip' or 'point' in cascade operation, but when completed becomes the knee/joint of a connection
alias foot = object.object[1] -- opposite end of the triangle object formation
alias cascade_length = 12
alias cascade_amount = 50

alias counter = temp_num0 -- input
alias src = temp_obj0 -- input
alias dst = temp_obj1 -- input
function cascade_loop()
	src.face_toward(dst.knee, 0,0,0)
	dst.face_toward(src.knee, 0,0,0)
	counter += 1
	if counter < cascade_amount then
		cascade_loop()
	end
end
--    src = temp_obj0 -- input/output
--    dst = temp_obj1 -- input/output
alias rotation_helper = temp_obj2 -- internal
alias requires_solid = temp_num3 -- input
function cascade() 
	-- DEBUG: too far apart exception
	temp_num0 = src.get_distance_to(dst)
	temp_num0 /= 2 -- we need to check if distance is greater than twice the cascade length, alternatively we check if half the distance is greater than a single cascade length
	if temp_num0 > cascade_length then
		game.show_message_to(all_players, none, "failure: range exceeded, increase the 'cascade_length'")
	end
	--

	-- essentially create editable versions of the locations
    if requires_solid == 0 then
	    src = src.place_between_me_and(src, sound_emitter_alarm_2, 0)
	    dst = dst.place_between_me_and(dst, sound_emitter_alarm_2, 0)
    end
    if requires_solid != 0 then
	    src = src.place_between_me_and(src, flag_stand, 0)
	    dst = dst.place_between_me_and(dst, flag_stand, 0)
        src.set_scale(1)
        dst.set_scale(1)
    end


	
	-- create rotation helper to orient our locations towards another
	-- NOTE: we could replace this with a global helper object, so that it only needs to be spawned in once, however reseting coords might not be the easiest, which is probably why we always spawned it from scratch in the original pitch axis functions
	rotation_helper = src.place_at_me(sound_emitter_alarm_2, none,none, 0,0,0, none)
	rotation_helper.attach_to(src, 0,0,0, relative)
	rotation_helper.detach()
	-- then offset rotation, converting roll to pitch
	rotation_helper.face_toward(rotation_helper,0,-1,0)
	src.attach_to(rotation_helper, 0,0,0,relative)
	-- then correct our src's yaw to face towards dst
	rotation_helper.face_toward(dst, 0,0,0)
	src.detach()
	rotation_helper.delete() -- no longer needed
	-- we can simply copy the rotation over to dst as well, so they will now have the exact same pitch heading
	dst.copy_rotation_from(src, true)
	
	-- setup the edge things
    if requires_solid == 0 then
	    src.knee = src.place_between_me_and(src, sound_emitter_alarm_2, 0)
    end
    if requires_solid != 0 then
	    src.knee = src.place_between_me_and(src, flag_stand, 0)
        src.knee.set_scale(1)
    end
	dst.knee = dst.place_between_me_and(src, sound_emitter_alarm_2, 0)
	-- src knee needs to have the same orientation, so we can rotate it later
	src.knee.copy_rotation_from(src, true)

	src.knee.attach_to(src, cascade_length,0,0, relative)
	dst.knee.attach_to(dst, cascade_length,0,0, relative)
	
	-- apply a rotation to dst, so if the two points are exactly ontop of another, they wouldn't fail to find a common middle point
	-- plus this should also make it find common middle points more consistently
	-- NOTE: this actually did not even nearly work as intended, it subtly broke a lot of the mechanics, no idea why
	--dst.face_toward(dst, 0,-1,0)

	-- call the cascade recursive function
	counter = 0
	cascade_loop()
	dst.knee.delete() -- no longer needed
	
	-- fixup src.knee 
	src.knee.detach()
	src.knee.face_toward(dst, 0,0,0)
	src.knee.attach_to(src, cascade_length,0,0, relative)
	-- bind foot to our thing
	dst.attach_to(src.knee, cascade_length,0,0, relative)
	src.foot = dst
end
function cascade_attach()
    src = mover_orient
    dst = current_object
    cascade()
    src.attach_to(mover_orient, 0,0,0, relative)
    current_object.attach_to(dst, 0, 0, 0, relative)
    --current_object.set_shape_visibility(everyone)
end
-- node mapping thing
alias iter_node_sequence = temp_num0
alias iter_lowest_sequence = temp_num1
alias iter_node = temp_obj0
alias iter_next_node = temp_obj1
function recurse_find_next_node()
    -- find next object in order
    iter_lowest_sequence = 9999 -- so the first object will always have a lower spawn sequence
    for each object with label "node" do
        if current_object.spawn_sequence >= iter_node_sequence and current_object.spawn_sequence < iter_lowest_sequence then
            iter_node.next_node = current_object
            iter_lowest_sequence = current_object.spawn_sequence
        end
    end
    -- check for if more iterations are necessary, and append distance data to the next node
    if iter_node.next_node != no_object then
        -- update distances
        temp_num3 = iter_node.get_distance_to(iter_node.next_node)
        total_distance += temp_num3
        iter_node = iter_node.next_node
        iter_node.cum_dist = total_distance -- first node will always have distance of 0, so we dont need to assign to number 1
        iter_node_sequence = iter_node.spawn_sequence
        iter_node_sequence += 1
        recurse_find_next_node()
    end
end
-- // ////////////////////// //
-- // INITIALIZE EVERYTHING //
-- // //////////////////// //
function enable_payload_waypoints()
    phase = 1 
    payload_last_team = mover_yaw.team -- update control boundary thing
    mover_yaw.set_shape_visibility(everyone)
    payload_waypoint.set_waypoint_icon(crown)
    payload_waypoint.set_waypoint_priority(high)
    payload_waypoint.set_waypoint_visibility(everyone)
    payload_waypoint.team = neutral_team
    checkpoint2.set_waypoint_visibility(everyone)
    checkpoint2.set_waypoint_icon(diamond)
    sirens_sounding = no_team -- clear siren status just in case
end
if is_host == 0 then
    is_host = 1
    temp_obj0 = get_random_object("p_base", no_object)
    -- setup rotation helper objects
    mover_pitch = temp_obj0.place_between_me_and(temp_obj0, flag_stand, 0)
    mover_yaw = mover_pitch.place_at_me(flag_stand, none, none, 0,0,0, none) 
    client_mover = mover_yaw -- make sure our mover object is our yaw mover on host
    -- force yaw to be at our precise location
    mover_yaw.attach_to(temp_obj0, 0,0,0,relative)
    mover_yaw.detach()
    mover_orient = mover_pitch.place_at_me(flag_stand, none, none, 0,0,0, none)
    mover_yaw.face_toward(mover_yaw,0,-1,0)
    mover_pitch.face_toward(mover_pitch,0,1,0) -- fix pitch so its face forward?
    mover_orient.copy_rotation_from(mover_yaw, true) -- make orient match rotation
    mover_orient.attach_to(mover_pitch, 0,0,0,relative)
    mover_pitch.attach_to(mover_yaw, 0,0,0,relative)
    mover_yaw.copy_rotation_from(temp_obj0, true) -- make sure they are perfectly aligned, potentially unneeded
    -- then set up the direction detecting helpers
    prong_left = mover_yaw.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
    prong_right = mover_yaw.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
    prong_up = mover_yaw.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
    prong_down = mover_yaw.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)

    -- setup the noise maker thing
    temp_obj1 = mover_yaw.place_at_me(sound_emitter_alarm_1, none, none, 0,0,0, none)
    temp_obj1.attach_to(mover_yaw, 0,0,0,relative)

    -- setup our movement tracker object for the non-hosts
    mover_host_pos = mover_yaw.place_between_me_and(mover_yaw, sound_emitter_alarm_2, 0)
    mover_host_pos.copy_rotation_from(mover_yaw, true)

    -- setup the team stuff for our base object (mover yaw???), and then waypoints
    mover_yaw.set_shape(cylinder, payload_shape_size,payload_shape_size,5)
        
    -- setup the first objective if its on this map!!
    checkpoint1 = get_random_object("checkpoint1", no_object)
    checkpoint2 = get_random_object("checkpoint2", no_object)
    if checkpoint1 == no_object then -- if no checkpoint 1 then skip the phase
        enable_payload_waypoints()
    end
    if checkpoint1 != no_object then
        checkpoint1.set_shape_visibility(everyone)
        checkpoint1.set_waypoint_icon(crown)
        checkpoint1.set_waypoint_priority(high)
        checkpoint1.set_waypoint_visibility(everyone)
        checkpoint1.set_waypoint_timer(0)
        checkpoint1.team = neutral_team
    end

    -- bind all the thingo objects
    for each object with label "p_attach" do -- attaches objects for asthetic
        --cascade_attach()
        current_object.attach_to(mover_orient, 0, 0, 0, relative)
    end
    for each object with label "p_push_out" do -- players in hill get pushed from the center
        --cascade_attach()
        current_object.attach_to(mover_orient, 0, 0, 0, relative)
        --current_object.set_shape_visibility(everyone)
    end
    for each object with label "p_collision" do -- creates a 1x1flat, hill represents the object
        requires_solid = 0
        cascade_attach()
        current_object.host_collider = current_object.place_between_me_and(current_object, block_1x1_flat, 0)
        current_object.host_collider.copy_rotation_from(current_object, true)
        current_object.host_collider.set_hidden(true)
    end
    for each object with label "p_phys" do -- players in hill move with object
        --cascade_attach()
        current_object.attach_to(mover_orient, 0, 0, 0, relative)
        --current_object.set_shape_visibility(everyone)
    end

    -- map out the nodes
    for each object with label "node" do
        if current_object.spawn_sequence == 0 then
            curr_node = current_object
        end
    end
    if curr_node != no_object then -- failsafe
        iter_node = curr_node
        iter_node_sequence = 1
        recurse_find_next_node()
    end
end





-- // /////////////////// //
-- // CHECKPOINT 2 STUFF //
-- // ///////////////// //
-- check for checkpoint2 being reached
if phase == 1 and checkpoint2.shape_contains(mover_yaw) then
    phase = 2
    checkpoint2.set_waypoint_visibility(everyone)
    checkpoint2.set_waypoint_icon(padlock)
    checkpoint2.set_waypoint_priority(blink)
    checkpoint2.set_waypoint_timer(1)
    checkpoint2.team = defending_team
    mover_yaw.team = no_team
    payload_last_team = no_team
    mover_yaw.set_shape_visibility(no_one)
    mover_yaw.set_waypoint_priority(normal)
    game.play_sound_for(all_players, timer_beep, true)
    for each player do
        send_incident(checkpoint_reached, current_player, no_player)
    end
    -- update timer with more bonus time
    game.round_timer += checkpoint2_bonus
    game.sudden_death_timer.reset()
end
-- count timer down if in checkpoint2, so we can move onto the next stage
if phase == 2 then
    payload_moving = 0
    checkpoint2_timer.set_rate(-100%)
    sirens_sounding = neutral_team -- make siren sound
    if checkpoint2_timer.is_zero() then
        sirens_sounding = no_team -- clear siren
        mover_yaw.set_shape_visibility(everyone)
        mover_yaw.set_waypoint_priority(high)
        phase = 3
        checkpoint2.delete()
        -- make the last checkpoint have a cool waypoint
        temp_num0 = 0
        temp_obj0 = no_object
        for each object with label "node" do
            if current_object.spawn_sequence >= temp_num0 then
                temp_obj0 = current_object
                temp_num0 = current_object.spawn_sequence
            end
        end
        temp_obj0.set_waypoint_icon(diamond)
        temp_obj0.set_waypoint_visibility(everyone)
        send_incident(hill_moved, all_players, all_players)
        game.play_sound_for(all_players, boneyard_generator_power_down, true)
    end
end
-- // /////////////////////////////// //
-- // ENABLE PAYLOAD MOVEMENT SCRIPT //
-- // ///////////////////////////// //
alias object_to_check = temp_obj0
function set_team_to_controlling()
    temp_team0 = no_team -- defaults to no_team
    for each player do
        if object_to_check.shape_contains(current_player.biped) and temp_team0 != neutral_team then
            -- inherit first team seen in hill, if any other players in hill dont match that team then the enemy team must be in the hill
            if temp_team0 == no_team then 
                temp_team0 = current_player.team 
            end
            if temp_team0 != current_player.team then 
                temp_team0 = neutral_team
            end
        end
    end
    object_to_check.team = temp_team0
end
-- initial hill cap stage, and regular payload movement stage
if phase != 2 and is_game_over == no_team then
    -- REGULAR PAYLOAD PHASE --
    if checkpoint1 == no_object then
        payload_moving = 1
        object_to_check = mover_yaw
        set_team_to_controlling()
        if temp_team0 != defending_team then -- no teams or wrong team controlling payload
            payload_moving = 0
        end
    end
    -- INITIAL KOTH PHASE --
    if checkpoint1 != no_object then
        payload_moving = 0
        object_to_check = checkpoint1
        set_team_to_controlling()
        -- if hill owned by players
        if checkpoint1.team == defending_team then
            checkpoint1.set_waypoint_priority(blink)
            checkpoint1_timer.set_rate(-100%)
            sirens_sounding = neutral_team
        end
        -- if hill not owned
        if checkpoint1.team != defending_team then 
            checkpoint1.set_waypoint_priority(high)
            sirens_sounding = no_team
            checkpoint1_timer.set_rate(0%) -- contested
            -- if hill owned by enemies or no players
            if checkpoint1.team == attacking_team or checkpoint1.team == no_team then
                if checkpoint1_timer < checkpoint1_min_cap then
                    checkpoint1_timer.set_rate(200%)
                end
            end
        end
        -- if hill captured
        if checkpoint1_timer.is_zero() then
            checkpoint1.delete()
            -- CLEAR FIRST CHECKPOINT
            game.round_timer += checkpoint1_bonus
            game.sudden_death_timer.reset()
            send_incident(hill_moved, all_players, all_players)
            enable_payload_waypoints()
        end
    end
end
-- fixup display team for waypoint marker
do
    payload_waypoint.team = mover_yaw.team
    if payload_waypoint.team == no_team then
        payload_waypoint.team = neutral_team
    end
end
-- announce hill status changes
do
    payload_announce_timer.set_rate(-100%)
    if payload_announce_timer.is_zero() then
        temp_obj1 = mover_yaw
        if checkpoint1 != no_object then -- swap logic for if we have the first checkpoint capture hill active
            temp_obj1 = checkpoint1
        end
        if payload_last_team != temp_obj1.team then
            payload_last_team = temp_obj1.team
            if payload_last_team != no_team then
                payload_announce_timer.reset()
                if payload_last_team == attacking_team or payload_last_team == defending_team then 
                    send_incident(hill_controlled_team, payload_last_team, all_players)
                end
                if payload_last_team == neutral_team then -- NOTE: for checkpoint1, this will fire when players leave the hill
                    for each player do
                        if temp_obj1.shape_contains(current_player.biped) then 
                        send_incident(hill_contested_team, current_player, no_player)
                        end
                    end
                end
            end
        end
    end
end


-- // //////////////////////////// //
-- // GAME OVER DETECTION SCRIPTS //
-- // ////////////////////////// //
function game_end()
    game.end_round() -- yeah... i was thinking something fancy here but whatever
end
-- manage game timers, check for time running out
do
    game.round_timer.set_rate(-100%)
    if game.round_timer.is_zero() then
        -- make this work for initial capture zone too!!!
        temp_obj1 = mover_yaw
        if checkpoint1 != no_object then -- swap logic for if we have the first checkpoint capture hill active
            temp_obj1 = checkpoint1
        end
        -- if the hill has defenders in it
        if temp_obj1.team == defending_team or temp_obj1.team == neutral_team then -- owned by defenders or contested
            game.sudden_death_timer.set_rate(-100%)
            game.grace_period_timer.reset()
            -- announce sudden death
            if has_announced_sudden_death == no_team then
                has_announced_sudden_death = neutral_team
                send_incident(sudden_death, all_players, all_players)
            end
            if game.sudden_death_timer.is_zero() then
                game_end() -- failed to deliver
            end
        end
        if temp_obj1.team != defending_team and temp_obj1.team != neutral_team then -- owned by attackers or no one
            game.grace_period_timer.set_rate(-100%)
            if game.grace_period_timer.is_zero() then -- no players on hill and grace has run out
                game_end()
            end
        end
    end
    if not game.round_timer.is_zero() then -- clear grace period
        game.grace_period_timer = 0
    end
end
-- fixup checkpoint1 waypoint display team
if checkpoint1 != no_object and checkpoint1.team == no_team then
    checkpoint1.team = neutral_team -- just so the waypoint shows up nicely
end
-- // ///////////////////////////// //
-- // CHECK FOR GAME WIN CONDITION //
-- // /////////////////////////// //
if mover_yaw != no_object and payload_moving != 0 then
    -- mover_yaw.team = defending_team -- we moved the logic elsewhere??
    if curr_node.shape_contains(mover_yaw) then
        curr_node = curr_node.next_node
        -- check if this was the last node to go to
        if curr_node == no_object then
            -- GAME WIN CONDITION
            temp_team0 = mover_yaw.team
            temp_team0.score = total_distance
            -- mark game as ended so payload stops trying to do stuff
            is_game_over = neutral_team
            payload_moving = 0
            gameover_bomb = mover_yaw.place_at_me(bomb, none, none, 0,0,0, none)
            game.play_sound_for(all_players, boneyard_generator_power_down, true)
            -- fetch a random player to credit for bomb being armed??
            temp_player0 = no_player
            for each player randomly do
                if mover_yaw.shape_contains(current_player.biped) and current_player.team == defending_team then
                    temp_player0 = current_player
                end
            end
            send_incident(bomb_armed, temp_player0, all_players)
            send_incident(bomb_planted, temp_player0, all_players)
        end
    end
end
-- game has ended, give it a second and then detonate the bomb
if is_game_over == neutral_team then
    bomb_timer.set_rate(-100%)
    if bomb_timer.is_zero() then
        gameover_bomb.kill(false)
        send_incident(bomb_detonated, defending_team, attacking_team)
        game_end()
    end
end
-- // /////////// //
-- // UI SCRIPTS //
-- // ///////// //
-- calulate payload distance and setup UI
if phase > 0 then -- only show payload details after initial hill has been capped
    -- calc current progress distance
    temp_num0 = mover_yaw.get_distance_to(curr_node)
    temp_num1 = curr_node.cum_dist
    temp_num1 -= temp_num0
    if temp_num1 < 0 then -- fail safe for when the guy hasn't made it to the first node yet
        temp_num1 = 0
    end
    progress_widget.set_meter_params(number, defending_team.score, total_distance)
    progress_widget.set_value_text("Payload Progress")
    if payload_moving != 0 then
        defending_team.score = temp_num1
    end
end
-- just a silly script to beep every so often when payload is nearing the end
-- do
--     -- calculate how much distance is left
--     temp_num0 = total_distance
--     temp_num0 -= temp_num1
--     nearing_end_alert_timer.set_rate(0%)
--     if temp_num0 < 200 then
--         nearing_end_alert_timer.set_rate(-25%)
--         if temp_num0 < 100 then
--             nearing_end_alert_timer.set_rate(-50%)
--             if temp_num0 < 50 then
--                 nearing_end_alert_timer.set_rate(-100%)
--                 if temp_num0 < 30 then
--                     nearing_end_alert_timer.set_rate(-200%)
--                     if temp_num0 < 20 then
--                         nearing_end_alert_timer.set_rate(-400%)
--                     end
--                 end
--             end
--         end
--     end
-- end
-- if nearing_end_alert_timer.is_zero() then
--     nearing_end_alert_timer.reset()
--     game.play_sound_for(all_players, timer_beep, true)
-- end
-- annouce play for players
for each player do
    current_player.set_objective_text("Escort the Payload to the enemy goal.\r\nCreated by Gamergotten.")
    begin_announce_delay.set_rate(-100%)
    if has_player_init == 0 and begin_announce_delay.is_zero() then 
        send_incident(rocket_race_game_start, current_player, no_player)
        has_player_init = 1
     end
end
-- // ///////////////// //
-- // KILL SCORE STUFF //
-- // /////////////// //
for each player do
    if current_player.killer_type_is(kill) then 
        temp_player0 = current_player.try_get_killer()
        temp_player0.score += 1
    end
end


-- // //////////////////////////// //
-- // BUBBLE SHIELD CARGO PHYSICS //
-- // ////////////////////////// //
-- thanks to weesee (erm your code did not work properly)
-- NOTE: its theoretically possible for players to claim ownership of already deployed dropshields that weren't deployed on the payload, however it would be tricky for that to happen
alias is_on_payload = temp_num0
for each player do
    current_player.bubble_cooloff.set_rate(-500%)
    if current_player.biped != no_object then
        temp_obj0 = current_player.try_get_armor_ability()
        if temp_obj0.is_of_type(drop_shield) then
            if temp_obj0.is_in_use() then
                current_player.bubble_cooloff.reset()
            end
            if not current_player.bubble_cooloff.is_zero() then
                is_on_payload = 0
                for each object with label "p_phys" do
                    if current_object.shape_contains(current_player.biped) then
                        is_on_payload = 1
                    end
                end
                if is_on_payload == 1 then
                    for each object do
                        if temp_obj0 != no_object then -- we use this temp in the cascade function, so we have to clear it to break the loop
                            temp_num0 = current_object.shields
                            if temp_num0 > 97 and not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) then
                                temp_num0 = current_object.get_distance_to(temp_obj0)
                                if temp_num0 < 7 and current_object.bubble_already_attached == 0 then
                                    -- bubble shield has been created, cascade attach, set variable so we dont double up
                                    requires_solid = 1
                                    cascade_attach()
                                    current_object.bubble_already_attached = 1
                                    temp_obj1 = current_object.place_at_me(sound_emitter_alarm_2, "_bubble_tracker", none, 0, 0, 0, none)
                                    temp_obj1.bubble = current_object
                                    temp_obj1.attach_cluster = src
                                    temp_obj0 = no_object
                                    current_player.bubble_cooloff = 0
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
-- clean up bubble shields
for each object with label "_bubble_tracker" do
    if current_object.bubble == no_object then
        current_object.attach_cluster.delete()
        current_object.delete()
    end
end




-- SCALE JUNK --
-- (we're just using the basic stuff)
alias recursions = temp_num0
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
   if current_object.spawn_sequence != 0 then
      temp_num3 = 100
      recursions = current_object.spawn_sequence
      if current_object.spawn_sequence < 0 then 
         recursions *= 5
         temp_num3 += recursions
         if current_object.spawn_sequence <= -20 then 
            recursions = current_object.spawn_sequence
            recursions += 201
            if current_object.spawn_sequence == -20 then 
               temp_num3 = 1
               current_object.set_hidden(true)
            end
         end
      end
      if current_object.spawn_sequence < -20 or current_object.spawn_sequence > 0 then 
         temp_num3 = 100
         _330x_recurs()
      end
      current_object.set_scale(temp_num3)
      current_object.copy_rotation_from(current_object, false)
   end
end



-- // ///////////////////// //
-- // LOCAL CODE EXECUTION //
-- // /////////////////// //
-- payload mover script
alias left_side = temp_obj0 -- input
alias right_side = temp_obj1 -- input
alias last_direction = temp_num3 -- input
alias paused_ticks = temp_num0 -- input/output
alias direction = temp_num2 -- output
function get_direction()
    direction = 0 -- if they're both the same length
    if paused_ticks == 0 then
        left_side.detach()
        right_side.detach()
        temp_num0 = left_side.get_distance_to(curr_node)
        temp_num1 = right_side.get_distance_to(curr_node)
        if temp_num0 < temp_num1 then direction = 2 end -- left side
        if temp_num1 < temp_num0 then direction = 1 end -- right side
        paused_ticks = 0 -- rest value as we used temp_num0 for distance measurements
        -- the resulting direction is differnt, then output pause ticks to stall rotation
        if direction != last_direction and last_direction != 0 then
            paused_ticks = 5
        end
    end
    if paused_ticks > 0 then -- this garantees that the last direction will be set to 0 after pausing, allowing it to switch direction freely after the pause
        paused_ticks -= 1
    end
end
on local: do
    -- // //////////////////// //
    -- // NON-HOST INITIALIZE //
    -- // ////////////////// //
    if is_host == 0 then
        -- wait for all data to sync over, just incase
        if mover_yaw != no_object and mover_pitch != no_object and mover_orient != no_object and mover_host_pos != no_object 
        and prong_down != no_object and prong_up != no_object and prong_right != no_object and prong_left != no_object then
            is_host = -1
            -- setup our override mover object
            client_mover = mover_yaw.place_between_me_and(mover_yaw, sound_emitter_alarm_2, 0)
            client_mover.copy_rotation_from(mover_yaw, true)
            mover_yaw.attach_to(client_mover, 0,0,0,relative)

            -- sort out the collision objects to use local thingos
            for each object with label "p_collision" do
                current_object.collider = current_object.place_between_me_and(current_object, block_1x1_flat, 0)
                current_object.collider.set_scale(1)
                current_object.collider.copy_rotation_from(current_object, true)
                current_object.collider.set_hidden(true)
                current_object.host_collider.set_hidden(true)
            end
        end
    end
    -- only run the stuff below after everything has been initialized!!!
    if is_host != 0 then
        -- // ///////////// //
        -- // MOVER UPDATE //
        -- // /////////// //
        -- correct client payload position if too far off from host's
        if is_host == -1 then
            temp_num0 = mover_host_pos.get_distance_to(client_mover)
            if temp_num0 > 3 then -- PAYLOAD RE SYNC POSITION IF TOO DESYNCED (this can happen if a client is running with low FPS and regularly has frame drops)
                client_mover.attach_to(mover_host_pos, 0,0,0,relative) -- could this have bad side effects??
                client_mover.detach()
                client_mover.copy_rotation_from(mover_host_pos, true)
            end
        end
        -- perform actual payload movement
        if curr_node != no_object and payload_moving == 1 then
            -- process left/right direction (dir: 2 left, 1 right)
            left_side = prong_left
            right_side = prong_right
            last_direction = horz_last_direction
            paused_ticks = horz_rot_paused_ticks
            get_direction()
            horz_rot_paused_ticks = paused_ticks
            horz_last_direction = direction
            prong_left.attach_to(mover_orient,  0,-4,0, relative)
            prong_right.attach_to(mover_orient, 0, 4,0, relative)
            -- process down/up direction (dir: 2 down, 1 up)
            left_side = prong_down
            right_side = prong_up
            last_direction = vert_last_direction
            paused_ticks = vert_rot_paused_ticks
            get_direction()
            vert_rot_paused_ticks = paused_ticks
            vert_last_direction = direction
            prong_down.attach_to(mover_orient, 0,0,-4, relative)
            prong_up.attach_to(mover_orient,   0,0, 4, relative)
            -- perform rotations
            if horz_last_direction == 2 then client_mover.face_toward(client_mover, turn_factor,-1,0) end -- turn left
            if horz_last_direction == 1 then client_mover.face_toward(client_mover, turn_factor, 1,0) end -- turn right
            mover_pitch.detach()
            if vert_last_direction == 2 then mover_pitch.face_toward(mover_pitch, turn_factor, 1,0) end -- turn down
            if vert_last_direction == 1 then mover_pitch.face_toward(mover_pitch, turn_factor,-1,0) end -- turn up
            mover_pitch.attach_to(mover_yaw, 0,0,0,relative) -- add pitch back to the stack
            -- attach and offset mover agent, we have to create an object for this, as it causes massive issues if we keep using the same object through multiple ticks
            temp_obj0 = mover_orient.place_between_me_and(mover_orient, sound_emitter_alarm_2, 0)
            temp_obj0.copy_rotation_from(mover_orient, true)
            client_mover.attach_to(temp_obj0,1,0,0,relative) 
            temp_obj0.set_scale(movement_speed)
            temp_obj0.copy_rotation_from(temp_obj0, true)
            client_mover.detach()
            temp_obj0.delete()
        end
        -- update host pos tracker
        if is_host == 1 then
            mover_host_pos.attach_to(mover_yaw, 0,0,0,relative)
            mover_host_pos.detach()
            mover_host_pos.copy_rotation_from(mover_yaw, true)
        end

        -- // ///////////////// //
        -- // COLLIDERS UPDATE //
        -- // /////////////// //
        collision_tick += 1
        if collision_tick >= coll_tick_interval then
            collision_tick = 0
            -- update collider positions
            if is_host == -1 then
                for each object with label "p_collision" do
                    current_object.collider.attach_to(current_object,0,0,-1,relative)
                    current_object.collider.detach()
                    current_object.collider.copy_rotation_from(current_object, true)
                    -- hopefully this prevents it from ever moving?? may need to do this every tick
                    if current_object.has_local_fixedup == 0 and current_object.host_collider != no_object then
                        current_object.host_collider.attach_to(current_object,0,0,0,relative)
                        current_object.has_local_fixedup = 1
                    end
                end
            end
            if is_host == 1 then
                for each object with label "p_collision" do
                    current_object.host_collider.attach_to(current_object,0,0,-1,relative)
                    current_object.host_collider.detach()
                    current_object.host_collider.copy_rotation_from(current_object, true)
                end
            end
        end
        -- // //////////////// //
        -- // CASCADE PHYSICS //
        -- // ////////////// //
        for each player do
            is_on_payload = 0
            if current_player.biped != no_object then
                for each object with label "p_phys" do
                    if current_object.shape_contains(current_player.biped) then
                        is_on_payload = 1
                    end
                end

                if is_on_payload == 0 and current_player.relative_pos != no_object then
                    current_player.relative_pos.delete()
                end
                if is_on_payload == 1 then
                    if current_player.global_pos == no_object then
                        current_player.global_pos = current_player.biped.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
                    end
                    requires_solid = 0 -- set input for the following 3 function calls
                    -- check if player already has an offset ready to go
                    if current_player.relative_pos != no_object then
                        -- first we generate our offset attach for the difference between our player and where they were last cargo tick
                        src = current_player.global_pos
                        dst = current_player.biped
                        cascade()
                        temp_obj3 = src
                        -- then we stick that offset to our stored relative position, so the foot of temp_obj3 is our new relative position
                        temp_obj0 = current_player.relative_pos
                        temp_obj3.attach_to(temp_obj0.foot, 0,0,0, relative)
                        
                        -- then we create a new offset attach from the player to the new relative position
                        src = current_player.biped
                        dst = temp_obj3.foot
                        cascade()
                        -- attach the offset to the player (its already at the player, just not attached)
                        src.attach_to(current_player.biped, 0,0,0, relative)
                        -- complete the offset by attaching the player to the foot of this, automaticallly detaching them & maintaining momentumn
                        current_player.biped.attach_to(src.foot, 0,0,0, relative)

                        -- cleanup
                        src.delete()
                        temp_obj3.delete()
                        current_player.relative_pos.delete()
                    end
                    -- update previous position
                    current_player.global_pos.attach_to(current_player.biped, 0,0,0, relative)
                    current_player.global_pos.detach()
                    -- generate current relative position
                    src = mover_orient
                    dst = current_player.biped
                    cascade()
                    src.attach_to(mover_orient, 0,0,0, relative)
                    current_player.relative_pos = src
                end
            end
        end
        -- // ////////////////// //
        -- // VIRTUAL COLLISION //
        -- // //////////////// //
        alias yaw_helper = temp_obj0
        alias offset_helper = temp_obj1
        alias player_root = temp_obj2
        alias eject_force = temp_num0
        alias is_player_in_eject_shape = temp_num1
        for each player do
            is_player_in_eject_shape = 0
            player_root = current_player.try_get_vehicle()
            if player_root == no_object then
                player_root = current_player.biped
            end
            for each object with label "p_push_out" do
                if current_object.shape_contains(player_root) then
                    current_player.ticks_stuck += 1
                    is_player_in_eject_shape = 1
                    -- setup 2axis lookat & extend objects
                    yaw_helper = current_object.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
                    -- position & rotate yaw 
                    yaw_helper.attach_to(current_object, 0,0,0, relative)
                    yaw_helper.detach()  
                    yaw_helper.copy_rotation_from(current_object, true) -- so local yaw axis' match
                    yaw_helper.face_toward(player_root,0,0,0)
                    -- extension 'offset' object
                    offset_helper = yaw_helper.place_at_me(sound_emitter_alarm_2, none, none, 0,0,0, none)
                    offset_helper.attach_to(yaw_helper, 1,0,0, relative)
                    -- scale attachment distance, or rather: apply eject speed
                    eject_force = current_player.ticks_stuck
                    eject_force *= coll_eject_speed
                    yaw_helper.set_scale(eject_force)
                    yaw_helper.copy_rotation_from(yaw_helper, true) -- update scale
                    -- complete movement
                    yaw_helper.attach_to(player_root, 0, 0, 0, relative)
                    player_root.attach_to(offset_helper, 0, 0, 0, relative)
                    yaw_helper.delete() -- also deletes offset helper & pitch helper
                end
            end
            if is_player_in_eject_shape == 0 then
                current_player.ticks_stuck = 0
            end
        end

    end

    -- run scale stuff on all clients (required for set_hidden thing)
    if scale_ticks <= 30 then
        scale_ticks += 1
        if scale_ticks >= 20 then -- skip scaling things right at the start??
            for each object with label "scale" do
                _330x()
            end
        end
    end

    -- siren stuff
    if sirens_sounding == no_team then
        set_scenario_interpolator_state(1, 0)
    end
    if sirens_sounding != no_team then
        set_scenario_interpolator_state(1, 1)
    end
end


