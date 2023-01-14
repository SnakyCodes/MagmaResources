ui.add_combobox("Midget mode", {"Off", "Among Us", "Ducarii in GYM", "Midget Mode", "Real Midget Mode"})
local function on_setup_command()

    local local_player = entitylist.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end
    if ui.get_int("Midget mode") == 0 then
        local_player:set_prop_float("CCSPlayer", "m_flModelScale", 1)
        local_player:set_prop_int("CCSPlayer", "m_ScaleType", 0)
    elseif ui.get_int("Midget mode") == 1 then
        local_player:set_prop_float("CCSPlayer", "m_flModelScale", 2)
        local_player:set_prop_int("CCSPlayer", "m_ScaleType", 1)
    elseif ui.get_int("Midget mode") == 2 then
        local_player:set_prop_float("CCSPlayer", "m_flModelScale", 0.2)
        local_player:set_prop_int("CCSPlayer", "m_ScaleType", 1)
    elseif ui.get_int("Midget mode") == 3 then
        local_player:set_prop_float("CCSPlayer", "m_flModelScale", 0.2)
        local_player:set_prop_int("CCSPlayer", "m_ScaleType", 0)
    elseif ui.get_int("Midget mode") == 4 then
        local_player:set_prop_float("CCSPlayer", "m_flModelScale", 0.6)
    end


end
local function on_shutdown()

    local local_player = entitylist.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end


    local_player:set_prop_float("CCSPlayer", "m_flModelScale", 1)
    local_player:set_prop_int("CCSPlayer", "m_ScaleType", 0)
end
cheat.RegisterCallback("on_createmove", on_setup_command)
cheat.RegisterCallback("on_unload", on_shutdown)