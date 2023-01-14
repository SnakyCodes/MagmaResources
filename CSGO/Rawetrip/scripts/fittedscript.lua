--quick note i dont even know half the shit im writing in here so dont ask
local font = render.setup_font("Verdana", 16, fontflags.bold)
local fpindfont = render.setup_font("Verdana", 13, fontflags.bold)
local indfont = render.setup_font("Verdana", 11, fontflags.bold)
local scale = 1
local themecol = ui.add_colorpicker("Theme color")
local clantagenable = ui.add_checkbox("Enable clantag")
local freestandbind = ui.add_hotkey("Freestand on key")
local watermarkenable = ui.add_checkbox("Enable watermark")
local kdbarenable = ui.add_checkbox("Enable KD bar")
local autors = ui.add_checkbox("Auto RS")
local indcombo = ui.add_combobox("Indicators", { "None", "First Person", "Third Person", "Both" })
local waterscale = ui.add_sliderint("Indicator Scale", 50, 300)
local enablehitlist = ui.add_checkbox("Enable Hitlist")
local hitx = ui.add_sliderint("Hitlist X", 0, engine.get_screen_size().x)
local hity = ui.add_sliderint("Hitlist Y", 0, engine.get_screen_size().y)
local clantagbool = false
--local localkills = ui.add_sliderint("kills", 0, 20)
--local localdeaths = ui.add_sliderint("deaths", 0, 20)


local snames = {}
local sdmgs = {}
local shtbxs = {}
local btks = {}
local shotresults = {}
local localkills = 0
local localdeaths = 0
local white = color(255, 255, 255, 255)
local black = color(0, 0, 0, 255)
local red = color(255, 0, 0, 255)
local green = color(0, 255, 0, 255)
local teal = color(0, 255, 255, 255)
local blue = color(0, 0, 255, 255)
local grey = color(75, 75, 75, 255)
local dark_grey = color(35, 35, 35, 255)
local orange = color(255, 155, 0, 255)
local darker_grey = color(20, 20, 20, 255)
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function GetRealKD()
	local kd = localkills / localdeaths
	if localdeaths <= 0 then 
		kd = localkills
	end

	if localkills <= 0 and localdeaths > 1 then
		kd = 1 / localdeaths
	end
	return kd
end


local lastattempt = 'None'
local lasthit = 'None'
local lastbt = 0
local lastmiss = 'None'
local labels = {
	"8=======mD",
	"8=====m==D",
	"8===m====D",
	"8=m======D",
	"8====m===D",
    "8=======mD",
    "8====m===D",
    "8m=======D",
    "8m=======D~",
    "8m=======D~~",
    "8m=======D~~~",
    "8m=======D ~~~",
    "8m=======D  ~~~",
    "8m=======D~  ~~",
    "8m=======D ~~ ~",
    "8m=======D   ~~",
    "8m=======D    ~",
    "8m=======D     ",
    "8=m======D    ",
    "8===m====D   ",
    "8=====m==D  ",
}

local time = {
	first = 0, second = 0
}

function drawkdbar()
    local realkd = GetRealKD()
    local ss = engine.get_screen_size()

    local w = 240
    local h = 24
    render.rect_filled((ss.x / 2) - (w / 2), ss.y - 60, w, h, dark_grey, 3)
    render.gradient(((ss.x / 2) - (w / 2)) + 3, ss.y - 57, w - 6, h - 6, red, green, 0)

    render.rect_filled((ss.x / 2) - (3 / 2), ss.y - 57, 3, h - 6, black, 2)
    render.rect_filled((ss.x / 2) - (3 / 2) - (w / 4), ss.y - 57, 3, h - 6, black, 2)
    render.rect_filled((ss.x / 2) - (3 / 2) + (w / 4), ss.y - 57, 3, h - 6, black, 2)
    
    local kd = (220 * realkd)
    if kd > 220 then
        kd = 220
    end
    if kd == nil then
		kd = 0
	end
    render.circle_filled(((ss.x / 2) - (220 / 2)) + kd, ss.y - 48, 12, 7, white)
    local txtsize = render.get_text_size(font, round(realkd, 2))
    render.text(font, (ss.x / 2) - (txtsize.x / 2), ss.y - 80, white, round(realkd, 2), false, true)
end
function clantag()
    ui.find_menu_bool("Misc.clantag_spammer"):set(false)
    if time.first < globalvars.get_tickcount() then   
		time.second = time.second + 1
        if time.second > #labels + 1 then
            time.second = 0
        end

        engine.set_clantag(labels[time.second])

        time.first = globalvars.get_tickcount() + 8
    end


end
local extxt = 'DT'
local dtcol = white
local dtalp = 0
local fdalp = 0
local peekalp = 0
local spalp = 0
local baimalp = 0
local dmgalp = 0
local fsalp = 0
local maxy = 0
local totalenabled = 0
local y1 = 0
function fpind()
    if (engine.is_in_game() and entity.get_local():is_alive()) then
        local chpos = vector_2d(engine.get_screen_size().x / 2, engine.get_screen_size().y / 2 + 15)

        local size = render.get_text_size(fpindfont, extxt)
        y = chpos.y
        local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(dtalp, 0))
        local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(dtalp / 17, 0))
        render.gradient(chpos.x - ((size.x / 2) + 10), y, (size.x / 2) + 10, size.y, g2, g1, 0)
        render.gradient(chpos.x, y, (size.x / 2) + 10, size.y, g1, g2, 0)
        render.text(fpindfont, chpos.x - (size.x / 2), y, dtcol, extxt, false, true)


        if (ui.get_keybind_state(keybinds.fakeduck)) then
            y = y + size.y
            fdalp = animate.lerp(fdalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'FD')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(fdalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(fdalp / 17, 0))
            local ww = color(255, 255, 255, round(fdalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end

            render.gradient(chpos.x - ((size.x / 2) + 10), yy, (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy, (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy, ww, 'FD', false, true)
        else
            fdalp = 0
        end
        
        

        


        if (ui.get_keybind_state(keybinds.safe_points)) then
            y = y + size.y 
            spalp = animate.lerp(spalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'SP')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(spalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(spalp / 17, 0))
            local ww = color(255, 255, 255, round(spalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end
            render.gradient(chpos.x - ((size.x / 2) + 10), yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy - (totalenabled * size.y), ww, 'SP', false, true)
        else
            spalp = 0
        end
        
        
        if (ui.get_keybind_state(keybinds.body_aim)) then
            y = y + size.y 
            baimalp = animate.lerp(baimalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'BAIM')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(baimalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(baimalp / 17, 0))
            local ww = color(255, 255, 255, round(baimalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end
            render.gradient(chpos.x - ((size.x / 2) + 10), yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy - (totalenabled * size.y), ww, 'BAIM', false, true)
        else
            baimalp = 0
        end
        



        if (ui.get_keybind_state(keybinds.damage_override)) then
            y = y + size.y 
            dmgalp = animate.lerp(dmgalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'DMG')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(dmgalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(dmgalp / 17, 0))
            local ww = color(255, 255, 255, round(dmgalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end
            render.gradient(chpos.x - ((size.x / 2) + 10), yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy - (totalenabled * size.y), ww, 'DMG', false, true)
        else
            dmgalp = 0
        end
        



        if (ui.get_keybind_state(keybinds.automatic_peek)) then
            y = y + size.y 
            peekalp = animate.lerp(peekalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'PEEK')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(peekalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(peekalp / 17, 0))
            local ww = color(255, 255, 255, round(peekalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end
            render.gradient(chpos.x - ((size.x / 2) + 10), yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy - (totalenabled * size.y), ww, 'PEEK', false, true)
        else
            peekalp = 0
        end
        


        if freestandbind:get() then
            y = y + size.y 
            fsalp = animate.lerp(fsalp, 255, 0.1)
            local size = render.get_text_size(fpindfont, 'FS')
            local g1 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(fsalp, 0))
            local g2 = color(themecol:get():r(), themecol:get():g(), themecol:get():b(), round(fsalp / 17, 0))
            local ww = color(255, 255, 255, round(fsalp, 0))
            local yy = maxy
            if yy > y then
                yy = y
            end
            render.gradient(chpos.x - ((size.x / 2) + 10), yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g2, g1, 0)
            render.gradient(chpos.x, yy - (totalenabled * size.y), (size.x / 2) + 10, size.y, g1, g2, 0)
            render.text(fpindfont, chpos.x - (size.x / 2), yy - (totalenabled * size.y), ww, 'FS', false, true)
        else
            fsalp = 0
        end
        



        maxy = animate.lerp(maxy, y, 0.1)
        

        if (not ui.get_keybind_state(keybinds.thirdperson) and (indcombo:get() == 1 or indcombo:get() == 3)) or indcombo:get() == 1 then
            if (ui.get_keybind_state(keybinds.hide_shots)) then
                extxt = 'HS'
                dtcol = animate.lerp_color(dtcol, teal, 0.01)
            else
                extxt = 'DT'
                if (globalvars.get_dt_recharging() and not ui.get_keybind_state(keybinds.double_tap)) then
                    dtcol = animate.lerp_color(dtcol, red, 0.1)
                elseif (not globalvars.get_dt_recharging() and ui.get_keybind_state(keybinds.double_tap)) then
                    if (ui.get_keybind_state(keybinds.fakeduck)) then
                        dtcol = animate.lerp_color(dtcol, red, 0.1)
                    else
                        dtcol = animate.lerp_color(dtcol, themecol:get(), 0.025)
                    end
                else
                    dtcol = animate.lerp_color(dtcol, white, 0.1)
                end
            end
        end

        if ui.get_keybind_state(keybinds.hide_shots) or ui.get_keybind_state(keybinds.double_tap) or globalvars.get_dt_recharging() then
            dtalp = animate.lerp(dtalp, 255, 0.025)
        else
            dtalp = animate.lerp(dtalp, 0, 0.1)
        end

    end
end

local col = white
function indicators()
    if (engine.is_in_game() and entity.get_local():is_alive()) then
        if (not ui.get_keybind_state(keybinds.thirdperson) and (indcombo:get() == 1 or indcombo:get() == 3)) or indcombo:get() == 1 then
            fpind()
        elseif (indcombo:get() > 1) then
            local lp = entity.get_local()
            origin = lp:get_absorigin()
            origin.z = origin.z + 35
            
            local bodpos = render.world_to_screen(origin)
            bodpos.x = bodpos.x + 35

            

            render.line(bodpos.x, bodpos.y, bodpos.x + (100 * scale) - 7, bodpos.y - (100 * scale) - 2, color(35, 35, 35, 255), 1)
            render.rect_filled(bodpos.x + (100 * scale) - 5, bodpos.y - (100 * scale) - 2, scale * 90, scale * 125, color(16, 16, 16, 160), 4)
            render.rect(bodpos.x + (100 * scale) - 7, bodpos.y - (100 * scale) - 4, (scale * 90) + 4, (scale * 125) + 4, themecol:get(), 4)

            local vx = lp:get_velocity().x
            local vy = lp:get_velocity().y

            if (vx < 0) then
                vx = vx * -1
            end
            if (vy < 0) then
                vy = vy * -1
            end


            local dtstatus = 'off'
            local vel = (vx + vy)
            local fdstatus = 'off'
            local spstatus = 'off'
            local baimstatus = 'off'
            local mndmg = 'off'
            local apstatus = 'off'
            local fsstatus = 'off'

            local expcol = white
            local fdcol = white
            local spcol = white
            local baimcol = white
            local dmgcol = white
            local apcol = white
            local fscol = white


            if (globalvars.get_dt_recharging() and not ui.get_keybind_state(keybinds.double_tap)) then
                dtstatus = 'charge'
                expcol = red
            elseif (not globalvars.get_dt_recharging() and ui.get_keybind_state(keybinds.double_tap)) then
                dtstatus = 'DT'
                expcol = green
                if (ui.get_keybind_state(keybinds.fakeduck)) then
                    dtstatus = 'FD'
                    expcol = red
                end
            end
            if (ui.get_keybind_state(keybinds.hide_shots)) then
                dtstatus = 'HS'
                expcol = teal
            end
            

            if (ui.get_keybind_state(keybinds.fakeduck)) then
                fdstatus = 'on'
                fdcol = green
            
            end
            if (ui.get_keybind_state(keybinds.safe_points)) then
                spstatus = 'on'
                spcol = teal
            
            end
            if (ui.get_keybind_state(keybinds.body_aim)) then
                baimstatus = 'on'
                baimcol = green
            
            end
            if ui.get_keybind_state(keybinds.damage_override) then
                mndmg = 'on'
                dmgcol = green
            
            end
            if ui.get_keybind_state(keybinds.automatic_peek) then
                apstatus = 'on'
                apcol = green
            end

            if freestandbind:get() then
                fsstatus = 'on'
                fscol = teal
            end


            local middle = bodpos.x + (100 * scale) + ((scale * 90) / 2)
            local y = bodpos.y - (100 * scale)
            local str = 'exploit:'..dtstatus
            local size = render.get_text_size(indfont, str)
            local x = middle - (size.x / 2)
            render.text(indfont, middle - (size.x / 2), y, expcol, str, false, false)
            y = y + size.y
            local str = 'FS:'..fsstatus
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, fscol, str, false, false)
            y = y + size.y
            local str = 'FD:'..fdstatus
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, fdcol, str, false, false)
            y = y + size.y
            local str = 'SP:'..spstatus
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, spcol, str, false, false)
            y = y + size.y
            local str = 'DMG:'..mndmg
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, dmgcol, str, false, false)
            y = y + size.y
            local str = 'FBaim:'..baimstatus
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, baimcol, str, false, false)
            y = y + size.y
            local str = 'Peek:'..apstatus
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, apcol, str, false, false)
            y = y + size.y
            local str = 'speed:'..round(lp:get_animstate()['m_velocity'], 0)
            local size = render.get_text_size(indfont, str)
            render.text(indfont, middle - (size.x / 2), y, white, str, false, false)
            

        end
    end
    
end
local pos = vector_2d(engine.get_screen_size().x - 25, 15)
function watermark()
    local string = '|rawetrip|'..globalvars.get_time()
    
    
    

    if (engine.is_in_game()) then
        string = string..'|'..engine.get_level_name_short()..'|FPS: '..globalvars.get_framerate()..'|ping:'..globalvars.get_ping()
    end


    local txtsize = render.get_text_size(font, string)
    render.rect_filled(pos.x - txtsize.x, pos.y, txtsize.x + 10, 20, color(16, 16, 16, 255), 4)

    render.rect(pos.x - txtsize.x - 2, pos.y - 2, txtsize.x + 14, 24, themecol:get(), 4)

    render.text(font, pos.x + 5 - txtsize.x, pos.y, color(255, 255, 255, 255), string, false, true)


    if (globalvars.is_open_menu()) then
        
        pos.x = animate.lerp(pos.x, globalvars.get_menu().x + globalvars.get_menu().z - 12, 0.1)
        pos.y = animate.lerp(pos.y, globalvars.get_menu().y - 24, 0.1)
    else
        pos.x = animate.lerp(pos.x, engine.get_screen_size().x - 25, 0.01)
        pos.y = animate.lerp(pos.y, 15, 0.01)
    end
end

function hitlist()
    local ss = engine.get_screen_size()
    x = hitx:get()

    local limit = #shotresults - 10
    local bruh = (#shotresults + 1) * 17
    if limit >= 0 then
        bruh = 11 * 17
    end

    render.rect_filled(x - 10, hity:get(), 350, bruh, color(16, 16, 16, 160))
    render.line(x - 10, hity:get() + 14, x + 340, hity:get() + 14, themecol:get(), 2)
    render.text(indfont, x, hity:get(), white, 'Name', false, true)
    render.text(indfont, x + 130, hity:get(), white, 'Dmg', false, true)
    render.text(indfont, x + 200, hity:get(), white, 'Hitbox', false, true)
    render.text(indfont, x + 275, hity:get(), white, 'Backtrack', false, true)
    for i = 1, #shotresults do
        if i > limit then
            col = orange
            local y = 0
            if shotresults[i] == 'Hit' then
                col = green
            elseif shotresults[i] == 'Resolver' then
                col = red
            elseif shotresults[i] == 'Spread' then
                col = teal
            end

            if limit >= 0 then
                y = hity:get() + bruh - (17 * (i - limit))
            else
                y = hity:get() + bruh - (17 * i)
            end
            render.rect_filled(x - 5, y, 3, 14, col)
            render.text(indfont, x, y, white, (snames[i]):sub(1,20), false, true)
            render.text(indfont, x + 125, y, white, sdmgs[i], false, true)
            render.text(indfont, x + 185, y, white, shtbxs[i], false, true)
            render.text(indfont, x + 300, y, white, btks[i], false, true)
        end
        
    end
end


cheat.push_callback("on_override_view", function(view)
    local lp = entity.get_local()
    local origin = lp:get_absorigin()
    origin.z = origin.z + 50
    local dist = view.origin:dist_to(origin)
    scale = ((waterscale:get() - dist) / waterscale:get()) + 1
end)

cheat.push_callback("on_shot", function(shot_info)
    table.insert(snames, shot_info.target_name)
    table.insert(sdmgs, shot_info.server_damage..'('..shot_info.client_damage..')')
    table.insert(shtbxs, shot_info.server_hitbox..'('..shot_info.client_hitbox..')')
    table.insert(btks, shot_info.backtrack)
    table.insert(shotresults, shot_info.result)

end)
cheat.push_callback("on_unload", function()
    engine.set_clantag(" ")
end)

cheat.push_callback("on_paint", function()
    if (watermarkenable:get()) then
        watermark()
    end

    if (indcombo:get() > 0) then
        indicators()
    end
    if engine.is_in_game() then
        if (clantagenable:get()) then 
            clantag()
            clantagbool = true
        elseif clantagbool then
            engine.set_clantag(" ")
            clantagbool = false
        end


        if kdbarenable:get() then
            drawkdbar()
        end
        if enablehitlist:get() then
            hitlist()
        end

    end
    
end)


cheat.push_callback("on_event", function(event)
    
    if (event:get_name() == "player_death") then
        local atkid = event:get_int("attacker")
        local pid = event:get_int("userid")
        
        local attacker = engine.get_player_for_user_id(atkid)
        local victim = engine.get_player_for_user_id(pid)
        local lpidx = engine.get_local_player_index()
        if (attacker == lpidx) then
            localkills = localkills + 1
            
        end
        if (victim == lpidx) then
            localdeaths = localdeaths + 1
            
        end
    end

    --if (event:get_name() == "player_say") then
     --   local msg = event:get_string("text")
     --   local pid = event:get_int("userid")
     --   local player = engine.get_player_for_user_id(pid)
      --  local lp = entity.get_local()
     --   if not lp then return end
     --   console.execute_client_cmd('say '..msg)
     --   cheat.notify(msg)
     --   cheat.notify('gay')
      --  if player:get_team() ~= lp:get_team() then
     --       chat.print(player:get_name()..': '..msg)
     --   end
    --end


    if (event:get_name() == "game_newmap" or event:get_name() == "client_disconnect") then
        localdeaths = 0
        localkills = 0
    end
    
end)


cheat.push_callback("on_createmove", function(cmd)
    local target_yaw = ui.find_menu_int("0Antiaim.base_angle")
    
    if autors:get() then
        if GetRealKD() <= 0.5 then
            console.execute_client_cmd('rs')
        end
    end

    if freestandbind:get() then
        local fs = ui.find_menu_bool("Antiaim.freestand")
        if not fs:get() then
            fs:set(1)
        end


        if target_yaw:get() == 1 then
            target_yaw:set(0)
        end
    else
        if target_yaw:get() == 0 then
            target_yaw:set(1)
        end
    end
end)










