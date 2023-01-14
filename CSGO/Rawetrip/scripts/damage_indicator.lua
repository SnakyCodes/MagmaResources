-- ui
ui.add_checkbox('Enable dmg indicator')
ui.add_combobox("Indicators Size", { "Normal", "Big", "Medium", "Small", "Ultra Small" })

--fonts
local font_nor = render.setup_font("Verdana", 18, 300, true, true, false)
local font_big = render.setup_font('Verdana', 24, 400, true, true, false)
local font_medium = render.setup_font("Verdana", 17, 300, true, true, false)
local font_small = render.setup_font("Verdana", 12, 400, true, true, false)
local font_ultra_small = render.setup_font("Verdana", 10, 400, true, true, false)
--main
local screen_x,screen_y = engine.get_screen_width(),engine.get_screen_height()
local no_color = color.new(255,255,255)
local count = 0
local distance = 12
local s_width = render.get_text_width
local offsett = 15 


local function on_paint()

    if not ui.get_bool('Enable dmg indicator') then return end

	if not entitylist.get_local_player():is_alive() then return end

    local color_ind = color.new(255,255,255)
    local no_color = color.new(255,255,255)    
        if ui.get_int("Indicators Size") == 0 then

            if(ui.get_keybind_state(keybinds.damage_override)) then
			local weapname = weapon.get_name(entitylist.get_weapon_by_player(entitylist.get_local_player()))


			if weapname == "SSG 08" then
			render.text(font_nor, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("5Ragebot.minimum_override_damage")))
			end
			
			if weapname == "SCAR-20" or weapname == "G3SG1" then
			render.text(font_nor, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("4Ragebot.minimum_override_damage")))
			end

			if weapname == "DEAGLE" or weapname == "REVOLVER" then
			render.text(font_nor, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("0Ragebot.minimum_override_damage")))
			end
			
			if weapname == "GLOCK 18" or weapname == "CZ75-AUTO" or weapname == "P250" or weapname == "FIVE-SEVEN" or weapname == "USP-S" or weapname == "DUAL BERETTAS" or weapname == "TEC-9" or weapname == "P2000" then
			render.text(font_nor, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("1Ragebot.minimum_override_damage")))
			end

			if weapname == "AWP" then
			render.text(font_nor, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("6Ragebot.minimum_override_damage")))
			end


              offset = offset + 10
            
            end
        
        end


        if ui.get_int("Indicators Size") == 1 then

            if(ui.get_keybind_state(keybinds.damage_override)) then

			local weapname = weapon.get_name(entitylist.get_weapon_by_player(entitylist.get_local_player()))


			if weapname == "SSG 08" then
			render.text(font_big, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("5Ragebot.minimum_override_damage")))
			end
			
			if weapname == "SCAR-20" or weapname == "G3SG1" then
			render.text(font_big, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("4Ragebot.minimum_override_damage")))
			end

			if weapname == "DEAGLE" or weapname == "REVOLVER" then
			render.text(font_big, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("0Ragebot.minimum_override_damage")))
			end
			
			if weapname == "GLOCK 18" or weapname == "CZ75-AUTO" or weapname == "P250" or weapname == "FIVE-SEVEN" or weapname == "USP-S" or weapname == "DUAL BERETTAS" or weapname == "TEC-9" or weapname == "P2000" then
			render.text(font_big, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("1Ragebot.minimum_override_damage")))
			end

			if weapname == "AWP" then
			render.text(font_big, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("6Ragebot.minimum_override_damage")))
			end

              offset = offset + 10
            
            end
        
        end


    
  

        if ui.get_int("Indicators Size") == 2 then

            if(ui.get_keybind_state(keybinds.damage_override)) then

              	local weapname = weapon.get_name(entitylist.get_weapon_by_player(entitylist.get_local_player()))


			if weapname == "SSG 08" then
			render.text(font_medium, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("5Ragebot.minimum_override_damage")))
			end
			
			if weapname == "SCAR-20" or weapname == "G3SG1" then
			render.text(font_medium, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("4Ragebot.minimum_override_damage")))
			end

			if weapname == "DEAGLE" or weapname == "REVOLVER" then
			render.text(font_medium, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("0Ragebot.minimum_override_damage")))
			end
			
			if weapname == "GLOCK 18" or weapname == "CZ75-AUTO" or weapname == "P250" or weapname == "FIVE-SEVEN" or weapname == "USP-S" or weapname == "DUAL BERETTAS" or weapname == "TEC-9" or weapname == "P2000" then
			render.text(font_medium, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("1Ragebot.minimum_override_damage")))
			end

			if weapname == "AWP" then
			render.text(font_medium, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("6Ragebot.minimum_override_damage")))
			end

              offset = offset + 10
            
            end
        
        end


        if ui.get_int("Indicators Size") == 3 then

            if(ui.get_keybind_state(keybinds.damage_override)) then

              	local weapname = weapon.get_name(entitylist.get_weapon_by_player(entitylist.get_local_player()))


			if weapname == "SSG 08" then
			render.text(font_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("5Ragebot.minimum_override_damage")))
			end
			
			if weapname == "SCAR-20" or weapname == "G3SG1" then
			render.text(font_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("4Ragebot.minimum_override_damage")))
			end

			if weapname == "DEAGLE" or weapname == "REVOLVER" then
			render.text(font_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("0Ragebot.minimum_override_damage")))
			end
			
			if weapname == "GLOCK 18" or weapname == "CZ75-AUTO" or weapname == "P250" or weapname == "FIVE-SEVEN" or weapname == "USP-S" or weapname == "DUAL BERETTAS" or weapname == "TEC-9" or weapname == "P2000" then
			render.text(font_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("1Ragebot.minimum_override_damage")))
			end

			if weapname == "AWP" then
			render.text(font_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("6Ragebot.minimum_override_damage")))
			end

              offset = offset + 10
            
            end
        
        end

        if ui.get_int("Indicators Size") == 4 then

            if(ui.get_keybind_state(keybinds.damage_override)) then

                local weapname = weapon.get_name(entitylist.get_weapon_by_player(entitylist.get_local_player()))


			if weapname == "SSG 08" then
			render.text(font_ultra_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("5Ragebot.minimum_override_damage")))
			end
			
			if weapname == "SCAR-20" or weapname == "G3SG1" then
			render.text(font_ultra_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("4Ragebot.minimum_override_damage")))
			end

			if weapname == "DEAGLE" or weapname == "REVOLVER" then
			render.text(font_ultra_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("0Ragebot.minimum_override_damage")))
			end
			
			if weapname == "GLOCK 18" or weapname == "CZ75-AUTO" or weapname == "P250" or weapname == "FIVE-SEVEN" or weapname == "USP-S" or weapname == "DUAL BERETTAS" or weapname == "TEC-9" or weapname == "P2000" then
			render.text(font_ultra_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("1Ragebot.minimum_override_damage")))
			end

			if weapname == "AWP" then
			render.text(font_ultra_small, screen_x/2 + 5, screen_y - 560 , color.new(255, 255, 255, 255), tostring(ui.get_int("6Ragebot.minimum_override_damage")))
			end

              offset = offset + 10
            
            end
        
        end

end

--callback
cheat.RegisterCallback("on_paint", on_paint)



