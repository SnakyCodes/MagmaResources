--[[
     - "www.youtube.com/watch?v=8YKnEWD0a7U" - script is based on this video (published 3 month ago)
     - For a better experience, disable the standard rawetrip logs
     - HorribleBooba#6800
    -=-=-=-=-=-=-
     - "www.youtube.com/watch?v=8YKnEWD0a7U" - скрипт сделан по этому видео (опубликовано 3 месяца назад)
     - Для лучшего опыта отключите стандартные логи рэйвтрипа
     - HorribleBooba#6800
]]--


cheat.notify("[!] for a better experience, disable the standard rawetrip logs!")
cheat.notify("[!] для лучшего опыта отключите стандартные логи рэйвтрипа!")

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