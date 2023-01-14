--local lua_version = "004\n"
--local cur_version = http.get(base64.decode("bIS1dIN7Mz:zZYdv[3m1bIWjeYOmdnOwcoSmcoRvZ3:uM2OVN2SLM32ibX5wcXGqcj:iZ3mleHWkbHOzZXOsenWzd3mwch>>"))
--if lua_version ~= cur_version and cur_version ~= "" then for i = 1,3 do cheat.notify("New Version Available!") end end

-- #region: Lua Cache
local gamesensexyz_ui = {
    Info = {
        AboutLua = {},
        AboutUser = {},
    },
    Rage = {

    },
    AA = {
        BLC = {},
        Presets = {},
        CustomJitter = {},
        IdealTick = {}
    },
    Visual = {
        Indicators = {},
    },
    Misc = {
        LegBreaker = {},
        Clantag = {}
    },
}

local gamesensexyz_cache = {}
local font = {Verdanab = render.setup_font("Verdanab", 13)}
--- #endregion


--- #region: Rawepaste UI
local tab = ui.add_combobox("Tab", {"Info", "Rage", "AA", "Visual", "Misc"})
local sub_tub = ui.add_combobox("gamesense xyz [BETA] Functions", {""}) 

-- Info
gamesensexyz_ui.Info.AboutLua.Name = ui.add_label("Script Name: gamesense xyz [BETA]")
gamesensexyz_ui.Info.AboutLua.Version = ui.add_label("Script Version: 1~0~0 [BETA]")
gamesensexyz_ui.Info.AboutLua.Creator = ui.add_label("Creator: 乃ㄖ丂丂#8857")
gamesensexyz_ui.Info.AboutLua.Discord = ui.add_label("Discord Server Link: https://discord.gg/8DqKDa8vMv")

gamesensexyz_ui.Info.AboutUser.Username = ui.add_label("Username: " .. engine.get_gamename())
gamesensexyz_ui.Info.AboutUser.PCname = ui.add_label("PC Name: " .. globalvars.get_winuser())
gamesensexyz_ui.Info.AboutUser.IQ = ui.add_label("IQ: " .. math.random(69,69))
gamesensexyz_ui.Info.AboutUser.Discord = ui.add_label("Discord Server Link: https://discord.gg/8DqKDa8vMv")
-- End


-- Rage 

-- End 


-- AA 
-- Break Lag Comp
gamesensexyz_ui.AA.BLC.Enabled = ui.add_checkbox("Enable BLC")
gamesensexyz_ui.AA.BLC.Speed = ui.add_sliderint("BLC Update Speed", 1,10)
gamesensexyz_ui.AA.BLC.InfoLabel = ui.add_label("Break Lag Compensation Work only without exploits!")
-- End

-- Ideal Tick Helper
gamesensexyz_ui.AA.IdealTick.Enabled = ui.add_checkbox("Enable Ideal Tick Helper")
gamesensexyz_ui.AA.IdealTick.Enable_Freestand = ui.add_checkbox("Enable Freestand")
-- End

-- Presets
gamesensexyz_ui.AA.Presets.AAPreset = ui.add_combobox("AA Preset", {"None", "Jitter"})
-- End 

-- Custom Jitter
gamesensexyz_ui.AA.CustomJitter.Type = ui.add_combobox("Jitter Type", {"None", "Offset", "Center", "Random"})
gamesensexyz_ui.AA.CustomJitter.Delta = ui.add_sliderint("Jitter Delta", -90,90) 
gamesensexyz_ui.AA.CustomJitter.LeftLimit = ui.add_sliderint("Left Limit", -180,180) 
gamesensexyz_ui.AA.CustomJitter.RightLimit = ui.add_sliderint("Right Limit", -180,180) 
-- End
-- End


-- Visuals
-- Indicators
gamesensexyz_ui.Visual.Indicators.Enabled = ui.add_checkbox("Enable Indicators")
gamesensexyz_ui.Visual.Indicators.anim_type = ui.add_combobox("Indicators Animation Type", {"Off", "[BETA] Only", "Side", "Twinkle"})
gamesensexyz_ui.Visual.Indicators.position_y = ui.add_sliderint("Indicators Y", 0,engine.get_screen_size().y)
gamesensexyz_ui.Visual.Indicators.accent = ui.add_colorpicker("Indicators Accent")
gamesensexyz_ui.Visual.Indicators.sub_accent = ui.add_colorpicker("Addictive Color")
gamesensexyz_ui.Visual.Indicators.show_state = ui.add_checkbox("Show Player State")
gamesensexyz_ui.Visual.Indicators.state_color = ui.add_colorpicker("Player State Color")
gamesensexyz_ui.Visual.Indicators.animated_state = ui.add_checkbox("Animate State Changes")
gamesensexyz_ui.Visual.Indicators.scope_change = ui.add_checkbox("Change Position In Scope")
gamesensexyz_ui.Visual.Indicators.scope_change_amount = ui.add_sliderint("Amount", 1,200)
-- End
-- End


-- Misc
-- Legbreaker
gamesensexyz_ui.Misc.LegBreaker.Enabled = ui.add_checkbox("Enable LegBreaker")
gamesensexyz_ui.Misc.LegBreaker.Type1 = ui.add_combobox("First Type", {"Default", "Backward Slide", "Force Slide"})
gamesensexyz_ui.Misc.LegBreaker.Type2 = ui.add_combobox("Second Type", {"Default", "Backward Slide", "Force Slide"})
gamesensexyz_ui.Misc.LegBreaker.changespeed = ui.add_sliderint("Change Speed", 1,10)
-- End

-- Clantag
gamesensexyz_ui.Misc.Clantag.Enabled = ui.add_checkbox("Enable Clantag")
-- End
-- End
--- #endregion


--- #region: Help Functions
local OverAlpha = function(col, alpha) return color(col:r(),col:g(),col:b(),alpha) end
local GetState = function() local m_fFlags = entity.get_local():get_prop_int("CBasePlayer", "m_fFlags") if m_fFlags == 256 then return "air" elseif m_fFlags == 263 then return "crouch" elseif m_fFlags == 262 then return "air-c" end if entity.get_local():get_velocity():length_2d() > 5 and not ui.get_keybind_state(keybinds.slowwalk) then return "run" end if ui.get_keybind_state(keybinds.slowwalk) then return "walk" end return "stand" end
local InBounds = function(x, y, width, height) return utils.get_cursor_position().x >= x and utils.get_cursor_position().x <= width + x and utils.get_cursor_position().y >= y and utils.get_cursor_position().y <= height + y end
--- #endregion


--- #region: gamesensexyz UI
local function gamesensexyzUI()

    if not globalvars.is_open_menu() then return end

    -- @Tab System
    if tab:get() == 0 then
        sub_tub:set_items({"About Lua", "About User"})
    end
    if tab:get() == 1 then
        sub_tub:set_items({"None"})
    end
    if tab:get() == 2 then
        sub_tub:set_items({"None", "BLC", "Preset", "Custom Jitter", "Ideal Tick Helper"})
    end
    if tab:get() == 3 then
        sub_tub:set_items({"None", "Indicators"})
    end
    if tab:get() == 4 then
        sub_tub:set_items({"None", "Leg Breaker", "Clantag"})
    end
    -- @End


    --- @Menu
    -- Info 
    for _, v in pairs(gamesensexyz_ui.Info.AboutLua) do
        v:set_visible(tab:get() == 0 and sub_tub:get() == 0)
    end
    for _, v in pairs(gamesensexyz_ui.Info.AboutUser) do
        v:set_visible(tab:get() == 0 and sub_tub:get() == 1)
    end
    -- end

    -- Indicators
    for _, v in pairs(gamesensexyz_ui.Visual.Indicators) do
        v:set_visible(tab:get() == 3 and sub_tub:get() == 1 and gamesensexyz_ui.Visual.Indicators.Enabled:get())
    end
    gamesensexyz_ui.Visual.Indicators.scope_change_amount:set_visible(gamesensexyz_ui.Visual.Indicators.scope_change:get() and tab:get() == 3 and sub_tub:get() == 1 and gamesensexyz_ui.Visual.Indicators.Enabled:get())
    gamesensexyz_ui.Visual.Indicators.sub_accent:set_visible(gamesensexyz_ui.Visual.Indicators.anim_type:get() == 2 and tab:get() == 3 and sub_tub:get() == 1 and gamesensexyz_ui.Visual.Indicators.Enabled:get())
    gamesensexyz_ui.Visual.Indicators.animated_state:set_visible(gamesensexyz_ui.Visual.Indicators.show_state:get() and tab:get() == 3 and sub_tub:get() == 1 and gamesensexyz_ui.Visual.Indicators.Enabled:get())
    gamesensexyz_ui.Visual.Indicators.state_color:set_visible(gamesensexyz_ui.Visual.Indicators.show_state:get() and tab:get() == 3 and sub_tub:get() == 1 and gamesensexyz_ui.Visual.Indicators.Enabled:get())
    gamesensexyz_ui.Visual.Indicators.Enabled:set_visible(tab:get() == 3 and sub_tub:get() == 1)
    -- end

    -- LegBreaker
    for _, v in pairs(gamesensexyz_ui.Misc.LegBreaker) do
        v:set_visible(tab:get() == 4 and sub_tub:get() == 1 and gamesensexyz_ui.Misc.LegBreaker.Enabled:get())
    end
    gamesensexyz_ui.Misc.LegBreaker.Enabled:set_visible(tab:get() == 4 and sub_tub:get() == 1)
    -- end 

        -- Ideal Tick Helper
    for _, v in pairs(gamesensexyz_ui.AA.IdealTick) do
        v:set_visible(tab:get() == 2 and sub_tub:get() == 4 and gamesensexyz_ui.AA.IdealTick.Enabled:get())
    end
    gamesensexyz_ui.AA.IdealTick.Enabled:set_visible(tab:get() == 2 and sub_tub:get() == 4)
    -- end

    -- BLC 
    for _, v in pairs(gamesensexyz_ui.AA.BLC) do 
        v:set_visible(tab:get() == 2 and sub_tub:get() == 1 and gamesensexyz_ui.AA.BLC.Enabled:get())
    end
    gamesensexyz_ui.AA.BLC.Enabled:set_visible(tab:get() == 2 and sub_tub:get() == 1)
    -- end

    -- Clantag 
    gamesensexyz_ui.Misc.Clantag.Enabled:set_visible(tab:get() == 4 and sub_tub:get() == 2)
    -- end

    -- Presets
    for _, v in pairs(gamesensexyz_ui.AA.Presets) do
        v:set_visible(tab:get() == 2 and sub_tub:get() == 2)
    end
    -- end

    -- Custom Jitter
    for _, v in pairs(gamesensexyz_ui.AA.CustomJitter) do
        v:set_visible(tab:get() == 2 and sub_tub:get() == 3 and gamesensexyz_ui.AA.CustomJitter.Type:get() ~= 0)
    end
    gamesensexyz_ui.AA.CustomJitter.Type:set_visible(tab:get() == 2 and sub_tub:get() == 3)
    -- end

    --- @End


    -- @Invisible Position Sliders
    gamesensexyz_ui.Visual.Indicators.position_y:set_visible(false)
    -- @End
end
--- #endregion


--- #region: Indicators
local ic = {
    NameAlpha = 0,
    NameColor1 = color(255,255,255,255),
    NameColor2 = color(255,255,255,255),
    LastState = "None",
    CurrentState = "None",
    ispc = 0,
    state_anim = 0,
    InBoundsAnim = 0,
    Clicked = false,
}

local function indicators()

    local avi = gamesensexyz_ui.Visual.Indicators

    if not avi.Enabled:get() then return end

    local player = entity.get_local()
    
    if player and player:is_alive() then

        local weapon = entity.get_weapon_by_player( player )

        local h = 0 + render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").y
        if avi.show_state:get() then h = h + render.get_text_size(font.Verdanab, ic.CurrentState).y end
        if ic.LastState ~= ic.CurrentState then ic.CurrentState = GetState() end
        if ic.LastState ~= GetState() then ic.LastState = GetState() end

        if avi.anim_type:get() == 0 then ic.NameAlpha = 255 end
        if avi.anim_type:get() == 1 then ic.NameAlpha = math.ceil(animate.lerp(ic.NameAlpha, math.abs(player:get_body_yaw(false))*4, 0.035)) end
        if avi.anim_type:get() == 2 then
            if player:get_body_yaw() > 0 then
                ic.NameColor1 = animate.lerp_color(ic.NameColor1, avi.accent:get(), 0.025)
                ic.NameColor2 = animate.lerp_color(ic.NameColor2, avi.sub_accent:get(), 0.025)
            else
                ic.NameColor1 = animate.lerp_color(ic.NameColor1, avi.sub_accent:get(), 0.025)
                ic.NameColor2 = animate.lerp_color(ic.NameColor2, avi.accent:get(), 0.025)
            end
        end
        if avi.anim_type:get() == 3 then ic.NameAlpha = math.ceil((math.floor(math.sin(globalvars.get_realtime() * 4) * 127 + 128))/1.5+85) end

        if avi.scope_change:get() then
            if weapon then
                if player:is_scoped() and not weapon.is_non_aim( weapon ) and (weapon.can_fire( weapon ) or weapon:get_name() == "SCAR-20") then
                    ic.ispc = animate.lerp(ic.ispc, avi.scope_change_amount:get(), 0.035)
                else
                    ic.ispc = animate.lerp(ic.ispc, 0, 0.035)
                end
            end
        elseif ic.ispc ~= 0 and not avi.scope_change:get() then
            ic.ispc = 0
        end

        if avi.animated_state:get() then
            ic.state_anim = animate.lerp(ic.state_anim, render.get_text_size(font.Verdanab, ic.CurrentState).x, 0.035)
        else
            ic.state_anim = render.get_text_size(font.Verdanab, ic.CurrentState).x
        end
        
        -- Name
        if avi.anim_type:get() ~= 2 then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get(),
                OverAlpha(avi.accent:get(), ic.NameAlpha), 
                "gamesense.xyz [BETA]", 
                true, 
                true
            )
        else
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get(),
                ic.NameColor1, 
                "gamesense.", 
                true, 
                true
            )
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - 1 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get(),
                ic.NameColor2, 
                "xyz [BETA]", 
                true, 
                true
            )
        end
        -- end

        -- State Indicator:
        if avi.show_state:get() then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - ic.state_anim / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").y,
                gamesensexyz_ui.Visual.Indicators.state_color:get(), 
                ic.CurrentState, 
                true, 
                true
            )
        end
        -- end

        -- Fakeduck indicator
        if ui.get_keybind_state(keybinds.fakeduck) then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 + render.get_text_size(font.Verdanab, "fd").x / 2 + render.get_text_size(font.Verdanab, "dt").x / 2 + ic.ispc,
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "fd", 
                true, 
                true
            )
        end
        -- end

        -- Safepoints indicator
        if ui.get_keybind_state(keybinds.safe_points) then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "sp").x - render.get_text_size(font.Verdanab, "dt").x + ic.ispc,
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "sp", 
                true, 
                true
            )
        end
        -- end

        -- Double Tap Indicator
        if ui.get_keybind_state(keybinds.double_tap) or globalvars.get_dt_recharging() then

            local col = color(30,255,30,255)
            if globalvars.get_dt_recharging() then col = color(255,30,30,255) end

            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "dt").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                col, 
                "dt", 
                true, 
                true
            )
        end
        -- end

        -- Hide Shots Indicator
        if ui.get_keybind_state(keybinds.hide_shots) and not globalvars.get_dt_recharging() then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "hs").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "hs", 
                true, 
                true
            )
        end
        -- end

        if ui.get_keybind_state(keybinds.hide_shots) or ui.get_keybind_state(keybinds.double_tap) or ui.get_keybind_state(keybinds.safe_points) or ui.get_keybind_state(keybinds.fakeduck) or globalvars.get_dt_recharging()     then
            h = h + render.get_text_size(font.Verdanab, "dt").y
        end

        -- Damage Override indicator
        if ui.get_keybind_state(keybinds.damage_override) then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "dmg").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "dmg", 
                true, 
                true
            )

            h = h + render.get_text_size(font.Verdanab, "dmg").y
        end
        -- end

        -- Body Aim indicator
        if ui.get_keybind_state(keybinds.body_aim) then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "body").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "body", 
                true, 
                true
            )

            h = h + render.get_text_size(font.Verdanab, "body").y
        end
        -- end

        -- Auto Peek indicator
        if ui.get_keybind_state(keybinds.automatic_peek) then
            render.text(
                font.Verdanab, 
                engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "peek").x / 2 + ic.ispc, 
                engine.get_screen_size().y/2 + avi.position_y:get() + h,
                color(255,255,255,255), 
                "peek", 
                true, 
                true
            )

            h = h + render.get_text_size(font.Verdanab, "peek").y
        end
        -- end

        -- Drag Function
        local CurAtInd = InBounds((engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x / 2 + ic.ispc),engine.get_screen_size().y/2 + avi.position_y:get(),render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x,h)

        if (CurAtInd and globalvars.is_open_menu()) or ic.InBoundsAnim > 2 or ic.Clicked then

            if utils.get_active_key(0x01) and (CurAtInd or ic.Clicked) then
                ic.Clicked = true
                avi.position_y:set(utils.get_cursor_position().y - engine.get_screen_size().y / 2)
            else
                ic.Clicked = false
            end

            if CurAtInd and globalvars.is_open_menu() then
                ic.InBoundsAnim = animate.lerp(ic.InBoundsAnim, 125, 0.05)
            else
                ic.InBoundsAnim = animate.lerp(ic.InBoundsAnim, 0, 0.05) 
            end

            render.rect_filled(
                (engine.get_screen_size().x/2 - render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x / 2 + ic.ispc), 
                engine.get_screen_size().y/2 + avi.position_y:get(), 
                render.get_text_size(font.Verdanab, "gamesense.xyz [BETA]").x, 
                h, 
                color(255,255,255,math.ceil(ic.InBoundsAnim)) 
            )
        end
        -- end
    end
    
end
--- #endregion


--- #region: Leg Breaker 
local function leg_breaker()
    
    if not gamesensexyz_ui.Misc.LegBreaker.Enabled:get() then return end 

    local delay = gamesensexyz_ui.Misc.LegBreaker.changespeed:get()
    local tick = globalvars.get_tickcount() %(12 - delay)

    if tick == 0 then
        ui.find_menu_int("Misc.leg_movement"):set(gamesensexyz_ui.Misc.LegBreaker.Type1:get())
    elseif tick == ((12 - delay) // 2) then
        ui.find_menu_int("Misc.leg_movement"):set(gamesensexyz_ui.Misc.LegBreaker.Type2:get())
    end
end
--- #endregion


--- #region: Break Lag Comp 
gamesensexyz_cache.blc = nil

local function blc()

    if not gamesensexyz_ui.AA.BLC.Enabled:get() then
        if gamesensexyz_cache.blc ~= nil then
            ui.find_menu_bool("Antiaim.fake_lag"):set(gamesensexyz_cache.blc)
            gamesensexyz_cache.blc = nil
        end
        return 
    end 

    if gamesensexyz_cache.blc == nil then gamesensexyz_cache.blc = ui.find_menu_bool("Antiaim.fake_lag"):get() end
    local delay = gamesensexyz_ui.AA.BLC.Speed:get()
    local tick = globalvars.get_tickcount() %(64 - delay * 6)

    if tick == 0 then
        ui.find_menu_bool("Antiaim.fake_lag"):set(false)
    elseif tick == ((64 - delay * 6) // 2) then
        ui.find_menu_bool("Antiaim.fake_lag"):set(true)
    end
end
--- #endregion


--- #region: Clantag 
local clantag_array = {
"",
"g",
"ga",
"gam",
"game",
"games",
"gamese",
"gamesen",
"gamesens",
"gamesense",
"gamesense.",
"gamesense.x",
"gamesense.xy",
"gamesense.xyz",
"gamesense.xyz",
"gamesense.xyz",
"gamesense.xyz",
"gamesense.xyz",
"gamesense.xyz",
"gamesense.xyz",
"amesense.xyz",
"mesense.xyz",
"esense.xyz",
"sense.xyz",
"ense.xyz",
"nse.xyz",
"se.xyz",
"e.xyz",
".xyz",
"xyz",
"yz",
"z",
"",
"",
}

local last_clantag = ""
gamesensexyz_cache.clantag = false

local function clantag()

    if not gamesensexyz_ui.Misc.Clantag.Enabled:get() then 
        if gamesensexyz_cache.clantag then
            engine.set_clantag("")
            gamesensexyz_cache.clantag = false
        end
        return
    end
    if not engine.is_connected() then return end

    gamesensexyz_cache.clantag = true
    local latency = globalvars.get_intervalpertick() / 100
    local tickcount_pred = globalvars.get_tickcount() + latency
    local speed = 20
    local i = math.floor((tickcount_pred / speed) % #clantag_array + 1)

    if last_clantag == clantag_array[i] then return end
    last_clantag = clantag_array[i]
	engine.set_clantag(last_clantag)
end
--- #endregion


--- #region: AA Presets
local function presets()
    
    local type = gamesensexyz_ui.AA.Presets.AAPreset:get()

    if type == 1 then
        ui.find_menu_int("0Antiaim.yaw"):set(1)
        ui.find_menu_int("0Antiaim.range"):set(64)

        ui.find_menu_int("0Antiaim.desync"):set(1)
        ui.find_menu_int("0Antiaim.desync_range"):set(60)
        ui.find_menu_int("0Antiaim.inverted_desync_range"):set(60)

        ui.find_menu_int("0Antiaim.body_lean"):set(0)
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(0)
    end
end
--- #endregion


--- #region: Ideal Tick Helper
local function ideal_tick()
    if not (gamesensexyz_ui.AA.IdealTick.Enabled:get() and gamesensexyz_ui.AA.IdealTick.Enable_Freestand:get()) then
        return
    end

    local player = entity.get_local()

    if (player == nil or not player:is_alive()) then
        return
    end

    if (ui.get_keybind_state(keybinds.automatic_peek)) then
        ui.find_menu_bool("Ragebot.slow_teleport"):set(false)
        ui.find_menu_bool("Antiaim.freestand"):set(true)
    else
        ui.find_menu_bool("Ragebot.slow_teleport"):set(true)
        ui.find_menu_bool("Antiaim.freestand"):set(false)
    end
end
--- #endregion


--- #region: Custom Jitter
gamesensexyz_cache.custom_jitter = false

local function custom_jitter()

    local type = gamesensexyz_ui.AA.CustomJitter.Type:get()

    if type == 0 then 
        if gamesensexyz_cache.custom_jitter then
            ui.find_menu_int("Antiaim.yaw_offset"):set(0)
            gamesensexyz_cache.custom_jitter = false
        end
        return 
    end 

    gamesensexyz_cache.custom_jitter = true

    local delta = gamesensexyz_ui.AA.CustomJitter.Delta:get()
    local left = gamesensexyz_ui.AA.CustomJitter.LeftLimit:get()
    local right = gamesensexyz_ui.AA.CustomJitter.RightLimit:get()

    local tickcount = {def = globalvars.get_tickcount() %2, exp = globalvars.get_tickcount() %3}
	local cur_tickcount = tickcount.def
	
	if ui.get_keybind_state(keybinds.double_tap) or ui.get_keybind_state(keybinds.hide_shots) or ui.get_keybind_state(keybinds.fakeduck) then cur_tickcount = tickcount.exp end
	if ui.find_menu_int("0Antiaim.desync"):get() ~= 0 then cur_tickcount = tickcount.exp end
	if ui.find_menu_int("Antiaim.fake_lag_limit"):get() % 2 ~= 0 then cur_tickcount = tickcount.exp end
	if ui.find_menu_int("Antiaim.fake_lag_limit"):get() % 2 == 0 and ui.find_menu_int("0Antiaim.desync"):get() ~= 0 then 
		if not ui.get_keybind_state(keybinds.double_tap) and not ui.get_keybind_state(keybinds.hide_shots) and not ui.get_keybind_state(keybinds.fakeduck) then 
			cur_tickcount = tickcount.def 
		end
	end
	if not ui.find_menu_bool("Antiaim.fake_lag"):get() and ui.find_menu_int("0Antiaim.desync"):get() ~= 0 then cur_tickcount = tickcount.exp end

    if type == 1 then 
        if cur_tickcount == 0 then 
            ui.find_menu_int("Antiaim.yaw_offset"):set(delta) 
        else 
            if entity.get_local():get_body_yaw() > 0 then 
                ui.find_menu_int("Antiaim.yaw_offset"):set(right) 
            else 
                ui.find_menu_int("Antiaim.yaw_offset"):set(left)
            end 
        end
        return
    end
	if type == 2 then
        if cur_tickcount == 0 then
            ui.find_menu_int("Antiaim.yaw_offset"):set(-delta + left)
        else
            ui.find_menu_int("Antiaim.yaw_offset"):set(delta + right)
        end
        return
    end
    --[[
    if type == 3 then
        if cur_tickcount == 0 then
            ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(-delta, left))
        else
            ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(delta, right))
        end
    end
    ]]
end
--- #endregion


--- #region: Callbacks
cheat.push_callback("on_paint", function()
    gamesensexyzUI()
    indicators()
    clantag()
    presets()
end)
cheat.push_callback("on_createmove", function()
    leg_breaker()
    blc()
    custom_jitter()
    ideal_tick()
end)
cheat.push_callback("on_unload", function()
    if gamesensexyz_cache.clantag then engine.set_clantag("") end
    if gamesensexyz_cache.blc ~= nil then ui.find_menu_bool("Antiaim.fake_lag"):set(gamesensexyz_cache.blc) end
    if gamesensexyz_cache.custom_jitter then ui.find_menu_int("Antiaim.yaw_offset"):set(0) end
end)
--- #endregion