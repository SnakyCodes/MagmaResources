--[[

    -- * Script Name: Divine
    -- * Script Version: 14
    -- * Script Author: guccish#2018
    -- * Fixed by: Klient#1690

]]

--- @region: enumerations
local e_conditions = {
    SHARED = 1,
    STANDING = 2,
    RUNNING = 3,
    WALKING = 4,
    AIR = 5,
    CROUCH = 6
}

local e_player_flags = {
    ON_GROUND = bit.lshift(1, 0),
    DUCKING = bit.lshift(1, 1),
    ANIMDUCKING = bit.lshift(1, 2),
    WATERJUMP = bit.lshift(1, 3),
    ON_TRAIN = bit.lshift(1, 4),
    IN_RAIN = bit.lshift(1, 5),
    FROZEN = bit.lshift(1, 6),
    ATCONTROLS = bit.lshift(1, 7),
    CLIENT = bit.lshift(1, 8),
    FAKECLIENT = bit.lshift(1, 9),
    IN_WATER = bit.lshift(1, 10)
}

local e_poses = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 15,
    AIM_BLEND_COURCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}
--- @endregion

--- @region: color
local color_c = {}

--- @param: r: number
--- @param: g: number
--- @param: b: number
--- @param: a: number
--- @return: color
function color_c.new(r, g, b, a)
    return color(math.floor(r or 255), math.floor(g or 255), math.floor(b or 255), math.floor(a or 255))
end

--- @param: color_u: color
--- @return: <number, number, number, number>
function color_c.unpack(color_u)
    return color_u:r(), color_u:g(), color_u:b(), color_u:a()
end
--- @endregion

--- @region: entity helpers
local entity_c = {}

--- @return: number
function entity_c.get_condition()
    local player = entity.get_local()

    if (player == nil or not player:is_alive()) then
        return e_conditions.SHARED
    end

    local velocity = player:get_velocity():length_2d()

    local flags = player:get_prop_int("CBasePlayer", "m_fFlags")

    if (bit.band(flags, e_player_flags.ON_GROUND) ~= 1) then
        return e_conditions.AIR
    end

    if (bit.band(flags, e_player_flags.DUCKING) ~= 0) then
        return e_conditions.CROUCH
    end

    if (velocity > 5) then
        if (ui.get_keybind_state(keybinds.slowwalk)) then
            return e_conditions.WALKING
        end

        return e_conditions.RUNNING
    end

    return e_conditions.STANDING
end
--- @endregion

--- @region: setup
(function()
    console.execute_client_cmd("clear")
    console.execute_client_cmd("showconsole")

    console.print_color("Divine.lua Discord Server: https://discord.gg/UdzKjv4Re7\n", color_c.new(122, 195, 250))
	console.print_color("Fixed By: Klient#1690\n\n", color_c.new(122, 195, 250))

	cheat.notify("Divine.lua Loaded, Have Fun!")
end)()
--- @endregion

--- @region: ui
local label_info = ui.add_label("https://discord.gg/2PThRWBwuF For Getting Lua Earlier!")
local label_ragebot = ui.add_label("Ragebot Settings")

local adaptive_ragebot = ui.add_checkbox("Adaptive Ragebot")
local ideal_tick = ui.add_checkbox("Ideal Tick")
local desync_on_shot = ui.add_checkbox("Desync On Shot")

local label_anti_aim = ui.add_label("Anti-Aim Settings")

local desync_presets = ui.add_combobox("Desync Presets", {"None", "Adaptive", "Low Range", "High Range", "Jitter"})
local aa_presets = ui.add_combobox("AA Presets", {"None", "False LagSync", "Anti OT", "Lag Breaker"})
local yaw_presets = ui.add_combobox("Yaw Presets", {"None", "Adaptive", "Low Range", "High Range", "High Random"})
local aa_jitter_range = ui.add_combobox("AA Jitter Range", {"None", "Low Range", "Mid Range", "High Range"})
local body_lean_presets = ui.add_combobox("Body Lean Presets", {"None", "Adaptive", "Low Range", "High Range", "Jitter"})
local fake_lag_randomizer = ui.add_combobox("Fake Lag Randomizer", {"None", "Random 5-16", "Random 10-16", "Switch 8-16", "Switch 10-16"})

local anti_brute = ui.add_checkbox("AntiBrute Force")
local anti_brute_type = ui.add_combobox("AntiBrute Force Type", {"On Shot"})

local fake_flick = ui.add_checkbox("Fake Flick")
local low_desync_range_on_dt = ui.add_checkbox("Low Desync Range On DT")
local pitch_zero = ui.add_checkbox("Pitch Zero")
local invert_in_air = ui.add_checkbox("Invert In Air")
local invert_on_move = ui.add_checkbox("Invert On Move")
local at_targets_in_air = ui.add_checkbox("At Targets In Air")
local slow_walk_speed_mod = ui.add_checkbox("Slowwalk Speed Modifier")
local slow_walk_speed = ui.add_sliderint("Slowwalk Speed", 0, 155)
local leg_breaker = ui.add_checkbox("Leg Breaker")
--- @endregion

--- @region: ragebot
local ragebot_c = {}

ragebot_c.switch = false

--- @item: Adaptive Ragebot
function ragebot_c.adaptive_ragebot()
	if (not adaptive_ragebot:get()) then
		return
	end

	local function set_int(var, value)
		local find = ui.find_menu_int(var)

		find:set(value)
	end

    set_int("0Ragebot.hitchance_amount", math.random(50, 62))
    set_int("0Ragebot.minimum_visible_damage", math.random(45, 55))
    set_int("0Ragebot.minimum_override_damage", math.random(5, 15))
    set_int("0Ragebot.max_misses_amount", math.random(0, 3))
    set_int("1Ragebot.hitchance_amount", math.random(35, 44))
    set_int("1Ragebot.minimum_visible_damage", math.random(10, 30))
    set_int("1Ragebot.minimum_override_damage", math.random(1, 5))
    set_int("1Ragebot.max_misses_amount", math.random(0, 3))
    set_int("2Ragebot.hitchance_amount", math.random(30, 42))
    set_int("2Ragebot.minimum_visible_damage", math.random(15, 35))
    set_int("2Ragebot.minimum_override_damage", math.random(1, 5))
    set_int("2Ragebot.max_misses_amount", math.random(0, 3))
    set_int("3Ragebot.hitchance_amount", math.random(30, 42))
    set_int("3Ragebot.minimum_visible_damage", math.random(15, 35))
    set_int("3Ragebot.minimum_override_damage", math.random(1, 5))
    set_int("3Ragebot.max_misses_amount", math.random(0, 3))
    set_int("4Ragebot.hitchance_amount", math.random(50, 55))
    set_int("4Ragebot.minimum_visible_damage", math.random(35, 55))
    set_int("4Ragebot.minimum_override_damage", math.random(1, 5))
    set_int("4Ragebot.max_misses_amount", math.random(0, 2))

    if (ui.get_keybind_state(keybinds.damage_override)) then
        set_int("4Ragebot.hitchance_amount", math.random(20, 35))
    end

    set_int("5Ragebot.hitchance_amount", math.random(70, 83))
    set_int("5Ragebot.minimum_visible_damage", math.random(70, 82))
    set_int("5Ragebot.max_misses_amount", math.random(0, 3))

    if (ui.get_keybind_state(keybinds.damage_override)) then
        set_int("5Ragebot.hitchance_amount", math.random(10, 30))
        set_int("5Ragebot.minimum_override_damage", math.random(1, 15))
    end

    set_int("6Ragebot.hitchance_amount", math.random(75, 85))
    set_int("6Ragebot.minimum_visible_damage", math.random(100, 103))
    set_int("6Ragebot.minimum_override_damage", math.random(10, 15))
    set_int("6Ragebot.max_misses_amount", math.random(0, 1))

    if (ui.get_keybind_state(keybinds.damage_override)) then
        set_int("6Ragebot.hitchance_amount", math.random(20, 30))
    end

    set_int("7Ragebot.hitchance_amount", math.random(10, 15))
    set_int("7Ragebot.minimum_visible_damage", math.random(10, 35))
    set_int("7Ragebot.minimum_override_damage", math.random(10, 15))
    set_int("7Ragebot.max_misses_amount", math.random(0, 3))
end

--- @item: Ideal Tick
function ragebot_c.ideal_tick()
	if (not ideal_tick:get()) then
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

--- @item: Desync On Shot
function ragebot_c.desync_on_shot(event)
	if (not desync_on_shot:get()) then
		return
	end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	if (ragebot_c.switch) then
        ui.find_menu_int("0Antiaim.body_lean"):set(100)
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(100)
        ui.find_menu_int("0Antiaim.desync_range"):set(60)
        ui.find_menu_int("0Antiaim.inverted_desync_range"):set(60)
        ui.find_menu_int("Antiaim.yaw_offset"):set(20)
	end

	ragebot_c.switch = not ragebot_c.switch
end
--- @endregion

--- @region: anti-aims
local anti_aim_c = {}

anti_aim_c.ground_ticks = 1
anti_aim_c.end_time = 0

--- @item: Desync Presets
function anti_aim_c.desync_presets()
	if (desync_presets:get() == 0) then
		return
	end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	if (desync_presets:get() == 1) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(5, 10))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(5, 10))
        else
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(5, 10))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(5, 10))
        end
    elseif (desync_presets:get() == 2) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(7, 17))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(7, 17))
        else
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(7, 17))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(7, 17))
        end
    elseif (desync_presets:get() == 3) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(21, 27))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(21, 27))
        else
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(21, 27))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(21, 27))
        end
    elseif (desync_presets:get() == 4) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(23, 48))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(23, 48))
        else
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(23, 48))
            ui.find_menu_int("0Antiaim.inverted_desync_range"):set(math.random(23, 48))
        end
	end

	ragebot_c.switch = not ragebot_c.switch
end

--- @item: AA Presets
function anti_aim_c.presets()
	if (aa_presets:get() == 0) then
		return
	end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (aa_presets:get() == 1) then
        for i = 0, 3 do
            ui.find_menu_int(("%sAntiaim.range"):format(i)):set(math.random(10, 20))
            ui.find_menu_int(("%sAntiaim.yaw"):format(i)):set(math.random(1, 2))
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(22, 42))
        end

        ui.find_menu_int("0Antiaim.desync"):set(2)
    elseif (aa_presets:get() == 2) then
        for i = 0, 3 do
            if (globalvars.get_tickcount() % 3 < 1) then
            	ui.find_menu_int(("%sAntiaim.body_lean"):format(i)):set(10)
            	ui.find_menu_int(("%sAntiaim.inverted_body_lean"):format(i)):set(10)
               	ui.find_menu_int("0Antiaim.desync_range"):set(math.random(0, 54))
            else
                ui.find_menu_int(("%sAntiaim.body_lean"):format(i)):set(25)
                ui.find_menu_int(("%sAntiaim.inverted_body_lean"):format(i)):set(25)
                ui.find_menu_int("0Antiaim.desync_range"):set(math.random(20, 56))
            end
        end

        ui.find_menu_int("0Antiaim.desync"):set(math.random(0, 2))
    elseif (aa_presets:get() == 3) then
        for i = 0, 3 do
            ui.find_menu_int(("%sAntiaim.range"):format(i)):set(math.random(0, 30))
           	ui.find_menu_int(("%sAntiaim.yaw"):format(i)):set(math.random(1, 2))
            ui.find_menu_int("0Antiaim.desync_range"):set(math.random(18, 32))
        end

        if (globalvars.get_tickcount() % 3 < 1) then
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(5)
        else
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(15)
        end

       	ui.find_menu_int("Antiaim.fake_lag_type"):set(math.random(0, 1))
        ui.find_menu_int("0Antiaim.desync"):set(math.random(1, 2))
    end
end

--- @item: Yaw Presets
function anti_aim_c.yaw_presets()
	if (yaw_presets:get() == 0) then
		return
	end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (yaw_presets:get() == 1) then
        ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(-8, 12))
    elseif (yaw_presets:get() == 2) then
        ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(0, 10))
    elseif (yaw_presets:get() == 3) then
        ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(-21, 21))
    elseif (yaw_presets:get() == 4) then
        ui.find_menu_int("Antiaim.yaw_offset"):set(math.random(-30, 35))
    end
end

--- @item: AA Jitter Range
function anti_aim_c.aa_jitter_range()
	if (aa_jitter_range:get() == 0) then
		return
	end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (aa_jitter_range:get() == 1) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(5, 10))
        else
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(5, 10))
        end
    elseif (aa_jitter_range:get() == 2) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(10, 15))
        else
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(10, 15))
        end
    elseif (aa_jitter_range:get() == 3) then
        if (ragebot_c.switch) then
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(25, 35))
        else
            ui.find_menu_int("0Antiaim.yaw"):set(1)
            ui.find_menu_int("0Antiaim.range"):set(math.random(25, 35))
        end
    end

	ragebot_c.switch = not ragebot_c.switch
end

--- @item: Body Lean Presets
function anti_aim_c.body_lean_presets()
	if (body_lean_presets:get() == 0) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (body_lean_presets:get() == 1) then
        ui.find_menu_int("0Antiaim.body_lean"):set(math.random(3, 9))
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(math.random(3, 9))
    elseif (body_lean_presets:get() == 2) then
        ui.find_menu_int("0Antiaim.body_lean"):set(math.random(11, 16))
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(math.random(11, 16))
    elseif (body_lean_presets:get() == 3) then
        ui.find_menu_int("0Antiaim.body_lean"):set(math.random(17, 26))
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(math.random(17, 26))
    elseif (body_lean_presets:get() == 4) then
        ui.find_menu_int("0Antiaim.body_lean"):set(math.random(31, 46))
        ui.find_menu_int("0Antiaim.inverted_body_lean"):set(math.random(31, 46))
    end
end

--- @item: Fake Lag Randomizer
function anti_aim_c.fake_lag_randomizer()
	if (fake_lag_randomizer:get() == 0) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (fake_lag_randomizer:get() == 1) then
        ui.find_menu_int("Antiaim.fake_lag_limit"):set(math.random(5, 16))
    elseif (fake_lag_randomizer:get() == 2) then
        ui.find_menu_int("Antiaim.fake_lag_limit"):set(math.random(10, 16))
    elseif (fake_lag_randomizer:get() == 3) then
        if (ragebot_c.switch) then
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(8)
        else
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(16)
        end
    elseif (fake_lag_randomizer:get() == 4) then
        if (ragebot_c.switch) then
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(10)
        else
            ui.find_menu_int("Antiaim.fake_lag_limit"):set(16)
        end
    end

    ragebot_c.switch = not ragebot_c.switch
end

--- @item: AntiBrute Force
function anti_aim_c.anti_brute(event)
	if (not anti_brute:get()) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	if (anti_brute_type:get() == 0) then
		if (ui.get_keybind_state(keybinds.flip_desync)) then
			ui.set_keybind_state(keybinds.flip_desync, false)
		else
			ui.set_keybind_state(keybinds.flip_desync, true)
		end
	end
end

--- @item: Fake Flick
function anti_aim_c.fake_flick()
	if (not fake_flick:get()) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    local tickcount = globalvars.get_tickcount() % 60

    if (tickcount == 14 or tickcount == 17) then
        if (ui.get_keybind_state(keybinds.flip_desync)) then
            ui.find_menu_int("Antiaim.yaw_offset"):set(-90)
        else
            ui.find_menu_int("Antiaim.yaw_offset"):set(90)
        end
    else
        ui.find_menu_int("Antiaim.yaw_offset"):set(0)
    end
end

--- @item: Low desync range on dt
function anti_aim_c.low_desync_range_on_dt()
	if (not low_desync_range_on_dt:get()) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	if (not ui.get_keybind_state(keybinds.double_tap)) then
		return
	end

    ui.find_menu_int("0Antiaim.desync_range"):set(14)
    ui.find_menu_int("0Antiaim.inverted_desync_range"):set(14)
    ui.find_menu_int("Antiaim.yaw_offset"):set(0)
    ui.find_menu_int("0Antiaim.inverted_body_lean"):set(0)
    ui.find_menu_int("0Antiaim.body_lean"):set(0)
end

--- @item: Pitch Zero
function anti_aim_c.pitch_zero(stage)
	if (not pitch_zero:get()) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    if (stage ~= enum_frames.frame_render_start) then
        return
    end

    local flags = player:get_prop_int("CBasePlayer", "m_fFlags")
    local on_ground = bit.band(flags, e_player_flags.ON_GROUND) == 1

    if (on_ground) then
        anti_aim_c.ground_ticks = anti_aim_c.ground_ticks + 1
    else
        anti_aim_c.ground_ticks = 0
        anti_aim_c.end_time = globalvars.get_curtime() + 1
    end

    if (anti_aim_c.ground_ticks > (ui.find_menu_int("Antiaim.fake_lag_limit"):get() + 1) and anti_aim_c.end_time > globalvars.get_curtime()) then
        player:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
end

--- @item: Invert
function anti_aim_c.invert()
	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	local condition = entity_c.get_condition()

	if (invert_in_air:get() and condition == e_conditions.AIR) then
        if ragebot_c.switch then
            ui.set_keybind_state(keybinds.flip_desync, true)
        else
            ui.set_keybind_state(keybinds.flip_desync, false)
        end

        ragebot_c.switch = not ragebot_c.switch
	end

	if (invert_on_move:get() and condition == e_conditions.RUNNING) then
        if ragebot_c.switch then
            ui.set_keybind_state(keybinds.flip_desync, true)
        else
            ui.set_keybind_state(keybinds.flip_desync, false)
        end

        ragebot_c.switch = not ragebot_c.switch
	end
end

--- @item: At Targets In Air
function anti_aim_c.at_targets_in_air()
	if (not at_targets_in_air:get()) then
		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	local condition = entity_c.get_condition()

	if (condition == e_conditions.AIR) then
		ui.find_menu_int("0Antiaim.base_angle"):set(1)
	else
		ui.find_menu_int("0Antiaim.base_angle"):set(0)
	end
end

--- @item: Slowwalk Speed
function anti_aim_c.slow_walk_speed()
	if (not slow_walk_speed_mod:get()) then
        console.set_int("cl_forwardspeed", 450)
        console.set_int("cl_backspeed", 450)
        console.set_int("cl_sidespeed", 450)

		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

    local speed = slow_walk_speed:get()

    if (ui.get_keybind_state(keybinds.slowwalk)) then
        console.set_int("cl_forwardspeed", speed)
        console.set_int("cl_backspeed", speed)
        console.set_int("cl_sidespeed", speed)
    else
        console.set_int("cl_forwardspeed", 450)
        console.set_int("cl_backspeed", 450)
        console.set_int("cl_sidespeed", 450)
    end
end

--- @item: Leg Breaker
function anti_aim_c.leg_breaker()
	if (not leg_breaker:get()) then
		ui.find_menu_int("Misc.leg_movement"):set(0)

		return
    end

	local player = entity.get_local()

	if (player == nil or not player:is_alive()) then
		ui.find_menu_int("Misc.leg_movement"):set(0)

		return
	end

	if (ragebot_c.switch) then
		ui.find_menu_int("Misc.leg_movement"):set(0)
	else
		ui.find_menu_int("Misc.leg_movement"):set(1)
	end

	ragebot_c.switch = not ragebot_c.switch
end
--- @endregion

--- @region: callbacks
--- @callback: paint
cheat.push_callback("on_paint", function()
	ragebot_c.adaptive_ragebot()
end)

--- @callback: createmove
cheat.push_callback("on_createmove", function()
	ragebot_c.ideal_tick()

	anti_aim_c.desync_presets()
	anti_aim_c.presets()
	anti_aim_c.yaw_presets()
	anti_aim_c.aa_jitter_range()
	anti_aim_c.body_lean_presets()
	anti_aim_c.fake_lag_randomizer()
	anti_aim_c.fake_flick()
	anti_aim_c.low_desync_range_on_dt()
	anti_aim_c.invert()
	anti_aim_c.slow_walk_speed()
	anti_aim_c.leg_breaker()
end)

--- @callback: shot
cheat.push_callback("on_shot", function(event)
	ragebot_c.desync_on_shot(event)

	anti_aim_c.anti_brute(event)
end)

--- @callback: frame_net
cheat.push_callback("on_frame_net", function(stage)
	anti_aim_c.pitch_zero(stage)
end)
--- @endregion