cheat.notify("NeverLose By TTR#3653")
cheat.notify("Disable Rawetrip Logs")

--TTR was here
--credits to the mf who made the logs
local yaw=("Antiaim.yaw_offset")
local yaw=("Antiaim.yaw_center")
local i =  1
local count = 2
local check = true;
local p = true;
local n = true;
ui.add_checkbox("Enable Resolver correction")
cheat.notify("NeverLose Resolver Loaded!")
local function resolver(shot_info)
if ui.get_bool("Enable Resolver correction") == true then
	local result = shot_info.result
	local gpinf = engine.get_player_info
	local target = shot_info.target_index
	local target_name_hit
	local target_name_miss
	if result == "Hit" then
        		cheat.notify("{NeverLose} Hit");
		target_name_hit = gpinf(target).name;
		if target_name_hit == target_name_miss then
			i = 1;
			count = 1;
		end
	else
		cheat.notify("{NeverLose} Missed");
		target_name_miss = gpinf(target).name;
		i = i + 1;
		check = true;
    	end
end
end
local function aaset()
local random
if ui.get_bool("Enable Resolver correction") == true then
	if i > 1 then
		if check then 
			if ui.get_bool("Enable Resolver correction") == true then
				if count > 1 then
					if p then
						cheat.notify("{NeverLose} Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('-84','84','0'));	
						check = true;
					end
					if n then
						cheat.notify("{NeverLose} Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('-69','69','0'));
						check = true;
					end
				else
					random = math.random('-180','180','0');
					if random > -1 then 
						p = true;
						n = true;
					else
						p = true;
						n = true;				
					end
					cheat.notify("{NeverLose} Yaw Change");
					ui.set_int("Antiaim.yaw_center", random);
					count = count + 2;
					check = true;
				end
			else
				cheat.notify("{NeverLose} Yaw Change");
				ui.set_int("Antiaim.yaw_center", math.random('-90','-90','0'));	
				check =true;
			end
		end
	end
	if i == 2 then
		ui.set_int("Antiaim.yaw_center", yaw);
	end
end
end
local function reset()
if ui.get_bool("Enable Resolver correction") == true then
	events.register_event("round_end", function(e)
  		i = 1;
		count = 1;
		check = true;
		p = true;
		n = true;	
		ui.set_int("Antiaim.yaw_center", yaw);
		cheat.notify("Resolver By TTR#3653");
	end)
end
end

local fpsboost = ui.add_checkbox("FPS Boost")

cheat.push_callback("on_paint", function()

    if fpsboost:get() then

    console.set_int( "r_3dsky", 0 )
    console.set_int( "r_shadows", 0 )
    console.set_int( "cl_csm_static_prop_shadows", 0 )
    console.set_int( "cl_csm_shadows", 0 )
    console.set_int( "cl_csm_world_shadows", 0 )
    console.set_int( "cl_foot_contact_shadows", 0 )
    console.set_int( "cl_csm_viewmodel_shadows", 0 )
    console.set_int( "cl_csm_rope_shadows", 0 )
    console.set_int( "cl_csm_sprite_shadows", 0 )
    console.set_int( "cl_disablefreezecam", 0 )
    console.set_int( "cl_freezecampanel_position_dynamic", 0 )
    console.set_int( "cl_freezecameffects_showholiday", 0 )
    console.set_int( "cl_showhelp", 0 )
    console.set_int( "cl_autohelp", 0 )
    console.set_int( "cl_disablehtmlmotd", 0 )
    console.set_int( "mat_postprocess_enable", 0 )
    console.set_int( "fog_enable_water_fog", 0 )
    console.set_int( "gameinstructor_enable", 0 )
    console.set_int( "cl_csm_world_shadows_in_viewmodelcascade", 0 )
    console.set_int( "cl_disable_ragdolls", 0 )
    end
end)

cheat.push_callback("on_unload", function()
    console.set_int( "r_3dsky", 1 )
    console.set_int( "r_shadows", 1 )
    console.set_int( "cl_csm_static_prop_shadows", 1 )
    console.set_int( "cl_csm_shadows", 1 )
    console.set_int( "cl_csm_world_shadows", 1 )
    console.set_int( "cl_foot_contact_shadows", 1 )
    console.set_int( "cl_csm_viewmodel_shadows", 1 )
    console.set_int( "cl_csm_rope_shadows", 1 )
    console.set_int( "cl_csm_sprite_shadows", 1 )
    console.set_int( "cl_disablefreezecam", 1 )
    console.set_int( "cl_freezecampanel_position_dynamic", 1 )
    console.set_int( "cl_freezecameffects_showholiday", 1 )
    console.set_int( "cl_showhelp", 1 )
    console.set_int( "cl_autohelp", 1 )
    console.set_int( "cl_disablehtmlmotd", 1 )
    console.set_int( "mat_postprocess_enable", 1 )
    console.set_int( "fog_enable_water_fog", 1 )
    console.set_int( "gameinstructor_enable", 1 )
    console.set_int( "cl_csm_world_shadows_in_viewmodelcascade", 1 )
    console.set_int( "cl_disable_ragdolls", 1 )   
end)

cheat.push_callback("on_shot", function(shot_info) 
if shot_info.result == "Spread" then
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: - | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: spread") 
elseif shot_info.result == "Occlusion" then 
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: - | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: occlusion") 
elseif shot_info.result == "Hit" then   
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: " .. shot_info.server_hitbox .. " | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: -") 
elseif shot_info.result == "resolver" then  
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: - | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: resolver")
elseif shot_info.result == "unregistered" then  
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: - | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: death")
elseif shot_info.result == "invalid backtrack tick" then 
    cheat.notify("[ Neverlose ] Registered shot at " .. shot_info.target_name .. " | Hitbox: - | Hitchance: "  .. shot_info.hitchance .. " | Damage: " .. shot_info.server_damage  .. " | Reason: prediction error")
    end
end)

cheat.push_callback("on_unload", function()
    cheat.notify("bye!")
end)



