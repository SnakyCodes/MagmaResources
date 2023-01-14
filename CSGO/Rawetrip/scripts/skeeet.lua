local print = cheat.notify 
local acafont2 = render.setup_font("Small Fonts", 11, 450, false, false, true )
local font = render.setup_font("Smallest Pixel-7", 10, 500, true, false, false) 
local menu = ui local randomz local pitchch = ui.get_int("0Antiaim.pitch") 
local int = 0 local A=0 local font1 = render.setup_font("Verdana", 13, 500, true, true, false) 
local calibri = render.setup_font("Calibri", 29, 700, true, false, false) 
local font3 = render.setup_font("Verdana", 13, 500, true, true, false) 
local keybindss = render.setup_font("Verdana", 12, 500, true, true, false) 
local choke_d = {0, 0, 0, 0, 0, 0}
local ind_offset = 0


ui.add_sliderint("DaYe Skeet Ind lua", 0, 0)
ui.add_checkbox("Skeet Ind")



local add_to_indicators = function(text, color)
    local size = render.get_text_width(calibri, text)
    local sx, sy = engine.get_screen_width(), engine.get_screen_height()

    render.gradient(11, sy - 340 - 37 * ind_offset - 6, math.floor(size / 2), 33, color.new(0, 0, 0, 5), color.new(0, 0, 0, 180))
    render.gradient(11 + math.floor(size / 2), sy - 340 - 37 * ind_offset - 6, math.floor(size / 2), 33, color.new(0, 0, 0, 180), color.new(0, 0, 0, 5))

    render.text(calibri, 16 + 1, sy - 344 - 37 * ind_offset + 1, color.new(0, 0, 0, 200), text)
    render.text(calibri, 16, sy - 344 - 37 * ind_offset, color, text)

    ind_offset = ind_offset + 1
    return (sy - 340 - 37 * (ind_offset - 1))
end

function gamesense()
    local me = entitylist.get_local_player()
    if me == nil then return end
    if not player.is_alive(me) then return end

    local dmg = ui.get_int("0Ragebot.minimum_override_damage")

    ind_offset = 0

    if ui.get_keybind_state(keybinds.damage_override) and ui.get_bool("Skeet Ind") then
        add_to_indicators(": "..dmg, color.new(255, 255, 255, 255))
    end

    if ui.get_keybind_state(keybinds.double_tap) and ui.get_bool("Skeet Ind") then
        add_to_indicators("DT", not globalvars.get_dt_recharging() and color.new(210, 210, 210, 255) or color.new(255, 0, 0, 255))
    end

    if ui.get_keybind_state(keybinds.safe_points) and ui.get_bool("Skeet Ind") then
        add_to_indicators("SAFE", color.new(132, 195, 16, 255))
    end

    if ui.get_keybind_state(keybinds.body_aim) and uix:get("Skeet Ind") then
        add_to_indicators("BAIM", color.new(192, 192, 192, 255))
    end

    if ui.get_bool("Skeet Ind") then
        add_to_indicators("DA", color.new(132, 195, 16, 255))
    end

    if ui.get_keybind_state(keybinds.hide_shots) and ui.get_bool("Skeet Ind") then
        add_to_indicators("ONSHOT", color.new(132, 195, 16, 255))
    end

    if ui.get_bool("Skeet Ind") then
        add_to_indicators(string.format("%i-%i-%i-%i-%i", choke_d[6], choke_d[5], choke_d[4], choke_d[3], choke_d[2]), color.new(255, 255, 255, 255))
    end

    if ui.get_bool("Antiaim.freestand") and ui.get_bool("Skeet Ind") then
        add_to_indicators("FS", color.new(132, 195, 16, 255))
    end

    if ui.get_keybind_state(keybinds.fakeduck) and ui.get_bool("Skeet Ind") then
        add_to_indicators("DUCK", color.new(255, 255, 255, 255))
    end

    if ui.get_bool("Skeet Ind") then
        local fl_y = add_to_indicators("FL", color.new(120, 121, 241, 255))
        render.arc(53, fl_y + 12, 6, 10, -90, 360, color.new(33, 33, 33, 255))
        render.arc(53, fl_y + 12, 6, 10, -90, choke_d[1] / 17 * 360, color.new(120, 121, 241, 255))
    end

    if ui.get_bool("Skeet Ind") then
        local body_yaw = math.max(-60, math.min(60, antiaim.get_body_yaw(true)))
        local perc = math.abs(body_yaw) / 60
        local r, g, b = 192 - (perc * 71), 32 + (perc * 146), 28
        add_to_indicators("FAKE", color.new(r, g, b, 255))
    end
end

function update_choke()
    if cmd.get_choked_commands() < choke_d[1] then
        choke_d[2] = choke_d[3]
        choke_d[3] = choke_d[4]
        choke_d[4] = choke_d[5]
        choke_d[5] = choke_d[6]
        choke_d[6] = choke_d[1]
    end

    choke_d[1] = cmd.get_choked_commands()
end


cheat.RegisterCallback("on_paint", function() 
gamesense() update_choke() end) 