local x_pos = ui.add_sliderint("X", 0, engine.get_screen_size().x)
local y_pos = ui.add_sliderint("Y", 0, engine.get_screen_size().y)
local binds_color = ui.add_colorpicker("Binds color")

local font = render.setup_font("Verdana", 12, fontflags.noantialiasing )

local allBinds = {
    { name = "Double Tap", active = keybinds.double_tap, alpha = 0, y = 0 },
    { name = "Hide Shots", active = keybinds.hide_shots, alpha = 0, y = 0 },
    { name = "Anti-aim inverter", active = keybinds.flip_desync, alpha = 0, y = 0 },
    { name = "Slow walk", active = keybinds.slowwalk, alpha = 0, y = 0 },
    { name = "Thirdperson", active = keybinds.thirdperson, alpha = 0, y = 0 },
    { name = "Minimum damage", active = keybinds.damage_override, alpha = 0, y = 0 },
    { name = "Automatic peek", active = keybinds.automatic_peek, alpha = 0, y = 0 },
    { name = "Force body aim", active = keybinds.body_aim, alpha = 0, y = 0 },
    { name = "Force safe points", active = keybinds.safe_points, alpha = 0, y = 0 },
    { name = "Fake duck", active = keybinds.fakeduck, alpha = 0, y = 0 },
}

local function modeToString(mode)
    return mode and "[toggled]" or "[holding]"
end

cheat.push_callback("on_paint", function()
    -- Variables
    local bindPosition = { x_pos:get(), y_pos:get() }
    local bindSize = { 165, 21 }
    local bindOffset = 0
    local col = binds_color:get()

    render.rect_filled(bindPosition[1], bindPosition[2], bindSize[1], bindSize[2], color(0,0,0,170))
    render.rect_filled(bindPosition[1], bindPosition[2], bindSize[1], 1, color(col:r(),col:g(),col:b(), 255))

    render.text(font, bindPosition[1] + bindSize[1]/2 - render.get_text_size(font, "keybinds").x/2, bindPosition[2] + 4, color(255,255,255, 255), "keybinds")

    for i = 1, #allBinds do

        local bindMode = ui.get_keybind_mode(allBinds[i].active)

        render.text(font, bindPosition[1] + 4, bindPosition[2] + 25 + allBinds[i].y - 15, color(255,255,255, math.floor(allBinds[i].alpha)), allBinds[i].name, true)
        render.text(font, bindPosition[1] + bindSize[1] - render.get_text_size(font, modeToString(bindMode)).x - 4, bindPosition[2] + 25 + allBinds[i].y - 15, color(255,255,255, math.floor(allBinds[i].alpha)), modeToString(bindMode), true)   

        if ui.get_keybind_state(allBinds[i].active) then
            allBinds[i].alpha = animate.lerp(allBinds[i].alpha, 255, 0.1)
            bindOffset = bindOffset + 15
            allBinds[i].y = animate.lerp(allBinds[i].y, bindOffset, 0.1)
        else
            allBinds[i].alpha = animate.lerp(allBinds[i].alpha, 0, 0.1)
        end
    end
end)

cheat.push_callback("on_createmove", function(cmd)

end)