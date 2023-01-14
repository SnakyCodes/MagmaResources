--Made By ELDment
--我觉得按理来说这个lua应该能起到修正的效果
local yaw = ui.get_int("Antiaim.yaw_offset")
local i = 0
local count = 0
local check = false
local p = false
local n = false
ui.add_checkbox("Enable Resolver correction")
ui.add_checkbox("Posi and Nega num switching")
cheat.notify("Resolver correction Made By ELDment")
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
			i = 0;
			count = 0;
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
	if i > 2 then
		if check then 
			if ui.get_bool("Posi and Nega num switching") == true then
				if count > 0 then
					if p then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('0', '-35'));	
						check = false;
					end
					if n then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('0', '35'));
						check = false;
					end
				else
					random = math.random('-35', '35');
					if random > 0 then 
						p = true;
						n = false;
					else
						p = false;
						n = true;				
					end
					cheat.notify("[ELD_Debug] Yaw Change");
					ui.set_int("Antiaim.yaw_offset", random);
					count = count + 1;
					check = false;
				end
			else
				cheat.notify("[ELD_Debug] Yaw Change");
				ui.set_int("Antiaim.yaw_offset", math.random('-35', '35'));	
				check = false;
			end
		end
	end
	if i == 0 then
		ui.set_int("Antiaim.yaw_offset", yaw);
	end
end
end
local function reset()
if ui.get_bool("Enable Resolver correction") == true then
	events.register_event("round_end", function(e)
  		i = 0;
		count = 0;
		check = false;
		p = false;
		n = false;	
		ui.set_int("Antiaim.yaw_offset", yaw);
		cheat.notify("Resolver correction Made By ELDment");
	end)
end
end
------
cheat.RegisterCallback("on_shot", resolver)
cheat.RegisterCallback("on_createmove", aaset)
cheat.RegisterCallback("on_paint", reset)