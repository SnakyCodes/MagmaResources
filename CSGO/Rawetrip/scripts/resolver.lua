local yaw=("Antiaim.yaw_offset")
local yaw=("Antiaim.yaw_center")
local i =  0
local count = 2
local check = true;
local p = false;
local n = false;
ui.add_checkbox("1")
ui.add_checkbox("2")
cheat.notify("1")
local function resolver(shot_info)
if ui.get_bool("1") == true then
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
if ui.get_bool("1") == true then
	if i > 0 then
		if check then 
			if ui.get_bool("2") == true then
				if count > 1 then
					if p then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('0','-1','-12','-34','-44','-57','-60','-69','-72','-85','-90','-180'));	
						check = true;
					end
					if n then
						cheat.notify("[ELD_Debug] Yaw Change");
						ui.set_int("Antiaim.yaw_offset", math.random('0','1','12','34','44','57','60','69','72','85','90','180'));
						check = true;
					end
				else
				ui.set_int("Antiaim.yaw_center", math.random('-90','90'));	
					if random > -1 then 
						p = true;
						n = true;
					else
						p = false;
						n = false;				
					end
					cheat.notify("[ELD_Debug] Yaw Change");
					ui.set_int("Antiaim.yaw_center", random);
					count = count + 2;
					check = true;
				end
			else
				cheat.notify("[ELD_Debug] Yaw Change");
				ui.set_int("Antiaim.yaw_center", math.random('-90','90'));	
				check =true;
			end
		end
	end
	if i == 0 then
		ui.set_int("Antiaim.yaw_center", yaw);
	end
end
end
local function reset()
if ui.get_bool("1") == true then
	events.register_event("round_end", function(e)
  		i = 0;
		count = 1;
		check = true;
		p = false;
		n = false;	
		ui.set_int("Antiaim.yaw_center", yaw);
		cheat.notify("1");
	end)
end
end























































































































































































