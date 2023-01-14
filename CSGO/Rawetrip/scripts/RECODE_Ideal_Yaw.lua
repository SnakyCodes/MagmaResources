local font = render.setup_font("Verdana", 12)
local fontmedium = render.setup_font("Verdana", 14)
local smallestpixel = render.setup_font("Smallest Pixel-7", 10)
local weapfont = render.setup_weapon_font(72)

cheat.popup("Ideal.Yaw loaded", "Welcome back, " .. engine.get_gamename())

ui.add_checkbox("Enable watermark")
ui.add_checkbox("Enable indicators")
ui.add_checkbox("Enable holo panel")
ui.add_checkbox("Enable keybinds")
ui.add_sliderint("x", 0, engine.get_screen_width() - 110)
ui.add_sliderint("y", 0, engine.get_screen_height() - 19)
ui.add_checkbox("Enable halo")
ui.add_checkbox("Enable legbreaker")
ui.add_combobox("Break type", {"Force slide", "Backward slide"})
ui.add_checkbox("Enable viewmodel in scope")

	-- execute sound
	console.execute_client_cmd("play items/ammocrate_close.wav") 

local function lerp(start, _end, time, do_extraanim) if (not do_extraanim and math.floor(start) == _end) then return _end end; time = globalvars.get_frametime() * (time * 175); if time < 0 then time = 0.01 elseif time > 1 then time = 1 end; return (_end - start) * time + start end
local watermark_animation = 0
local dt_animation = 360
local tickbase_alpha = 0
local tickbase_hone = 0
local tickbase_htwo = 0
local tickbase_hthree = 0

local function menu_water()

    local menu = globalvars.get_menu()
	local options = { h = 40 }
	if globalvars.is_open_menu() then
		
		render.rect_filled_rounded(menu.x, menu.y - options.h - 5, menu.z, options.h, 60, 3, color.new(0, 0, 0, 170))
		render.gradient(menu.x, menu.y - options.h - 5, menu.z, 2, color.new(209, 203, 254), color.new(253, 201, 251))

		render.begin_cliprect(menu.x, menu.y - options.h - 5, menu.z, options.h)
		render.text(weapfont, menu.x - 15, menu.y - options.h - 5, color.new(255,255,255, 50), "l")
		render.end_cliprect()

		render.text(fontmedium, menu.x + 15, menu.y - options.h + 9, color.new(255,255,255), "Ideal Yaw", true, false)
		render.text(fontmedium, menu.x + menu.z - render.get_text_width(fontmedium, globalvars.get_time() ) - 15, menu.y - options.h + 9, color.new(255,255,255), globalvars.get_time(), true, false )
		render.image(textures.anime, menu.x, menu.y - options.h - 5 - 287, 460, 287)
	end

end

local function watermark()
    if not ui.get_bool("Enable watermark") then return end

    if globalvars.is_open_menu() then watermark_animation = lerp(watermark_animation, 355, 0.05, false) else watermark_animation = lerp(watermark_animation, 0, 0.05, false) end

    local data = { x = engine.get_screen_width(), y = engine.get_screen_height(), text = "ideal.yaw | " .. "@" .. string.lower(engine.get_gamename()) .. " | delay: " .. globalvars.get_ping() .. "ms | " .. globalvars.get_time() .. " " }

    local textwidth = render.get_text_width(font, data.text)

    render.rect_filled(data.x - textwidth - 15 + watermark_animation, 10, textwidth + 10, 23, color.new(20,20,20,150))
    render.rect_filled(data.x - textwidth - 15 + watermark_animation, 10, textwidth + 10, 2, color.new(255,255,255,255))
    render.text(font, data.x - textwidth - 9 + watermark_animation, 16, color.new(255,255,255,255), data.text)

end

local function indicators()
    if not ui.get_bool("Enable indicators") then return end

    local renderdata = { width = engine.get_screen_width(), height = engine.get_screen_height(), offset = 20, type = "DYNAMIC" }

    if ui.get_bool("Antiaim.freestand") then renderdata.type = "FREESTAND" end

    render.text(font, renderdata.width/2 + 10, renderdata.height/2 + renderdata.offset, color.new(255,255,255,255), "IDEAL-YAW", true)
    render.text(font, renderdata.width/2 + 10, renderdata.height/2 + renderdata.offset + 10, color.new(220,220,220,255), renderdata.type, true)

    if globalvars.get_dt_recharging() then

        dt_animation = lerp(dt_animation, 0, 0.05, false)

    elseif not globalvars.get_dt_recharging() then 

        dt_animation = lerp(dt_animation, 360, 0.05, false)

    end

    if ui.get_keybind_state(keybinds.double_tap) then 

        render.text(font, renderdata.width/2 + 10, renderdata.height/2 + renderdata.offset + 20, color.new(220,220,220,255), "DT", true)
        render.arc(renderdata.width/2 + 75,  renderdata.height/2 + renderdata.offset + 6, 3, 4, -90, dt_animation, color.new(255,255,255))
        renderdata.offset = renderdata.offset + 10

    end

    if ui.get_keybind_state(keybinds.hide_shots) then 

        render.text(font, renderdata.width/2 + 10, renderdata.height/2 + renderdata.offset + 20, color.new(220,220,220,255), "HS", true)
        renderdata.offset = renderdata.offset + 10

    end


end

local pos = { x = engine.get_screen_width() / 2 + 130, y = engine.get_screen_height() / 2 - 120}

local function holopanel()

    if not ui.get_bool("Enable holo panel") then return end
    if not engine.is_in_game() then return end
    if entitylist.get_local_player():get_health() == 0 then return end

    local pos_hand = vector.new(0, 0, 0)

    if ui.get_keybind_state(keybinds.thirdperson) then 
        pos_hand = entitylist.get_local_player():get_player_bone_pos(48) 
    end

    if not entitylist.get_local_player():is_scoped() then 
        if not ui.get_keybind_state(keybinds.thirdperson) then 
            pos_hand = entitylist.get_local_player():get_muzzle_pos() 
        end 
    end

     local screenan = render.world_to_screen(pos_hand)
     local screenand = render.world_to_screen(pos_hand)
     screenan.x, screenan.y = screenan.x + 130, screenan.y - 90

     local smooth = {
         x = lerp(pos.x, screenan.x, 0.05),
         y = lerp(pos.y, screenan.y, 0.05),
     }

    pos.x, pos.y = smooth.x, smooth.y
         
    if pos_hand == vector.new(0,0,0) then return end
    if screenand.x == 0 then return end
 
    local renderdata = { x = pos.x, y = pos.y }

    if ui.get_keybind_state(keybinds.thirdperson) then 

        renderdata.x = pos.x + 70
        renderdata.y = pos.y - 50
    else
        renderdata.x = pos.x
        renderdata.y = pos.y
    end

    local circle_fade = math.floor(math.sin(globalvars.get_realtime() * 6) * 1 + 1)

    render.line(screenan.x - 130, screenan.y + 90, renderdata.x, renderdata.y + 65, color.new(255, 255, 255))

    render.circle_filled(screenan.x - 130, screenan.y + 90, 70, 3 + circle_fade, color.new(255,255,255))

    local byaw = antiaim.get_body_yaw()

    local tickbase_shift = false
    if ui.get_keybind_state(keybinds.double_tap) or ui.get_keybind_state(keybinds.hide_shots) then tickbase_shift = true end

    render.blur(renderdata.x, renderdata.y, 165, 65, 255)
    render.rect_filled(renderdata.x, renderdata.y, 165, 65, color.new(0,0,0, 120))

    render.arc(renderdata.x + 145, renderdata.y + 18, 7, 10, -90, 360, color.new(120, 120, 120, 120))
    render.arc(renderdata.x + 145, renderdata.y + 18, 7, 10, -90, 60 + byaw + 110, color.new(255, 255, 255, 255))

    render.rect_filled(renderdata.x, renderdata.y, 165, 2, color.new(255,255,255))

    render.text(smallestpixel, renderdata.x + 7, renderdata.y + 7, color.new(255,255,255), "ANTI-AIMBOT DEBUG", false, true)

    if tickbase_shift then

        tickbase_alpha = lerp(tickbase_alpha, 255, 0.05, false)
        tickbase_hone = lerp(tickbase_hone, 3, 0.05, false)
        tickbase_htwo = lerp(tickbase_htwo, 5, 0.05, false)
        tickbase_hthree = lerp(tickbase_hthree, 7, 0.05, false)

    else

        tickbase_alpha = lerp(tickbase_alpha, 0, 0.05, false)
        tickbase_hone = lerp(tickbase_hone, 0, 0.05, false)
        tickbase_htwo = lerp(tickbase_htwo, 0, 0.05, false)
        tickbase_hthree = lerp(tickbase_hthree, 0, 0.05, false)

    end

        render.text(smallestpixel, renderdata.x + 10, renderdata.y + 21, color.new(255,255,255), "FAKE: " .. byaw .. "°", false, true)
        render.rect_filled(renderdata.x + 5, renderdata.y + 22, 1, 8, color.new(255,255,255))
        render.rect_filled(renderdata.x + 5, renderdata.y + 37, 1, 8, color.new(255,255,255))
        render.text(smallestpixel, renderdata.x + 10, renderdata.y + 36, color.new(255,255,255), "SP:", false, true)

        render.text(smallestpixel, renderdata.x + 7, renderdata.y + 65 - 15, color.new(255,255,255, tickbase_alpha), "TICKBASE SHIFTING", false, true)
        render.rect_filled(renderdata.x + 165 - 12, renderdata.y + 65 - 14, 3, tickbase_hthree, color.new(255,255,255, tickbase_alpha))
        render.rect_filled(renderdata.x + 165 - 16, renderdata.y + 65 - 13, 3, tickbase_htwo, color.new(255,255,255, tickbase_alpha))
        render.rect_filled(renderdata.x + 165 - 20, renderdata.y + 65 - 12, 3, tickbase_hone, color.new(255,255,255, tickbase_alpha))
    
end

local function breaklegs()
    local local_player = entitylist.get_local_player()
    local is_alive = local_player:is_alive()
    local slidebreak = 0
    if ui.get_int("Break type") == 0 then
    slidebreak = 2
    end
    if ui.get_int("Break type") == 1 then
    slidebreak = 1
    end

    local swtich = true
    
    if ui.get_bool("Enable legbreaker") and cmd.get_send_packet() == true then
        if is_alive == true then
            if swtich then
                swtich = false
            else
                swtich = true
            end
            if swtich then
                ui.set_int("Misc.leg_movement", 0)
            else
                ui.set_int("Misc.leg_movement", slidebreak)
            end
        else
            ui.set_int("Misc.leg_movement", 0)
        end  
    end
end

local lerpklient = function(a, b, percentage) return a + (b - a) * percentage;end
local get_screen_size = function()local screen_size = { engine.get_screen_width(), engine.get_screen_height() };local screen_size = {screen_size[1] - screen_size[1] * console.get_float("safezonex"), screen_size[2] * console.get_float("safezoney")};return screen_size;end


local keybinds_tbl = {height = 0, width = 0, alpha = 0, modes = {"always", "holding", "toggled", "disabled"}, active = {}, dragging = {0, 0, 0},
    list = {
        {name = "Minimum damage", key = keybinds.damage_override},
        {name = "Double tap", key = keybinds.double_tap},
        {name = "On shot anti-aim", key = keybinds.hide_shots},
        {name = "Slow motion", key = keybinds.slowwalk},
        {name = "Anti-aim inverter", key = keybinds.flip_desync},
        {name = "Duck peek assist", key = keybinds.fakeduck},
        {name = "Quick peek assist", key = keybinds.automatic_peek},
        {name = "Force body aim", key = keybinds.body_aim},
        {name = "Force safe points", key = keybinds.safe_points},
    }
}

local g_paint_handler = function()
    local self = keybinds_tbl
    self.alpha = lerpklient(self.alpha, ui.get_bool("Enable keybinds") and 1 or 0, globalvars.get_frametime() * 12)
    if self.alpha < 0 then return end

    local maximum_offset = 66
    local indexes = 0

    for c_id, c_data in pairs(self.list) do
        local item_active = ui.get_keybind_state(c_data.key)

        if item_active then
            indexes = indexes + 1
            if self.active[c_id] == nil then
                self.active[c_id] = {
                    mode = "", alpha = 0, offset = 0, active = true, name = ""
                }
            end

            local text_width = render.get_text_width(fontmedium, c_data.name)
            
            self.active[c_id].name = c_data.name
            self.active[c_id].active = true
            self.active[c_id].offset = text_width
            self.active[c_id].mode = self.modes[(ui.get_keybind_mode(c_data.key) + 2)]
            self.active[c_id].alpha = lerpklient(self.active[c_id].alpha, 1, globalvars.get_frametime() * 12)

            if self.active[c_id].alpha > 1 then
                self.active[c_id].alpha = 1
            end
        elseif self.active[c_id] ~= nil then
            self.active[c_id].active = false
            self.active[c_id].alpha = lerpklient(self.active[c_id].alpha, 0, globalvars.get_frametime() * 12)

            if self.active[c_id].alpha < 0.1 then
                self.active[c_id] = nil
            end
        end

        if self.active[c_id] ~= nil and self.active[c_id].offset > maximum_offset then
            maximum_offset = self.active[c_id].offset
        end
    end

    local text = "keybinds"
    local x, y = ui.get_int("x"), ui.get_int("y")
    local r, g, b, a = 150, 150, 255, 255

    self.height = lerpklient(self.height, indexes > 0 and 5 + indexes * 15 or 0, globalvars.get_frametime() * 12)
    local height_offset = 23; self.width = lerpklient(self.width, 75 + maximum_offset, globalvars.get_frametime() * 12)
    local w, h = self.width, 50

    render.rect_filled(x, y, w, 2, color.new(r, g, b, self.alpha*255))
    render.rect_filled(x, y + 2, w, 20, color.new(17, 17, 17, self.alpha*100))
    render.text(fontmedium, x - render.get_text_width(fontmedium, text) / 2 + w / 2, y + 4, color.new(255, 255, 255, self.alpha*255), text)

    for c_name, c_ref in pairs(self.active) do
        local key_type = "[" .. (c_ref.mode or "?") .. "]"

        render.text(fontmedium, x + 5, y + height_offset, color.new(255, 255, 255, self.alpha*c_ref.alpha*255), c_ref.name, true)
        render.text(fontmedium, x + w - render.get_text_width(fontmedium, key_type) - 5, y + height_offset, color.new(255, 255, 255, self.alpha*c_ref.alpha*255), key_type, true)

        height_offset = height_offset + 15 * c_ref.alpha
    end
end

local function halo()

    if not ui.get_bool("Enable halo") then return end

    if not ui.get_keybind_state(keybinds.thirdperson) then return end

    local head = entitylist.get_local_player():get_player_hitbox_pos(0)
    head.z = head.z + 10
    render.circle_3d(head, 5, color.new(255,255,255,255))

end

cheat.RegisterCallback("on_paint", function()
    watermark()
    indicators()
    holopanel()
    g_paint_handler()
    halo()
    menu_water()
end)

cheat.RegisterCallback("on_createmove", function()
    if ui.get_bool("Enable viewmodel in scope") then
        if ui.get_keybind_state(keybinds.third_person) then
            console.set_int( "fov_cs_debug", 0 )
        else
            console.set_int( "fov_cs_debug", 90 )
     end
    else
    console.set_int( "fov_cs_debug", 0 )
    end

    breaklegs()
end)


cheat.RegisterCallback("on_unload", function()
	console.execute_client_cmd("play items/ammocrate_open.wav")
end)