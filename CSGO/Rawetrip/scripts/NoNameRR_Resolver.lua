--Made By NoNameRR
--我觉得按理来说这个lua应该能起到修正的效果
local yaw=("Antiaim.yaw_offset")
local i =  4
local count = 8
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
			i = 5;
			count = 5;
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
						ui.set_int("Antiaim.yaw_offset", math.random('-12','-34', '-44', '-57', '-69'));	
						check = true;
					end
					if n then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('12','34', '44', '57', '69'));
						check = true;
					end
				else
					random = math.random('-90', '90');
					if random > 1 then 
						p = false;
						n = false;
					else
						p = false;
						n = false;				
					end
					cheat.notify("[ELD_Debug] Yaw Change");
					ui.set_int("Antiaim.yaw_offset", random);
					count = count + 8;
					check = true;
				end
			else
				cheat.notify("[ELD_Debug] Yaw Change");
				ui.set_int("Antiaim.yaw_offset", math.random('-90', '90'));	
				check =true;
			end
		end
	end
	if i == 2 then
		ui.set_int("Antiaim.yaw_offset", yaw);
	end
end
end
local function reset()
if ui.get_bool("Enable Resolver correction") == true then
	events.register_event("round_end", function(e)
  		i = 8;
		count = 8;
		check =true;
		p = true;
		n = true;	
		ui.set_int("Antiaim.yaw_offset", yaw);
		cheat.notify("Resolver correction Made By NoNameR");
	end)
end
end
































































