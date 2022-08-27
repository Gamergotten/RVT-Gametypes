
declare global.number[0] with network priority high -- zombie count
declare global.number[4] with network priority high -- hotspots completed
declare global.number[5] with network priority local -- VO gameover ticks
declare global.number[6] with network priority local -- game.is_initialized
declare global.number[10] with network priority local -- last man standing players count

declare global.timer[0] = script_option[0] -- wave intermission time
declare global.timer[1] = 10 -- hotspot incoming time
declare global.timer[2] = 4 -- initial timer

declare global.object[1] with network priority local -- mover agent
declare global.object[2] with network priority local -- wall checker agent
declare global.object[5] with network priority high -- zombie hotspot
declare global.object[6] with network priority local -- previous zombie hotspot
declare global.object[7] with network priority local -- incoming hotspot

declare global.number[1] with network priority local -- temp number#1
declare global.number[2] with network priority local -- temp number#2
declare global.number[3] with network priority local -- temp number#3
declare global.number[7] with network priority local -- temp number#4
declare global.number[8] with network priority local -- temp number#5
declare global.number[9] with network priority local -- temp number#6

declare global.object[0] with network priority local -- temp object#1
declare global.object[3] with network priority local -- temp object#2
declare global.object[4] with network priority local -- temp object#3
declare global.player[0] with network priority local -- temp player#1

declare object.player[0] with network priority local -- zombie's target 
																	  -- door unlock target
																	  -- store.purchaser
declare object.object[0] with network priority local -- zombie's location tracker 
																	  -- xombspwnr.validzone
																	  -- store.purchasedisplay
																	  -- storedisp.previewitem
declare object.object[1] with network priority local -- zombie's attack target
                                                     -- store.left
																	  -- xombspwnr.hotspot
declare object.object[2] with network priority local -- zombie's held sword // emiles held bomb
                                                     -- store.right
declare object.object[3] with network priority local -- zombie's origin object
                                                     -- store.back

declare object.number[0] with network priority local -- is zombie dead 
																	  -- blockade.isinitialized? 
                                                     -- zombiezone is active? 1 -> true 
																	  -- zombiespawner isactive?
                                                     -- zdoor.cost
     																  -- store.isinitiated?
																	  -- storeitem.displayprice
																	  -- shadow.issetup?
declare object.number[1] with network priority local -- zombie's walk ticker 
																	  -- blockade health
																	  -- store.category?
																	  -- storeitem.ispackaged?
																	  -- zombiespawner zombies spawned
																	  -- shadow.islocalsetup
declare object.number[2] with network priority local -- zombie's speedometer
																	  -- store.itemindex
declare object.number[3] with network priority local -- zombie's jumpometer
																	  -- store.is_in_boundary
declare object.number[4] with network priority local -- zombie's attack animation tick counter
																	  -- store.itemprice
declare object.number[5] with network priority local -- zombie's lockon object timer check // 60 is good
declare object.number[6] with network priority high -- zombie's type //0=normal//1=fast//2=climber//3=bomber//
declare object.number[7] with network priority local -- blockade & barrier destructible // 0 true, 1 false
																	  -- zombie's ishotspot modifier

declare object.timer[0] = 1 -- zombie's jump timer 
									 -- door unlock timer
									 -- player biped health regen timer
declare object.timer[1] = 1 -- zombie location check
declare object.timer[2] = 1 -- zombie's attack timer
declare object.timer[3] = 1 -- zombie's pre-attack timer

declare player.timer[0] = 3 -- player purchase display
-- do these two 10 times as fast, cause we're displaying them as numbers, opposed to displaying them as timers
-- it lets them feel just as fluid
declare player.timer[1] = 150 -- player bleed out timer
declare player.timer[2] = 40 -- player revive timer

declare player.number[0] with network priority high -- isplayerunlocking? the price of the unlock
declare player.number[1] with network priority local -- player state? 0-not ingame 1-playing 2-spectating 3-downed

declare player.number[2] with network priority high -- player revive display . max
declare player.number[3] with network priority high -- player revive display . current
declare player.number[4] with network priority high -- player recieved store instructions?

declare player.object[0] with network priority local -- player revive beacon
declare player.object[1] with network priority local -- player biped reference
declare player.object[2] with network priority local -- player entered hotspot check
declare player.object[3] with network priority local -- player flashlight

------------------------
-- PLAYER INITIZATION --
------------------------
for each player do
	if current_player.number[1] == 0 then
		current_player.number[1] = 1
		current_player.score = script_option[5]
		current_player.score *= 10
	end
end

-----------------------------
-- BLOCKADE INITIALIZATION --
-----------------------------
for each object with label "Z_Blockade" do
   if current_object.number[0] == 0 then
      current_object.number[0] = 1
		if current_object.spawn_sequence == 0 then
			current_object.number[1] = 100
      end
		if current_object.spawn_sequence >= 0 then
			current_object.number[1] = current_object.spawn_sequence
         current_object.number[1] *= 20
      end
		if current_object.spawn_sequence <= 0 then
			current_object.number[1] = current_object.spawn_sequence
         current_object.number[1] *= -100
      end
   end
end

-------------------
-- INITIAL TIMER --
-------------------
do
   global.timer[2].set_rate(-100%)
	if global.timer[2].is_zero() then
		if global.number[6] == 0 then
			global.number[6] = 1
			for each player do
				current_player.set_round_card_title("Epic mod by Gamergotten\r\nIt just works :)\r\nfind more epic stuff at halocustoms.com")
			end
			if script_option[10] > 0 then
				game.play_sound_for(all_players, inv_boneyard_vo_spartan_p1_intro, true)
			end
		end
	end
end

---------------------
-- DELETE GRENADES --
---------------------
for each object with label 4 do
   current_object.delete()
end


-------------------------
-- ZOMBIE DELETE ZONES --
-------------------------
for each object with label "Z_DelZomb" do
   global.object[0] = current_object
   for each object with label "Z" do
      if global.object[0].shape_contains(current_object) then
         current_object.delete()
      end
   end
end
-------------------------
-- ZOMBIE ACTIVE ZONES --
-------------------------
for each object with label "Z_Spawner" do
   current_object.object[0] = no_object
end
for each object with label "Z_Activezone" do
   current_object.number[0] = 0
   for each player do
      if current_object.shape_contains(current_player.biped) and current_player.number[1] < 2 then
         current_object.number[0] = 1
      end
   end
	if current_object.spawn_sequence < 0 then
		current_object.number[0] = 1
	end
   -- if zone is valid -> give object.validzone to all contained spawners
   if current_object.number[0] == 1 then
      global.object[0] = current_object
		for each object with label "Z_Spawner" do
      	if global.object[0].shape_contains(current_object) then
   			current_object.object[0] = global.object[0]
         end
		end
   end
end
---------------------
--	ZOMBIE HOTSPOTS --
---------------------
function setup_incoming()
	global.timer[1].reset()
	global.object[7].number[0] = 0
	global.object[7].set_waypoint_icon(arrow)
	global.object[7].set_waypoint_priority(blink)
	global.object[7].set_waypoint_visibility(everyone)
	global.object[7].set_waypoint_text("Incoming")
end
--
function revive_player()
	-- remember their old biped
	global.object[4] = current_player.biped
	-- annouce revial
	game.show_message_to(all_players, none, "%p was revived!", global.player[0])
	-- revive player
	global.object[3] = global.object[0].place_at_me(spartan, none, none, 0, 0, 0, none)
	global.player[0].set_biped(global.object[3])
	-- configure weapons
	--	global.object[3].add_weapon(assault_rifle, force)
	-- or dont
	-- configure player
	global.player[0].number[1] = 1
	global.object[0].delete()
	current_player.timer[1].reset()
	current_player.timer[2].reset()
	-- cleanup old biped
	global.object[4].set_invincibility(0)
	global.object[4].kill(false)
	global.object[4].delete()
end
function monitor_respawn()
	current_player.number[1] = 1
	global.object[3] = current_player.biped
	global.object[3].set_invincibility(0)
	global.object[3].kill(false)
	global.object[0].delete()
	current_player.timer[1].reset()
	current_player.timer[2].reset()
end
--
--function selected_ordered_hotspot()
	-- that was us getting the next object spawn sequence
--end

-- make sure game has "started"
if script_option[10] > 0 and  global.number[5] == 0 and global.timer[2].is_zero() then -- we allow hotspots
	-- check status of current hotspot
	if global.object[5] != no_object then
		for each player do
			if current_player.object[2] == no_object and current_player.number[1] < 2 and global.object[5].shape_contains(current_player.biped) then
				-- announce entering hotspot
				current_player.object[2] = global.object[5]
				current_player.set_round_card_title("")
				current_player.set_round_card_title("Now Entering the Hotspot, clear out the area to progress")
			end
		end
		global.object[5].number[0] = 1 -- make sure our xombos are fine to be there
		
		-- count our dudes
		global.number[1] = 0
		for each object with label "Z" do -- make sure we don't have any left
			if current_object.number[7] == 1 or global.object[5].shape_contains(current_object) then
				-- either is a hotspot xomb or is normal zomb in the hotspot
				global.number[1] += 1
			end
		end
		global.object[5].number[6] = script_option[14]
		global.object[5].number[6] -= global.object[5].number[1]
		global.object[5].number[6] += global.number[1]
		
		if script_option[14] > 0 and global.object[5].number[1] >= script_option[14] then
			-- if we've spawned enough zombies
			if global.number[1] == 0 then -- clear this hill
				global.object[5].set_waypoint_visibility(no_one)
				global.object[5].number[1] = 0
				global.object[6] = global.object[5] -- mark as dormant
				global.object[5] = no_object
				global.object[7] = no_object
				game.show_message_to(all_players, none, "Hotspot cleared!")
				global.number[4] += 1
				-- COME BACK TO THIS
				game.play_sound_for(all_players, inv_cue_spartan_win_1, true)
				global.number[1] = script_option[11]
				global.number[1] *= 10
				for each player do
					current_player.score += global.number[1]
					-- check for death criteria
					if current_player.number[1] == 2 then -- player is dead
						global.object[0] = no_object -- added to fix objectives breaking
						monitor_respawn()
	 				end
					if current_player.number[1] == 3 then -- player is down
						global.player[0] = current_player
						global.object[0] = current_player.object[0]
						revive_player()
					end
				end
			end
		end
	end
		-- HOTSPOTS MUST HAVE SPAWN SEQUENCE ABOVE 0
	-- find a hotspot if needed

	if global.object[5] == no_object then
	-- find incoming hotspot
		if global.object[7] == no_object then
			-- pick a random one
			if script_option[10] == 1 then
				--global.object[5] = get_random_object("Z_Activezone", global.object[6])
				global.number[2] = 0
				-- count valid activezones
				for each object with label "Z_Activezone" do
					if current_object.spawn_sequence > 0 and current_object != global.object[6] then
						global.number[2] += 1
					end
				end
				-- get the index for a random one of those objects
				global.number[1] = rand(global.number[2])
				global.number[2] = 0
				for each object with label "Z_Activezone" do
					if current_object.spawn_sequence > 0 and current_object != global.object[6] then
						if global.number[2] == global.number[1] then -- this is our number
							global.object[7] = current_object
							setup_incoming()
						end
						global.number[2] += 1
					end
				end
			end 
			--
			-- pick the next one 
			--
			if script_option[10] == 2 then
				global.number[1] = 0
				if global.object[6] != no_object then
					global.number[1] = global.object[6].spawn_sequence
				end
				global.number[1] += 1
				
				global.number[2] = 0
				-- function
	-- count valid activezones
	for each object with label "Z_Activezone" do
		if current_object.spawn_sequence == global.number[1] then
			global.number[2] += 1
		end
	end
	-- get the index for a random one of those objects
	global.number[3] = rand(global.number[2])
	global.number[2] = 0
	for each object with label "Z_Activezone" do
		if current_object.spawn_sequence == global.number[1] then
			if global.number[2] == global.number[3] then -- this is our number
				global.object[7] = current_object
				setup_incoming()
			end
			global.number[2] += 1
		end
	end
				--
				--selected_ordered_hotspot()
				
				-- no fallback hotspot anymore
				-- if failed to find the next hotspot
				-- if global.object[7] == no_object then 
					--game.show_message_to(all_players, none, "Zombies: %n\r\nHotspots Cleared: %n", global.number[1], global.number[2])
					--game.show_message_to(all_players, none, "$%n", global.number[3])
					--global.number[1] = 1
					--selected_ordered_hotspot()
					--if global.object[6] == global.object[7] and global.number[7] != no_object then
						-- then we picked the same spot as last time?
					--	global.object[6] = no_object -- make sure our hotspot isn't dormant
					--end
				--end
			end
		end
		if global.object[7] != no_object then
			global.timer[1].set_rate(-100%)
			if global.timer[1].is_zero() then
				global.timer[1].reset()
				global.object[5] = global.object[7]
				global.object[7] = no_object
	game.play_sound_for(all_players, announce_destination_moved, true)
	global.object[5].number[0] = 1
	global.object[5].number[1] = 0
	global.object[5].set_waypoint_icon(skull)
	global.object[5].set_waypoint_priority(high)
				if script_option[14] == -1 then
					global.object[5].set_waypoint_text("")
				end
				if script_option[14] > -1 then
					global.object[5].set_waypoint_text("%n left", global.object[5].number[6])
				end
			end
		end
	end
end


-- use this for adding bonus health & shields to hotspot zombies
function dohealth()
   global.number[2] = 0
	if script_option[12] == 1 then -- + 40
		global.number[2] += 40
	end
	if script_option[12] == 2 then -- + 80
		global.number[2] += 80
	end
	if script_option[12] == 3 then -- + players*5
		for each player do 
			if current_player.biped != no_object and current_player.number[1] < 2 then
				global.number[2] += 5
			end
		end
	end
	if script_option[12] == 4 then -- + players*10
		for each player do 
			if current_player.biped != no_object and current_player.number[1] < 2 then
				global.number[2] += 10
			end
		end
	end
	if script_option[12] == 5 then -- + 40 & players*5
		global.number[2] += 40
		for each player do 
			if current_player.biped != no_object and current_player.number[1] < 2 then
				global.number[2] += 5
			end
		end
	end
	global.number[7] = global.number[4]
	global.number[7] += 1
	if script_option[12] == 6 then -- + hotspots * 15
		global.number[7] *= 15
		global.number[2] += global.number[7]
	end
	if script_option[12] == 7 then -- + hotspots * 30
		global.number[7] *= 30
		global.number[2] += global.number[7]
	end
	if script_option[12] == 8 then -- + 40 & hotspots * 15
		global.number[2] += 40
		global.number[7] *= 15
		global.number[2] += global.number[7]
	end
end
--
---------------------
-- ZOMBIE SPAWNING --
---------------------
do
	if global.number[0] >= script_option[2] then -- no countdown - all zombos accounted for
		global.timer[0].set_rate(0%) 
		for each player do
			script_widget[1].set_visibility(current_player, false)
		end
   end
	if global.number[0] < script_option[2] then -- start countdown when first zombo dies
      -- start timer if below min zomb count
		if global.number[0] < script_option[1] then
      	if global.number[0] != 0 then
      	   global.timer[0].set_rate(-100%)
      	end
      	if global.number[0] == 0 then
      	   global.timer[0].set_rate(-200%)
      	end
			for each player do
				script_widget[1].set_visibility(current_player, true)
			end
   	end
      -- prevent timer from going if we aren't below min yet
		if global.number[0] >= script_option[1] or not global.timer[2].is_zero() then
			global.timer[0].set_rate(0%)
		end
   	-- zombo count
		if global.timer[0].is_zero() then
			global.number[0] += 1
			

			----------------------------
			-- SPAWN LOCATION FINDING --
			----------------------------
         -- count number of valid zones
         global.object[0] = no_object
			global.number[3] = 0
			-- if we have a hotspot active
			if global.object[5] != no_object then
				global.number[2] = 1 -- we're good to pass to spawn here
				if script_option[14] > 0 and global.object[5].number[1] >= script_option[14] then
					global.number[2] = 0 -- actually we're not, this object has spawned enough zombies
				end
				-- now check to see if we've hit the min zombs here
				global.number[1] = 0 
				for each object with label "Z" do
					if current_object.number[7] == 1 then -- they were originally born here
						global.number[1] += 1
					end
				end
				if global.number[1] > script_option[13] then
					global.number[2] = 0 -- ok, theres already the min amount of hotspot zombies, dont worry
				end

				if global.number[2] == 1 then -- we're allowed to spawn xombies here i guess
					global.number[1] = 0 
         		for each object with label "Z_Spawner" do
						if global.object[5].shape_contains(current_object) then
							global.number[1] += 1
							current_object.object[0] = global.object[5]
         		  	end
         		end
					-- if no active zones, then don't spawn here
         		if global.number[1] > 0 then
         			-- random number for valid zone index
						global.number[2] = rand(global.number[1])
        				global.number[1] = 0
         			for each object with label "Z_Spawner" do
							if global.object[5].shape_contains(current_object) then
         			      if global.number[2] == global.number[1] then
         			         global.object[0] = current_object
									global.number[3] = 1 -- so we know we got this from a hotspot
         		  	      end
								global.number[1] += 1
         			   end
						end
         		end
					-- tada, random object with label & criteria
				end
			end
			
			-- check to see if we didn't find a hotspot spawn
			if global.object[0] == no_object then 
				global.number[1] = 0 
         	for each object with label "Z_Spawner" do
					if current_object.object[0] != no_object and current_object.object[0] != global.object[6] and current_object.object[0] != global.object[5] then
						global.number[1] += 1
         	   end
					-- could be substituted with an or, but whatever
					if current_object.object[0] == global.object[5] and script_option[14] > 0 and global.object[5].number[1] < script_option[14] then
						global.number[1] += 1
					end
         	end
				-- if no active zones, then don't spawn zombies
         	if global.number[1] > 0 then
         		-- random number for valid zone index
					global.number[2] = rand(global.number[1])
         		global.number[1] = 0
         		for each object with label "Z_Spawner" do
						if current_object.object[0] != no_object and current_object.object[0] != global.object[6] and current_object.object[0] != global.object[5] then
         		      if global.number[2] == global.number[1] then
        	   	      	global.object[0] = current_object
         		      end
							global.number[1] += 1
         		   end
						-- could be substituted with an or, but whatever
						if current_object.object[0] == global.object[5] and script_option[14] > 0 and global.object[5].number[1] < script_option[14]  then
         		      if global.number[2] == global.number[1] then
        	   	      	global.object[0] = current_object
         		      end
							global.number[1] += 1
         		   end
         		end
				end
				-- tada, random object with label & criteria
			end

			-- hopefully either of those two found a hotspot
			if global.object[0] != no_object then
         -- select zombie type
         global.number[1] = rand(25)
			--------------------
			-- SPARTAN ZOMBIE --
			--------------------
         if global.number[1] <= 19 then
				if global.number[3] == 0 then -- not hotspot zomb
	            -- select spartan variant
	         	global.number[2] = rand(6)
	         	if global.number[2] == 0 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, none)
	            end
	         	if global.number[2] == 1 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, female)
	            end
	         	if global.number[2] == 2 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, male)
	            end
	         	if global.number[2] == 3 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, default)
	            end
	         	if global.number[2] == 4 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, player_skull)
						global.object[3].number[6] = 2 -- climber type
	            end
	  	       	if global.number[2] == 5 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, kat)
						global.object[3].number[6] = 1 -- speed type
	            end
					-- shields
					global.number[9] = script_option[3]
					-- health
					global.number[8] = script_option[4]
				end
				if global.number[3] == 1 then -- is hotspot zomb
	            -- select spartan variant
	         	global.number[2] = rand(4)
	         	if global.number[2] == 0 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, carter)
	            end
	         	if global.number[2] == 1 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, jun)
	            end
	         	if global.number[2] == 2 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, player_skull)
						global.object[3].number[6] = 2 -- climber type
	            end
	         	if global.number[2] == 3 then
			  			global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, kat)
						global.object[3].number[6] = 1 -- speed type
	            end
					-- shields
					global.number[9] = script_option[3]
					dohealth()
					global.number[9] += global.number[2]
					-- health
					global.number[8] = script_option[4]
					dohealth()
					global.number[8] += global.number[2]
				end
			end
			------------------
			-- ELITE ZOMBIE --
			------------------
         if global.number[1] > 19 and global.number[1] < 24 then
				if global.number[3] == 0 then
	            -- select elite variant
	         	global.number[2] = rand(3)
	         	if global.number[2] == 0 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, minor)
	            end
	         	if global.number[2] == 1 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, spec_ops)
	            end
	         	if global.number[2] == 2 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, space)
	            end
					-- shields
					global.number[9] = script_option[3]
					global.number[9] *= 2
					-- health
					global.number[8] = script_option[4]
					global.number[8] *= 2
				end
				if global.number[3] == 1 then
	            -- select elite variant
	         	global.number[2] = rand(4)
	         	if global.number[2] == 0 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, ultra)
	            end
	         	if global.number[2] == 1 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, zealot)
	            end
	  	       	if global.number[2] == 2 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, general)
	            end
	         	if global.number[2] == 3 then
			  			global.object[3] = global.object[0].place_at_me(elite, "Z", none, 0,0,0, officer)
	            end
					-- shields
					global.number[9] = script_option[3]
					global.number[9] *= 2
					dohealth()
					global.number[9] += global.number[2]
					-- health
					global.number[8] = script_option[4]
					global.number[8] *= 2
					dohealth()
					global.number[8] += global.number[2]
				end
			end
			-----------------
			-- BOMB ZOMBIE --
			-----------------
         if global.number[1] == 24 then
            -- this ones gonna be the bomb zombie
		   	global.object[3] = global.object[0].place_at_me(spartan, "Z", none, 0,0,0, emile)
				-- bomber type
				global.object[3].number[6] = 3
				global.object[3].add_weapon(bomb, force)
				-- now we have to find the bomb lol
				for each object with label 11 do
					global.number[1] = current_object.get_distance_to(global.object[3])
					if global.number[1] == 0 then
						global.object[3].object[2] = current_object -- probably our bomb
					end
				end
				--
				-- shields
				global.number[9] = script_option[3]
				-- health
				global.number[8] = script_option[4]
			end

			-- debug
			if global.object[3] == no_object then
				game.show_message_to(all_players, none, "spawner machine broke")
         end
			-- dont destroy the map
			if global.object[3] != no_object then
				global.object[3].max_shields = global.number[9]
				global.object[3].shields = 100
				global.object[3].max_health = global.number[8]
				global.object[3].health = 100
				
				if global.number[3] == 1 then
					global.object[5].number[1] += 1
					global.object[3].number[7] = 1
				end
	      	global.object[3].set_shape(cylinder, 7, 10, 2) 
         	-- not entirely needed, but it makes for good practice
         	global.object[3].object[3] = global.object[0].object[0]
				-- cleanup attached weapons and etc
		      for each object do 
					global.number[1] = current_object.get_distance_to(global.object[3])
		         if global.number[1] == 0 then -- distance check
						if current_object != global.object[0] and current_object != global.object[3] then -- not a prev obj check
							if not current_object.is_of_type(spartan) and not current_object.is_of_type(elite) and not current_object.is_of_type(bomb) then -- not prev xomb test
		            		current_object.delete()
							end
						end
		         end
		      end
		      -- zombo count
				if global.number[0] >= script_option[2] then
			      global.timer[0].reset()	
			   end
         end
     	   end
		end
	   script_widget[1].set_text("Zombies are coming (%n)", global.timer[0])
	   script_widget[1].set_meter_params(timer, global.timer[0])
   end
end

if script_option[0] == 0 then
   for each player do
		script_widget[1].set_visibility(current_player, false)
	end
end
---------------------
-- ZOMBIE MECHNICS --
---------------------
for each object with label "Z" do
	current_object.set_waypoint_visibility(everyone)
	current_object.set_waypoint_range(0, 2)
	current_object.set_waypoint_priority(blink)
   if current_object.number[0] > 30 then -- is not alive
		current_object.number[0] += 1
   	if current_object.number[0] > 210 then -- delay for 180 ticks (3 seconds)
			current_object.delete()
   	end
   end
   if current_object.number[0] == 0 then -- is still alive
      current_object.timer[2].set_rate(-100%)
      if current_object.timer[2].is_zero() then
			-------------------
			-- LOCKING LOGIC --
         -------------------
         -- every 60 ticks: look for closest player & check to see if in valid play space

			-- /////////////////// --
			-- 3 FREE ACTIONS HERE --
			-- /////////////////// --
			--global.player[0] = current_object.player[0]
			--if global.player[0] != no_player and global.player[0].number[1] >= 2 then
			--   current_object.player[0] = no_player
			--	  current_object.number[5] = 0
			--end
			-- //// --
         current_object.number[5] -= 1
			if current_object.number[5] <= 0 then
				current_object.number[5] = 60
		      global.number[1] = 9999 -- targeting range
				current_object.player[0] = no_player -- this will fix single player testing
				for each player do
		         if current_player.biped != no_object and current_player.number[1] < 2 then
		            global.number[2] = current_object.get_distance_to(current_player.biped)	
		            if global.number[2] < global.number[1] then
		               global.number[1] = global.number[2]
							current_object.player[0] = current_player
		            end
		         end
				end
				global.object[0] = current_object.object[3]
            -- if not in original zone OR og zone is no longer active
            if not global.object[0].shape_contains(current_object) or global.object[0].number[0] == 0 or global.object[0] == no_object then
               global.object[0] = current_object
               global.object[0].object[3] = no_object
               -- see if they are still in another valid playspace
   	         for each object with label "Z_Activezone" do
  	               -- check to also make sure this zone is currently being used by players
						if current_object.shape_contains(global.object[0]) and current_object.number[0] == 1 then
							global.object[0].object[3] = current_object
                  end
               end
               if global.object[0].object[3] == no_object then	
						if current_object.number[7] == 1 then 
							global.object[5].number[1] -= 1
						end
						current_object.delete()
               end
            end
		   end
         ------------------
			-- ATTACK LOGIC --
         ------------------
			global.object[0] = current_object
			for each player do
				if global.object[0].shape_contains(current_player.biped) and current_player.number[1] < 2 then
               global.object[0].object[1] = current_player.biped
            end
			end
			for each object with label "Z_Blockade" do
				if global.object[0].shape_contains(current_object) and current_object.number[7] == 0 then
               global.object[0].object[1] = current_object
            end
         end
			for each object with label "Z_Barrier" do
				if global.object[0].shape_contains(current_object) and current_object.number[7] == 0 then
					global.number[1] = current_object.health
               if global.number[1] > 0 then
               	global.object[0].object[1] = current_object
					end
            end
         end
         --------------------
         -- TRACKING LOGIC --
         --------------------
			if current_object.player[0] != no_player then
				current_object.face_toward(current_object.player[0].biped, 0, 0, 0)
		
	         -- is able to jump ?
				global.number[1] = current_object.get_speed()
				if global.number[1] < 15 then -- not falling/jumping
		         current_object.timer[0].set_rate(-100%)
		      end
		      if global.number[1] >= 15 then
		         current_object.timer[0].reset()	
               current_object.timer[1].reset() -- don't bother doing a postion check, we're jumping
		      end

	         ------------------------------------------------------------------
	         -- DEBUGNG -------------------------------------------------------
	 	      ------------------------------------------------------------------
	         --current_object.number[2] = global.number[1]
	         --current_object.set_waypoint_text("S(%n) D(%n)", hud_target_object.number[2], hud_target_object.number[3])
	         --current_object.set_waypoint_visibility(everyone)
	         --current_object.set_waypoint_range(0, 100)
	         ------------------------------------------------------------------


				------------------
				-- MOVING LOGIC --
				------------------
				-- is able to move ? -- and then move if so 
				global.number[1] = current_object.get_speed()
            -- now we try to normalize movement by ticking when falling too, since each step casues falling

				--if  then -- not falling/jumping so move
					current_object.number[1] += 1 -- do this so they can get moving as soon as they land
					if current_object.number[6] == 1 then -- this is a speedy zombie
						if current_object.number[1] >= 8 then
							current_object.number[1] = 99 -- skip 3 ticks to increase speed, actually this would just make them go faster up hills
						end
					end
		         if current_object.number[1] >= 13 and global.number[1] < 6 then

						current_object.number[1] = 0
						-- do wall check
						if global.object[2] == no_object then
							global.object[2] = current_object.place_at_me(hill_marker, none, none, 0,0,0, none)
						end
                  global.object[2].attach_to(current_object, 4, 0, 5, relative)
                  global.object[2].detach()
                  global.object[0] = global.object[2].place_at_me(bomb, none, none, 0,0,0, none)
						global.number[1] = global.object[2].get_distance_to(global.object[0])
                  if global.number[1] > 0 then -- our dude is facing a wall
							 -- give about 0.525 seconds future step delay
							current_object.number[1] = -45
							-- zombie wall climbing logic
							if current_object.number[6] == 2 then
								current_object.number[1] = 0
								current_object.push_upward()
							end
                     -- potentially this will fix them going through walls
                     --global.number[1] = 0
                  end
                  if global.number[1] <= 0 then -- wall check failed, we're good to walk
						if global.object[1] == no_object then
				         global.object[1] = current_object.place_at_me(hill_marker, none, none, 0,0,0, none)
				      end
						-- looking back at this, i have no idea how 0.9*28 is about 1 forge unit lol
                  -- maybe it transfers it as velocity? and then only takes a fraction of that step?
		            -- move agent to player
						global.object[1].copy_rotation_from(current_object, true)
						if current_object.number[7] == 0 then -- normal speed
							global.object[1].attach_to(current_object, 28, 0, 1, relative)
						end
						if current_object.number[7] == 1 then -- hotspot speed
							global.object[1].attach_to(current_object, 34, 0, 1, relative)
						end
						global.object[1].detach()
						-- scale down distance between agent & player
						if current_object.number[7] == 0 then -- normal speed
							current_object.attach_to(global.object[1], -28, 0, 0, relative)
						end
						if current_object.number[7] == 1 then -- hotspot speed
							current_object.attach_to(global.object[1], -34, 0, 0, relative)
						end
						global.object[1].set_scale(90)
		            global.object[1].copy_rotation_from(global.object[1], true)
						current_object.detach()
						-- reset move_agent's scale
						global.object[1].set_scale(100)
		            global.object[1].copy_rotation_from(global.object[1], true)
						end
                  -- cleanup our wall check object
                  global.object[0].delete()
		         end
	         --end

				-- location tracker
				if current_object.object[0] == no_object then
				   current_object.object[0] = current_object.place_at_me(hill_marker, none, none, 0,0,0, none)
				end
	         current_object.timer[1].set_rate(-100%)
         
		      if current_object.timer[1].is_zero() then	-- every 1 sec, upadate last location
			      if current_object.timer[0].is_zero() then	-- if zump timer is zero()
		            global.number[1] = current_object.get_distance_to(current_object.object[0])

			         ------------------------------------------------------------------	
			         -- DEBUGNG -------------------------------------------------------
			         ------------------------------------------------------------------
			         --current_object.number[3] = global.number[1]
			         ------------------------------------------------------------------
	
						-- as of writing, 8 seems to be the lowest a striaght walking xombie will achieve
						-- 10 might be a better number now that we've increased the base speed
		            if global.number[1] < 10 then -- if didn't move enough
			            current_object.number[1] = -30 -- to prevent walking for a half second
				         current_object.push_upward()
				         current_object.push_upward()	
				         current_object.push_upward()
				         current_object.timer[0].reset()
		            	if global.number[1] < 5 then
                        -- not moving at all, so this *should* make them jump sooner
                        -- however, previous code resets if we're at jumping speed
								-- so this line becomes redundant
								-- /////////////////// --
								-- 1 FREE ACTIONS HERE --
								-- /////////////////// --
								-- current_object.timer[0] = 0
								-- //// --
	                  end
		            end
			      end
	            current_object.object[0].attach_to(current_object, 0, 0, 0, relative)
	            current_object.object[0].detach()
	            current_object.timer[1].reset()
	         end
			end
         --------------------
         -- DAMAGING LOGIC --
         --------------------
         if current_object.object[1] != no_object then
				current_object.face_toward(current_object.object[1], 0, 0, 0)
            global.object[0] = current_object.object[1]
            current_object.timer[3].set_rate(-500%)
            if current_object.timer[3].is_zero() then
               -- cleanup
					current_object.timer[3].reset() 
					current_object.object[1] = no_object
               --
               if current_object.shape_contains(global.object[0]) then
	               -- zombo has attacked
						-- somehow this is not working correctly
						current_object.timer[2].reset()
                  current_object.number[4] = -1

						if global.object[0].has_forge_label("Z_Blockade") then
		               -- target is a blockade
		               global.object[0].number[1] -= 20
		               if global.object[0].number[1] <= 0 then
		                  global.object[0].delete()
		               end
	               end
						if not global.object[0].has_forge_label("Z_Blockade") then
	                  -- target is a player / barrier
							global.number[1] = global.object[0].health
		               if global.number[1] > 0 then -- make sure that target is still alive
		            		global.object[0].shields = 0
								-- barrier damage
								if global.object[0].has_forge_label("Z_Barrier") then
			               	global.object[0].health -= 20
									-- do a damage state update, thanks for the idea rabid
									global.object[3] = current_object.place_between_me_and(global.object[0], monitor, 0)
   								global.object[3].kill(false)
									
								end
								-- player damage
								if not global.object[0].has_forge_label("Z_Barrier") then
								
									if current_object.number[6] != 3 then -- not attacking with bomb
										if current_object.number[7] == 0 then -- normal damage
											global.object[0].health -= 34
										end
										if current_object.number[7] == 1 then -- hotspot damage
											global.object[0].health -= 54
										end
										-- do a damage state update, thanks for the idea rabid
										global.object[3] = current_object.place_between_me_and(global.object[0], monitor, 0)
										global.object[3].kill(false)
									end
									if current_object.number[6] == 3 then -- attacking with bomb
										current_object.object[2].delete()
										global.object[3] = current_object.place_between_me_and(global.object[0], fusion_coil, 0)
										global.object[3] = current_object.place_between_me_and(global.object[0], fusion_coil, 0)
										global.object[3].kill(true)
									end
								end
			               global.number[1] = global.object[0].health
			               if global.number[1] <= 0 then
			                  global.object[0].kill(true)
			               end
							end
                  end
               end
            end
         end
         if current_object.object[1] == no_object then
				current_object.timer[3].reset()
         end
      end
      if not current_object.timer[2].is_zero() then
         -- tick down the animation, if currently in action
			if current_object.number[4] > 0 and current_object.number[6] != 3 then
				current_object.number[4] -= 1
            if current_object.number[4] <= 0 then -- we finish the animation
					current_object.remove_weapon(primary, true)
               --current_object.number[4] = 0 -- really shouldn't need this though
            end
         end
         -- if xombie has just attacked something, start the animation
			if current_object.number[4] == -1 then
            current_object.number[4] = 45 -- ticks
				if current_object.number[6] != 3 then -- not attacking with bomb
            	current_object.add_weapon(energy_sword, force)
            	global.object[0] = current_object
            	for each object with label 5 do
            	   global.number[1] = current_object.get_distance_to(global.object[0])
            	   if global.number[1] == 0 then
            	      global.object[0].object[2] = current_object
            	   end
           		end
				end
         end
		end
   end
end


-------------------
-- DEBUG WIDGETS --
-------------------
do
   global.number[0] = 0
	for each object with label "Z" do
	   global.number[1] = current_object.health
	   if global.number[1] > 0 then
			global.number[0] += 1
	   end
		-- xombie died
      if global.number[1] <= 0 and current_object.number[0] < 35 then
         current_object.number[0] = 35
         if current_object.object[0] != no_object then
            current_object.object[0].delete()
         end
         if current_object.object[2] != no_object then
            current_object.object[2].delete()
         end
      end
	end
	if script_option[10] > 0 then -- we do not allow hotspots
		script_widget[0].set_value_text("Zombies: %n", global.number[0])
	end
	if script_option[10] > 0 then -- we do have hotspots enabled
		if script_option[15] == -1 then -- unlimited objectives
			script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n", global.number[0], global.number[4])
		end
		if script_option[15] > 0 then -- we do a set amount of objectives
			-- lol, lets do it the stupid way so we can have 3 variables
			if script_option[15] == 1 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/1", global.number[0], global.number[4])
			end
			if script_option[15] == 2 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/2", global.number[0], global.number[4])
			end
			if script_option[15] == 3 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/3", global.number[0], global.number[4])
			end
			if script_option[15] == 4 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/4", global.number[0], global.number[4])
			end
			if script_option[15] == 5 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/5", global.number[0], global.number[4])
			end
			if script_option[15] == 7 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/7", global.number[0], global.number[4])
			end
			if script_option[15] == 10 then 
				script_widget[0].set_value_text("Zombies: %n\r\nHotspots Cleared: %n/10", global.number[0], global.number[4])
			end
		end
	end
end

for each player do
	-- apparently setting a players team before they spawn in is bad, 
	-- especially for join in progress players (the infection enemy survivors bug)
   if current_player.biped != no_object and script_option[9] > 2 then
		current_player.team = team[0]
   end
end

-- coop spawning
if global.object[6] != no_object then
	global.object[6].set_spawn_location_permissions(everyone)
end
for each player do
	current_player.set_co_op_spawning(true)
	if global.object[6] != no_object then
		current_player.set_primary_respawn_object(global.object[6])
	end
end	

--------------------
-- POINT AWARDING --
--------------------
-- zombie kill
on object death: do
   if killed_object.has_forge_label("Z") then
		if killer_player != no_player then
      	global.object[0] = killer_player.biped	
			
         killer_player.score += script_option[6]
			-- killspree logic
 			global.object[0].number[1] += 1
			if global.object[0].number[1] == 5 then
				send_incident(zombie_kill_5x, killer_player, no_player)
			end
			if global.object[0].number[1] == 10 then
				send_incident(zombie_kill_10x, killer_player, no_player)
			end
			if global.object[0].number[1] == 15 then
				send_incident(zombie_kill_15x, killer_player, no_player)
			end
         if global.object[0].number[1] == 50 then
				game.show_message_to(all_players, none, "%p Has killed 50 zombies in a row", killer_player)
			end
         if global.object[0].number[1] == 100 then
				game.show_message_to(all_players, none, "%p Has killed 100 zombies in a row", killer_player)
			end
         if global.object[0].number[1] == 250 then
				game.show_message_to(all_players, none, "%p Has killed 250 zombies in a row", killer_player)
			end
      end
   end
end

--
--
function monitorify_player()
	global.object[3] = global.object[0].place_at_me(monitor, "playerquitcheck", none, 0, 0, 0, none)
	global.object[3].player[1] = current_player
	global.object[3].set_scale(1)
	--global.object[3].copy_rotation_from(global.object[3], true)
	current_player.set_biped(global.object[3])
   global.object[3].remove_weapon(primary, true)
	global.object[3].set_invincibility(1)
end
------------------
-- PLAYER DEATH --
------------------
for each player do
	global.object[0] = current_player.biped	
	if global.object[0] != no_object then
		current_player.object[1] = current_player.biped
	end
	if global.object[0] == no_object and current_player.object[3] != no_object then
		current_player.object[3].delete()
	end
	if current_player.biped == no_object and current_player.object[1] != no_object and not current_player.object[1].is_of_type(monitor) then
		-- player has died normally
   	if current_player.killer_type_is(kill) then
			-- player was MURDERED
   	   global.player[0] = current_player.get_killer()
   	   global.player[0].score += script_option[7]
		end
		if current_player.object[1] != no_object then
		-- there we go, we saved it
		global.object[0] = current_player.object[1]
		if script_option[9] != 0 and script_option[9] != 2 and script_option[9] != 5 and script_option[9] != 6 then
		-- no reviving, so just die normally
			if script_option[9] == 1 or script_option[9] == 2 or script_option[9] == 4 or script_option[9] == 6 then
				-- 1 life mode is on, monitor ify them
				current_player.number[1] = 2	
				monitorify_player()
				current_player.set_round_card_title("You are now spectating\r\nWait till the next Hotspot is cleared to be revived")
			end
		end
		if script_option[9] == 0 or script_option[9] == 2 or script_option[9] == 5 or script_option[9] == 6 then
		-- reviving enabled, down this player
			current_player.number[1] = 3 -- downed state
			monitorify_player()
			
			current_player.object[0] = global.object[0].place_at_me(flag_stand, "playerquitcheck", none, 0, 0, 0, none)
			-- setup light
			global.object[3] = global.object[0].place_at_me(light_red, none, none, 0, 0, 0, none)
			global.object[3].attach_to(current_player.object[0], 0, 0, 0, relative)
			-- do all the other stuff
			global.object[3] = current_player.object[0]
			global.object[3].player[1] = current_player
			-- boundary
			global.object[3].set_shape(cylinder, 8, 7, 7)
			-- alert down
			game.show_message_to(all_players, none, "%p has been downed", current_player)
			global.object[3].set_waypoint_text("DOWN")
			global.object[3].set_waypoint_visibility(everyone)
			global.object[3].set_waypoint_priority(low)
			current_player.timer[1].reset()
			current_player.timer[2].reset()
		end
		end
   end
end



---------------------
-- DOOR PURCHASING --
---------------------
for each object with label "Z_Door" do
   -- calculate price of door from spawn sequence
   -- (spwnseq > 0) spwnseq * 50
   -- (spwnseq < 0) spwnseq * -250
   -- (spwnseq == 0) spwnseq = 750
	
	current_object.set_waypoint_visibility(everyone)
	current_object.set_waypoint_icon(padlock)
	current_object.set_waypoint_text("$%n", hud_target_object.number[0])
	current_object.set_waypoint_range(0, 12)
	
   if current_object.number[0] == 0 then
      current_object.number[0] = current_object.spawn_sequence
      current_object.number[0] *= 50
      if current_object.number[0] < 0 then
         current_object.number[0] *= -5
      end
      if current_object.number[0] == 0 then
         current_object.number[0] = 750
      end
   end
	if current_object.player[0] == no_player then
   	for each player do
			if current_object.shape_contains(current_player.biped) and current_player.score >= current_object.number[0] and current_object.player[0] == no_player and current_player.number[0] == 0 and current_player.number[1] < 2 then
				current_object.player[0] = current_player
            current_object.timer[0] = 3
            -- set unlock states for this player
            current_player.timer[0].reset()
            current_player.timer[0].set_rate(-100%)
            current_player.number[0] = current_object.number[0]
         end
      end
   end
	if current_object.player[0] != no_player then
   	if current_object.shape_contains(current_object.player[0].biped) then
			current_object.timer[0].set_rate(-100%)
         if current_object.timer[0].is_zero() then
            -- subtract our price from the player
				current_object.player[0].score -= current_object.number[0]
            -- cleanup player purchasing
         	global.player[0] = current_object.player[0]
         	global.player[0].timer[0].set_rate(0%)
         	global.player[0].number[0] = 0
            -- complete door transaction
            current_object.delete()
         end
		end
   	if not current_object.shape_contains(current_object.player[0].biped) then
			-- end unlock
         -- set unlock states for this player
         global.player[0] = current_object.player[0]
         global.player[0].timer[0].set_rate(0%)
         global.player[0].number[0] = 0
			current_object.player[0] = no_player
		end
   end
end

---------------------
-- PURCHASE WIDGET --
---------------------
do
	script_widget[2].set_text("Purchasing for %n", hud_player.number[0])
   script_widget[2].set_meter_params(timer, hud_player.timer[0])
	for each player do
	   if current_player.number[0] != 0 then	
	      script_widget[2].set_visibility(current_player, true)
	   end	
	   if current_player.number[0] == 0 then
	      script_widget[2].set_visibility(current_player, false)
	   end
	end
end

-----------------
-- STORE LOGIC --
-----------------
function store_object_60()
	global.object[0].object[0].set_scale(60)
	global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
end
--
function store_object_40()
	global.object[0].object[0].set_scale(40)
	global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
end
--
function store_object_25()
	global.object[0].object[0].set_scale(25)
	global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
end
--
function store_object_20()
	global.object[0].object[0].set_scale(20)
	global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
end
--
function do_store_category() 
	-- function moment
	global.object[0] = current_object.object[0]
	global.object[0].object[0].delete()

	if current_object.number[1] == 0 then
		global.object[0].object[0] = current_object.place_at_me(assault_rifle, none, none, 0,0,0,none)
		store_object_60()
		global.object[0].set_waypoint_text("UNSC WEAPONS")
	end
	if current_object.number[1] == 1 then
		global.object[0].object[0] = current_object.place_at_me(plasma_repeater, none, none, 0,0,0,none)
		store_object_60()
		global.object[0].set_waypoint_text("COV WEAPONS")
	end
	if current_object.number[1] == 2 then
		global.object[0].object[0] = current_object.place_at_me(mongoose, none, none, 0,0,0,none)
		store_object_20()
		global.object[0].set_waypoint_text("VEHICLES")
	end
	if current_object.number[1] == 3 then
		global.object[0].object[0] = current_object.place_at_me(sprint, none, none, 0,0,0,none)
		store_object_40()
		global.object[0].set_waypoint_text("EQUIPMENT")
	end
	if current_object.number[1] == 4 then
		global.object[0].object[0] = current_object.place_at_me(dice, none, none, 0,0,0,none)
		global.object[0].object[0].set_scale(18)
		global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
		global.object[0].set_waypoint_text("MISC")
	end
   global.object[0].object[0].set_invincibility(1)
	global.object[0].object[0].attach_to(global.object[0], 0, 0, 0, relative)
end
--
--
function store_item_price()
   current_object.number[4] = global.number[1]
   global.object[0].number[0] = global.number[1]
	global.object[0].set_waypoint_text("$%n", hud_target_object.number[0])
end
--
function store_barrier_object_invincibility()
	store_item_price()
	global.object[4] = global.object[0].object[0]
	global.object[4].number[7] = 1
end
--
function store_item_40_balls()
	store_object_40()
	store_item_price()
end
function store_item_60_balls()
	store_object_60()
	store_item_price()
end
--
function store_item_150_60()
   global.number[1] = 150
	store_item_60_balls()
end
function store_item_400_60()
   global.number[1] = 400
	store_item_60_balls()
end
function store_item_500_60()
   global.number[1] = 500
	store_item_60_balls()
end
function store_item_500_40()
	global.number[1] = 500
	store_item_40_balls()
end
function benis()
	global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
	store_barrier_object_invincibility()
end

function store_item_bounds()
	if current_object.number[2] < 0 then
		current_object.number[2] = global.number[9]
	end
	if current_object.number[2] > global.number[9] then
		current_object.number[2] = 0
	end
end

function do_store_item() 
	-- function moment
	global.object[0] = current_object.object[0]
	global.object[0].object[0].delete()

	if current_object.number[1] == 0 then -- unsc weap
      -- if outta bounds, fix it
		global.number[9] = 7
		store_item_bounds()
		--
		if current_object.number[2] == 0 then
			global.object[0].object[0] = current_object.place_at_me(assault_rifle, none, none, 0,0,0,none)
			store_item_150_60()
		end
		if current_object.number[2] == 1 then
			global.object[0].object[0] = current_object.place_at_me(magnum, none, none, 0,0,0,none)
			store_item_150_60()
		end
		if current_object.number[2] == 2 then
			global.object[0].object[0] = current_object.place_at_me(dmr, none, none, 0,0,0,none)
         global.number[1] = 250
			store_item_60_balls()
		end
		if current_object.number[2] == 3 then
			global.object[0].object[0] = current_object.place_at_me(grenade_launcher, none, none, 0,0,0,none)
			store_item_400_60()
		end
		if current_object.number[2] == 4 then
			global.object[0].object[0] = current_object.place_at_me(shotgun, none, none, 0,0,0,none)
			store_item_400_60()
		end
		if current_object.number[2] == 5 then
			global.object[0].object[0] = current_object.place_at_me(sniper_rifle, none, none, 0,0,0,none)
			store_item_500_60()
		end
		if current_object.number[2] == 6 then
			global.object[0].object[0] = current_object.place_at_me(spartan_laser, none, none, 0,0,0,none)
			store_item_500_60()
		end
		if current_object.number[2] == 7 then
			global.object[0].object[0] = current_object.place_at_me(rocket_launcher, none, none, 0,0,0,none)
			store_item_500_60()
		end
	end
	if current_object.number[1] == 1 then -- cov weap
      -- if outta bounds, fix it
		global.number[9] = 7
		store_item_bounds()
		--
		if current_object.number[2] == 0 then
			global.object[0].object[0] = current_object.place_at_me(plasma_repeater, none, none, 0,0,0,none)
			store_item_150_60()
		end
		if current_object.number[2] == 1 then
			global.object[0].object[0] = current_object.place_at_me(plasma_pistol, none, none, 0,0,0,none)
			store_item_150_60()
		end
		if current_object.number[2] == 2 then
			global.object[0].object[0] = current_object.place_at_me(needle_rifle, none, none, 0,0,0,none)
         global.number[1] = 250
			store_item_60_balls()
		end
		if current_object.number[2] == 3 then
			global.object[0].object[0] = current_object.place_at_me(concussion_rifle, none, none, 0,0,0,none)
			store_item_400_60()
		end
		if current_object.number[2] == 4 then
			global.object[0].object[0] = current_object.place_at_me(energy_sword, none, none, 0,0,0,none)
			store_item_400_60()
		end
		if current_object.number[2] == 5 then
			global.object[0].object[0] = current_object.place_at_me(focus_rifle, none, none, 0,0,0,none)
			store_item_500_60()
		end
		if current_object.number[2] == 6 then
			global.object[0].object[0] = current_object.place_at_me(plasma_launcher, none, none, 0,0,0,none)
			store_item_500_60()
		end
		if current_object.number[2] == 7 then
			global.object[0].object[0] = current_object.place_at_me(fuel_rod_gun, none, none, 0,0,0,none)
			store_item_500_60()
		end
	end
	if current_object.number[1] == 2 then -- vehicles
      -- if outta bounds, fix it
		if script_option[8] == 0 then
			-- everything logic
			global.number[9] = 3
			store_item_bounds()
		end
		if script_option[8] > 0 then
			-- no objects logic
			global.number[9] = 1
			store_item_bounds()
		end
		--
		if current_object.number[2] == 0 then
			global.object[0].object[0] = current_object.place_at_me(plasma_cannon, "Z_Barrier", none, 0,0,0,none)
			store_object_25()
         global.number[1] = 500
			store_barrier_object_invincibility()
		end
		if current_object.number[2] == 1 then
			global.object[0].object[0] = current_object.place_at_me(machine_gun_turret, "Z_Barrier", none, 0,0,0,none)
			store_object_25()
         global.number[1] = 600
			store_barrier_object_invincibility()
		end
		if current_object.number[2] == 2 then
			global.object[0].object[0] = current_object.place_at_me(mongoose, "Z_Barrier", none, 0,0,0,none)
			store_object_20()
         global.number[1] = 800
			store_barrier_object_invincibility()
		end
		if current_object.number[2] == 3 then
			global.object[0].object[0] = current_object.place_at_me(ghost, "Z_Barrier", none, 0,0,0,none)
			store_object_20()
         global.number[1] = 1200
			store_barrier_object_invincibility()
		end
	end
	if current_object.number[1] == 3 then -- equipment
      -- if outta bounds, fix it
		if script_option[8] < 3 then
			global.number[9] = 6
			store_item_bounds()
		end
		if script_option[8] >= 3 then
			-- no pvp items logic
			global.number[9] = 1
			store_item_bounds()
		end
		--
		if current_object.number[2] == 0 then
			global.object[0].object[0] = current_object.place_at_me(sprint, none, none, 0,0,0,none)
         global.number[1] = 300
			store_item_40_balls()
		end
		if current_object.number[2] == 1 then
			global.object[0].object[0] = current_object.place_at_me(evade, none, none, 0,0,0,none)
         global.number[1] = 300
			store_item_40_balls()
		end
		if current_object.number[2] == 2 then
			global.object[0].object[0] = current_object.place_at_me(hologram, none, none, 0,0,0,none)
         store_item_500_40()
		end
		if current_object.number[2] == 3 then
			global.object[0].object[0] = current_object.place_at_me(armor_lock, none, none, 0,0,0,none)
         store_item_500_40()
		end
		if current_object.number[2] == 4 then
			global.object[0].object[0] = current_object.place_at_me(drop_shield, none, none, 0,0,0,none)
         store_item_500_40()
		end
		if current_object.number[2] == 5 then
			global.object[0].object[0] = current_object.place_at_me(jetpack, none, none, 0,0,0,none)
         store_item_500_40()
		end
		if current_object.number[2] == 6 then
			global.object[0].object[0] = current_object.place_at_me(active_camo_aa, none, none, 0,0,0,none)
         store_item_500_40()
		end
	end
	if current_object.number[1] == 4 then -- misc
      -- if outta bounds, fix it
		if script_option[8] == 0 then
			global.number[9] = 6
			store_item_bounds()
		end
		if script_option[8] == 1 or script_option[8] == 4 then
			-- no objects logic
			global.number[9] = 0
			store_item_bounds()
		end
		if script_option[8] == 2 or script_option[8] == 3  then
			-- some objects logic
			global.number[9] = 2
			store_item_bounds()
		end
		--
		if current_object.number[2] == 0 then
			global.object[0].object[0] = current_object.place_at_me(health_pack, none, none, 0,0,0,none)
 			global.object[0].object[0].set_scale(50)
			global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
         global.number[1] = 200
			store_item_price()
		end
		if current_object.number[2] == 1 then
			global.object[0].object[0] = current_object.place_at_me(fusion_coil, none, none, 0,0,0,none)
			store_object_25()
         global.number[1] = 400
			store_item_price()
		end
		if current_object.number[2] == 2 then
			global.object[0].object[0] = current_object.place_at_me(landmine, none, none, 0,0,0,none)
			store_object_25()
         global.number[1] = 500
			store_item_price()
		end
		if current_object.number[2] == 3 then
			global.object[0].object[0] = current_object.place_at_me(block_1x1_flat, "Z_Blockade", none, 0,0,0,none)
			global.object[0].object[0].set_scale(10)
         global.number[1] = 500
			benis()
		end
		if current_object.number[2] == 4 then
			global.object[0].object[0] = current_object.place_at_me(dice, "Z_Blockade", none, 0,0,0,none)
			global.object[0].object[0].set_scale(18)
         global.number[1] = 600
			benis()
		end
		if current_object.number[2] == 5 then
			global.object[0].object[0] = current_object.place_at_me(heavy_barrier, "Z_Blockade", none, 0,0,0,none)
			global.object[0].object[0].set_scale(10)
         global.number[1] = 800
			benis()
		end
		if current_object.number[2] == 6 then
			global.object[0].object[0] = current_object.place_at_me(breakpoint_bomb_door, "Z_Blockade", none, 0,0,0,none)	
			global.object[0].object[0].set_scale(5)
         global.number[1] = 1100
			benis()
		end
	end
	global.object[0].object[0].set_invincibility(1)
	global.object[0].object[0].attach_to(global.object[0], 0, 0, 0, relative)
end
--
--
function clear_dem_objects()
	current_object.player[0] = no_player
	current_object.object[1].delete()
	current_object.object[2].delete()
	current_object.object[3].delete()
end
function store_button_boundary()
	global.object[0].set_shape(box, 8,8,10,10)
	global.object[0].set_shape_visibility(mod_player, current_player, 1)
	global.object[0].set_waypoint_visibility(mod_player, current_player, 1)
	global.object[0].set_waypoint_range(0, 10)
	global.object[0].set_waypoint_priority(high)
end
--
function redo_data_core()
	current_object.object[0] = current_object.place_at_me(unsc_data_core, none, none, 0,0,0,none)
	current_object.object[0].set_pickup_permissions(no_one)
	current_object.object[0].set_scale(1)
	current_object.object[0].copy_rotation_from(current_object.object[0],true)
   current_object.object[0].attach_to(current_object, 0, -2, 0, relative)

	global.object[0] = current_object.object[0]
	global.object[0].team = neutral_team

	current_object.object[0].set_waypoint_visibility(mod_player, current_object.player[0], 1)
	current_object.object[0].set_waypoint_range(0, 10)
	current_object.object[0].set_waypoint_priority(normal)
end

function new()
	global.object[4].player[0] = current_object.player[0]
	global.object[4].apply_shape_color_from_player_member(0)
end
-- give players the store instructions
for each player do
	global.number[1] = 0
	for each object with label "Z_Store" do
		if current_object.shape_contains(current_player.biped) and current_player.number[1] < 2 then
			global.number[1] = 1
		end
	end
	if global.number[1] == 1 and current_player.number[4] == 0 then
		game.show_message_to(current_player, none, "Melee the monitor to open the store menu")
	end
	current_player.number[4] = global.number[1]
end
--
for each object with label "Z_Store" do
	global.number[1] = current_object.health
	if script_option[8] != -1 and global.number[1] > 0 then
	-- setup store if not setup already
   if current_object.number[0] == 0 then
      current_object.number[0] = 1
      current_object.max_health = 3000
      current_object.set_waypoint_icon(supply_ammo)
      current_object.set_waypoint_visibility(everyone)
      current_object.set_waypoint_range(0, 5)
   end
   if current_object.player[0] == no_player then
		-- check to see if someone is tryna purchase
		if global.number[1] < 97 then
			--game.show_message_to(all_players, none, "$%n", global.number[1])
			
			current_object.health = 100
			-- someone has tried to initiate a purchase
         for each player do
         	if current_object.shape_contains(current_player.biped) and current_object.player[0] == no_player and current_player.number[1] < 2 then
					current_object.player[0] = current_player
					-- store instructions
					game.show_message_to(current_object.player[0], none, "Use the back, left & right boundaries to navigate the menu\r\nMelee to select/purchase")
					-- alert other players that they are not using the store
					for each player do
						if current_object.shape_contains(current_player.biped) and current_player.number[1] < 2 and current_player != current_object.player[0] then
							game.show_message_to(current_player, none, "%p is using the store!", current_object.player[0])
						end
					end
					
					
					current_object.number[1] = 0
					current_object.number[2] = -1
					-- preview stand
					redo_data_core()
					global.object[0].object[0] = current_object.place_at_me(assault_rifle, none, none, 0,0,0,none)
					global.object[0].object[0].set_scale(60)
					global.object[0].object[0].copy_rotation_from(global.object[0].object[0], true)
               global.object[0].object[0].attach_to(global.object[0], 0, 0, 0, relative)
					global.object[0].set_waypoint_text("UNSC WEAPONS")
					-- setup preview items
					-- left
					current_object.object[1] = current_object.place_at_me(hill_marker, none, none, 0,0,0,none)
					global.object[0] = current_object.object[1]
					store_button_boundary()
					current_object.object[1].set_waypoint_text("Left")
               current_object.object[1].attach_to(current_object, -6, -5, -7, relative)
					-- right
					current_object.object[2] = current_object.place_at_me(hill_marker, none, none, 0,0,0,none)
					global.object[0] = current_object.object[2]
					store_button_boundary()
					current_object.object[2].set_waypoint_text("Right")
               current_object.object[2].attach_to(current_object, 6, -5, -7, relative)
					-- back
					current_object.object[3] = current_object.place_at_me(hill_marker, none, none, 0,0,0,none)
					global.object[0] = current_object.object[3]
					store_button_boundary()
					current_object.object[3].set_waypoint_text("Back")
               current_object.object[3].attach_to(current_object, 0, -11, -7, relative)
				end
         end
      end
	end
   if current_object.player[0] != no_player then
		-- someone is using the store
		-- check to see if player is NOT in any of the boundaries -- essentially a toggle
      if current_object.number[3] == 1 then
			global.number[1] = 0
         -- check to see if player hopped in boundaries
         if current_object.object[1].shape_contains(current_object.player[0].biped) then -- left
				global.number[1] = 1
			end
         if current_object.object[2].shape_contains(current_object.player[0].biped) then -- right
				global.number[1] = 1
			end
         if current_object.object[3].shape_contains(current_object.player[0].biped) then -- back
				global.number[1] = 1
			end
         -- isnt in any boundaries? good, remove the color
			if global.number[1] == 0 then
				current_object.number[3] = 0
				current_object.object[1].apply_shape_color_from_player_member(-1)
				current_object.object[2].apply_shape_color_from_player_member(-1)
				current_object.object[3].apply_shape_color_from_player_member(-1)
			end
      end
      if current_object.number[3] == 0 then
         -- check to see if player hopped in boundaries
         if current_object.object[1].shape_contains(current_object.player[0].biped) then -- left
				global.object[4] = current_object.object[1]
				new()

				current_object.number[3] = 1
				if current_object.number[2] == -1 then
               -- decrease category
					current_object.number[1] -= 1
					if current_object.number[1] < 0 then
						current_object.number[1] = 4
					end
					if script_option[8] == 1 then
						-- disable vehi category if no objects mode
						if current_object.number[1] == 2 then
							current_object.number[1] = 1
						end
					end
					do_store_category() -- funct
				end
				if current_object.number[2] != -1 then
					current_object.number[2] -= 1
					-- do the index thing
					do_store_item() 
				end
			end
         if current_object.object[2].shape_contains(current_object.player[0].biped) then -- right
				global.object[4] = current_object.object[2]
				new()

				current_object.number[3] = 1
				if current_object.number[2] == -1 then
               -- increase category
					current_object.number[1] += 1
					if current_object.number[1] > 4 then
						current_object.number[1] = 0
					end
					if script_option[8] == 1 then
						-- disable vehi category if no objects mode
						if current_object.number[1] == 2 then
							current_object.number[1] = 3
						end
					end
					do_store_category() -- funct
				end
				if current_object.number[2] != -1 then
					current_object.number[2] += 1
					-- do the index thing
					do_store_item() 
				end
			end
         if current_object.object[3].shape_contains(current_object.player[0].biped) then -- back
				global.object[4] = current_object.object[3]
				new()

				current_object.number[3] = 1
				if current_object.number[2] == -1 then
					current_object.object[0].delete()
					clear_dem_objects()
				end
				if current_object.number[2] != -1 then
					current_object.number[2] = -1
					do_store_category() 
				end
			end
      end
		
		-- check to see if someone is tryna interact
      global.number[1] = current_object.health
		if global.number[1] < 100 then
			global.player[0] = current_object.player[0] 
			global.object[0] = current_object.object[0]
			-- is in item selection mode
			if current_object.number[2] != -1 then
				-- not enough money
				if global.player[0].score < current_object.number[4] then
					game.show_message_to(global.player[0], none, "You dont have enough points")
					-- put it back on the stand
					current_object.object[0].delete()
					redo_data_core()
					do_store_item() 
				end
				-- purchase item
				if global.player[0].score >= current_object.number[4] then
					global.player[0].score -= current_object.number[4]
					game.show_message_to(global.player[0], none, "Successfully Purchased")
					global.object[0].detach()
					-- put our item in the box (:
					global.object[3] = global.object[0].object[0]
					-- shink our item
					global.object[3].detach()
					global.object[3].set_scale(1)
					global.object[3].copy_rotation_from(global.object[3], true)
					-- resize our container
					global.object[0].detach()
					global.object[0].set_scale(100)
					global.object[0].copy_rotation_from(global.object[0], true)
					-- give it back to the player
					global.object[0].player[0] = global.player[0]
					global.object[3].attach_to(global.object[0], 0, 0, 0, relative)
					global.player[0].add_weapon(global.object[0])
					-- is ready to go!
					global.object[0].number[1] = 1 
					-- cleanup our variables
					current_object.object[0] = no_object
					clear_dem_objects()
				end
			end
			-- is in category selection mode
			if current_object.number[2] == -1 then
				current_object.number[2] = 0
				current_object.object[0].delete()
				-- restore powercore			
				redo_data_core()
				do_store_item() 
			end
		end
		
		-- just use pickup perms lol
		
		-- reset core if someone accidently picks it up
		--global.object[0] = current_object.object[0]
		--global.player[0] = global.object[0].get_carrier()
      --if global.player[0] == current_object.player[0] then
		--	-- if is in object selection mode
		--	if current_object.number[2] != -1 then
		--		-- not enough money
		--		if global.player[0].score < current_object.number[4] then
		--			-- put it back on the stand
		--			current_object.object[0].delete()
		--			redo_data_core()
		--			do_store_item() 
		--		end
		--end
		if not current_object.shape_contains(current_object.player[0].biped) then
			-- looks like they ran away
			current_object.object[0].delete()
			clear_dem_objects()
      end
	end
	current_object.health = 100
	end
end

-------------------
-- STORE PACKAGE --
-------------------
for each object with label 10 do
	if current_object.number[1] == 1 then
   -- then this is ready to go
		global.player[0] = current_object.get_carrier()
		if global.player[0] == no_player then
			current_object.timer[0].set_rate(-50%)
         if current_object.timer[0].is_zero() then
				-- jack in the box moment
				current_object.object[0].detach()
				current_object.object[0].set_scale(100)
				current_object.object[0].copy_rotation_from(current_object.player[0].biped, true)
 				current_object.object[0].set_invincibility(0)
				global.object[3] = current_object.object[0]
				if global.object[3].number[7] == 1 then
					global.object[3].number[7] = 0
				end
				current_object.delete()
			end
 		end 
		if global.player[0] != no_player then
			current_object.timer[0].reset()
 		end
	end
end

------------------------
-- ZONE OBJECT LOGICS --
------------------------
-- positive sequences are only allowed in active zones
-- negative sequences are not allowed within active zones
for each object with label "Z_ZoneObj" do
	global.number[1] = 0
	global.object[0] = current_object
	for each object with label "Z_Activezone" do
		if current_object.number[0] == 1 and current_object.shape_contains(global.object[0]) then
			global.number[1] = 1
		end
	end
	-- object not contained in hotspot && spawn seq is + so remove
	if global.number[1] == 0 then -- *is not* contained in a hotspot
		if current_object.spawn_sequence >= 0 then -- our spawn sequence is positive
			current_object.delete()
		end
	end
	-- object is contained in hotspot && spawnseq is - so remove
	if global.number[1] == 1 then -- *is* contained in a hotspot
		if current_object.spawn_sequence < 0 then -- our spawn sequence is minus
			current_object.delete()
		end
	end
end

-------------------
-- SHADOW DEVICE --
-------------------
for each object with label "Z_Shadow" do
	if current_object.number[0] == 0 then
		current_object.number[0] = 1
		-- ///////////////////////////////////// --
		-- SHINK OBJECT - CODE MOVED TO ON LOCAL --
		-- ///////////////////////////////////// --
		--global.object[0] = current_object.place_between_me_and(current_object, warthog_turret, 0)
		global.object[0] = current_object.place_at_me(warthog_turret, none, none, 0,0,0, none)
		global.object[0].set_invincibility(1)
		global.object[0].attach_to(current_object, 0, 0, 0, relative)
		global.object[0].detach()
		current_object.attach_to(global.object[0], 0, 0, 0, relative)
	end
end

----------------------
-- FLASHLIGHT LOGIC --
----------------------
for each player do
	if current_player.biped != no_object and current_player.number[1] < 2 then
		global.number[1] = 0
		for each object with label "Z_Flashlight" do
			if current_object.shape_contains(current_player.biped) then
				global.number[1] = 1 	
			end
		end
		if current_player.object[3] == no_object and global.number[1] == 1 then 
			-- needa grab a flashlight for the player
			current_player.object[3] = current_player.biped.place_at_me(light_white, none, none, 0, 0, 0, none)
			-- ///////////////////////////////////// --
			-- SHINK OBJECT - CODE MOVED TO ON LOCAL --
			-- ///////////////////////////////////// --
			current_player.object[3].attach_to(current_player.biped, 0, 0, 5, relative)
		end
		if current_player.object[3] != no_object and global.number[1] == 0 then 
			-- they just left the flashlight zones, better clean up
			current_player.object[3].delete()
		end
	end
end

on local: do
	-- scale player lights on local
	for each player do	
		if current_player.object[3] != no_object then
			current_player.object[3].set_scale(1)
			current_player.object[3].copy_rotation_from(current_player.object[3], true)
		end
	end
	-- scale shadow objects
	for each object with label "Z_Shadow" do
		if current_object.number[1] == 0 then
			current_object.number[1] = current_object.spawn_sequence
			if current_object.spawn_sequence < 0 then
				current_object.number[1] *= -100
			end
			if current_object.spawn_sequence > 0 then
				current_object.number[1] *= 25
			end
			if current_object.spawn_sequence == 0 then
				current_object.number[1] = 100
			end
			current_object.set_scale(current_object.number[1])
			current_object.copy_rotation_from(current_object, true)
		end
	end
end

--------------------------
-- PASSIVE HEALTH REGEN --
--------------------------
for each player do
	global.number[1] = current_player.biped.shields
	if global.number[1] < 95 then
		global.object[0] = current_player.biped
		global.object[0].timer[0].reset()
	end
	if global.number[1] >= 95 then
		global.number[1] = current_player.biped.health
		if global.number[1] <= 55 then
			global.object[0] = current_player.biped
			global.object[0].timer[0].set_rate(-100%)
			if global.object[0].timer[0].is_zero() then
				current_player.biped.health += 1
			end
		end
	end
end

---------------------------------
-- PLAYER COUNT DAMAGE SCALING --
---------------------------------
do
	global.number[1] = 0
	-- count players
   for each player do
		global.number[1] += 1
	end
	
	for each player do
		if global.number[1] <= 4 then -- 4 player traits
			current_player.apply_traits(script_traits[1])
		end
		if global.number[1] > 4 and global.number[1] <= 8 then -- 8 player traits
			current_player.apply_traits(script_traits[2])
		end
		if global.number[1] > 8 and global.number[1] <= 12 then -- 12 player traits
			current_player.apply_traits(script_traits[3])
		end
	end
end


--------------------------
-- DOWNED PLAYERS LOGIC --
--------------------------
do
	script_widget[3].set_text("DOWNED")
	-- type -> current -> maximum
	script_widget[3].set_meter_params(number, hud_player.number[3], hud_player.number[2])
end

for each player do
	script_widget[3].set_visibility(current_player, false)
end

for each player do
	if current_player.number[1] >= 2 then
		current_player.apply_traits(script_traits[0])
		current_player.biped.remove_weapon(primary, false)
		if current_player.biped.is_of_type(spartan) then
			current_player.number[1] = 1
		end
	end
	if current_player.number[1] == 3 then -- player is downed
		global.object[0] = current_player.object[0]
		
		if script_option[9] == 1 or script_option[9] == 2 or script_option[9] == 4 or script_option[9] == 6 then
		-- if one life enabled
			current_player.timer[1].set_rate(-300%)
		end
		if script_option[9] != 1 and script_option[9] != 2 and script_option[9] != 4 and script_option[9] != 6 then
		-- if one life disabled
			current_player.timer[1].set_rate(-1000%)
		end
		-- //////////////// --
		-- FREE ACTION HERE --
		-- //////////////// --
		global.player[0] = current_player
		-- //// --
		current_player.number[2] = 150
		current_player.number[3] = current_player.timer[1]
		script_widget[3].set_visibility(current_player, true)
		script_widget[1].set_visibility(current_player, false)
		-- check to see if we're being revived
		if global.object[0].player[0] != no_player then
			-- stop reviving
			if not global.object[0].shape_contains(global.object[0].player[0].biped) then
				current_player.number[2] = 150
				current_player.number[3] = current_player.timer[1]
				global.object[0].player[0] = no_player
				global.object[0].timer[1] = 0
			end
			-- continue reviving
			if global.object[0].shape_contains(global.object[0].player[0].biped) then
				-- do the widgets
				current_player.number[2] = 40
				current_player.number[3] = current_player.timer[2]

				global.player[1] = global.object[0].player[0]
				global.player[1].number[2] = 40
				global.player[1].number[3] = current_player.timer[2]
				
				
				script_widget[1].set_visibility(global.object[0].player[0], false)
				script_widget[3].set_visibility(global.object[0].player[0], true)
				--	
				current_player.timer[1].set_rate(0%)
				current_player.timer[2].set_rate(1000%)
				if current_player.timer[2] >= 40 then
					-- revive player
					revive_player()
				end
			end
		end
		if global.object[0].player[0] == no_player then
			for each player do
				if current_player.number[1] < 2 then
					if global.object[0].shape_contains(current_player.biped) and global.object[0].player[0] == no_player then
						global.object[0].player[0] = current_player
						global.player[0].timer[2] = 0
					end
				end
			end
		end
		-- cheeky free action & trigger 
		if current_player.timer[1] <= 50	then
			global.object[0].set_waypoint_priority(blink)	
			-- check for death criteria
			if current_player.timer[1].is_zero() then
				if script_option[9] == 1 or script_option[9] == 2 or script_option[9] == 4 or script_option[9] == 6  then
					-- 1 life mode is on, monitor ify them
					current_player.number[1] = 2
					-- our player should already be a monitor
					global.object[0].delete()
					-- spectater mode
					current_player.set_round_card_title("You are now spectating\r\nWait till the next Hotspot is cleared to be revived")
				end
				if script_option[9] != 1 and script_option[9] != 2 and script_option[9] != 4 and script_option[9] != 6  then
					-- 1 life mode is off, respawn our player
					monitor_respawn()
					game.show_message_to(all_players, none, "%p bled out!", global.player[0])
				end
			end
		end
	end
end

----------------------
--	END GAME CRITERA --
----------------------
-- gameover via no living players left
if script_option[9] == 1 or script_option[9] == 2 or script_option[9] == 4 or script_option[9] == 6  then -- game is onelife
	global.number[1] = 0
	global.player[0] = no_player
	for each player do
		if current_player.number[1] < 2 then
			-- a player is still alive
			global.number[1] += 1
			global.player[0] = current_player
		end
   end
	-- check to see if notify last player last man standing
	if global.number[1] == 1 and global.number[10] > 1 then
		send_incident(inf_last_man, global.player[0], no_player)
	end
	-- record amount of players for next check
	global.number[10] = global.number[1]
	if global.number[1] == 0 and global.number[5] == 0 then
		-- no players left standing, end game
		global.number[5] = 1
		game.play_sound_for(all_players, inv_spire_vo_spartan_p1_loss, true)
	end
end
-- gameover via time out
if game.round_time_limit > 0 and game.round_timer.is_zero() and global.number[5] == 0 then 
	global.number[5] = 1
	game.play_sound_for(all_players, inv_spire_vo_spartan_p1_loss, true)
end
-- gameover via win
if script_option[15] > 0 and global.number[4] >= script_option[15] and global.number[5] == 0 then
	global.number[5] = 1
	game.play_sound_for(all_players, inv_boneyard_vo_spartan_p1_win, true)
end

if global.number[5] > 0 then
	global.number[5] += 1
	if global.number[5] > 181 then
	   game.end_round()
	end
end

for each object with label "playerquitcheck" do
	global.player[0] = current_object.player[1]
	global.number[1] = 0
	for each player do
		if current_player == global.player[0] then
			global.number[1] = 1
		end
	end
	if global.number[1] == 0 then
		current_object.delete()
	end
end



