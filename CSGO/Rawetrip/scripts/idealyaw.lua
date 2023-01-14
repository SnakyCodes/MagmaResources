local font = render.setup_font("Verdana", 12, 500, true, true, false)
local font_med = render.setup_font("Verdana", 14, 500, true, true, false)
local font_netgraph = render.setup_font("Verdana", 16, 400, true, true, false)
local font_big = render.setup_font("Verdana", 24, 500, true, true, false)
local font_small = render.setup_font("Verdana", 10, 400, true, true, false)
local font_small_calibri = render.setup_font("Calibri", 16, 200, true, false, false)

cheat.notify("Ideal Yaw loaded, welcome, bro.")

ui.add_sliderint("Ideal Yaw", 0, 0)
ui.add_checkbox("Enable watermark")
ui.add_checkbox("Enable indicators")
ui.add_checkbox("Enable holo panel")
ui.add_checkbox("Enable keybinds")
ui.add_sliderint("x", 0, engine.get_screen_width() - 110)
ui.add_sliderint("y", 0, engine.get_screen_height() - 19)
ui.add_combobox("Keybinds style", {"Fade", "Gradient"})
ui.add_checkbox("Enable halo")
--ui.add_colorpicker("holopanelcolor")
ui.add_checkbox("Enable legbreaker")
ui.add_checkbox("Enable viewmodel in scope")
ui.add_combobox("Menu bar style", {"Static", "Aero", "Minimalistic"})
ui.add_checkbox("Enable top line")
ui.add_checkbox("Enable netgraph")
ui.add_sliderint("X netgraph", 0, engine.get_screen_width() - 110)
ui.add_sliderint("Y netgraph", 0, engine.get_screen_height() - 19)

local swtich = true

local function Legbreak()
    local local_player = entitylist.get_local_player()
    local is_alive = local_player:is_alive()
    if ui.get_bool("Enable legbreaker") and cmd.get_send_packet() == true then
        if is_alive == true then
            if swtich then
                swtich = false
            else
                swtich = true
            end
            if swtich then
                ui.set_bool("Misc.slidewalk", false)
            else
                ui.set_bool("Misc.slidewalk", true)
            end
        else
            ui.set_bool("Misc.slidewalk", true)
        end  
    end
end
cheat.RegisterCallback("on_createmove", Legbreak)


local function paint()
 	local y = engine.get_screen_height()
	local x = engine.get_screen_width()
	local xmen = globalvars.get_menu_pos_x()
	local ymen = globalvars.get_menu_pos_y()
	local menu_opened = globalvars.is_open_menu()
	local fps = globalvars.get_framerate()	
	
	local rb = math.floor(math.sin(globalvars.get_realtime() * 2) * 127 + 128)
    	local gb =  math.floor(math.sin(globalvars.get_realtime() * 2 + 2) * 127 + 128)
    	local bb = math.floor(math.sin(globalvars.get_realtime() * 2 + 4) * 127 + 128)
    	
    	
    	local rbb = math.floor(math.sin(globalvars.get_realtime() * 3) * 127 + 128)
    	local gbb =  math.floor(math.sin(globalvars.get_realtime() * 3 + 2) * 127 + 128)
    	local bbb = math.floor(math.sin(globalvars.get_realtime() * 3 + 4) * 127 + 128)
 

	
	offset = 10
        	if menu_opened == true then
        	
	if ui.get_int("Menu bar style") == 0 then
    	render.rect_filled(xmen, ymen - 30, 160 + 60, 30, color.new(0,0,0,120))
    	render.text(font, xmen + 10, ymen - 20, color.new(255, 255, 255, 255), "Ideal Yaw Cord by citizzen<" .. "     " .. "fps: " .. tostring(fps))
    	render.gradient(xmen, ymen - 30, 160 + 60, 2, color.new(rb,gb,bb,255), color.new(rbb,gbb,bbb,255), horizontal)
    	end
    	
    	if ui.get_int("Menu bar style") == 1 then
    	local upanim = math.floor(math.sin(globalvars.get_realtime() * 5) * 30 + 30)
    	
    	local idyas = render.get_text_width(font_big, "IDEAL YAW")
    	local fpsize = render.get_text_width(font_med, "fps: " .. tostring(fps))
    	render.rect_filled(xmen - 250, ymen - 60 - 60  + upanim, 160 + 60, 30, color.new(0,0,0,120))
    	render.text(font_big, xmen + 7 - 250, ymen - 56 - 60  + upanim, color.new(255, 255, 255, 255), "IDEAL YAW")
    	render.text(font_med, xmen + 7 - 250 + 220 - fpsize - 15, ymen - 51 - 60  + upanim, color.new(255, 255, 255, 255), "fps: " .. tostring(fps))
    	render.gradient(xmen - 250, ymen - 60 - 60  + upanim, 160 + 60, 2, color.new(rb,gb,bb,255), color.new(rbb,gbb,bbb,255), horizontal)
    	render.line(xmen - 250 + 220, ymen - 60 - 60 + upanim, xmen, ymen, color.new(rbb,gbb,bbb,255))
end

    	if ui.get_int("Menu bar style") == 2 then
    	render.rect_filled_rounded(xmen, ymen - 26, 750, 22, 50, 3, color.new(0,0,0,150))
    	
    	local idys = render.get_text_width(font_small_calibri, "IDEAL-YAW")
    	render.text(font_small_calibri, xmen + 7, ymen - 23, color.new(242, 107, 255, 255), "IDEAL YAW")
    	render.text(font_small_calibri, xmen + 6, ymen - 22, color.new(242, 107, 255, 255), "IDEAL YAW")
    	render.text(font_small_calibri, xmen + 6, ymen - 23, color.new(255, 255, 255, 255), "IDEAL YAW")
    	render.text(font_small_calibri, xmen + idys + 8, ymen - 24, color.new(255, 255, 255, 255), "|")
    	render.text(font_small_calibri, xmen + idys + 8 + 8, ymen - 23, color.new(255, 255, 255, 255), "Welcome back, " .. "user")
    	render.text(font_small_calibri, xmen + 750 - 53, ymen - 23, color.new(255, 255, 255, 255), globalvars.get_time())
end

   	end
   	
if ui.get_bool("Enable top line") then
render.gradient(0, 0, engine.get_screen_width(), 2, color.new(rb,gb,bb), color.new(rbb,gbb,bbb))
end

   	
if ui.get_bool("Enable viewmodel in scope") then
            if ui.get_keybind_state( "misc.third_person_key" ) then
                console.set_int( "fov_cs_debug", 0 )
            else
                console.set_int( "fov_cs_debug", 90 )
		 end
else
console.set_int( "fov_cs_debug", 0 )
end
   	
   	
   	   if ui.get_bool("Enable keybinds") then 
   local x_pos = ui.get_int("x")
   local y_pos = ui.get_int("y")
   local offsett = 15  
   local hsmode = ui.get_keybind_mode(keybinds.hide_shots)
   local dtmode = ui.get_keybind_mode(keybinds.double_tap)
   local apmode = ui.get_keybind_mode(keybinds.automatic_peek)
   local spmode = ui.get_keybind_mode(keybinds.safe_points)
   local aamode = ui.get_keybind_mode(keybinds.flip_desync)
   local baimode = ui.get_keybind_mode(keybinds.body_aim)
   local swmode = ui.get_keybind_mode(keybinds.slowwalk)
   local fdmode = ui.get_keybind_mode(keybinds.fakeduck)
   local ejmode = ui.get_keybind_mode(keybinds.edge_jump)
   local dmgmode = ui.get_keybind_mode(keybinds.damage_override)
   if ui.get_int("Keybinds style") == 0 then
render.gradient(x_pos, y_pos, 60, 2, color.new(0,0,0,0), color.new(255,255,255))
render.gradient(x_pos + 60, y_pos, 60, 2, color.new(255,255,255), color.new(0,0,0,0))
end
if ui.get_int("Keybinds style") == 1 then
render.triplegradient(x_pos, y_pos, 120, 2, color.new(1,212,255,255), color.new(207,32,192,255), color.new(255,248,1,255), 0)
end
render.rect_filled(x_pos, y_pos + 2, 120, 15, color.new(0,0,0, 180))
render.text(font, x_pos + 40 - 3, y_pos + 3, color.new(255,255,255), "keybinds")
if (ui.get_keybind_state(keybinds.double_tap)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "double tap")
render.text(font, x_pos + 110 - 5 - 5 - 2,y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end
if (ui.get_keybind_state(keybinds.hide_shots)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "hide shots")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.flip_desync)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "anti-aim inverter")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.body_aim)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "body aim")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.slowwalk)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "slow walk")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.fakeduck)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "fake duck")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.edge_jump)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "edge jump")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.automatic_peek)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "auto peek")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.damage_override)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "damage override")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end

if (ui.get_keybind_state(keybinds.safe_points)) then
render.text(font, x_pos + 2, y_pos + 3 + offsett, color.new(255,255,255), "safe points")
render.text(font, x_pos + 110 - 5 - 5 - 2, y_pos + 3 + offsett, color.new(255,255,255), "[" .. "on" .. "]")
offsett = offsett + 15
end
end

   	
 if ui.get_bool("Enable watermark") then
local screen_w = engine.get_screen_width()
local screen_h = engine.get_screen_height()
local datetime = globalvars.get_time()
local xx, yy= engine.get_screen_width()/2,engine.get_screen_height()/2
local sundwat = render.get_text_width(font, "ideal yaw | " .. "rawetrip" .. " | " .. globalvars.get_ping() .. "ms" .. " |  " .. datetime)
render.rect_filled(screen_w - sundwat - 10, 10, sundwat + 4, 17, color.new(0,0,0,120))
render.rect_filled(screen_w - sundwat - 10, 10, sundwat + 4, 2, color.new(255,255,255,255))
render.gradient(screen_w - sundwat - 10, 10, sundwat + 4, 2, color.new(rb,gb,bb,255), color.new(rbb,gbb,bbb,255))
render.text(font, screen_w - sundwat - 10 + 2, 13, color.new(255,255,255,255), "ideal yaw | " .. "rawetrip" .. " | " .. globalvars.get_ping() .. "ms" .. " |  " .. datetime)
--if ui.get_int("Watermark mode") == 1 then
if(ui.get_keybind_state(keybinds.double_tap)) then
local ioind = globalvars.get_frametime()*1000
render.rect_filled(screen_w - 86, 30, 80, 17, color.new(0,0,0,120))
render.gradient(screen_w - 59, 34, 50 - math.ceil(ioind)*4, 8, color.new(255,255,255,255), color.new(0,0,0,0))

render.rect_filled(screen_w - 86, 45, 80, 2, color.new(255,255,255,255))
--render.rect_filled(screen_w - 125, 35, 50 , 8, color.new(255,0,0,120))
render.text(font, screen_w - 83, 31, color.new(255,255,255,255), "IO |")
end

if(ui.get_keybind_state(keybinds.hide_shots)) then
local ioind = globalvars.get_frametime()*1000
render.rect_filled(screen_w - 86, 30, 80, 17, color.new(0,0,0,120))
render.gradient(screen_w - 59, 34, 50 - math.ceil(ioind)*4, 8, color.new(255,255,255,255), color.new(0,0,0,0))
render.rect_filled(screen_w - 86, 45, 80, 2, color.new(255,255,255,255))
--render.rect_filled(screen_w - 125, 35, 50 , 8, color.new(255,0,0,120))
render.text(font, screen_w - 83, 31, color.new(255,255,255,255), "IO |")
end

if not (ui.get_keybind_state(keybinds.double_tap)) and not (ui.get_keybind_state(keybinds.hide_shots)) then
local ioind = globalvars.get_frametime()*1000
render.rect_filled(screen_w - 86, 30, 80, 17, color.new(0,0,0,120))
render.gradient(screen_w - 59, 34, 50 - math.ceil(ioind)*4, 8, color.new(255,255,255,255), color.new(0,0,0,0))
render.rect_filled(screen_w - 86, 45, 80, 2, color.new(255,255,255,255))
--render.rect_filled(screen_w - 125, 35, 50 , 8, color.new(255,0,0,120))
render.text(font, screen_w - 83, 31, color.new(255,255,255,255), "IO |")
render.gradient(screen_w - 86 - 14 - 10, 30, 20, 17, color.new(0,0,0,200), color.new(0,0,0,0))
render.gradient(screen_w - 86 - 14 - 20 - 10, 30, 20, 17, color.new(0,0,0,0), color.new(0,0,0,200))

render.gradient(screen_w - 86 - 14 - 10, 45, 20, 2, color.new(255,255,255,255), color.new(0,0,0,0))
render.gradient(screen_w - 86 - 14 - 20 - 10, 45, 20, 2, color.new(0,0,0,0), color.new(255,255,255,255))

render.text(font, screen_w - 86 - 14 - 7 - 10, 31, color.new(255,255,255,255), "FL")
local realtime_fade = math.floor(math.sin(globalvars.get_realtime() * 5) * 127 + 128)
render.text(font, screen_w - 86 - 14 - 7 - 10, 31, color.new(255,100,100,realtime_fade), "FL")

end

end
--end

   	
    if ui.get_bool("Enable indicators") then
        if not engine.is_in_game() then return end
    if entitylist.get_local_player():get_health() == 0 then return end

    	render.text(font, x/2 + 10, y/2 + 10, color.new(220, 135, 49, 255), "IDEAL YAW")
    	
    	if(ui.get_keybind_state(keybinds.flip_desync)) then
    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(209, 159, 230, 255), "POSITIVE")
 	offset = offset + 10
    	else
    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(209, 159, 230, 255), "NEGATIVE")
    	offset = offset + 10
    	end
    	
    	if(ui.get_keybind_state(keybinds.double_tap)) then   

    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(25, 255, 25, 255), "DT")
    	offset = offset + 10
    	end
    	
    	if(ui.get_keybind_state(keybinds.hide_shots)) then    	
    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(255, 255, 255, 255), "HS")
    	offset = offset + 10
    	end

    	if(ui.get_keybind_state(keybinds.damage_override)) then    	
    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(200, 185, 255, 255), "DMG")
    	offset = offset + 10
    	end
    	
    	if(ui.get_keybind_state(keybinds.body_aim)) then    	
    	render.text(font, x/2 + 10, y/2 + 10 + offset, color.new(190, 105, 19, 255), "BODY")
    	offset = offset + 10
    	end
   end
   
if not (ui.get_keybind_state(keybinds.thirdperson)) then return end
if not engine.is_in_game() then return end
    if entitylist.get_local_player():get_health() == 0 then return end
    
       	if ui.get_bool("Enable netgraph") then
   	local fps = math.floor(1 / globalvars.get_frametime())
   	local pinguha = globalvars.get_ping()
   	local fpsek = render.get_text_width(font_netgraph, tostring(fps))
   	local timereal = globalvars.get_time()
   	local ping2 = math.floor(pinguha * 10000 / 19.5)
   	local chokek = render.get_text_width(font_netgraph, "choke: " .. tostring(choke))
   	local timeek = render.get_text_width(font_netgraph, "time: " .. timereal)
   	local x_pos = ui.get_int("X netgraph")
   	local y_pos = ui.get_int("Y netgraph")
    local local_player = entitylist.get_local_player()
    local velocity = local_player:get_velocity()
    local speed = velocity:length_2d()   	
   	local colorfps = color.new(255,255,255)
   	if fps < 60 then
   	colorfps = color.new(255, 125, 95)
   	end
   	
   	local colorping = color.new(255,255,255)
   	if pinguha > 80 then
   	colorping = color.new(255, 125, 95)
   	end
   	
     local alpha_fade = math.floor(math.sin(globalvars.get_realtime() * 5) * 127 + 128)
   	
   	render.text(font_netgraph, x_pos, y_pos, colorfps, "fps: " .. tostring(fps))
   	render.text(font_netgraph, x_pos + fpsek + 50, y_pos, colorping, "ping: " .. tostring(pinguha) .. "ms")
   	render.text(font_netgraph, x_pos, y_pos + 20, color.new(255,255,255), "time: " .. timereal)
   	render.text(font_netgraph, x_pos + timeek + 20, y_pos + 20, color.new(255,255,255), "vel: " .. math.ceil(speed) .. " u/s")

   	render.text(font_netgraph, x_pos, y_pos + 40, color.new(255,255,255), "ver: 1389")
   	render.text(font_med, x_pos + 20, y_pos - 20, color.new(255,255,255,alpha_fade), "clock syncing")
   	--render.text(font_med, x_pos + 20 , y_pos + 60, color.new(255,255,255,alpha_fade), "exploit: disabled")
   	--render.circle(x_pos + 7, y_pos - 13, 50, 6, color.new(255,255,255, 60))
   	render.circle(x_pos + 7, y_pos - 13, 50, 5, color.new(255,255,255))
   	--render.text(font_netgraph, x_pos + 63, y_pos - 50, color.new(255,255,0,255), "!")
   	render.line(x_pos + 7, y_pos - 13, x_pos + 12, y_pos - 13, color.new(255,255,255))
   	render.line(x_pos + 7, y_pos - 13, x_pos + 10, y_pos - 18, color.new(255,255,255))
   	--render.line(x_pos + 56, y_pos - 33, x_pos + 66, y_pos - 55, color.new(255,201,95))
   	--render.line(x_pos + 66, y_pos - 55, x_pos + 76, y_pos - 32, color.new(255,201,95))
   	--render.line(x_pos + 56, y_pos - 33, x_pos + 76, y_pos - 33, color.new(255,201,95))

   	--render.line(x_pos + 55, y_pos - 33, x_pos + 65, y_pos - 55, color.new(255,201,95))
   	--render.line(x_pos + 65, y_pos - 55, x_pos + 75, y_pos - 32, color.new(255,201,95))
   	--render.line(x_pos + 55, y_pos - 33, x_pos + 75, y_pos - 33, color.new(255,201,95))
   


   	end

    
--local holo_color = ui.get_color("holopanelcolor")
   local hp = entitylist.get_local_player():get_health()
    local origin = entitylist.get_local_player():get_absorigin()
    origin.z, origin.y = origin.z + 5, origin.y + 10
    local screen = render.world_to_screen(entitylist.get_local_player():get_absorigin())
    
      local originline = entitylist.get_local_player():get_absorigin()
      originline.z = originline.z + 35
      local screens = render.world_to_screen(originline)
          
      local headstart = entitylist.get_local_player():get_player_hitbox_pos(15)
      local screend = render.world_to_screen(headstart)
      
      local handstart = entitylist.get_local_player():get_player_hitbox_pos(18)
      local screendd = render.world_to_screen(handstart)

    
    if x == 0 then
    	end
    	
    	    if ui.get_bool("Enable halo") then
    	    	local hanim = math.floor(math.sin(globalvars.get_realtime() * 5) * 127 + 128)
          local heads = entitylist.get_local_player():get_player_hitbox_pos(0)
          heads.z = heads.z + 10
          local rfoot = entitylist.get_local_player():get_player_hitbox_pos(11)
    		local headscreen = render.world_to_screen(heads)




			render.circle_3d(heads, 5, color.new(255, 255, 255,255))
			--render.gradient(headscreen.x, headscreen.y - 40, 1, 40,color.new(0,0,0,0), color.new(255,255,255), 1)
			--render.rect_filled(headscreen.x - 50, headscreen.y - 60 - 40, 100, 60,color.new(0,0,0,255))
			--render.rect_filled(headscreen.x - 50, headscreen.y - 60 - 40, 100, 1,color.new(200,200,200,255))
			--render.rect_filled(headscreen.x - 50, headscreen.y - 40 - 2, 100, 3,color.new(200,200,200,255))
			--render.rect_filled(headscreen.x - 50, headscreen.y - 60 - 40, 1, 60,color.new(200,200,200,255))
			--render.rect_filled(headscreen.x + 49, headscreen.y - 60 - 40, 1, 60,color.new(200,200,200,255))
			--render.text(font_small, headscreen.x - 20, headscreen.y - 35 - 40, color.new(255,255,255), 'SAMSUNG')
           end
    	
		if ui.get_bool("Enable holo panel") then 
		
		local flvalue = ui.get_int("Antiaim.fake_lag_limit")
		
						render.rect_filled(math.floor(screen.x + 198), math.floor(screen.y - 175), math.floor(137), math.floor(65), color.new(0,0,0, 120) )
--render.rect(math.floor(screen.x + 198), math.floor(screen.y - 175), math.floor(137), math.floor(65), color.new(40,40,40, 255) )
--render.rect_filled(math.floor(screen.x + 198), math.floor(screen.y - 178), math.floor(137), math.floor(3), color.new(255,255,255, 255))
render.gradient(math.floor(screen.x + 198), math.floor(screen.y - 178), math.floor(68), math.floor(3), color.new(0,0,0,0), color.new(255,255,255,255))
render.gradient(math.floor(screen.x + 198 + 68), math.floor(screen.y - 178), math.floor(68), math.floor(3), color.new(255,255,255,255), color.new(0,0,0,0))


local realtime_fade = math.floor(math.sin(globalvars.get_realtime() * 5) * 127 + 128)
local rand = math.random(100, 140)
local realtime_faded = math.floor(math.sin(globalvars.get_realtime() * 2) * rand + rand)
local circle_fade = math.floor(math.sin(globalvars.get_realtime() * 6) * 2 + 2)
--render.circle(math.floor(screen.x + 320), math.floor(screen.y - 160), 50, 10, color.new(120,120,120))
--render.circle(math.floor(screen.x + 320), math.floor(screen.y - 160), 50, 11, color.new(120,120,120))

render.arc(math.floor(screen.x + 320), math.floor(screen.y - 160), 10, 11, -90, 360, color.new(120,120,120, 120))
render.arc(math.floor(screen.x + 320), math.floor(screen.y - 160), 10, 11, -90, 60 + realtime_faded, color.new(255,255,255, realtime_fade))
--render.circle(math.floor(screen.x + 320), math.floor(screen.y - 160), 60 , 12, color.new(255,255,255, realtime_fade))
--render.circle(math.floor(screen.x + 320), math.floor(screen.y - 160), 60 , 11, color.new(255,255,255, realtime_fade))
render.line(math.floor(screend.x), math.floor(screend.y), math.floor(screen.x + 198), math.floor(screen.y - 175), color.new(255, 255, 255))
render.circle_filled(screend.x, screend.y, 50, 4, color.new(255,255,255,255))
render.circle_filled(screen.x + 198, screen.y - 175, 50, 2, color.new(255,255,255,255))
render.circle(screend.x, screend.y, 50, 4 + circle_fade, color.new(255,255,255,255))
render.text(font_small, math.floor(screen.x + 204), math.floor(screen.y - 170), color.new(255,255,255), 'ANTI-AIMBOT DEBUG')
local rechdt = globalvars.get_dt_recharging()


if(ui.get_keybind_state(keybinds.hide_shots)) or (ui.get_keybind_state(keybinds.double_tap)) then
render.text(font, math.floor(screen.x + 204 + 5), math.floor(screen.y - 155), color.new(255,255,255), "FL: 0")
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148), math.floor(2), math.floor(3), color.new(255,0,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(255,0,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149), math.floor(2), math.floor(1), color.new(255,0,0, 255))

end

if not (ui.get_keybind_state(keybinds.hide_shots)) and not (ui.get_keybind_state(keybinds.double_tap)) then
render.text(font, math.floor(screen.x + 204 + 5), math.floor(screen.y - 155), color.new(255,255,255), "FL: " .. flvalue)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148), math.floor(2), math.floor(3), color.new(0,255,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(0,255,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149), math.floor(2), math.floor(1), color.new(0,255,0, 255))
end

if(ui.get_keybind_state(keybinds.flip_desync)) then
	render.text(font, math.floor(screen.x + 204 + 45), math.floor(screen.y - 155), color.new(255,255,255), 'SIDE: L')
else
	render.text(font, math.floor(screen.x + 204 + 45), math.floor(screen.y - 155), color.new(255,255,255), 'SIDE: R')
end

			if (ui.get_keybind_state(keybinds.double_tap)) then
render.text(font_med, math.floor(screen.x + 204 + 5), math.floor(screen.y - 130), color.new(255,255,255,255), 'exploit: dt')
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148 + 27), math.floor(2), math.floor(3), color.new(0,255,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152 + 27), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(0,255,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149 + 27), math.floor(2), math.floor(1), color.new(0,255,0, 255))

			end
			if (ui.get_keybind_state(keybinds.hide_shots)) and not (ui.get_keybind_state(keybinds.double_tap)) then
				render.text(font_med, math.floor(screen.x + 204 + 5), math.floor(screen.y - 130), color.new(255,255,255), 'exploit: hs')
				render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148 + 27), math.floor(2), math.floor(3), color.new(0,255,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152 + 27), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(0,255,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149 + 27), math.floor(2), math.floor(1), color.new(0,255,0, 255))

			end
			if not (ui.get_keybind_state(keybinds.hide_shots)) and not (ui.get_keybind_state(keybinds.double_tap)) and not rechdt then
				render.text(font_med, math.floor(screen.x + 204 + 5), math.floor(screen.y - 130), color.new(255,255,255), 'exploit: none')
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148 + 27), math.floor(2), math.floor(3), color.new(255,0,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152 + 27), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(255,0,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149 + 27), math.floor(2), math.floor(1), color.new(255,0,0, 255))


			end
			
if rechdt then
render.text(font_med, math.floor(screen.x + 204 + 5), math.floor(screen.y - 130), color.new(255,255,255), 'exploit: recharge')
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 148 + 27), math.floor(2), math.floor(3), color.new(255,0,0,255), color.new(0,0,0,0), 1)
render.gradient(math.floor(screen.x + 204), math.floor(screen.y - 152 + 27), math.floor(2), math.floor(3), color.new(0,0,0,0), color.new(255,0,0,255), 1)
render.rect_filled(math.floor(screen.x + 204), math.floor(screen.y - 149 + 27), math.floor(2), math.floor(1), color.new(255,0,0, 255))
end



end
end
cheat.RegisterCallback("on_paint", paint)
