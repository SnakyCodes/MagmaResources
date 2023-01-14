--Made By NoNameRR
--我觉得按理来说这个lua应该能起到修正的效果
local yaw=("Antiaim.yaw_offset")
local yaw=("Antiaim.yaw_center")
local i =  1
local count = 2
local check = true;
local p = true;
local n = true;
ui.add_checkbox("Enable Resolver correction")
ui.add_checkbox("Enable NoNameRR Resolver")
cheat.notify("Resolver correction NoNameRR")
local function resolver(shot_info)
if ui.get_bool("Enable Resolver correction") == true then
	local result = shot_info.result
	local gpinf = engine.get_player_info
	local target = shot_info.target_index
	local target_name_hit
	local target_name_miss
	if result == "Hit" then
        		cheat.notify("[ELD_Debug] Hit");
		target_name_hit = gpinf(target).name;
		if target_name_hit == target_name_miss then
			i = 1;
			count = 1;
		end
	else
		cheat.notify("[ELD_Debug] Miss");
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
			if ui.get_bool("Enable NoNameRR Resolver") == true then
				if count > 1 then
					if p then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('-84','84','0'));	
						check = true;
					end
					if n then
						cheat.notify("[ELD_Debug] Yaw Change");
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
					cheat.notify("[ELD_Debug] Yaw Change");
					ui.set_int("Antiaim.yaw_center", random);
					count = count + 2;
					check = true;
				end
			else
				cheat.notify("[ELD_Debug] Yaw Change");
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
		cheat.notify("Resolver correction Made By NoNameR");
	end)
end
end
























































































