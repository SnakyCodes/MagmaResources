local function on_shot()
    end

     cheat.push_callback("on_shot", function(shot_info)
        if shot_info.result == "Resolver" then
           cheat.popup("Aquaholic.lua", "Missed shot due to Coder")

         elseif shot_info.result == "Occlusion" then
           cheat.popup("Aquaholic.lua", "Missed shot due to fucking wall")
       
         elseif shot_info.result == "Spread" then
            cheat.popup("Aquaholic.lua", "Missed shot due to spread ")

         elseif shot_info.result == "backtrack" then
            cheat.popup("Aquaholic.lua", "Missed shot due to invalid backtrack tick")

         elseif shot_info.result == "unregistered bullet" then
            cheat.popup("Aquaholic.lua", "Missed shot due to Internet ")
           
         elseif shot_info.result == "Hit" then
            cheat.popup("Aquaholic.lua","Hit in fucking slave: " .. shot_info.target_name .. " For: " .. shot_info.client_damage)

         elseif shot_info.result == "Misprediction" then
            cheat.popup("Aquaholic.lua_", "Missed shot due to FIX CFG")

         elseif shot_info.result == "Prediction" then
            cheat.popup("Aquaholic.lua", "Missed shot due to Coder")
        end
end)