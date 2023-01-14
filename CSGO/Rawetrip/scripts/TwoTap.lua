
--[[
































████████╗░██╗░░░░░░░██╗░█████╗░████████╗░█████╗░██████╗░░░░██╗░░░░░██╗░░░██╗░█████╗░
╚══██╔══╝░██║░░██╗░░██║██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗░░░██║░░░░░██║░░░██║██╔══██╗
░░░██║░░░░╚██╗████╗██╔╝██║░░██║░░░██║░░░███████║██████╔╝░░░██║░░░░░██║░░░██║███████║
░░░██║░░░░░████╔═████║░██║░░██║░░░██║░░░██╔══██║██╔═══╝░░░░██║░░░░░██║░░░██║██╔══██║
░░░██║░░░░░╚██╔╝░╚██╔╝░╚█████╔╝░░░██║░░░██║░░██║██║░░░░░██╗███████╗╚██████╔╝██║░░██║
░░░╚═╝░░░░░░╚═╝░░░╚═╝░░░╚════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝░╚═════╝░╚═╝░░╚═╝
































































]]


































cheat.popup("WARNING!","Please understand this is a ALPHA build of twotap.lua, Please send all issues to tabby")
local tabs = ui.add_combobox("Tabs",{"Rage","Anti Aim","Visuals","Misc"})
local preset = ui.add_combobox("Presets",{"None","Tabby","gh0st","tim","Agressive","Passive","Balanced","Skeet","Fakelag","1x1","5x5"})
local Enable = ui.add_checkbox("Enabled")
--> Rage
local dynamicdmg = ui.add_checkbox("Dynamic Min Damage")
local dynamic = ui.add_checkbox("Dynamic HitChance")
--> Anti Aim
local Enableaa = ui.add_checkbox("Enable Anti Aim")
local invertspam = ui.add_checkbox("Invert Spammer")
local randomdesynctype = ui.add_checkbox("Randomize desync type")
local RandomJitter = ui.add_checkbox("Randomize Jitter")
local randomjitermin = ui.add_sliderint("Min Jitter",1,180)
local randomjitermax = ui.add_sliderint("Max Jitter",1,180)
local customjit = ui.add_checkbox("Randomize Yaw")
local customjitermin = ui.add_sliderint("Min Yaw",-180,180)
local customjitermax = ui.add_sliderint("Max Yaw",-180,180)
local RandomDesync = ui.add_checkbox("Randomize Desync")
local legfuck = ui.add_checkbox("Leg Fucker")
local randomlean = ui.add_checkbox("Randomize Lean")
local randomfakelag = ui.add_checkbox("Better Random Fakelag")
local randomfakelagmin = ui.add_sliderint("Min fakelag",1,15)
local randomfakelagmax = ui.add_sliderint("Max fakelag",1,16)

--> visuals
local FUCK = ui.add_sliderint("NOT ADDED",0,0)
local enablevis = ui.add_checkbox("Enable Visuals")
local watermark = ui.add_checkbox("WaterMark")
local indicators = ui.add_checkbox("Indicators")
local keybinds = ui.add_checkbox("Keybinds")
local chinahat = ui.add_checkbox("China Hat")
--> Misc

cheat.popup("TwoTap.Lua","TwoTap.Lua Loaded")

}
dynamicdmg:set_visible(false)
dynamic:set_visible(false)
randomdesynctype:set_visible(false)
RandomJitter:set_visible(false)
RandomDesync:set_visible(false)
legfuck:set_visible(false)
randomlean:set_visible(false)
randomfakelag:set_visible(false)
chinahat:set_visible(false)
keybinds:set_visible(false)
indicators:set_visible(false)
watermark:set_visible(false)
FUCK:set_visible(false)
Enableaa:set_visible(false)
enablevis:set_visible(false)
Enable:set_visible(false)
randomjitermin:set_visible(false)
randomjitermax:set_visible(false)
randomfakelagmin:set_visible(false)
randomfakelagmax:set_visible(false)
customjitermax:set_visible(false)
customjitermin:set_visible(false)
customjit:set_visible(false)
invertspam:set_visible(false)
customjitermax:set(180)

local time = {
	first = 0, second = 0
}
cheat.push_callback("on_paint", function()
--> menu shit

if preset:get() == 1  then
    randomfakelag:set(true)
    Enableaa:set(true)
    enablevis:set(true)
    Enable:set(true)
    dynamicdmg:set(true)
    dynamic:set(true)
    randomdesynctype:set(false)
    randomfakelagmax:set(16)
    randomfakelagmin:set(2)
    RandomJitter:set(true)
    legfuck:set(true)
    randomlean:set(true)
    randomjitermax:set(50)
    randomjitermin:set(35)
    RandomDesync:set(true)
    customjitermin:set(-12)
    customjitermax:set(12)
    customjit:set(false)
    preset:set(0)

    
end

if preset:get() == 2  then
    Enableaa:set(true)
    enablevis:set(true)
    Enable:set(true)
    randomfakelag:set(true)
    dynamicdmg:set(true)
    dynamic:set(true)
    randomdesynctype:set(true)
    randomfakelagmax:set(11)
    randomfakelagmin:set(7)
    RandomJitter:set(true)
    legfuck:set(true)
    randomlean:set(false)
    randomjitermax:set(15)
    randomjitermin:set(10)
    RandomDesync:set(false)
    preset:set(0)
end






if tabs:get() == 0  then

    Enable:set_visible(true)
    dynamicdmg:set_visible(true)
    dynamic:set_visible(true)
    randomdesynctype:set_visible(false)
    RandomJitter:set_visible(false)
    RandomDesync:set_visible(false)
    legfuck:set_visible(false)
    randomlean:set_visible(false)
    randomfakelag:set_visible(false)
    chinahat:set_visible(false)
    keybinds:set_visible(false)
    indicators:set_visible(false)
    watermark:set_visible(false)
    FUCK:set_visible(false) 
    Enableaa:set_visible(false)
    enablevis:set_visible(false)
    randomjitermin:set_visible(false)
    randomjitermax:set_visible(false)
    randomfakelagmin:set_visible(false)
randomfakelagmax:set_visible(false)
customjitermax:set_visible(false)
customjitermin:set_visible(false)
customjit:set_visible(false)
invertspam:set_visible(false)


end


if tabs:get() == 1 then
    dynamicdmg:set_visible(false)
    dynamic:set_visible(false)
    randomdesynctype:set_visible(true)
    RandomJitter:set_visible(true)
    RandomDesync:set_visible(true)
    legfuck:set_visible(true)
    randomlean:set_visible(true)
    randomfakelag:set_visible(true)
    chinahat:set_visible(false)
    keybinds:set_visible(false)
    indicators:set_visible(false)
    watermark:set_visible(false)
    FUCK:set_visible(false) 
    Enable:set_visible(false)
    Enableaa:set_visible(true)
    randomjitermin:set_visible(true)
    randomjitermax:set_visible(true)
    enablevis:set_visible(false)
    randomfakelagmin:set_visible(true)
    randomfakelagmax:set_visible(true)
    customjitermax:set_visible(true)
    customjitermin:set_visible(true)
    customjit:set_visible(true)
    invertspam:set_visible(true)




end

if tabs:get() == 2 then
    dynamicdmg:set_visible(false)
    dynamic:set_visible(false)
    randomdesynctype:set_visible(false)
    RandomJitter:set_visible(false)
    RandomDesync:set_visible(false)
    legfuck:set_visible(false)
    randomlean:set_visible(false)
    randomfakelag:set_visible(false)
    chinahat:set_visible(true)
    keybinds:set_visible(true)
    indicators:set_visible(true)
    watermark:set_visible(true)
    FUCK:set_visible(true)
    enablevis:set_visible(true)
    Enable:set_visible(false)
    Enableaa:set_visible(false)
    randomjitermin:set_visible(false)
    randomjitermax:set_visible(false)   
    randomfakelagmin:set_visible(false)
    randomfakelagmax:set_visible(false)
    customjit:set_visible(false)
    customjitermax:set_visible(false)
customjitermin:set_visible(false)
invertspam:set_visible(false)


end


if tabs:get() == 3 then
    dynamicdmg:set_visible(false)
    dynamic:set_visible(false)
    randomdesynctype:set_visible(false)
    RandomJitter:set_visible(false)
    RandomDesync:set_visible(false)
    legfuck:set_visible(false)
    randomlean:set_visible(false)
    randomfakelag:set_visible(false)
    chinahat:set_visible(false)
    keybinds:set_visible(false)
    indicators:set_visible(false)
    watermark:set_visible(false)
    FUCK:set_visible(false)
    Enableaa:set_visible(false)
    enablevis:set_visible(false)
    Enable:set_visible(false)
    randomjitermin:set_visible(false)
    randomjitermax:set_visible(false)
    randomfakelagmin:set_visible(false)
    randomfakelagmax:set_visible(false)
    customjitermax:set_visible(false)
    customjitermin:set_visible(false)
    customjit:set_visible(false)

    invertspam:set_visible(false)

end














--> Actual features
local max,min,minf,maxf
max = randomjitermax:get()
min = randomjitermin:get()
minf = randomfakelagmin:get()
maxf = randomfakelagmax:get()
minj = customjitermin:get()
maxj = customjitermax:get()

-- here to stop crash's
if RandomJitter:get() and Enableaa:get() and min >= max then 
   randomjitermin:set(max)
   RandomJitter:set(false)
   cheat.popup("Crash prevention","The action you attemped to do wouldive crashed your game.")
    cheat.popup("Crash prevention","Please make the max 1 over the min")
end
if customjit:get() and Enableaa:get() and minj >= maxj then 
    customjitermin:set(maxj)
    customjit:set(false)
    cheat.popup("Crash prevention","The action you attemped to do wouldive crashed your game.")
     cheat.popup("Crash prevention","Please make the max 1 over the min")
 end
if randomfakelag:get() and Enableaa:get() and minf >= maxf then 
    randomfakelagmin:set(maxf)
    randomfakelag:set(false)
    cheat.popup("Crash prevention","The action you attemped to do wouldive crashed your game.")
     cheat.popup("Crash prevention","Please make the max 1 over the min")
 end
if  Enableaa:get() == true and RandomJitter:get() == true then
ui.find_menu_int("0Antiaim.range"):set(math.random(min,max))
ui.find_menu_int("0Antiaim.yaw"):set(1)
end
if Enableaa:get() and customjit:get() then
 ui.find_menu_int("0Antiaim.base_angle"):set(0)
    ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(minj,maxj))
end
if  Enableaa:get() == true and randomfakelag:get() == true then
    ui.find_menu_int("Antiaim.fake_lag_type"):set(0)
    ui.find_menu_int("Antiaim.fake_lag_limit"):set(math.random(math.random(minf,maxf)))
end

if  Enableaa:get() == true and RandomDesync:get() == true then
    ui.find_menu_bool("Antiaim.freestand"):set(false)
    ui.find_menu_int("0Antiaim.desync_range"):set(math.random(50,60))
    ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(50,60))
end
if  Enable:get() == true and dynamic:get() == true then
    ui.find_menu_int("4Ragebot.hitchance_amount"):set(math.random(57,60))
    ui.find_menu_int("5Ragebot.hitchance_amount"):set(math.random(70,74))
    ui.find_menu_int("0Ragebot.hitchance_amount"):set(math.random(31,40))
    ui.find_menu_int("1Ragebot.hitchance_amount"):set(math.random(35,40))
    ui.find_menu_int("6Ragebot.hitchance_amount"):set(math.random(70,75))
end

if  Enable:get() == true and dynamicdmg:get() == true then
    ui.find_menu_int("4Ragebot.minimum_visible_damage"):set(math.random(30,35))
    ui.find_menu_int("5Ragebot.minimum_visible_damage"):set(math.random(95,102))
    ui.find_menu_int("0Ragebot.minimum_visible_damage"):set(math.random(15,25))
    ui.find_menu_int("6Ragebot.minimum_visible_damage"):set(math.random(100,104))
    ui.find_menu_int("1Ragebot.minimum_visible_damage"):set(math.random(5,10))
end

if Enableaa:get() == true and legfuck:get() == true then
    ui.find_menu_int("Misc.leg_movement"):set(math.random(0,2))
end
if Enableaa:get() == true and randomlean:get() == true then
    ui.find_menu_int("0Antiaim.body_lean"):set(math.random(25,35))
    ui.find_menu_int("0Antiaim.inverted_body_lean"):set(math.random(25,35))
end   

ui.find_menu_bool("Misc.clantag_spammer"):set(false)

if time.first < globalvars.get_tickcount() then   
    time.second = time.second + 1
    if time.second > #labels + 1 then
        time.second = 0
    end

    engine.set_clantag(labels[time.second])

    time.first = globalvars.get_tickcount() + 17



end 

end)
cheat.push_callback("on_unload", function()
 cheat.popup("Goodbye","TwoTap.lua is unloading")
     engine.set_clantag(" ")
end) 
cheat.push_callback("on_shot", function(shot_info)

	if shot_info.result == "Spread" then
	cheat.popup("TwoTap.Lua","Shot Missed due to spread") 
elseif shot_info.result == "Occlusion" then
		cheat.popup("TwoTap.Lua","Shot Missed due to Occlusion" ) 
elseif shot_info.result == "Hit" then
	cheat.popup("TwoTap.Lua","Hit player: " .. shot_info.target_name .. " For: " .. shot_info.client_damage) 
elseif shot_info.result == "resolver" then 
    cheat.popup("TwoTap.Lua","Missed due to resolver")
elseif shot_info.result == "unregistered" then 
    cheat.popup("TwoTap.lua","Missed Shot due to death")
elseif shot_info.result == "invalid backtrack tick" then 
    cheat.popup("TwoTap.Lua","Missed shot due to invalid backtrack tick")
	    end
    end)
    

