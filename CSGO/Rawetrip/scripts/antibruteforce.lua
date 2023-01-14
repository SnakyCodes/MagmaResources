-- local variables for API functions. any changes to the line below will be lost on re-generation
local cheat_push_callback, entity_get_local, ui_add_checkbox, ui_add_combobox, ui_get_keybind_state, ui_set_keybind_state = cheat.push_callback, entity.get_local, ui.add_checkbox, ui.add_combobox, ui.get_keybind_state, ui.set_keybind_state

--[[
  * Name - Anti-Bruteforce
  * Coder - x64#8137
]]

-- @region: Ui System
local Menu_Handler = {
    Self = {
        Enable_Brute = ui_add_checkbox('Bruteforce'),
        Type_Brute = ui_add_combobox("AntiBrute Force Type", {"On Shot"}),
    },
}

-- @region: AntiBrute Force
function anti_brute(event)
	if (not Menu_Handler.Self.Enable_Brute:get()) then
		return
    end

	local player = entity_get_local()

	if (player == nil or not player:is_alive()) then
		return
	end

	if (Menu_Handler.Self.Type_Brute:get() == 0) then
		if (ui_get_keybind_state(keybinds.flip_desync)) then
			ui_set_keybind_state(keybinds.flip_desync, false)
		else
			ui_set_keybind_state(keybinds.flip_desync, true)
		end
	end
end

-- @region: CallBack
cheat_push_callback("on_shot", function(event)
	anti_brute(event)
end)