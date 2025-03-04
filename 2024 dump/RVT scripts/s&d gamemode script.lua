alias round_state = global.number[8]
-- 0: store
-- 1: playing

alias ticks_waiting_for_hosts_localplayer = global.number[9]
declare ticks_waiting_for_hosts_localplayer with network priority local

alias assigned_defuser = global.player[0]

alias store_timer = global.timer[0]
declare store_timer = 120
alias short_store_timer = global.timer[1]
declare short_store_timer = 5

alias store_fx = global.object[2]


alias localplayer = global.player[2]
declare localplayer with network priority local

alias temp_obj0 = global.object[0]
alias temp_obj1 = global.object[1]
alias temp_num0 = global.number[1]
alias temp_num1 = global.number[2]
alias temp_num2 = global.number[3]
alias temp_num3 = global.number[4]
alias temp_num4 = global.number[5]
alias temp_num5 = global.number[6]
alias temp_num6 = global.number[7]
alias temp_player0 = global.player[1]

-- hud variables
alias local_shop_widget = script_widget[0]
alias players_ready_widget = script_widget[1]
alias defuser_widget = script_widget[3]
alias countdown_widget = script_widget[2]

alias total_players = global.number[1] -- overlaps temp var
declare total_players with network priority high
alias total_players_ready = global.number[2] -- overlaps temp var
declare total_players_ready with network priority high


-- player vars
alias is_ready = player.number[1]
alias weap_swap_ticks = player.number[2]

alias warp_ticks = player.number[3]
declare player.warp_ticks with network priority high
alias local_warp_ticks = player.number[4]
declare player.local_warp_ticks with network priority local

alias selected_item_cost = player.number[0]
declare player.selected_item_cost with network priority high
alias item_index = player.number[5]
declare player.item_index with network priority high
alias selected_item_obj  = player.object[0]

alias store_pos_tracker = player.object[1]
declare player.store_pos_tracker with network priority high
alias store_jump_tracker = player.object[2]

alias local_tester = player.object[3]
declare player.local_tester with network priority local

alias store_pos_check_timer = player.timer[0]
declare player.store_pos_check_timer = 1
alias store_ability_block_timer = player.timer[1]
declare player.store_ability_block_timer = 1

-- player.biped vars
alias init_ticks = object.number[0]

-- player.store_pos_tracker vars
alias left_tracker = object.object[0]
alias right_tracker = object.object[1]
alias forward_tracker = object.object[2]
alias backward_tracker = object.object[3]

-- player.store_jump_tracker vars
alias store_instanced_item = object.object[0]
alias interaction_object = object.object[1]


-- left/right movement -> left/right shop movement
-- up/down movement -> up/down shop movement

-- jump -> ready up
-- interact -> purchase
-- armor ability -> bomb related activity


-- setup map stuff
if round_state == 0 and store_fx == no_object then
    -- place store mode filter
    for each player do
        if current_player.biped != no_object and store_fx == no_object then
            store_fx = current_player.biped.place_at_me(fx_colorblind, none, none, 0,0,50,none)
        end
    end
end


function reset_store_item()
    temp_obj0 = current_player.store_jump_tracker
    if temp_obj0 != no_object then
        temp_obj0.store_instanced_item.delete()
        temp_obj0.store_instanced_item = no_object
        if current_player.item_index == 0 then
            current_player.selected_item_cost = 0
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(magnum, none,none, 0,0,0,none)
        end
        if current_player.item_index == 1 then
            current_player.selected_item_cost = 1
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(spiker, none,none, 0,0,0,none)
        end
        if current_player.item_index == 2 then
            current_player.selected_item_cost = 2
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(dmr, none,none, 0,0,0,none)
        end
        if current_player.item_index == 3 then
            current_player.selected_item_cost = 3
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(grenade_launcher, none,none, 0,0,0,none)
        end
        if current_player.item_index == 4 then
            current_player.selected_item_cost = 4
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(shotgun, none,none, 0,0,0,none)
        end
        if current_player.item_index == 5 then
            current_player.selected_item_cost = 5
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(plasma_pistol, none,none, 0,0,0,none)
        end
        if current_player.item_index == 6 then
            current_player.selected_item_cost = 6
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(plasma_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 7 then
            current_player.selected_item_cost = 7
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(needle_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 8 then
            current_player.selected_item_cost = 8
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(concussion_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 9 then
            current_player.selected_item_cost = 9
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(energy_sword, none,none, 0,0,0,none)
        end
        if current_player.item_index == 10 then
            current_player.selected_item_cost = 10
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(golf_club, none,none, 0,0,0,none)
        end
        if current_player.item_index == 11 then
            current_player.selected_item_cost = 11
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(plasma_repeater, none,none, 0,0,0,none)
        end
        if current_player.item_index == 12 then
            current_player.selected_item_cost = 12
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(focus_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 13 then
            current_player.selected_item_cost = 13
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(plasma_launcher, none,none, 0,0,0,none)
        end
        if current_player.item_index == 14 then
            current_player.selected_item_cost = 14
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(gravity_hammer, none,none, 0,0,0,none)
        end
        if current_player.item_index == 15 then
            current_player.selected_item_cost = 15
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(golf_club, none,none, 0,0,0,none)
        end
        if current_player.item_index == 16 then
            current_player.selected_item_cost = 16
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(assault_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 17 then
            current_player.selected_item_cost = 17
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(sniper_rifle, none,none, 0,0,0,none)
        end
        if current_player.item_index == 18 then
            current_player.selected_item_cost = 18
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(rocket_launcher, none,none, 0,0,0,none)
        end
        if current_player.item_index == 19 then
            current_player.selected_item_cost = 19
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(detached_machine_gun_turret, none,none, 0,0,0,none)
        end
        if current_player.item_index == 20 then
            current_player.selected_item_cost = 20
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(golf_club, none,none, 0,0,0,none)
        end
        if current_player.item_index == 21 then
            current_player.selected_item_cost = 21
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(needler, none,none, 0,0,0,none)
        end
        if current_player.item_index == 22 then
            current_player.selected_item_cost = 22
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(spartan_laser, none,none, 0,0,0,none)
        end
        if current_player.item_index == 23 then
            current_player.selected_item_cost = 23
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(fuel_rod_gun, none,none, 0,0,0,none)
        end
        if current_player.item_index == 24 then
            current_player.selected_item_cost = 24
            temp_obj0.store_instanced_item = temp_obj0.place_at_me(detached_plasma_cannon, none,none, 0,0,0,none)
        end
        temp_obj0.store_instanced_item.attach_to(temp_obj0, 0,0,0,relative)
        temp_obj0.store_instanced_item.set_pickup_permissions(no_one)
    end
end

function reset_store_visual()
    if localplayer.item_index == 0 then
        local_shop_widget.set_text("Magnum: $%n\n[\uE123] \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 1 then
        local_shop_widget.set_text("Spiker: $%n\n \uE123 [\uE132] \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 2 then
        local_shop_widget.set_text("DMR: $%n\n \uE123  \uE132 [\uE114] \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 3 then
        local_shop_widget.set_text("Grenade Launcher: $%n\n \uE123  \uE132  \uE114 [\uE116] \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 4 then
        local_shop_widget.set_text("Shotgun: $%n\n \uE123  \uE132  \uE114  \uE116 [\uE12F]\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 5 then
        local_shop_widget.set_text("Plasma Pistol: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n[\uE129] \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 6 then
        local_shop_widget.set_text("Plasma Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129 [\uE12A] \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 7 then
        local_shop_widget.set_text("Needle Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A [\uE117] \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 8 then
        local_shop_widget.set_text("Concusion Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117 [\uE121] \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 9 then
        local_shop_widget.set_text("Energy Sword: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121 [\uE119]\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 10 then
        local_shop_widget.set_text("Frag Grenade: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n[  \uE11E  ] \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 11 then
        local_shop_widget.set_text("Plasma Repeater: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E   [\uE12E] \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 12 then
        local_shop_widget.set_text("Focus Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E [\uE126] \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 13 then
        local_shop_widget.set_text("Plasma Launcher: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126 [\uE128] \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 14 then
        local_shop_widget.set_text("Gravity Hammer: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128 [\uE120]\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 15 then
        local_shop_widget.set_text("Plasma Grenade: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n[  \uE127  ] \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 16 then
        local_shop_widget.set_text("Assault Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127   [\uE112] \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 17 then
        local_shop_widget.set_text("Sniper Rifle: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112 [\uE131] \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 18 then
        local_shop_widget.set_text("Rocket Launcher: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131 [\uE12D] \uE122\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 19 then
        local_shop_widget.set_text("Machine Gun: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D [\uE122]\n \uE080  \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 20 then
        local_shop_widget.set_text("Extra: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n[\uE080] \uE125  \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 21 then
        local_shop_widget.set_text("Needler: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080 [\uE125] \uE12C  \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 22 then
        local_shop_widget.set_text("Spartan Laser: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125 [\uE12C] \uE11F  \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 23 then
        local_shop_widget.set_text("Fuel Rod Gun: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C [\uE11F] \uE12B \n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
    if localplayer.item_index == 24 then
        local_shop_widget.set_text("Plasma Cannon: $%n\n \uE123  \uE132  \uE114  \uE116  \uE12F\n \uE129  \uE12A  \uE117  \uE121  \uE119\n   \uE11E    \uE12E  \uE126  \uE128  \uE120\n   \uE127    \uE112  \uE131  \uE12D  \uE122\n \uE080  \uE125  \uE12C  \uE11F [\uE12B]\n.\n.\n.\n.\n.\n.\n.\n.12345678990 1234567890 1234567890", hud_player.selected_item_cost)
    end
end

-- we need to re-orient our markers to our rotation position
function reset_move_trackers()
    temp_obj0 = current_player.store_pos_tracker
    temp_obj1 = current_player.get_weapon(primary)
    temp_obj0.copy_rotation_from(current_player.biped, false)
    temp_obj0.left_tracker.attach_to(temp_obj0, 0,5,0,relative)
    temp_obj0.right_tracker.attach_to(temp_obj0, 0,-5,0,relative)
    temp_obj0.forward_tracker.attach_to(temp_obj0, 5,0,0,relative)
    temp_obj0.backward_tracker.attach_to(temp_obj0, -5,0,0,relative)
    temp_obj0.left_tracker.detach()
    temp_obj0.right_tracker.detach()
    temp_obj0.forward_tracker.detach()
    temp_obj0.backward_tracker.detach()
end
for each player do
    if round_state == 0 and current_player.biped != no_object then
        -- init player enter store mode
        temp_obj0 = current_player.biped
        if temp_obj0.init_ticks < 30 then
            temp_obj0.init_ticks += 1
            current_player.apply_traits(script_traits[0])
            if temp_obj0.init_ticks == 30 then
                -- give them some money to spend
                current_player.score += 100
                -- place activation ability
                temp_obj0 = current_player.biped.place_at_me(active_camo_aa, none, none, 0,0,2,none)

                temp_obj0 = current_player.biped.place_at_me(hill_marker, none, none, 0,0,0,none)
                current_player.store_pos_tracker = temp_obj0
                current_player.store_jump_tracker = current_player.biped.place_at_me(hill_marker, none, none, 0,0,0,none)
                temp_obj0.left_tracker = temp_obj0.place_at_me(hill_marker, none, none, 0,0,0,none)
                temp_obj0.right_tracker = temp_obj0.place_at_me(hill_marker, none, none, 0,0,0,none)
                temp_obj0.forward_tracker = temp_obj0.place_at_me(hill_marker, none, none, 0,0,0,none)
                temp_obj0.backward_tracker = temp_obj0.place_at_me(hill_marker, none, none, 0,0,0,none)
        
                temp_obj0.attach_to(current_player.biped, 0,0,0,relative)
                temp_obj0.detach()
                current_player.store_jump_tracker.attach_to(temp_obj0, 0,0,5,relative)
                current_player.store_jump_tracker.detach()
                
                temp_obj1 = current_player.store_jump_tracker
                temp_obj1.interaction_object = temp_obj1.place_between_me_and(temp_obj1, bomb, 0)
                temp_obj1.interaction_object.set_hidden(true)

                reset_move_trackers()
        
                --temp_obj0.left_tracker.set_waypoint_text("left")
                --temp_obj0.left_tracker.set_waypoint_visibility(everyone)
                --temp_obj0.right_tracker.set_waypoint_text("right")
                --temp_obj0.right_tracker.set_waypoint_visibility(everyone)
                --temp_obj0.forward_tracker.set_waypoint_text("forward")
                --temp_obj0.forward_tracker.set_waypoint_visibility(everyone)
                --temp_obj0.backward_tracker.set_waypoint_text("backward")
                --temp_obj0.backward_tracker.set_waypoint_visibility(everyone)

                reset_store_item()
            end
        end

        -- reset store markers
        if current_player.store_pos_tracker != no_object then
            reset_move_trackers()
        end

        -- run store movement check
        current_player.store_pos_check_timer.set_rate(-200%)
        if current_player.store_pos_check_timer.is_zero() then
            current_player.store_pos_check_timer.reset()

            -- check to see which direction they moved in, if any
            if current_player.biped != no_object and current_player.store_pos_tracker != no_object then
                temp_obj0 = current_player.store_pos_tracker

                temp_num0 = current_player.biped.get_distance_to(temp_obj0)
                --if temp_num0 <= 4 then
                --    game.show_message_to(current_player, none, "none")
                --end
                if temp_num0 > 4 then
                    --game.show_message_to(current_player, none, "dist %n", temp_num0)
                    temp_num0 = current_player.biped.get_distance_to(temp_obj0.left_tracker)
                    temp_num1 = current_player.biped.get_distance_to(temp_obj0.right_tracker)
                    temp_num2 = current_player.biped.get_distance_to(temp_obj0.forward_tracker)
                    temp_num3 = current_player.biped.get_distance_to(temp_obj0.backward_tracker)
                    temp_num6 = current_player.biped.get_distance_to(current_player.store_jump_tracker)
                    temp_num4 = 9999
                    if temp_num0 < temp_num4 then 
                        temp_num5 = 0
                        temp_num4 = temp_num0
                    end
                    if temp_num1 < temp_num4 then 
                        temp_num5 = 1
                        temp_num4 = temp_num1
                    end
                    if temp_num2 < temp_num4 then 
                        temp_num5 = 2
                        temp_num4 = temp_num2
                    end
                    if temp_num3 < temp_num4 then 
                        temp_num5 = 3
                        temp_num4 = temp_num3
                    end
                    if temp_num6 < temp_num4 then 
                        temp_num5 = 4
                        temp_num4 = temp_num6
                    end

                    if temp_num5 == 0 then
                        game.show_message_to(current_player, none, "left")
                        if current_player.item_index > 0 then
                            -- prevent wrap around
                            temp_num0 = current_player.item_index
                            temp_num0 %= 5
                            if temp_num0 > 0 then
                                current_player.item_index -= 1
                                reset_store_item()
                            end
                        end
                    end
                    if temp_num5 == 1 then
                        game.show_message_to(current_player, none, "right")
                        if current_player.item_index < 24 then
                            -- prevent wrap around
                            temp_num0 = current_player.item_index
                            temp_num0 %= 5
                            if temp_num0 < 4 then
                                current_player.item_index += 1
                                reset_store_item()
                            end
                        end 
                    end
                    if temp_num5 == 2 then
                        game.show_message_to(current_player, none, "forward")
                        if current_player.item_index >= 5 then
                            current_player.item_index -= 5
                            reset_store_item()
                        end
                    end
                    if temp_num5 == 3 then
                        game.show_message_to(current_player, none, "backward")
                        if current_player.item_index < 20 then
                            current_player.item_index += 5
                            reset_store_item()
                        end
                    end
                    if temp_num5 == 4 then
                        game.show_message_to(current_player, none, "jumped")
                        current_player.is_ready ^= 1
                    end

                    current_player.biped.attach_to(temp_obj0, 0,0,0,relative)
                    current_player.biped.detach()
                    current_player.warp_ticks += 3
                end
            end
        end

        local_shop_widget.set_visibility(current_player, true)

        -- block if ability recently used
        current_player.store_ability_block_timer.set_rate(-200%)
        if not current_player.store_ability_block_timer.is_zero() then
            current_player.apply_traits(script_traits[1])
        end

        -- check for ability use
        temp_obj0 = current_player.get_armor_ability()
        if temp_obj0 != no_object and temp_obj0.is_in_use() and current_player.store_ability_block_timer.is_zero() then
            current_player.apply_traits(script_traits[2])
            if assigned_defuser != no_player and assigned_defuser != current_player then
                game.show_message_to(all_players, none, "%p has the defuser already!", assigned_defuser)
            end

            if assigned_defuser == current_player then
                current_player.store_ability_block_timer.reset()
                assigned_defuser = no_player
                send_incident(bomb_dropped, current_player, current_player)
                game.show_message_to(all_players, none, "%p has dropped the defuser!", current_player)
            end
            if assigned_defuser == no_player and current_player.store_ability_block_timer.is_zero() then
                current_player.store_ability_block_timer.reset()
                assigned_defuser = current_player
                send_incident(bomb_taken, current_player, current_player)
                game.show_message_to(all_players, none, "%p has picked up the defuser!", current_player)
            end
        end


        temp_obj1 = current_player.store_jump_tracker
        if temp_obj1 != no_object then
            temp_player0 = temp_obj1.interaction_object.get_carrier()
            if temp_player0 == current_player then
                temp_obj1.interaction_object.delete()
                temp_obj1.interaction_object = temp_obj1.place_between_me_and(temp_obj1, bomb, 0)
                temp_obj1.interaction_object.set_hidden(true)

                current_player.store_ability_block_timer.reset()
                if current_player.score < current_player.selected_item_cost then
                    game.show_message_to(current_player, none, "Cannot afford item!")
                end
                if current_player.score >= current_player.selected_item_cost then
                    game.show_message_to(current_player, none, "Item purchased!")
                    current_player.score -= current_player.selected_item_cost
                    temp_obj0 = current_player.store_jump_tracker
                    temp_obj0.store_instanced_item.set_pickup_permissions(everyone)
                    temp_obj0.store_instanced_item.detach()
        
                    -- clear inventory if we dont have room
                    --temp_obj1 = current_player.get_weapon(secondary)
                    --if temp_obj1 != no_object then 
                    --    current_player.biped.remove_weapon(primary, false)
                    --end
                    current_player.biped.remove_weapon(secondary, false)
        
                    current_player.add_weapon(temp_obj0.store_instanced_item)
                    temp_obj0.store_instanced_item = no_object
                    current_player.weap_swap_ticks = 10
                    reset_store_item()
                end
            end
        end
    end
end


-- perform weapon slot swap
for each player do
    if current_player.weap_swap_ticks > 0 then
        current_player.weap_swap_ticks -= 1
        if current_player.weap_swap_ticks == 0 then
            temp_obj0 = current_player.get_weapon(primary)
            temp_obj1 = current_player.get_weapon(secondary)
            current_player.biped.remove_weapon(secondary, false)
            current_player.biped.remove_weapon(primary, false)
            current_player.add_weapon(temp_obj1)
            current_player.add_weapon(temp_obj0)
        end
    end
end

-- perform local fixup thing
on local: do
    if localplayer == no_player or ticks_waiting_for_hosts_localplayer < 60 then
        for each player do
            if current_player.biped != no_object then
                if current_player.local_tester == no_object then
                    current_player.local_tester = current_player.biped.place_between_me_and(current_player.biped, spartan, 0)
                end
                current_player.local_tester.attach_to(current_player.biped, 5,0,0,relative)
                current_player.local_tester.detach()
            end
            temp_obj0 = current_player.get_crosshair_target()
            if temp_obj0 != no_object then
                localplayer = current_player
                game.show_message_to(all_players, none, "client detected: %p", localplayer)
                for each player do
                    current_player.local_tester.delete()
                end
            end
        end
    end

    for each player do
        if current_player.warp_ticks > current_player.local_warp_ticks then
            current_player.biped.attach_to(current_player.store_pos_tracker,0,0,0,relative)
            current_player.biped.detach()
            current_player.local_warp_ticks += 1
        end
    end

    if localplayer != no_player then
        reset_store_visual()
    end
end

-- remove local testers if host search times out
if ticks_waiting_for_hosts_localplayer == 0 then
    for each player do
        if current_player.biped != no_object then
            ticks_waiting_for_hosts_localplayer = 1
        end
    end
end
if localplayer == no_player and ticks_waiting_for_hosts_localplayer > 0 then
    ticks_waiting_for_hosts_localplayer += 1
    if ticks_waiting_for_hosts_localplayer == 60 then
        game.show_message_to(all_players, none, "host not detected, it must be a CGB session")
        for each player do
            current_player.local_tester.delete()
        end
    end
end


-- readyup widgets

if round_state == 0 then
    total_players = 0
    total_players_ready = 0
    players_ready_widget.set_value_text("Players ready %n/%n\n[JUMP] to ready up", total_players_ready, total_players)
    if player[0].is_ready != 0 then
        players_ready_widget.set_value_text("Players ready %n/%n\n[JUMP] to un-ready", total_players_ready, total_players)
    end
    for each player do
        total_players += 1
        players_ready_widget.set_visibility(current_player, true)
        defuser_widget.set_visibility(current_player, true)
        total_players_ready += current_player.is_ready
    end
end

function start_gameplay()
    store_fx.delete()
    round_state = 1
    game.show_message_to(all_players, boneyard_generator_power_down, "Game start!")
    for each player do
        temp_obj0 = current_player.store_pos_tracker
        temp_obj0.left_tracker.delete()
        temp_obj0.right_tracker.delete()
        temp_obj0.forward_tracker.delete()
        temp_obj0.backward_tracker.delete()
        temp_obj0.delete()
        
        temp_obj0 = current_player.store_jump_tracker
        temp_obj0.store_instanced_item.delete()
        temp_obj0.interaction_object.delete()
        temp_obj0.delete()

        temp_obj0 = current_player.get_armor_ability()
        temp_obj0.delete()
    end

    if assigned_defuser != no_player then
        assigned_defuser.biped.add_weapon(bomb, force)
    end
end
-- store countdown
if round_state == 0 then
    countdown_widget.set_value_text("Game starting in %t", store_timer)
    store_timer.set_rate(-100%)
    short_store_timer.set_rate(1000%)
    if store_timer.is_zero() then
        start_gameplay()
    end
    if store_timer > short_store_timer and total_players == total_players_ready then
        short_store_timer.set_rate(-100%)
        countdown_widget.set_value_text("Game starting in %t", short_store_timer)
        if short_store_timer.is_zero() then
            start_gameplay()
        end
    end
end
-- defuser select
if round_state == 0 then
    defuser_widget.set_value_text("no one has the defuser\n[ABILITY] to pickup", assigned_defuser)
    if assigned_defuser != no_player then
        defuser_widget.set_value_text("%p has the defuser\n[ABILITY] to drop", assigned_defuser)
    end
end

if round_state == 1 then
    for each player do
        defuser_widget.set_visibility(current_player, false)
        countdown_widget.set_visibility(current_player, false)
        players_ready_widget.set_visibility(current_player, false)
        local_shop_widget.set_visibility(current_player, false)
    end
end


