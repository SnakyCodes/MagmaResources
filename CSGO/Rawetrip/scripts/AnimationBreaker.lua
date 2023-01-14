local static_legs = ui.add_checkbox("Static legs in air")
local pitch_null = ui.add_checkbox("Pitch 0 on land ( visual )")

local an_data = {
	grTicks = 1,
	endTime = 0
}

local call = {
	["InitAnimations"] = function(self)
		local m_pLocal = entity.get_local()

		if not m_pLocal then
			return
		end

		if not m_pLocal:is_alive() then
			return
		end

		local m_fl = ui.find_menu_int("Antiaim.fake_lag_limit"):get()

		if static_legs:get() then
			m_pLocal:set_render_pose(6, 1)
		end

		if pitch_null:get() then
			local onGround = bit.band(m_pLocal:get_prop_int("CBasePlayer", "m_fFlags"), 1)

			if onGround == 1 then
				an_data.grTicks = an_data.grTicks + 1
			else
				an_data.grTicks = 0
				an_data.endTime = globalvars.get_curtime() + 1
			end

			if an_data.grTicks > m_fl + 1 and an_data.endTime > globalvars.get_curtime() then
				m_pLocal:set_render_pose(12, 0.5)
			end
		end
	end
}

cheat.push_callback("on_frame_net", function(stage)
	if stage ~= enum_frames.frame_render_start then
		return
	end
	
	call["InitAnimations"]()
end)