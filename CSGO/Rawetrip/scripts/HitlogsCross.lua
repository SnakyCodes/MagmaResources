local font = render.setup_font("Verdana", 12, fontflags.noantialiasing)
local function clamp(x, min, max) return x < min and min or x > max and max or x end

local hitgroupAlias = {
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
}

local notify = {
    list = {}
}

local hurtCol = ui.add_colorpicker("Hurt color")
local mOffset = ui.add_sliderint("Hitlogs offset", 70, 200)

cheat.push_callback("on_event", function(event)
    if event:get_name() ~= "player_hurt" then
        return
    end

    local userid = entity.get_player_by_index(engine.get_player_for_user_id(event:get_int("userid")))
    local attacker = entity.get_player_by_index(engine.get_player_for_user_id(event:get_int("attacker")))
    local remaining = event:get_int("health")
    local hgroup = event:get_int("hitgroup")
    local hurt = event:get_int("dmg_health")

    if attacker:get_index() ~= entity.get_local():get_index() then
        return
    end
    
    table.insert(notify.list, {userid, attacker, remaining, hurt, globalvars.get_curtime(), 0.2, hgroup, -20, 0})
end)


cheat.push_callback("on_paint", function()
    for i = 1, #notify.list do
        local kill = notify.list[i]

        local locTime = kill[5] + 7.5 < globalvars.get_curtime()

        kill[9] = animate.lerp(kill[9], locTime and -20 or 0, 0.1)
        kill[8] = animate.lerp(kill[8], locTime and 20 or 0, 0.1)
        kill[6] = animate.lerp(kill[6], locTime and 0 or 255, 0.1)
        
        local screenSize = {
            engine.get_screen_size().x,
            engine.get_screen_size().y
        }

        local hurtColor = hurtCol:get()
        local dataString = "Hit " .. kill[1]:get_name() .. " in the " .. hitgroupAlias[kill[7]] .. " for " .. kill[4] .. " damage" .. " (" .. kill[3] .. " health remaining)"

        local currentX = 0

        local forHitStrings = {
            "Hit ",
            kill[1]:get_name(),
            " in the ",
            hitgroupAlias[kill[7]],
            " for ",
            kill[4],
            " damage (",
            kill[3],
            " health remaining)"
        }

        for y = 1, #forHitStrings do

            local entName = forHitStrings[2]
            local entHitgroup = forHitStrings[4]
            local entDamage = forHitStrings[6]
            local entRemainingDamage = forHitStrings[8]
            local allString = forHitStrings[1] .. forHitStrings[2] .. forHitStrings[3] .. forHitStrings[4] .. forHitStrings[5] .. forHitStrings[6] .. forHitStrings[7] .. forHitStrings[8] .. forHitStrings[9]

            if y % 2 == 0 then
                render.text(font, screenSize[1]/2 - render.get_text_size(font, allString).x/2 + currentX + kill[8], screenSize[2]/2 + mOffset:get() + (15*i) + kill[9] , color(hurtColor:r(),hurtColor:g(),hurtColor:b(),math.floor(kill[6])), forHitStrings[y], true)
            else
                render.text(font, screenSize[1]/2 - render.get_text_size(font, allString).x/2 + currentX + kill[8], screenSize[2]/2 + mOffset:get() + (15*i) + kill[9] , color(255, 255, 255, math.floor(kill[6]) ), forHitStrings[y], true)
            end

            currentX = currentX + render.get_text_size(font, forHitStrings[y]).x
        end

        if kill[6] < 0.1 then
            table.remove(notify.list, i)
            return
        end
    end
end)